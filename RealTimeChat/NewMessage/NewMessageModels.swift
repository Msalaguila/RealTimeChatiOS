//
//  NewMessageModels.swift
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

enum NewMessage
{
    // MARK: Use cases
    
    enum Something
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
    
    enum LoadAvailableUsers
    {
        struct Request
        {
        }
        struct Response
        {
            var users: [UserClass]
        }
        struct ViewModel
        {
            var users: [UserClass]
        }
    }
}
