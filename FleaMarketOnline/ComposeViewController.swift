//
//  ComposeViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 3/17/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var contectTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var sbTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var ref:DatabaseReference?
    override func viewDidLoad() {
        if Auth.auth().currentUser != nil {
          print("you are signed in")
          print (Auth.auth().currentUser?.uid)
        } else {
          print("you are not  signed in")
          let signOrLog = ViewController()
          let signOrLogNavigationController = UINavigationController(rootViewController: signOrLog)
          self.present(signOrLogNavigationController,animated: true, completion: nil)
          return
        }
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    @IBAction func addPost(_ sender: Any) {
        if Auth.auth().currentUser != nil {
          print("you are signed in")
          print (Auth.auth().currentUser?.uid)
          let uid = Auth.auth().currentUser?.uid
            let name = Auth.auth().currentUser?.displayName
          print(name)
          //post data to database
          var valueArr = [String]()
            valueArr.append(nameTF.text!)
            valueArr.append(uid!)
            valueArr.append(priceTF.text!)
            valueArr.append(sbTF.text!)
            valueArr.append(contectTF.text!)
            valueArr.append(descriptionTF.text!)

            ref?.child("Posts").childByAutoId().setValue(valueArr)
          //dismiss
          self.navigationController?.popViewController(animated: true)
        } else {
          print("you are not  signed in")
          let signOrLog = ViewController()
          let signOrLogNavigationController = UINavigationController(rootViewController: signOrLog)
          self.present(signOrLogNavigationController,animated: true, completion: nil)
          return
        }

    }
    


}
extension ComposeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
