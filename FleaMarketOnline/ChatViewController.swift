//
//  ChatViewController.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 3/22/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var allUsers = [User]()
    var messages = [Message]()
    var messagesDict = [String:Message]()
    var message: Message?
    var messageName: String?
    var toId:String?
    var selectedUser:User?
    var timer: Timer?
    var dataStore = UserDefaults.standard
    var itemName : String?
    var buyerID  : String?
    var firstName = ""
    var lastName = ""



    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(sendPurchasedMessage(n:)), name: NSNotification.Name.init(rawValue: "ItemPurchased"), object: nil)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        if Auth.auth().currentUser?.uid == nil {
            print("you are not  signed in")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
       
    }
    override func viewWillAppear(_ animated: Bool) {
         if Auth.auth().currentUser?.uid != nil {
            messagesDict.removeAll()
            observeUserMessages()
            print("you are signed in")
            checkIfItemPurchased()
            if let index = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: index, animated: true)
            }
         } else {
            messages.removeAll()
            messagesDict.removeAll()
            self.tableView.reloadData()
            print("you are not signed in")
        }
    }
   
    
    func observeUserMessages() {
        var uid: String?
        if Auth.auth().currentUser?.uid != nil {
            uid = Auth.auth().currentUser?.uid
        }
        let ref = Database.database().reference().child("user-messages").child(uid!)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid!).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? NSDictionary {
                    let message = Message()
                        message.fromId = dictionary["fromId"] as? String ?? ""
                        message.text = dictionary["text"] as? String ?? ""
                        message.timestamp = dictionary["timestamp"] as? Int ?? 0
                        message.toId = dictionary["toId"] as? String ?? ""
                        message.toName = dictionary["toUser"] as? String ?? ""
                        message.fromName = dictionary["fromUser"] as? String ?? ""
                        if let id = message.chatPartnerId() {
                            self.messagesDict[id] = message
                        }
                    }
                    self.reloadTableData()
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDict.removeValue(forKey: snapshot.key)
            self.reloadTableData()
        }, withCancel: nil)
    }
    
    /* Delays reload of table to prevent synchronization bugs*/
    func reloadTableData() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDict.values)
        self.messages.sort { (message1, message2) -> Bool in return message1.timestamp! > message2.timestamp! }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatLogSegue" {
        let nextViewController = segue.destination as! ChatLogController
            if message?.chatPartnerId() == message?.toId {
                nextViewController.userName = message?.toName
            } else {
                nextViewController.userName = self.message!.fromName
            }
        nextViewController.message = self.message
        }
    }
    
    @objc func sendPurchasedMessage(n:NSNotification){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = uid
        let toUser = ""
        let fromUser = "System"
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromId = "SystemSystemSystem"
    
        setUserName {
            let values = ["text":"Your item '" + self.itemName!+"' has been sold to: "+self.firstName+" "+self.lastName+"!",
                       "toId":toId,
                       "fromId":fromId,
                       "timestamp":timestamp,
                       "toUser":toUser,
                       "fromUser":fromUser] as [String : Any]
                   childRef.updateChildValues(values) { (error, ref) in
                       if error != nil {
                           print(error!)
                           return
                       }
                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                    let messageId = childRef.key
                       userMessagesRef.updateChildValues([messageId!:1])
                    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                       recipientUserMessagesRef.updateChildValues([messageId!:1])
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
           
                }
        }
        
    }
    
    func setUserName(completion: @escaping () -> Void){
        let userRef = Database.database().reference().child("users").child(self.buyerID!)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
                self.firstName = dictionary["firstName"] as? String ?? ""
                self.lastName = dictionary["lastName"] as? String ?? ""
                completion()
            }
        }, withCancel: nil)

        
    }
    
    func checkIfItemPurchased() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("User-posts").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            if let array = snapshot.value as? [String] {
                let index: Int = 7
                if let _ = array[exist:index] {
                let purchasedOrNot = array[index]
                    if purchasedOrNot == "True" {
                        self.itemName = array[0]
                        self.buyerID  = array[8]
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ItemPurchased"), object: nil)
                        Database.database().reference().child("User-posts").child(uid).child("\(snapshot.key)/7").setValue("nil")
                    }
                }
            }
            
        }, withCancel: nil)

    }
}
//Displaying number of cells and setting content of cells
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        if let id = message.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? NSDictionary {
                   let name = dictionary["firstName"] as? String ?? ""
                    let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(message.timestamp ?? 0))
                    
                cell.setMessage(message:message,name:name,date:timestampDate)
                }
            })
                }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            message = messages[indexPath.row]
            performSegue(withIdentifier: "chatLogSegue", sender: nil)
        }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let message = self.messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue { (error, ref) in
                if error != nil {
                    print("Could not delete message")
                    return
                }
                self.messagesDict.removeValue(forKey: chatPartnerId)
                self.reloadTableData()
                
            }
        }
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
  




