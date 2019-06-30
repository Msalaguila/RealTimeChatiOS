//
//  HomeWorker.swift
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

class HomeWorker
{
    
    var repository = Repository.getInstance()
    
    func doSomeWork()
    {
    }
    
    func checkIfUserIsLoggedIn(isLogged completion: @escaping((Bool) -> Void)) {
        if Auth.auth().currentUser?.uid != nil {
            // User is logged in
            completion(true)
            return
        }
        completion(false)
    }
    
    func logoutUser(completion: @escaping(() -> Void)) {
        do {
            try Auth.auth().signOut()
            completion()
            return
        } catch let error {
            print(error)
        }
    }
    
    func getCurrentUser(completion: @escaping ((UserClass) -> Void)) {
        repository.getLoggedInUser { (user) in
            completion(user)
        }
    }
    
    func loadAllMessages(completion: @escaping ([HomeMessage]) -> Void) {
        repository.loadHomeMessages { (messages) in
            completion(messages)
        }
    }
}
