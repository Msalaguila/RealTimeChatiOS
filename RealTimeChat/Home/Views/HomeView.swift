//
//  HomeView.swift
//  Firebase
//
//  Created by Manuel Salvador del Águila on 14/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import LBTATools

class HomeView: UIView {
    
    var tableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var tv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tv.backgroundColor = .white
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        addSubviewForAutolayout(tableView)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    
    }
}
