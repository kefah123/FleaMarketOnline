//
//  ComposeViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 3/17/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var contectTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var sbTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var ref:DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    @IBAction func addPost(_ sender: Any) {
        //post data to database
        ref?.child("Posts").childByAutoId().setValue(nameTF.text! + priceTF.text! + sbTF.text! + contectTF.text! + descriptionTF.text!)
        //dismiss
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    


}
extension ComposeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
