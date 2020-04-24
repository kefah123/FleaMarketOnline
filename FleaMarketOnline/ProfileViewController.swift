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
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var secureSwitch = true
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    
    
    let db = Firestore.firestore()
//    ref = Database.database().reference()..
    
    override func viewDidLoad() {

        super.viewDidLoad()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        ref = Database.database().reference()
         if Auth.auth().currentUser != nil {
          
              print("you are signed in")
            
              fetchData()
          
        } else {
              print("you are not  signed in")
              let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
              let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
              self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func fillFields () {
        firstNameField.text = firstName
        lastNameField.text = lastName
        emailField.text = email
        passwordField.text = password
    }
    
    func fetchData() {
        // access data from Cloud Firestore
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid

            let docRef = db.collection("users").document(uid!)

            docRef.getDocument{ (document, error) in
                if let document = document {
                    self.firstName = document.get("firstname") as? String ?? ""
                    self.lastName = document.get("lastname") as? String ?? ""
                    self.email = document.get("email") as? String ?? ""
                    self.password = document.get("password") as? String ?? ""
                    // filled in each textfiled
                    self.firstNameField.text = self.firstName
                    self.lastNameField.text = self.lastName
                    self.emailField.text = self.email
                    self.passwordField.text = self.password
                    self.passwordField.isSecureTextEntry = self.secureSwitch
                    self.HelloLabel.text = "Hello, " + self.firstName + " " + self.lastName
                    self.logOutButton.setTitle("Log Out", for: .normal) 
                    self.logOutButton.setTitleColor(.red, for: .normal)

                } else {
                    print("Document does not exist in cache")
                }
            }
        }
}

    @IBAction func firstNameEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/firstName").setValue(firstNameField.text!)

        let userRef = db.collection("users").document(uid!)
        userRef.updateData([
            "firstname": self.firstNameField.text!
        ])
 
    }
    
    @IBAction func lastNameEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/lastName").setValue(lastNameField.text)
        
        
        let userRef = db.collection("users").document(uid!)
        userRef.updateData([
            "lastname": self.lastNameField.text!
        ])
        
    
    }
    @IBAction func emailEditingButton(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        self.ref!.child("users/\(String(describing: uid!))/email").setValue(emailField.text)
        
        let userRef = db.collection("users").document(uid!)
        userRef.updateData([
            "email": self.emailField.text!
        ])
        
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
        
        let userRef = db.collection("users").document(uid!)
        userRef.updateData([
            "password": self.passwordField.text!
        ])

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
    
    // keyboard functions
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadView()
        
        fetchData()
        
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

