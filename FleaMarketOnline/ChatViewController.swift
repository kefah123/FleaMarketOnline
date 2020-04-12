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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUsers = createUsers()
    }
    
    func createUsers() -> [User] {
        var tempUsers = [User]()
        tempUsers.append(User(random: true))
        tempUsers.append(User(random: true))
        tempUsers.append(User(random: true))
        Database.database().reference().child("users").setValue(["username": tempUsers[0]])
        return tempUsers
    }
    
    /* TODO: fix fetch user to retrieve user info
    func fetchUser() {
    Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = User()
            user.setValuesForKeys(dictionary)
            self.users.append(user)
          //  print(user.name ?? "User instance is nil", user.email ?? "User instance is nil")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }, withCancel: nil)

}*/

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
}
//Displaying number of cells and setting content of cells
extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = allUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        cell.setUser(user:user)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "chatLogSegue"?:
    if let row = tableView.indexPathForSelectedRow?.row {
        let selectedUser = allUsers[row]
        let nextViewController = segue.destination as! ChatLogController
        nextViewController.user = selectedUser
    } default:
    preconditionFailure("Unexpected segue identifier.") }
    
}

}
