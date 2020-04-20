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
    var fromIdArray = Set<String>()
    var timer: Timer?
    var dataStore = UserDefaults.standard
    


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages.removeAll()
        messagesDict.removeAll()
       
        if checkLogInStatus() {
            observeUserMessages()
        }
        
   
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    func checkLogInStatus() -> Bool{
        if Auth.auth().currentUser != nil {
            print("you are signed in")
            return true
        } else {
            print("you are not  signed in")
            dataStore.set("compose", forKey: "status")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }

    }

    func fetchUser() {
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
        if let dictionary = snapshot.value as? NSDictionary {
            let user = User()
            user.id = snapshot.key
            user.name = dictionary["firstName"] as? String ?? ""
            user.email = dictionary["email"] as? String ?? ""
            self.allUsers.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }, withCancel: nil)
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
    }
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
    /*
    func sendPurchasedMessage(){
        let ref = Database.database().reference().child("Posts")
    }*/
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
            self.fromIdArray.insert(id)
                }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        message = messages[indexPath.row]
        performSegue(withIdentifier: "chatLogSegue", sender: nil)
        
        }
}

  




