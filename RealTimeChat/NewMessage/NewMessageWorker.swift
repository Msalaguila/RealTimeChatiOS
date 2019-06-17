//
//  NewMessageWorker.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 17/06/2019.
//  Copyright (c) 2019 Manuel Salvador del Águila. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class NewMessageWorker
{
    
    var repository = Repository.getInstance()
    
    func doSomeWork()
    {
    }
    
    func loadUsers(completion: @escaping (([UserClass]) -> Void)) {
        repository.getUsers { (users) in
            completion(users)
        }
    }
}
