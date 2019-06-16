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
    func doSomeWork()
    {
    }
    
    func registerUser(request: Login.RegisterButtonPressed.Request, error completionHandler: @escaping((Bool) -> Void)) {
        Auth.auth().createUser(withEmail: request.email, password: request.password, completion: { (res, error) in
            
            if let error = error {
                print(error)
                completionHandler(true)
            }
            
            guard let uid = res?.user.uid else {
                return
            }
            
            //successfully authenticated user
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let values = ["name": request.name, "email": request.email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    completionHandler(true)
                }
                
                print("Saved user successfully into Firebase db")
                
                completionHandler(false)
            })
            
        })
    }
}