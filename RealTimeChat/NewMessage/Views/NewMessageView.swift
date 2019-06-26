//
//  NewMessageView.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 17/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import LBTATools

class NewMessageView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var usersLoaded = [UserClass]()
    
    var cellID = "cellID"
    
    var tableView: UITableView = {
        var tb = UITableView()
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up views
    fileprivate func setUpTableView() {
        addSubviewForAutolayout(tableView)
        
        tableView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: .zero)
        
        tableView.register(NewMessageCell.self, forCellReuseIdentifier: cellID)
    }
    
    func setUpViews() {
        setUpTableView()
    }
    
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersLoaded.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? NewMessageCell {
            let user = usersLoaded[indexPath.item]
            cell.user = user
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    
    
}
