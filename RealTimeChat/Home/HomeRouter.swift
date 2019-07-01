//
//  HomeRouter.swift
//  Firebase
//
//  Created by Manuel Salvador del Águila on 14/06/2019.
//  Copyright (c) 2019 Manuel Salvador del Águila. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol HomeRoutingLogic
{
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToLogin()
    func routeToNewMessage()
    func routeToChatLog()
}

protocol HomeDataPassing
{
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
    weak var viewController: HomeViewController?
    var dataStore: HomeDataStore?
    
    // MARK: Routing
    
    func routeToChatLog() {
        let destinationVC = ChatLogViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToChatLogController(source: dataStore!, destination: &destinationDS)
        navigateToChatLog(source: viewController!, destination: destinationVC)
    }
    
    func routeToLogin() {
        let destinationVC = LoginViewController()
        navigateToLogin(source: viewController!, destination: destinationVC)
    }
    
    func routeToNewMessage() {
        let destinationVC = NewMessageViewController()
        navigateToNewMessage(source: viewController!, destination: destinationVC)
    }
    
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    func navigateToLogin(source: HomeViewController, destination: LoginViewController)
    {
        source.present(destination, animated: true, completion: nil)
    }
    
    func navigateToNewMessage(source: HomeViewController, destination: NewMessageViewController)
    {
        let navController = UINavigationController(rootViewController: destination)
        source.present(navController, animated: true, completion: nil)
    }
    
    func navigateToChatLog(source: HomeViewController, destination: ChatLogViewController)
    {
        source.show(destination, sender: nil)
    }
    
    //     MARK: Passing data
    
    func passDataToSomewhere(source: HomeDataStore, destination: inout LoginDataStore)
    {
        
    }
    
    func passDataToChatLogController(source: HomeDataStore, destination: inout ChatLogDataStore)
    {
        destination.currentUser = source.currentUser
        destination.userTapped = source.userTappedInHome
    }
    
    
}
