//
//  LoginViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 2/24/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

protocol LoginResultDelegate: AnyObject {
    func loginSuccessful(_: Bool)
}

class LoginViewController: UIViewController {
    weak var delegate: LoginResultDelegate? = nil
    var signInOK = false

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
      
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextfield)
        Utilities.styleFilledButton(loginButton)
        
    }
    


    @IBAction func loginTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //sign in user
        Auth.auth().signIn(withEmail: email, password: password){
            (result,error) in
            print("closure for signIn()")
            if error != nil{
                //cannot sign in
                self.errorLabel.text =  error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                self.signInOK = true
            }
            self.transitions()
        }

        
    }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        func transitions(){
            print("transitions()")
            delegate?.loginSuccessful(self.signInOK)
            self.navigationController?.popViewController(animated: true)
            
        }
    
}
