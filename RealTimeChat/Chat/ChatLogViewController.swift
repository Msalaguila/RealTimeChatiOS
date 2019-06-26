//
//  ChatLogViewController.swift
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

protocol ChatLogDisplayLogic: class
{
    func displaySomething(viewModel: ChatLog.Something.ViewModel)
}

class ChatLogViewController: UIViewController, ChatLogDisplayLogic
{
    var interactor: ChatLogBusinessLogic?
    var router: (NSObjectProtocol & ChatLogRoutingLogic & ChatLogDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ChatLogInteractor()
        let presenter = ChatLogPresenter()
        let router = ChatLogRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
        view.backgroundColor = .white
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = ChatLog.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: ChatLog.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
}