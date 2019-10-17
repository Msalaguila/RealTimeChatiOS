//
//  Repository.swift
//  RealTimeChat
//
//  Created by Manuel Salvador del Águila on 17/06/2019.
//  Copyright © 2019 Manuel Salvador del Águila. All rights reserved.
//

import Foundation
import Firebase

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class Repository {
    
    private static var INSTANCE: Repository?
    var currentUsers = [UserClass]()
    var messages = [Message]()
    var homeMessages = [HomeMessage]()
    var homeMessagesSorted = [String: HomeMessage]()
    var chatMessages = [Message]()
    
    var latestMessagesReference = Database.database().reference().child("latest-messages")
    let currentUserInAppID = Auth.auth().currentUser?.uid
    
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
                
                let id = snapshot.key
                
                if id != Auth.auth().currentUser?.uid {
                    guard let name = dictionary["name"] as? String else { return }
                    guard let email = dictionary["email"] as? String else { return }
                    guard let imageURL = dictionary["profileImageUrl"] as? String else { return }
                    
                    let user = UserClass(id: id, name: name, email: email, imageUrl: imageURL)
                    self.currentUsers.append(user)
                    
                    completion(self.currentUsers)
                }
            }
        }, withCancel: nil)
    }
    
    private func sendMessageToHome(toID: String, values: [String : Any]) {
        latestMessagesReference.child(currentUserInAppID!).child(toID).setValue(values)
        latestMessagesReference.child(toID).child(currentUserInAppID!).setValue(values)
    }
    
    func sendMessage(message: String, toUser: UserClass, completion: @escaping () -> Void) {
        let reference = Database.database().reference().child("messages")
        let messageIDReference = reference.childByAutoId()
        
        let fromID = Auth.auth().currentUser!.uid
        let toID = toUser.id!
        let timestamp: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        let timestampInt = timestamp.int32Value
        let values = ["text": message, "fromID": fromID, "toID": toID, "timestamp": timestampInt] as [String : Any]
        
        sendMessageToHome(toID: toID, values: values)
        
        messageIDReference.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error)
                return
            }
            
            let messageID = messageIDReference.key
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID).child(messageID!)
            
            userMessagesRef.setValue(1)
            
            let recipientMessagesRef = Database.database().reference().child("user-messages").child(toID).child(messageID!)
            recipientMessagesRef.setValue(1)
            completion()
        }
    }
    
    fileprivate func getMessageWithUID(_ messageID: String, completion: @escaping ([HomeMessage]) -> Void) {
        let messageRef = Database.database().reference().child("messages").child(messageID)
        
        messageRef.observeSingleEvent(of: .value, with: { (messageSnapshot) in
            
            if let dictionary = messageSnapshot.value as? [String: AnyObject] {
                
                let chatPartnerID: String?
                
                // 1. We get the whole Messsage object
                guard let fromID = dictionary["fromID"] as? String else { return }
                guard let text = dictionary["text"] as? String else { return }
                guard let timestamp = dictionary["timestamp"] as? NSNumber else { return }
                guard let toID = dictionary["toID"] as? String else { return }
                
                let loggedInUserID = Auth.auth().currentUser?.uid
                if fromID == loggedInUserID {
                    chatPartnerID = toID
                } else {
                    chatPartnerID = fromID
                }
                
                // 2. We get the user the message was sent to
                let userReference = Database.database().reference().child("users").child(chatPartnerID!).observe(.value, with: { (userSnapshot) in
                    
                    if let userDictionary = userSnapshot.value as? [String: Any] {
                        guard let imageUrl = userDictionary["profileImageUrl"] as? String else { return }
                        guard let name = userDictionary["name"] as? String else { return }
                        guard let userID = userSnapshot.key as? String else { return }
                        guard let email = userDictionary["email"] as? String else { return }
                        
                        let user = UserClass(id: userID, name: name, email: email, imageUrl: imageUrl)
                        
                        let homeMessage = HomeMessage(profileImageUrl: imageUrl, profileName: name, timestamp: timestamp, lastMessage: text, user: user)
                        
                        self.homeMessagesSorted[chatPartnerID!] = homeMessage
                        self.homeMessages = Array(self.homeMessagesSorted.values)
                        
                        self.homeMessages.sort { (m1, m2) -> Bool in
                            return m1.timestamp?.int32Value > m2.timestamp?.int32Value
                        }
                    }
                    completion(self.homeMessages)
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }
    
    func loadUserMessages(completion: @escaping ([HomeMessage]) -> Void) {
        
        print("LOADED NEW USER")
        
        messages = [Message]()
        homeMessages = [HomeMessage]()
        
        // let ref = Database.database().reference().child("user-messages")
        let userUID = Auth.auth().currentUser!.uid
        let userReference = self.ref.child(userUID)
        
        // We get the reference to the messages sent to that user
        userReference.observe(.childAdded) { (snapshot) in
            
            // For every message reference, we recover the message from the message node
            let messageID = snapshot.key
            
            self.getMessageWithUID(messageID, completion: completion)
        }
    }
    
    var ref = Database.database().reference().child("user-messages")
    var refInsideChat = Database.database().reference().child("user-messages")
    var handleRefInsideChat: UInt = 1
    
    func loadMessagesForUser(userToLoadMessages: UserClass, completion: @escaping ([Message]) -> Void) {
        self.chatMessages.removeAll()
        
        guard let userTappedID = userToLoadMessages.id as? String else { return }
        
        var user = getUserWithID(userUID: userTappedID) { (user) in
            
            let userProfileImageUrl = user.imageUrl
            
            guard let userID = Auth.auth().currentUser?.uid as? String else { return }
            
            // 1. We get all the messages from the userLoggedIn
            
            self.handleRefInsideChat = self.refInsideChat.child(userID).observe(.childAdded, with: { (snapshot) in
                
                // 2. We retrieve each message
                let messageID = snapshot.key
                let messageRef = Database.database().reference().child("messages").child(messageID)
                messageRef.observeSingleEvent(of: .value, with: { (messageSnapshot) in
                    
                    if let dictionary = messageSnapshot.value as? [String: AnyObject] {
                        
                        guard let fromID = dictionary["fromID"] as? String else { return }
                        guard let text = dictionary["text"] as? String else { return }
                        guard let timestamp = dictionary["timestamp"] as? NSNumber else { return }
                        guard let toID = dictionary["toID"] as? String else { return }
                        
                        // 3. We check that the message belongs to the userTappedID conversation
                        let message = Message(fromID: fromID, toID: toID, timestamp: timestamp, message: text, profileImageURL: userProfileImageUrl)
                        
                        if message.chatPartnerId() == userTappedID {
                
                            self.chatMessages.append(message)
                            self.chatMessages.sort { (message1, message2) -> Bool in
                                return message1.timestamp?.int32Value < message2.timestamp?.int32Value
                            }
                            completion(self.chatMessages)
                        }
                    }
                }, withCancel: nil)
            }, withCancel: nil)}
    }
    
    
    private func getUserWithID(userUID: String, completion: @escaping (UserClass) -> Void) {
        var ref = Database.database().reference().child("users").child(userUID)
        ref.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                guard let profileImageUrl = dictionary["profileImageUrl"] as? String else { return }
                let user = UserClass(id: nil, name: nil, email: nil, imageUrl: profileImageUrl)
                completion(user)
            }
        }
    }
}
