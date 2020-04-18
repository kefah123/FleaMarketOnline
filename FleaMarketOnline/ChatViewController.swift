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
    var ref = Database.database().reference()
    var messages = [Message]()
    var messagesDict = [String:Message]()
    var message: Message?
    var toId:String?
    var selectedUser:User?


    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //allUsers = createUsers()
        fetchUser()
        observeMessages()
    }
    
    func createUsers() -> [User] {
        var tempUsers = [User]()
        tempUsers.append(User(random: true))
        tempUsers.append(User(random: true))
        tempUsers.append(User(random: true))
        let userRef = ref.child("users").childByAutoId()
        let values = ["name": tempUsers[2].name!,"email":tempUsers[2].email!]
            userRef.updateChildValues(values)
        return tempUsers
    }
    

    func fetchUser() {
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
        if let dictionary = snapshot.value as? NSDictionary {
            let user = User()
            user.id = snapshot.key
            user.name = dictionary["name"] as? String ?? ""
            user.email = dictionary["email"] as? String ?? ""
            self.allUsers.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }, withCancel: nil)
}
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? NSDictionary {
            let message = Message()
                message.fromId = dictionary["fromId"] as? String ?? ""
                message.text = dictionary["text"] as? String ?? ""
                message.timestamp = dictionary["timestamp"] as? Int ?? 0
                message.toId = dictionary["toId"] as? String ?? ""
                message.name = dictionary["toUser"] as? String ?? ""
              
                if let toId = message.toId {
                self.messagesDict[toId] = message
                    self.messages = Array(self.messagesDict.values)
                    self.messages.sort { (message1, message2) -> Bool in
                        return message1.timestamp! > message2.timestamp!
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    

    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil,
                            afterDelay: 0)
        } else {
            Database.database().reference().child("users")
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError as NSError {
            print("Error signing out: %@", logoutError)
        }
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatLogSegue" {
        let nextViewController = segue.destination as! ChatLogController
        //nextViewController.toId = self.toId
            nextViewController.userName = self.message!.name
        nextViewController.message = self.message
        }

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
       // let user = allUsers[indexPath.row]
      //  cell.setUser(user:user)
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? NSDictionary {
                   let name = dictionary["name"] as? String ?? ""
                    let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(message.timestamp ?? 0))
                cell.setMessage(message:message,name:name,date:timestampDate)
                }
            })
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        message = messages[indexPath.row]
        //self.toId = message.toId
        performSegue(withIdentifier: "chatLogSegue", sender: nil)
        
        }
}

  




