//
//  HomeViewController.swift
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
//import LBTATools
//import Firebase

protocol HomeDisplayLogic: class
{
    func displaySomething(viewModel: Home.Something.ViewModel)
    func displayIsUserLoggedIn(viewModel: Home.IsUserLoggedIn.ViewModel)
    func displayLogoutUser(viewModel: Home.LogoutUser.ViewModel)
    func displayCurrentUser(viewModel: Home.GetCurrentUserLoggedIn.ViewModel)
    func displayMessages(viewModel: Home.LoadHomeMessages.ViewModel)
    func displayUserHasBeenTapped(viewModel: Home.UserTapped.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    var mainView = HomeView()
    var cellID = "cellID"
    var messages = [HomeMessage]()
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpNavBar()
        self.messages.removeAll()
        self.mainView.tableView.reloadData()
        setUpTableView()
        doSomething()
        askForPermissionForNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserIsLoggedIn()
    }
    
    var users = [UserClass]()
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = Home.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Home.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    func checkIfUserIsLoggedIn() {
        let request = Home.IsUserLoggedIn.Request()
        interactor?.checkIfUserIsLoggedIn(request: request)
    }
    
    func loadMessages() {
        let request = Home.LoadHomeMessages.Request()
        interactor?.loadMessages(request: request)
    }
    
    // MARK: Events
    
    @objc func logoutButtonPressed() {
        let request = Home.LogoutUser.Request()
        interactor?.logoutUser(request: request)
    }
    
    @objc func newMessageButtonPressed() {
        router?.routeToNewMessage()
    }
    
    // MARK: Events replies
    func displayIsUserLoggedIn(viewModel: Home.IsUserLoggedIn.ViewModel) {
        // User not logged in
        if !viewModel.isLogged {
            router?.routeToLogin()
        }
            // User logged in
        else {
            let request = Home.GetCurrentUserLoggedIn.Request()
            interactor?.getCurrentUser(request: request)
            loadMessages()
        }
    }
    
    func displayLogoutUser(viewModel: Home.LogoutUser.ViewModel) {
        router?.routeToLogin()
    }
    
    // Here we customize the nav bar
    func displayCurrentUser(viewModel: Home.GetCurrentUserLoggedIn.ViewModel) {
        if let username = viewModel.user.name {
            if let imageUrl = viewModel.user.imageUrl {
                profileImageView.loadImageUsingUrlString(urlString: imageUrl)
            }
            profileName.text = username
        } else {
            navigationItem.title = "Username not available"
        }
    }
    
    var timer: Timer?
    var lastMessage: HomeMessage? {
        didSet {
            
            guard let name = lastMessage?.profileName as String? else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "Real Time Chat"
            content.subtitle = "You have a new message from \(name)"
            content.badge = 1
            
            guard let mes = lastMessage?.lastMessage as String? else { return }
            content.body = "\(mes)"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if (error != nil) {
                 print("ERROR ADDING NOTIFICATION \(error)")
                }
                // UIApplication.shared.applicationIconBadgeNumber = 0
            }
            
        }
    }
    
    func displayMessages(viewModel: Home.LoadHomeMessages.ViewModel) {
        DispatchQueue.main.async {
            self.messages = viewModel.messages
            self.lastMessage = viewModel.messages[viewModel.messages.count - 1]
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: false)
        }
    }
    
    @objc func handleTimer() {
        self.mainView.tableView.reloadData()
        print("Table view reloaded")
    }
    
    func displayUserHasBeenTapped(viewModel: Home.UserTapped.ViewModel) {
        router?.routeToChatLog()
    }
    
    // MARK: Table View Methods
    
    func setUpTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.tableView.register(HomeViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = mainView.tableView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? HomeViewCell {
            let message = messages[indexPath.item]
            cell.homeMessage = message
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userTapped = messages[indexPath.item].user else { return }
        
        let request = Home.UserTapped.Request(user: userTapped)
        interactor?.userHasBeenTapped(request: request)
    }
    
    // MARK: NavBar View
    
    let profileImageView: CustomImageView = {
        var image = CustomImageView()
        image.layer.cornerRadius = 17.5
        image.clipsToBounds = true
        return image
    }()
    
    let profileName: UILabel = {
        var label = UILabel()
        return label
    }()
}

extension HomeViewController {
    
    func setUpNavBar() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(newMessageButtonPressed))
        
        let customView = UIView()
        customView.backgroundColor = .blue
        customView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        customView.addSubviewForAutolayout(containerView)
        
        profileImageView.contentMode = .scaleAspectFill
        containerView.addSubviewForAutolayout(profileImageView)
        profileImageView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 35, height: 35))
        profileImageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        
        containerView.addSubviewForAutolayout(profileName)
        profileName.anchor(top: containerView.topAnchor, leading: profileImageView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: customView.centerYAnchor)
            ])
        
        navigationItem.titleView = customView
    }
}

extension HomeViewController {
    
    func askForPermissionForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (didAllow, error) in
        }
    }
}
