//
//  ViewController.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 2/8/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

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

}
