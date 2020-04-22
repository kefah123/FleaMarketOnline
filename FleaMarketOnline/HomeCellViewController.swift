//
//  HomeCellViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 4/9/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeCellViewController: UIViewController {
    var getName = String()
    var getSeller = String()
    
    var getPrice = String()
    var getSB = String()
    var getContect = String()
    var getDescibption = String()
    var message = Message()

    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var sellerLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var subjectLB: UILabel!
    @IBOutlet weak var contactLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLB.text! = getName
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var sellerFirstName = ""
        var sellerLastName = ""
        ref.child("users").child(getSeller).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          
          sellerFirstName = value?["firstName"] as? String ?? ""
          sellerLastName = value?["lastName"] as? String ?? ""
            
            self.sellerLB.text! = sellerFirstName  + " " + sellerLastName
            
          }) { (error) in
            print(error.localizedDescription)
        }
   
        priceLB.text! =  getPrice
        subjectLB.text! = getSB
        contactLB.text! =  getContect
        descriptionLB.text! =  getDescibption
        let currentViewControllName = UserDefaults.standard.value(forKey: "currentViewController")
    }
    

    @IBAction func addToCartAction(_ sender: Any) {
        var ref: DatabaseReference?
        let databaseHandle:DatabaseHandle?
        ref = Database.database().reference()
        if Auth.auth().currentUser != nil {
                print("you are signed in")
           databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
                let key = snapshot.key
                let post = snapshot.value as? [String]
                if post?[0] == self.getName &&
                    post?[1] == self.getSeller &&
                    post?[2] == self.getPrice &&
                    post?[3] == self.getSB &&
                    post?[4] == self.getContect &&
                    post?[5] == self.getDescibption {
                    ref!.child("Posts/\(key)/6").setValue("True")
                    ref!.child("User-cart").child(Auth.auth().currentUser!.uid).setValue(
                        ["itemID" : key
                        ])
                    print("added to cart")
                    self.navigationController?.popViewController(animated: true)
            
                }
            })
        
        } else {
                print("you are not  signed in")

                let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
                let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
           

         }

    }
    
    @IBAction func buyItNowAction(_ sender: Any) {
        var ref: DatabaseReference?
        var databaseHandle:DatabaseHandle?
        ref = Database.database().reference()
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            let post = snapshot.value as? [String]
            if post?[0] == self.getName &&
                post?[1] == self.getSeller &&
                post?[2] == self.getPrice &&
                post?[3] == self.getSB &&
                post?[4] == self.getContect &&
                post?[5] == self.getDescibption {
                ref!.child("Posts/\(key)/7").setValue("True")
                //dismiss
                self.navigationController?.popViewController(animated: true)
        
            }
        })
        
        let buyerUserId = Auth.auth().currentUser?.uid
        databaseHandle = ref?.child("User-posts").child(getSeller).observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            let post = snapshot.value as? [String]
            if post?[0] == self.getName &&
                post?[1] == self.getSeller &&
                post?[2] == self.getPrice &&
                post?[3] == self.getSB &&
                post?[4] == self.getContect &&
                post?[5] == self.getDescibption {
                ref!.child("User-posts/\(self.getSeller)/\(key)/8").setValue(buyerUserId!)
                ref!.child("User-posts/\(self.getSeller)/\(key)/7").setValue("True")
                
                
                //dismiss
                self.navigationController?.popViewController(animated: true)
        
            }
        })
        
    }
    
    @IBAction func chatAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Chat", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogController
        setMessageDetails {
        vc.message = self.message
        vc.userName = self.message.toName
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setMessageDetails(completion: @escaping () -> Void){
    guard let fromId = Auth.auth().currentUser?.uid else {return}
    let posterRef = Database.database().reference().child("users").child(self.getSeller)
    let userRef = Database.database().reference().child("users").child(fromId)
    userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        if let dictionary = snapshot.value as? NSDictionary {
            posterRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let posterDict = snapshot.value as? NSDictionary {
                    self.message.fromName = dictionary["firstName"] as? String ?? ""
                    self.message.fromId = fromId
                    self.message.toId = self.getSeller
                    self.message.toName = posterDict["firstName"] as? String ?? ""
                    completion()
                }
            }, withCancel: nil)
            
        }
    }, withCancel: nil)
    
}
    
    
}
