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
        let newUser = User(name:"John",email:"john@gmail.com",date:"3/20/2020")
        tempUsers.append(newUser)
        tempUsers.append(newUser)
        tempUsers.append(newUser)
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
    
    
}

