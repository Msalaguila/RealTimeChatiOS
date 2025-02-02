//
//  ChatLogView.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 26/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import UIKit
import LBTATools

class ChatLogView: UIView {
    
    var bottomContainer: UIView = {
        var container = UIView()
        return container
    }()
    
    var inputTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Enter message..."
        return tf
    }()
    
    var sendButton: UIButton = {
        var bt = UIButton(type: .system)
        bt.setTitle("Send", for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return bt
    }()
    
    var separatorLine: UIView = {
        var separator = UIView()
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    var chatLogCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    var heightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpBottomContainer() {
        bottomContainer.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 100))
        
        bottomContainer.addSubviewForAutolayout(separatorLine)
        
        separatorLine.anchor(top: bottomContainer.topAnchor, leading: bottomContainer.leadingAnchor, bottom: nil, trailing: bottomContainer.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0.5))
        
        bottomContainer.addSubviewForAutolayout(sendButton)
        
        sendButton.anchor(top: bottomContainer.topAnchor, leading: nil, bottom: nil, trailing: bottomContainer.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 50))
        
        bottomContainer.addSubviewForAutolayout(inputTextField)
        
        inputTextField.anchor(top: bottomContainer.topAnchor, leading: bottomContainer.leadingAnchor, bottom: sendButton.bottomAnchor, trailing: sendButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
    }
    
    func setUpViews() {
//        addSubviewForAutolayout(bottomContainer)
//
//        setUpBottomContainer()
        
        addSubviewForAutolayout(chatLogCollectionView)
        
        chatLogCollectionView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0), size: CGSize(width: 0, height: 0))
//        chatLogCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
//        chatLogCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
//        chatLogCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        
//        heightConstraint = chatLogCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
//        heightConstraint?.isActive = true
    }
    
}
