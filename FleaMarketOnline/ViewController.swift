//
//  ViewController.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 2/8/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, LoginResultDelegate,SignUpResultDelegate{

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let ref = Database.database().reference();
        ref.child("id/name").setValue("key")
        setElement()
        
    }
    func setElement(){
        Utilities.styleFilledButton(logInButton)
        Utilities.styleFilledButton(signUpButton)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showLogin"?:
            let loginViewController = segue.destination as! LoginViewController
            loginViewController.delegate = self
            
        case "showSignup"?:
            let signUpViewController = segue.destination as! SignUpViewController
            signUpViewController.delegate = self 
        default:
            // some other segue
            print("some other segue")
        }
    }
    
    func loginSuccessful(_ success: Bool) {
        if success {
            print("login was successful")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("login failed")
        }
    }
    func signUpSuccessful(_ success: Bool) {
       print (success)
        if success {
            print("signUp was successful")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("signUp failed")
        }
    }
}
