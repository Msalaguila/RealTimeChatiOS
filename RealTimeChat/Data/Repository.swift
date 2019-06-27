//
//  Repository.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 17/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import Firebase

class Repository {
    
    private static var INSTANCE: Repository?
    var currentUsers = [UserClass]()
    var messages = [Message]()
    
    private init() {
        
    }
    
    public static func getInstance() -> Repository {
        if INSTANCE == nil {
            INSTANCE = Repository()
        }
        return INSTANCE!
    }
    
    func getLoggedInUser(completion: @escaping ((UserClass) -> Void)) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let name = dictionary["name"] as? String else { return }
                guard let email = dictionary["email"] as? String else { return }
                guard let imageURL = dictionary["profileImageUrl"] as? String else { return }
                
                let user = UserClass(name: name, email: email, imageUrl: imageURL)
                completion(user)
            }
            
        }, withCancel: nil)
    }
    
    func getUsers(completion: @escaping (([UserClass]) -> Void)) {
        
        // Reset the users previously loaded
        
        currentUsers = [UserClass]()
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                guard let id = snapshot.key as? String else { return }
                guard let name = dictionary["name"] as? String else { return }
                guard let email = dictionary["email"] as? String else { return }
                guard let imageURL = dictionary["profileImageUrl"] as? String else { return }
                
                let user = UserClass(id: id, name: name, email: email, imageUrl: imageURL)
                self.currentUsers.append(user)
            
                completion(self.currentUsers)
            }
        }, withCancel: nil)
    }
    
    func sendMessage(message: String, toUser: UserClass, completion: @escaping () -> Void) {
        let reference = Database.database().reference().child("messages")
        let messageIDReference = reference.childByAutoId()
        
        let fromID = Auth.auth().currentUser?.uid
        let toID = toUser.id
        let timestamp: Int = Int(NSDate().timeIntervalSince1970)
        let values = ["text": message, "fromID": fromID, "toID": toID, "timestamp": timestamp] as [String : Any]
        messageIDReference.updateChildValues(values)
        completion()
    }
    
    func loadAllMessages(completion: @escaping ([Message]) -> Void) {
        let reference = Database.database().reference().child("messages")
        
        DispatchQueue.global().async {
            self.messages = [Message]()
            
            reference.observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    guard let fromID = dictionary["fromID"] as? String else { return }
                    guard let text = dictionary["text"] as? String else { return }
                    guard let timestamp = dictionary["timestamp"] as? Int else { return }
                    guard let toID = dictionary["toID"] as? String else { return }
                    
                    let message = Message(fromID: fromID, toID: toID, timestamp: timestamp, message: text)
                    self.messages.append(message)
                    
                    completion(self.messages)
                }
                
            }, withCancel: nil)
        }
    }
}
