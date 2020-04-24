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


    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var sellerTitle: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var subjectTitle: UILabel!
    @IBOutlet weak var contactTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var sellerLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var subjectLB: UILabel!
    @IBOutlet weak var contactLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        nameLB.text! = " " + getName
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var sellerFirstName = ""
        var sellerLastName = ""
        ref.child("users").child(getSeller).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          
          sellerFirstName = value?["firstName"] as? String ?? ""
          sellerLastName = value?["lastName"] as? String ?? ""
            
            self.sellerLB.text! = " " + sellerFirstName  + " " + sellerLastName
            
          }) { (error) in
            print(error.localizedDescription)
        }
        
        priceLB.text! = " " +  getPrice
        subjectLB.text! = " " +  getSB
        contactLB.text! = " " +  getContect
        descriptionLB.text! = " " +  getDescibption
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
                    ref!.child("User-cart").child(Auth.auth().currentUser!.uid).child(key).setValue(
                        [
                            "Name" : self.getName,
                            "Price" : self.getPrice,
                            "Subject" : self.getSB,
                            "Contact" : self.getContect,
                            "Description" : self.getDescibption,
                            "Seller" : self.getSeller
                            
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
                let buyerUserId = Auth.auth().currentUser?.uid
                ref!.child("User-posts/\(self.getSeller)/\(key)/8").setValue(buyerUserId!)
                ref!.child("User-posts/\(self.getSeller)/\(key)/7").setValue("True")
                
                
                let title = "Confirm to buy \(self.getName)?"
                let message = "Are you sure you want to delete this item?"
                let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                let buyAction = UIAlertAction(title: "Buy", style: .destructive, handler: { (action) -> Void in
                    // remove the item from the firebase Posts
                    ref!.child("Posts/\(key)").setValue(nil)
                    print("buy successful ")
                    //dissmiss
                    self.navigationController?.popViewController(animated: true)
                })
                ac.addAction(buyAction)
                self.present(ac, animated: true, completion: nil)
                
            
        
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
    func UISetUp (){
        //define color
        let ironColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha:1.0)
        nameTitle.backgroundColor = ironColor
        nameTitle.layer.borderColor = ironColor.cgColor
        nameTitle.layer.borderWidth = 1.5
        nameTitle.layer.cornerRadius = 16
        nameTitle.clipsToBounds = true

        
        
        
        sellerTitle.layer.borderColor = UIColor.darkGray.cgColor
        sellerTitle.layer.borderWidth = 1.5
        sellerTitle.backgroundColor = ironColor
        sellerTitle.layer.borderColor = ironColor.cgColor
        sellerTitle.layer.cornerRadius = 16
        sellerTitle.clipsToBounds = true
        
        priceTitle.layer.borderColor = UIColor.darkGray.cgColor
        priceTitle.layer.borderWidth = 1.5
        priceTitle.backgroundColor = ironColor
        priceTitle.layer.borderColor = ironColor.cgColor
        priceTitle.layer.cornerRadius = 16
        priceTitle.clipsToBounds = true
        
        subjectTitle.layer.borderColor = UIColor.darkGray.cgColor
        subjectTitle.layer.borderWidth = 1.5
        subjectTitle.backgroundColor = ironColor
        subjectTitle.layer.borderColor = ironColor.cgColor
        subjectTitle.layer.cornerRadius = 16
        subjectTitle.clipsToBounds = true
        
        contactTitle.layer.borderColor = UIColor.darkGray.cgColor
        contactTitle.layer.borderWidth = 1.5
        contactTitle.backgroundColor = ironColor
        contactTitle.layer.borderColor = ironColor.cgColor
        contactTitle.layer.cornerRadius = 16
        contactTitle.clipsToBounds = true
        
        descriptionTitle.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTitle.layer.borderWidth = 1.5
        descriptionTitle.backgroundColor = ironColor
        descriptionTitle.layer.borderColor = ironColor.cgColor
        descriptionTitle.layer.cornerRadius = 16
        descriptionTitle.clipsToBounds = true
        
//        nameLB.layer.borderColor = UIColor.gray.cgColor
//        nameLB.layer.borderWidth = 0.2
        nameLB.backgroundColor = UIColor.white
        nameLB.layer.shadowColor = UIColor.lightGray.cgColor
        nameLB.layer.shadowOpacity = 1;
        nameLB.layer.shadowRadius = 2.0;
        
        sellerLB.backgroundColor = UIColor.white
        sellerLB.layer.shadowColor = UIColor.lightGray.cgColor
        sellerLB.layer.shadowOpacity = 1;
        sellerLB.layer.shadowRadius = 2.0;
        
        priceLB.backgroundColor = UIColor.white
        priceLB.layer.shadowColor = UIColor.lightGray.cgColor
        priceLB.layer.shadowOpacity = 1;
        priceLB.layer.shadowRadius = 2.0;
        
        subjectLB.backgroundColor = UIColor.white
        subjectLB.layer.shadowColor = UIColor.lightGray.cgColor
        subjectLB.layer.shadowOpacity = 1;
        subjectLB.layer.shadowRadius = 2.0;
        
        contactLB.backgroundColor = UIColor.white
        contactLB.layer.shadowColor = UIColor.lightGray.cgColor
        contactLB.layer.shadowOpacity = 1;
        contactLB.layer.shadowRadius = 2.0;
        
        descriptionLB.backgroundColor = UIColor.white
        descriptionLB.layer.shadowColor = UIColor.lightGray.cgColor
        descriptionLB.layer.shadowOpacity = 1;
        descriptionLB.layer.shadowRadius = 2.0;
        
    }
    
    
}
