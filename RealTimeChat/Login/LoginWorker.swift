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
    
    func loginUser(request: Login.LoginButtonPressed.Request, error completion: @escaping(_ err: Bool, _ shortPassword: Bool) -> Void) {
        
        repository.loginUser(request: request) { (error, shortPassword) in
            completion(error, shortPassword)
        }
    }
    
    func registerUser(request: Login.RegisterButtonPressed.Request, error completionHandler: @escaping((_ err: Bool, _ shortPassword: Bool) -> Void)) {
        
        repository.registerUser(request: request) { (error, shortPassword) in
            completionHandler(error, shortPassword)
        }
    }
}
