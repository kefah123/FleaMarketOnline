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
    var databaseHandle:DatabaseHandle?
    @IBOutlet weak var buyItNowButtonOutlet: UIButton!
    
    @IBOutlet weak var chatLB: UIButton!
    @IBOutlet weak var addToCartButtonOutlet: UIButton!
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
        buttonSetUp()
    }
    

    @IBAction func addToCartAction(_ sender: Any) {
        var ref: DatabaseReference?
      
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
        if Auth.auth().currentUser?.uid == nil {
            print("you are not  signed in")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    func buttonSetUp(){
        let currentViewControllName = UserDefaults.standard.value(forKey: "currentViewController") as! String
        
        //user cannot add or buy the item by them selves
        if  getSeller == Auth.auth().currentUser?.uid {
            buyItNowButtonOutlet.isHidden = true
            addToCartButtonOutlet.isHidden = true
        }
        // user cannot add to cart when open the cell in cart view
        if currentViewControllName == "Cart" {
            
            addToCartButtonOutlet.isHidden = true
        }
    }
    
    func UISetUp (){
        //define color
        let ironColor = UIColor.white
        nameTitle.backgroundColor = UIColor.white
        nameTitle.layer.shadowColor = UIColor.lightGray.cgColor
        nameTitle.layer.shadowOpacity = 1;
        nameTitle.layer.shadowRadius = 2.0;
        
        sellerTitle.backgroundColor = UIColor.white
        sellerTitle.layer.shadowColor = UIColor.lightGray.cgColor
        sellerTitle.layer.shadowOpacity = 1;
        sellerTitle.layer.shadowRadius = 2.0;
        
        priceTitle.backgroundColor = UIColor.white
        priceTitle.layer.shadowColor = UIColor.lightGray.cgColor
        priceTitle.layer.shadowOpacity = 1;
        priceTitle.layer.shadowRadius = 2.0;
        
        subjectTitle.backgroundColor = UIColor.white
        subjectTitle.layer.shadowColor = UIColor.lightGray.cgColor
        subjectTitle.layer.shadowOpacity = 1;
        subjectTitle.layer.shadowRadius = 2.0;
        
        contactTitle.backgroundColor = UIColor.white
        contactTitle.layer.shadowColor = UIColor.lightGray.cgColor
        contactTitle.layer.shadowOpacity = 1;
        contactTitle.layer.shadowRadius = 2.0;
        
        descriptionTitle.backgroundColor = UIColor.white
        descriptionTitle.layer.shadowColor = UIColor.lightGray.cgColor
        descriptionTitle.layer.shadowOpacity = 1;
        descriptionTitle.layer.shadowRadius = 2.0;
        
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
        
        chatLB.backgroundColor = UIColor.white
        chatLB.layer.shadowColor = UIColor.lightGray.cgColor
        chatLB.layer.shadowOpacity = 1;
        chatLB.layer.shadowRadius = 2.0;
        
        descriptionLB.backgroundColor = UIColor.white
        descriptionLB.layer.shadowColor = UIColor.lightGray.cgColor
        descriptionLB.layer.shadowOpacity = 1;
        descriptionLB.layer.shadowRadius = 2.0;
        
        buyItNowButtonOutlet.layer.borderColor = UIColor.systemBlue.cgColor
        buyItNowButtonOutlet.layer.borderWidth = 1.5
        buyItNowButtonOutlet.layer.cornerRadius = 16
        
       
        addToCartButtonOutlet.layer.borderColor = UIColor.systemBlue.cgColor
        addToCartButtonOutlet.layer.borderWidth = 1.5
        addToCartButtonOutlet.layer.cornerRadius = 16
        
        
    }
    
    
}
