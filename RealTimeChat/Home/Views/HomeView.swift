//
//  HomeView.swift
//  Firebase
//
//  Created by Manuel Salvador del Águila on 14/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import LBTATools

extension HomeViewController {
    
    func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(newMessageButtonPressed))
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navBarPressed)))
        
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
