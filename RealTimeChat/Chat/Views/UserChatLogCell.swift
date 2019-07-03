//
//  ChatLogCell.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 02/07/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import LBTATools

class UserChatLogCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            if let text = message?.message { messageText.text = text }
            
        }
    }
    
    var messageText: UILabel = {
        var lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = UIColor.white
        lb.isUserInteractionEnabled = true
        lb.numberOfLines = 0
        return lb
    }()
    
    var bubbleView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.init(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    func setUpUI() {
        contentView.addSubviewForAutolayout(bubbleView)
        bubbleView.addSubviewForAutolayout(messageText)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            ])
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
       
        messageText.anchor(top: bubbleView.topAnchor, leading: bubbleView.leadingAnchor, bottom: bubbleView.bottomAnchor, trailing: bubbleView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 0))
    }
}
