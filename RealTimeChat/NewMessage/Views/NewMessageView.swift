//
//  NewMessageView.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 17/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import LBTATools

class NewMessageView: UIView {
    
    var cellID = "cellID"
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up views
    fileprivate func setUpTableView() {
        addSubviewForAutolayout(collectionView)
        
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: .zero)
        
        collectionView.register(NewMessageCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func setUpViews() {
        setUpTableView()
    }
}
