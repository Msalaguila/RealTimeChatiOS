//
//  Message.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 27/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    var fromID: String?
    var toID: String?
    var timestamp: NSNumber?
    var message: String?
    var profileImageURL: String?
    
    func chatPartnerId() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}
