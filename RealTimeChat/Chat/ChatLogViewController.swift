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
    func messageSent(viewModel: ChatLog.SendMessage.ViewModel)
    func displayTappedUser(viewModel: ChatLog.GetTappedUser.ViewModel)
    func displayMessagesForTappedUser(viewModel: ChatLog.LoadMessagesForTappedUser.ViewModel)
}

class ChatLogViewController: UIViewController, ChatLogDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var interactor: ChatLogBusinessLogic?
    var router: (NSObjectProtocol & ChatLogRoutingLogic & ChatLogDataPassing)?
    var mainView = ChatLogView()
    
    var cellID = "cellID"
    
    var chatMessages = [Message]()
    
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
    
    func setUpCollectionView() {
        mainView.chatLogCollectionView.delegate = self
        mainView.chatLogCollectionView.dataSource = self
        
        mainView.chatLogCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpHandlers()
        setUpCollectionView()
        doSomething()
        getTappedUser()
        loadMessagesForTappedUser()
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
    
    func loadMessagesForTappedUser() {
        let request = ChatLog.LoadMessagesForTappedUser.Request()
        interactor?.loadMessagesForUserTapped(request: request)
    }
    
    // MARK: Events
    
    // TODO: Check that the message is not empty
    @objc func sendButtonPressed() {
        if let message = mainView.inputTextField.text {
            if !message.isEmpty {
                let request = ChatLog.SendMessage.Request(message: message)
                interactor?.sendMessage(request: request)
            }
        }
    }
    
    func getTappedUser() {
        let request = ChatLog.GetTappedUser.Request()
        interactor?.getTappedUser(request: request)
    }
    
    // MARK: Events replies
    
    func messageSent(viewModel: ChatLog.SendMessage.ViewModel) {
        mainView.inputTextField.text = ""
    }
    
    func displayTappedUser(viewModel: ChatLog.GetTappedUser.ViewModel) {
        navigationItem.title = viewModel.user.name
    }
    
    func displayMessagesForTappedUser(viewModel: ChatLog.LoadMessagesForTappedUser.ViewModel) {
        chatMessages = viewModel.messages
        mainView.chatLogCollectionView.reloadData()
        print(chatMessages.count)
    }
    
    // MARK: Handlers
    
    func setUpHandlers() {
        mainView.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        mainView.inputTextField.delegate = self
    }
    
    // MARK: Table View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? UICollectionViewCell {
            cell.backgroundColor = .blue
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

extension ChatLogViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonPressed()
        return true
    }
}
