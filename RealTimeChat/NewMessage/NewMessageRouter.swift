//
//  NewMessageRouter.swift
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

@objc protocol NewMessageRoutingLogic
{
    func routeToChatController()
}

protocol NewMessageDataPassing
{
    var dataStore: NewMessageDataStore? { get }
}

class NewMessageRouter: NSObject, NewMessageRoutingLogic, NewMessageDataPassing
{
    weak var viewController: NewMessageViewController?
    var dataStore: NewMessageDataStore?
    
    // MARK: Routing
    
    func routeToChatController() {
        let destinationVC = ChatLogViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToChatLogController(source: dataStore!, destination: &destinationDS)
        navigateToChatController(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToChatController(source: NewMessageViewController, destination: ChatLogViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToChatLogController(source: NewMessageDataStore, destination: inout ChatLogDataStore)
    {
        destination.currentUser = source.userTapped
    }
}
