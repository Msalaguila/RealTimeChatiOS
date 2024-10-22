//
//  LoginViewController.swift
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

protocol LoginDisplayLogic: class
{
    func displaySomething(viewModel: Login.Something.ViewModel)
    func userRegistered(viewModel: Login.RegisterButtonPressed.ViewModel)
    func userLoggedIn(viewModel: Login.LoginButtonPressed.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    var loginView = LoginView()
    let imagePickerController = UIImagePickerController()
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setUpImagePicker() {
        imagePickerController.delegate = self
        loginView.topImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(topImageTapped)))
        imagePickerController.allowsEditing  = true
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
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
        setUpImagePicker()
        doSomething()
        loginView.nameTextField.delegate = self
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
        let request = Login.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Login.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    
}

// MARK: Views
extension LoginViewController {
    
    func setUpView() {
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        loginView.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        
        loginView.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        
    }
    
}

// MARK: Events

extension LoginViewController {
    
    @objc func registerButtonPressed() {
        guard let name = loginView.nameTextField.text else { return }
        guard let email = loginView.emailTextField.text else { return }
        guard let password = loginView.passwordTextField.text else { return }
        guard let image = loginView.topImage.image else { return }
        
        loginView.activityIndicatorContainer.isHidden = false
        loginView.activityIndicator.startAnimating()
        
        // Login Activated
        if loginView.segmentedControl.selectedSegmentIndex == 0 {
            let request = Login.LoginButtonPressed.Request(email: email, password: password)
            interactor?.loginUser(request: request)
        }
            
        // Registration Activated
        else {
            let request = Login.RegisterButtonPressed.Request(name: name, email: email, password: password, profileImage: image)
            interactor?.registerUser(request: request)
        }
    }
    
    @objc func segmentedControlChanged() {
        let index = loginView.segmentedControl.selectedSegmentIndex
        
        // Login activated
        if index == 0 {
            
            // Change containerHeight
            loginView.containerHeight?.isActive = false
            loginView.containerHeight?.constant = 100
            loginView.containerHeight?.isActive = true
            
            // Change loginView height
            loginView.nameHeightAnchor?.isActive = false
            loginView.nameHeightAnchor = loginView.nameTextField.heightAnchor.constraint(equalTo: loginView.container.heightAnchor, multiplier: 0)
            loginView.nameHeightAnchor?.isActive = true
            
            loginView.emailHeightAnchor?.isActive = false
            loginView.emailHeightAnchor = loginView.emailTextField.heightAnchor.constraint(equalTo: loginView.container.heightAnchor, multiplier: 1/2)
            loginView.emailHeightAnchor?.isActive = true
            
            loginView.passwordHeightAnchor?.isActive = false
            loginView.passwordHeightAnchor = loginView.passwordTextField.heightAnchor.constraint(equalTo: loginView.container.heightAnchor, multiplier: 1/2)
            loginView.passwordHeightAnchor?.isActive = true
            
            loginView.nameSeparatorLine.isHidden = true
            
            loginView.registerButton.setTitle("Login", for: .normal)
            
            loginView.topImage.image = UIImage(named: "user-logo")
            loginView.topImage.isUserInteractionEnabled = false
        } else {
            
            // Register activated
            
            loginView.containerHeight?.constant = 150
            
            loginView.nameHeightAnchor?.isActive = false
            loginView.nameHeightAnchor = loginView.nameTextField.heightAnchor.constraint(equalTo: loginView.container.heightAnchor, multiplier: 1/3)
            loginView.nameHeightAnchor?.isActive = true
            
            loginView.emailHeightAnchor?.isActive = false
            loginView.emailHeightAnchor = loginView.emailTextField.heightAnchor.constraint(equalTo: loginView.container.heightAnchor, multiplier: 1/3)
            loginView.emailHeightAnchor?.isActive = true
            
            loginView.passwordHeightAnchor?.isActive = false
            loginView.passwordHeightAnchor = loginView.passwordTextField.heightAnchor.constraint(equalTo: loginView.container.heightAnchor, multiplier: 1/3)
            loginView.passwordHeightAnchor?.isActive = true
            
            loginView.nameSeparatorLine.isHidden = false
            
            loginView.registerButton.setTitle("Register", for: .normal)
            
            loginView.topImage.isUserInteractionEnabled = true
            
            if loginView.selectedImageFromPicker != nil {
                loginView.topImage.image = loginView.selectedImageFromPicker
            }
            else {
                loginView.topImage.image = UIImage(named: "user-logo")
            }
        }
    }
    
    @objc func topImageTapped() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
}

// MARK: Managing keyboard

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }
    
    func closekeyboard() {
        self.view.endEditing(true)
    }
    
}


// MARK: Events replies
extension LoginViewController {
    
    fileprivate func showPasswordTooShortAlert() {
        
        loginView.activityIndicatorContainer.isHidden = true
        loginView.activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Password too short", message: "The password needs to have at least 6 characters", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default) { (a) in
            print(123)
        }
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showErrorAlert() {
        
        loginView.activityIndicatorContainer.isHidden = true
        loginView.activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Registration Failed", message: "An error has occured", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default) { (a) in
            print(123)
        }
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showRegistrationSuccesfulAlert() {
        
        loginView.activityIndicatorContainer.isHidden = true
        loginView.activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Registration Successful", message: "You have been registered succesfully", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default) { (a) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoginErrorAlert() {
        
        loginView.activityIndicatorContainer.isHidden = true
        loginView.activityIndicator.stopAnimating()
        
        let alertController = UIAlertController(title: "Check your credentials", message: "Are you sure you have an account? Check your credentials again.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func userRegistered(viewModel: Login.RegisterButtonPressed.ViewModel) {
        if viewModel.passwordTooShort {
            showPasswordTooShortAlert()
        }
        else if viewModel.error {
            showErrorAlert()
        }
        else {
            showRegistrationSuccesfulAlert()
        }
    }
    
    func userLoggedIn(viewModel: Login.LoginButtonPressed.ViewModel) {
        if viewModel.passwordTooShort {
            showPasswordTooShortAlert()
        }
        else if viewModel.error {
            showLoginErrorAlert()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Image picker methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Obtenemos la imagen editada
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // Guardamos la imagen
            loginView.selectedImageFromPicker = editedImage
        }
        else {
            // Obtenemos la imagen original
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            // Guardamos la imagen
            loginView.selectedImageFromPicker = image
        }
        
        // Cerramos el picker
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
