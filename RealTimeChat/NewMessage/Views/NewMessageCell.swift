//
//  NewMessageCell.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 17/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import LBTATools

class NewMessageCell: UITableViewCell {
    
    var user: UserClass? {
        didSet {
            nameTextView.text = user?.name
            emailTextView.text = user?.email
            if let imageUrl = user?.imageUrl {
                profileImage.loadImageUsingUrlString(urlString: imageUrl)
            }
        }
    }
    
    private let profileImage: CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        im.clipsToBounds = true
        im.layer.cornerRadius = im.layer.frame.width / 2
        return im
    }()
    
    private let nameTextView: UITextView = {
        var tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let emailTextView: UITextView = {
        var tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews() {
        contentView.addSubviewForAutolayout(profileImage)
        
        NSLayoutConstraint.activate([
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 75),
            profileImage.heightAnchor.constraint(equalToConstant: 75),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
            ])
        
        contentView.addSubviewForAutolayout(nameTextView)
        
        nameTextView.anchor(top: profileImage.topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        
        contentView.addSubviewForAutolayout(emailTextView)
        
        emailTextView.anchor(top: nameTextView.bottomAnchor, leading: nameTextView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: .zero)
    }
    
}
