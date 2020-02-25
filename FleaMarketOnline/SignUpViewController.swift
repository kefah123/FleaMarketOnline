//
//  SignUpViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 2/20/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import FirebaseFirestore
class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //validation, check everything in the text field is in good types
    //or it will return errors meesags
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
            return "Please make sure your password be at least 8 characters with a special character and a number "
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
            Auth.auth().createUser(withEmail: "test", password: "test") { (result, error) in
                //if there is an error
                if error != nil {
                    self.errorLabel.text = "Cannot create user "
                    self.errorLabel.alpha = 1
                }else{
                    //create an instance for new user
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(
                        data: ["firstname":firstName,
                               "lastname":lastName
                               "email":email
                               "password":password
                            "id":result!.user.uid)
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
    
    
    func transitions(){
        
    }
    
}
