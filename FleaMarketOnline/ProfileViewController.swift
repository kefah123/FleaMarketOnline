//
//  ProfileViewController.swift
//  FleaMarketOnline
//
//  Created by 吴亨俊 on 4/13/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
        
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedInUserStatus()
//        ref = Database.database().reference()
//        let uid = Auth.auth().currentUser?.uid
//        ref!.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//          // Get user value
//          let value = snapshot.value as? NSDictionary
//          let name = value?["name"] as? String ?? ""
//          let email = value?["email"] as? String ?? ""
//            self.nameField.text = name
//            self.emailField.text = email
//
//        })
    }
    
    @IBAction func nameEditingButton(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid))/name").setValue(nameField.text)
    }
    
    @IBAction func emailEditingButton(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid))/email").setValue(emailField.text)
    }
    
    
    fileprivate func checkLoggedInUserStatus(){
        
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let signOrLog = ViewController()
                let signOrLogNavigationController = UINavigationController(rootViewController: signOrLog)
                self.present(signOrLogNavigationController,animated: true, completion: nil)
                return
            }
        }
    }
}

