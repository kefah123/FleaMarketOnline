//
//  CartViewController.swift
//  FleaMarketOnline
//
//  Created by Anyi Huang on 2/28/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseDatabase

class CartViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    //UITableViewDelegate, UITableViewDataSource
    var postData = [[String]]()
    var useForUpdate = [[String]]()
    var userCartData = [String]()
    var postIDSet = [String]()
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var firstInit  = true
    @IBOutlet weak var cartTableView: UITableView!
    
    //init
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("Cart", forKey: "currentViewController")
        if Auth.auth().currentUser != nil{
        }else {
              let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
              let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
              self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //toggle edit mod
    @IBAction func toggleEditingMode(_ sender: UIButton){
        self.cartTableView.isEditing = !self.cartTableView.isEditing
        if isEditing{
            //Change txt of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            //Turn off editing mode
            setEditing(false, animated: true)
        }else{
            //Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            //Ender editing mode
            setEditing(true, animated: true)
        }
    }
    //check out
    @IBAction func checkOut(_ sender: UIButton){
        let uid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        print (postData.count)
        let title = "Check Out"
        let message = "Do you confirm to check out ?"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        let buyAction = UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) -> Void in
            for i in 0..<self.postData.count{
                print ("\(i)....\(self.postData.count)" )
                //print("User-posts/\(self.postData[i][5])/\(self.postData[i][6])/7")
                let sellerId = self.postData[0][5]
                let itemId = self.postData[0][6]
                print("sellerId",sellerId)
                self.cartTableView.reloadData()
                self.ref = Database.database().reference()
                self.databaseHandle = self.ref?.child("User-posts").child(sellerId).observe(.childAdded, with: { (snapshot) in
                let key = snapshot.key
                    print("key",key)
                    print("itemId",itemId)
                    if key == itemId {
                        self.ref!.child("User-posts/\(sellerId)/\(key)/7").setValue("True")
                        self.ref!.child("User-posts/\(sellerId)/\(key)/8").setValue(uid)
                        self.ref!.child("User-cart/\(uid!)/\(itemId)").removeValue()
                        self.ref!.child("Posts/\(itemId)").removeValue()

                    }
                    })
                self.postData.remove(at: 0)
                print("postData",self.postData)
                self.cartTableView.reloadData()
            }
            print("post\(self.postData)")
            //dissmiss
            self.navigationController?.popViewController(animated: true)
        })
        ac.addAction(buyAction)
        self.present(ac, animated: true, completion: nil)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
        cell.textLabel?.text = postData[indexPath.row][0]
        return cell
        
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "HomeCellViewController") as! HomeCellViewController
        vc.getName = postData[indexPath.row][0]
        vc.getSeller = postData[indexPath.row][1]
        vc.getPrice = postData[indexPath.row][2]
        vc.getSB = postData[indexPath.row][3]
        vc.getContect = postData[indexPath.row][4]
        vc.getDescibption = postData[indexPath.row][5]
        //print(postData[indexPath.row][0])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //remove from cart
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser?.uid
        if editingStyle == .delete{
                // ask user to confirm
                //let item = postData[indexPath.row]
                let title = "Delete?"
                let message = "Are you sure you want to delete \(postData[indexPath.row][0])?"
                let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(cancelAction)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                    // remove the item from the store
                    //self.postData.remove(at:indexPath.row)
                    self.ref = Database.database().reference()
                    self.ref = self.ref?.child("User-cart").child(uid!).child(self.postData[indexPath.row][6])
                    self.ref!.removeValue()

                    // remove the item from the store
                    self.postData.remove(at:indexPath.row)
                    //remove from the tableview
                    self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
                
                })
                
                ac.addAction(deleteAction)
                // put up the controller as a modal view
              
                present(ac, animated: true, completion: nil)
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        //ref = Database.database().reference()
        if (firstInit){
            
        }else{
            postData = []
        }
        super.viewWillAppear(true)
        self.loadView()
        fetchData()
        UserDefaults.standard.set("Cart", forKey: "currentViewController")
        DispatchQueue.main.async { self.cartTableView.reloadData() }
        
        
    }
    func fetchData(){
        if Auth.auth().currentUser != nil{
            let uid = Auth.auth().currentUser?.uid
            print("logined:\(uid!)")
            postData = []
            self.cartTableView.reloadData()
            super.viewDidLoad()
            cartTableView.delegate = self
            cartTableView.dataSource = self
            //Set the firebase reference
            ref = Database.database().reference()
            let cartRef = Database.database().reference().child("User-cart").child(uid!)
            cartRef.observe(.childAdded, with: { (snapshot) in
                    var post = [String]()
                    if let dictionary = snapshot.value as? NSDictionary {
                        let  key = snapshot.key
                        post.append(dictionary["Name"] as? String ?? "")
                        post.append(dictionary["Price"] as? String ?? "")
                        post.append(dictionary["Subject"] as? String ?? "")
                        post.append(dictionary["Contact"] as? String ?? "")
                        post.append(dictionary["Description"] as? String ?? "")
                        post.append(dictionary["Seller"] as? String ?? "")
                        //post.append(dictionary["ItemID"] as? String ?? "")
                        post.append(key)
                        self.postData.append(post)
                        print("postData: ",self.postData )
                        self.cartTableView.reloadData()
                        }
                }, withCancel: nil)
        }else {
            print("FechData: you are not signed in")
                }
    }
    func setCart(completion: @escaping () -> Void){
        let uid = Auth.auth().currentUser?.uid
        self.userCartData = [String]()
           let userRef = Database.database().reference().child("User-cart").child(uid!)
           userRef.observeSingleEvent(of: .value, with: { (snapshot) in
               if let dictionary = snapshot.value as? NSDictionary {
                   self.userCartData.append(dictionary["itemID"] as? String ?? "")
                   completion()
             }
            }, withCancel: nil)
           print("count userCartData: \(self.userCartData.count)")
       }

}
