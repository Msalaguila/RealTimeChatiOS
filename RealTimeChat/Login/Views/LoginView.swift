//
//  LoginView.swift
//  Firebase
//
//  Created by Manuel Salvador del Águila on 14/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import LBTATools

class LoginView: UIView {
    
    var selectedImageFromPicker: UIImage? {
        didSet {
            topImage.image = selectedImageFromPicker
        }
    }
    
    var activityIndicatorContainer: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 88/255, green: 97/255, blue: 93/255, alpha: 0.7)
        view.isHidden = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var container: UIView = {
        var container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 5
        return container
    }()
    
    var nameTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Name"
        return tf
    }()
    
    var nameSeparatorLine: UIView = {
        var sp = UIView()
        sp.backgroundColor = .lightGray
        return sp
    }()
    
    var emailTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    var emailSeparatorLine: UIView = {
        var sp = UIView()
        sp.backgroundColor = .lightGray
        return sp
    }()
    
    var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    var topImage: UIImageView = {
        var ig = UIImageView()
        ig.image = UIImage(named: "user-logo")
        ig.contentMode = .scaleAspectFill
        ig.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        ig.clipsToBounds = true
        ig.layer.cornerRadius = ig.frame.size.width / 2
        ig.isUserInteractionEnabled = true
        return ig
    }()
    
    var registerButton: UIButton = {
        var bt = UIButton(type: .system)
        bt.setTitle("Register", for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        bt.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    
    var segmentedControl: UISegmentedControl = {
        var sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        return sc
    }()
    
    var containerHeight: NSLayoutConstraint?
    var nameHeightAnchor: NSLayoutConstraint?
    var emailHeightAnchor: NSLayoutConstraint?
    var passwordHeightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpContainer() {
        addSubviewForAutolayout(container)
        
        containerHeight = container.heightAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor, constant: -24),
            ])
        
        containerHeight?.isActive = true
    }
    
    fileprivate func setUpContainerElements() {
        container.addSubviewForAutolayout(nameTextField)
        
        nameTextField.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height:0))
        
        nameHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3)
        
        nameHeightAnchor?.isActive = true
        
        addSubviewForAutolayout(nameSeparatorLine)
        
        nameSeparatorLine.anchor(top: nameTextField.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        
        container.addSubviewForAutolayout(emailTextField)
        
        emailTextField.anchor(top: nameTextField.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        emailHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3)
        
        emailHeightAnchor?.isActive = true
        
        addSubviewForAutolayout(emailSeparatorLine)
        
        emailSeparatorLine.anchor(top: emailTextField.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        
        container.addSubviewForAutolayout(passwordTextField)
        
        passwordTextField.anchor(top: emailTextField.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        
        passwordHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 1/3)
        
        passwordHeightAnchor?.isActive = true
    }
    
    fileprivate func setUpRegisterButton() {
        addSubviewForAutolayout(registerButton)
        
        registerButton.anchor(top: container.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
    }
    
    fileprivate func setUpSegmentedControl() {
        addSubviewForAutolayout(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -12),
            segmentedControl.widthAnchor.constraint(equalTo: container.widthAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 36)
            ])
    }
    
    fileprivate func setUpTopImage() {
        addSubviewForAutolayout(topImage)
        
        NSLayoutConstraint.activate([
            topImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            topImage.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -12),
            topImage.widthAnchor.constraint(equalToConstant: 150),
            topImage.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
    
    fileprivate func setUpActivityIndicator() {
        
        addSubviewForAutolayout(activityIndicatorContainer)
        
        NSLayoutConstraint.activate([
            activityIndicatorContainer.widthAnchor.constraint(equalToConstant: 100),
            activityIndicatorContainer.heightAnchor.constraint(equalToConstant: 100),
            activityIndicatorContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorContainer.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        
        activityIndicatorContainer.addSubviewForAutolayout(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor)
            ])
    }
    
    func setUpUI() {
        setUpContainer()
        setUpContainerElements()
        setUpRegisterButton()
        setUpSegmentedControl()
        setUpTopImage()
        setUpActivityIndicator()
    }
}
