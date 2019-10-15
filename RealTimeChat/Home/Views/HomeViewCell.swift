//
//  HomeViewCell.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 27/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import UIKit
import LBTATools

class HomeViewCell: UICollectionViewCell {
    
    var homeMessage: HomeMessage? {
        didSet {
            
            guard let imageUrl = homeMessage?.profileImageUrl else { return }
            profileImage.loadImageUsingUrlString(urlString: imageUrl)
            
            nameLabel.text = homeMessage?.profileName
            
            if let seconds = homeMessage?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                dateLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            emailLabel.text = homeMessage?.lastMessage
        }
    }
    
    private let dateLabel: UILabel = {
        var dLabel = UILabel()
        dLabel.font = UIFont.systemFont(ofSize: 13)
        dLabel.textColor = UIColor.lightGray
        return dLabel
    }()
    
    private let profileImage: CustomImageView = {
        let im = CustomImageView()
        im.contentMode = .scaleAspectFill
        im.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        im.clipsToBounds = true
        im.layer.cornerRadius = im.layer.frame.width / 2
        return im
    }()
    
    let nameLabel: UILabel = {
        var tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isUserInteractionEnabled = true
        return tv
    }()
    
    private let emailLabel: UILabel = {
        var tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isUserInteractionEnabled = true
        return tv
    }()
    
    private let separatorLine: UIView = {
        var separator = UIView()
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        contentView.addSubviewForAutolayout(nameLabel)
        
        nameLabel.anchor(top: profileImage.topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
        
        contentView.addSubviewForAutolayout(emailLabel)
        
        emailLabel.anchor(top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50), size: .zero)
        
        contentView.addSubviewForAutolayout(separatorLine)
        
        separatorLine.anchor(top: nil, leading: profileImage.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0.5))
        
        contentView.addSubviewForAutolayout(dateLabel)
        
        dateLabel.anchor(top: nameLabel.topAnchor, leading: nil, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: -10), size: CGSize(width: 100, height: 12))
    }
    
    
    
}
