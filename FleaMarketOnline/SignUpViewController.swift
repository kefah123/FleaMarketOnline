//
//  SignUpViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 2/20/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {
    var ref:DatabaseReference?
    var dataStore = UserDefaults.standard
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        firstNameTextfield.resignFirstResponder()
        lastNameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
   
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(firstNameTextfield)
        Utilities.styleTextField(lastNameTextfield)
        Utilities.styleTextField(emailTextfield)
        Utilities.styleTextField(passwordTextfield)
        Utilities.styleFilledButton(signUpButton)
        
    }

    func validateFields() -> String?{
        //check if all fields are filled
        if (firstNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            return "Please fill in all fields"
        }
        //check if all password is secure
        let cleanPw = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPw) == false {
            return "Password should be at least 8 characters with a special character and a number "
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil{
            //there is an error message will be shown
            errorLabel.text = error!
            errorLabel.alpha = 1
        }else{
            //clean up data, no white space and newlines
            let firstName = firstNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create a user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                //if there is an error
                if error != nil {
                    print(error!)
                    self.errorLabel.text = ""
                    self.errorLabel.alpha = 1
                }else{
                    //make a copy of user to the firebase realtime database
                    var ref:DatabaseReference?
                    ref = Database.database().reference()

                    ref?.child("users").child(result!.user.uid).setValue(
                        ["firstName" : firstName,
                         "lastName" : lastName,
                         "email" : email,
                         "password" : password
                        ])
                    //create an instance for new user
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(
                        ["firstname":firstName,
                               "lastname":lastName,
                               "email":email,
                               "password":password,
                               "id":result!.user.uid ])
                    {(error) in
                            if error != nil{
                                self.errorLabel.text = "Cannot create user in database "
                                self.errorLabel.alpha = 1
                            }
                    }
                
            }
            }
            // transfer to next view
            self.transitions()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func transitions(){
        self.navigationController?.popViewController(animated: true)

    }
    
}
