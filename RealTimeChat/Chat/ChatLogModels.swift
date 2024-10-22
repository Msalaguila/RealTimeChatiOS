//
//  ChatLogModels.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 26/06/2019.
//  Copyright (c) 2019 Manuel Salvador del Águila. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ChatLog
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
    
    enum SendMessage
    {
        struct Request
        {
            var message: String
            var userToSendMessage: UserClass?
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
    
    enum GetTappedUser
    {
        struct Request
        {
        }
        struct Response
        {
            var user: UserClass
        }
        struct ViewModel
        {
            var user: UserClass
        }
    }
    
    enum LoadMessagesForTappedUser
    {
        struct Request
        {
            var user: UserClass?
        }
        struct Response
        {
            var messages: [Message]
        }
        struct ViewModel
        {
            var messages: [Message]
        }
    }
}
