//
//  LoginPresenter.swift
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

protocol LoginPresentationLogic
{
    func presentSomething(response: Login.Something.Response)
    func registerUser(response: Login.RegisterButtonPressed.Response)
}

class LoginPresenter: LoginPresentationLogic
{
    weak var viewController: LoginDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: Login.Something.Response)
    {
        let viewModel = Login.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func registerUser(response: Login.RegisterButtonPressed.Response) {
        let viewModel = Login.RegisterButtonPressed.ViewModel(error: response.error)
        viewController?.userRegistered(viewModel: viewModel)
    }
}