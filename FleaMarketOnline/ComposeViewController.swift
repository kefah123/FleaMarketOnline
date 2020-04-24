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

    var dataStore = UserDefaults.standard
    @IBOutlet weak var contectTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var sbTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var ref:DatabaseReference?
    override func viewDidLoad() {
        contectTF.resignFirstResponder()
        descriptionTF.resignFirstResponder()
        priceTF.resignFirstResponder()
        sbTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        super.viewDidLoad()
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
          print("you are signed in")
  
        } else {
          print("you are not  signed in")
            dataStore.set("compose", forKey: "status")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)

          return
        }
        
        
       
        // Do any additional setup after loading the view.
    }
    @IBAction func addPost(_ sender: Any) {
        if Auth.auth().currentUser != nil {
          print("you are signed in")

          let uid = Auth.auth().currentUser?.uid
           
  
          //post data to database
          var valueArr = [String]()
            valueArr.append(nameTF.text!)
            valueArr.append(uid!)
            valueArr.append(priceTF.text!)
            valueArr.append(sbTF.text!)
            valueArr.append(contectTF.text!)
            valueArr.append(descriptionTF.text!)
            valueArr.append("False")
            valueArr.append("False")
            print(valueArr)
            let itemID = ref?.childByAutoId().key!
            ref?.child("Posts").child(itemID!).setValue(valueArr)
            //create a new copy collection of user post, it will collect all post from that user
            ref?.child("User-posts").child(uid!).child(itemID!).setValue(valueArr)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
extension ComposeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
