//
//  LoginWorker.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 16/06/2019.
//  Copyright (c) 2019 Manuel Salvador del Águila. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Firebase

class LoginWorker
{
    
    var repository = Repository.getInstance()
    
    func doSomeWork()
    {
        
    }
    
    // TODO: Mover estos métodos al repositorio
    
    func loginUser(request: Login.LoginButtonPressed.Request, error completion: @escaping(_ err: Bool, _ shortPassword: Bool) -> Void) {
        
        repository.loginUser(request: request) { (error, shortPassword) in
            completion(error, shortPassword)
        }
    }
    
    func registerUser(request: Login.RegisterButtonPressed.Request, error completionHandler: @escaping((_ err: Bool, _ shortPassword: Bool) -> Void)) {
        
        // Check if password is short
        if request.password.count < 6 {
            completionHandler(true, true)
            return
        }
        
        createUser(request, completionHandler)
    }
    
    fileprivate func createUser(_ request: Login.RegisterButtonPressed.Request, _ completionHandler: @escaping ((Bool, Bool) -> Void)) {
        
        // 1. Create user with email and password
        Auth.auth().createUser(withEmail: request.email, password: request.password, completion: { (res, error) in
            
            if let error = error {
                print(error)
                completionHandler(true, false)
                return
            }
            
            guard let uid = res?.user.uid else {
                return
            }
            
            // 2. Store the user image into database
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = request.profileImage.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
                    if let error = error {
                        print(error)
                        completionHandler(true, true)
                        return
                    }
                    
                    // 3. We get the url in order to store it into the database with the other parameters
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            completionHandler(true, true)
                            return
                        }
                        guard let url = url else { return }
                        let values = ["name": request.name, "email": request.email, "profileImageUrl": url.absoluteString]
                        
                        // 4. Update the values into the database
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject], completionHandler)
                    })
                }
            }
        })
    }
    
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject], _ completionHandler: @escaping ((Bool, Bool) -> Void)) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                completionHandler(true, true)
                return
            }
            
            completionHandler(false, false)
        })
    }
}
