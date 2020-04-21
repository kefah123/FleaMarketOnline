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

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var HelloLabel: UILabel!
    
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var secureSwitch = true

    override func viewDidLoad() {
    
       if Auth.auth().currentUser != nil {
            print("you are signed in")

            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            ref?.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let firstName = value?["firstName"] as? String ?? ""
                let lastName = value?["lastName"] as? String ?? ""
                let email = value?["email"] as? String ?? ""
                let password = value?["password"] as? String ?? ""

                self.firstNameField.text = firstName
                self.lastNameField.text = lastName
                self.emailField.text = email
                self.passwordField.text = password
                self.passwordField.isSecureTextEntry = self.secureSwitch
                self.HelloLabel.text = "Hello, " + firstName + " " + lastName
        })
        
      } else {
            print("you are not  signed in")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
      }
        
        super.viewDidLoad()
        
    }
    

    @IBAction func firstNameEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/firstName").setValue(firstNameField.text)
    }
    
    @IBAction func lastNameEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/lastName").setValue(lastNameField.text)
    }
    @IBAction func emailEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/email").setValue(emailField.text)
    }
    
    @IBAction func passwordSecureButton(_ sender: UIButton) {
        if(secureSwitch == true) {
            passwordField.isSecureTextEntry = false
        } else {
            passwordField.isSecureTextEntry = true
        }
        secureSwitch = !secureSwitch
    }
    
    @IBAction func passwordEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/password").setValue(passwordField.text)
        
    }
    
    @IBAction func signOutAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        print("you are not  signed in")
        let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)   
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
    }
    fileprivate func checkLoggedInUserStatus(){
              if Auth.auth().currentUser != nil {
                print("you are signed in")
                return
        
              } else {
                print("you are not  signed in")
                  let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
                  let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                  self.navigationController?.pushViewController(vc, animated: true)

                return
              }

        
        
    }
}

