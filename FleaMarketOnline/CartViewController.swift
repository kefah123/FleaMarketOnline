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
    var uid = Auth.auth().currentUser?.uid
    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        print("cart test")
        if Auth.auth().currentUser != nil{
//            var userName = Auth.auth().currentUser
//            print("user:\(userName)")
            print("logined:\(uid)")
            self.cartTableView.reloadData()
            super.viewDidLoad()
            cartTableView.delegate = self
            cartTableView.dataSource = self
            //Set the firebase reference
            ref = Database.database().reference()
        }else {
          print("you are not  signed in")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)

          return
        }
        let cartRef = Database.database().reference().child("User-cart").child(uid!)
        cartRef.observe(.childAdded, with: { (snapshot) in
                var post = [String]()
                if let dictionary = snapshot.value as? NSDictionary {
                    let  key = snapshot.key
                    post.append( dictionary["Name"] as? String ?? "")
                    post.append( dictionary["Price"] as? String ?? "")
                    post.append( dictionary["Subject"] as? String ?? "")
                    post.append( dictionary["Contact"] as? String ?? "")
                    post.append( dictionary["Description"] as? String ?? "")
                    post.append(dictionary["Seller"] as? String ?? "")
                    post.append(dictionary["ItemID"] as? String ?? "")
                    
                    self.postData.append(post)
                    self.cartTableView.reloadData()
                    
                       
                 }
         }, withCancel: nil)


       
    }
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
    //check out done
    @IBAction func checkOut(_ sender: UIButton){
        ref = Database.database().reference()
        print (postData.count)
        for i in 0..<postData.count{
            print ("\(postData.count) ++ i = \(i)" )
            postData[0][6]="False"
            postData[0][7] = "True"
            postData.remove(at: 0)
            self.cartTableView.reloadData()
            //update database
            let Storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "HomeCellViewController") as! HomeCellViewController
            ref = Database.database().reference()
            databaseHandle = ref?.child("User-posts").observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            let post = snapshot.value as? [String]
                if post?[0] == self.useForUpdate[i][0] &&
                    post?[1] == self.useForUpdate[i][1] &&
                    post?[2] == self.useForUpdate[i][2] &&
                    post?[3] == self.useForUpdate[i][3] &&
                    post?[4] == self.useForUpdate[i][4] &&
                    post?[5] == self.useForUpdate[i][5] {
                    //self.ref!.child("Posts/\(key)/6").setValue("False")
                    self.ref!.child("Posts/\(key)/7").setValue("True")
                    self.ref!.child("Posts/\(key)/8").setValue(self.uid)
                }
                })
        }
        print("post\(postData)")
        print("update\(useForUpdate)")
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
                    self.postData.remove(at:indexPath.row)
                    self.useForUpdate[indexPath.row][6] = "False"
                    self.ref = Database.database().reference()
                    self.databaseHandle = self.ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
                    let key = snapshot.key
                    let post = snapshot.value as? [String]
                        if post?[0] == self.useForUpdate[indexPath.row][0] &&
                            post?[1] == self.useForUpdate[indexPath.row][1] &&
                            post?[2] == self.useForUpdate[indexPath.row][2] &&
                            post?[3] == self.useForUpdate[indexPath.row][3] &&
                            post?[4] == self.useForUpdate[indexPath.row][4] &&
                            post?[5] == self.useForUpdate[indexPath.row][5] {
                            self.ref!.child("Posts/\(key)/6").setValue("False")
                            
                        }
                        })
                    self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
                
                })
                
                ac.addAction(deleteAction)
                // put up the controller as a modal view
              
                present(ac, animated: true, completion: nil)
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        super.viewWillAppear(animated)

        DispatchQueue.main.async { self.cartTableView.reloadData() }
        
        
    }
    
    func setCart(completion: @escaping () -> Void){
        self.userCartData = [String]()
           let userRef = Database.database().reference().child("User-cart").child(self.uid!)
           userRef.observeSingleEvent(of: .value, with: { (snapshot) in
               if let dictionary = snapshot.value as? NSDictionary {
                   self.userCartData.append(dictionary["itemID"] as? String ?? "")
                   completion()
             }
            }, withCancel: nil)
           print("count userCartData: \(self.userCartData.count)")
       }

}
