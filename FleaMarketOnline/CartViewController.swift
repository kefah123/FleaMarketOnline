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
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var firstInit  = true

    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        
        print("cart test")
        self.cartTableView.reloadData()
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        //Set the firebase reference
        ref = Database.database().reference()
        
        
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
            databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            let post = snapshot.value as? [String]
                if post?[0] == self.useForUpdate[i][0] &&
                    post?[1] == self.useForUpdate[i][1] &&
                    post?[2] == self.useForUpdate[i][2] &&
                    post?[3] == self.useForUpdate[i][3] &&
                    post?[4] == self.useForUpdate[i][4] &&
                    post?[5] == self.useForUpdate[i][5] {
                    self.ref!.child("Posts/\(key)/6").setValue("False")
                    self.ref!.child("Posts/\(key)/7").setValue("True")
                    
                }
                })
        }
        print("post\(postData)")
        print("update\(useForUpdate)")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cart count : ",  postData.count)
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
        print("cart items :",postData[indexPath.row])
        if postData[indexPath.row][6] == "True"{
            print("yes")
            cell.textLabel?.text = postData[indexPath.row][0]
        }
        //cell.textLabel?.text = postData[indexPath.row][0]
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
        print(postData[indexPath.row][0])
        self.navigationController?.pushViewController(vc, animated: true)
    }
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
                
    //            vg.remove(at: indexPath.item)
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (firstInit){
            
        }else{
            useForUpdate = []
        }
        
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            self.firstInit = false
                    let post = snapshot.value as? [String]
                    //print(post!)
                    if let actualPost = post{
                        //print(actualPost[6])
                        if actualPost[6] == "True"{
                            //self.postData.append(actualPost)
                            self.useForUpdate.append(actualPost)
                            self.postData = self.useForUpdate
                            print(self.postData)
                            print("update\(self.postData)")
        //                    DispatchQueue.main.async {
        //                         self.cartTableView.reloadData()
        //                    }
                           
                        }
                        
                    }
                       }){ (error) in
                        print(error.localizedDescription)
                }
        DispatchQueue.main.async { self.cartTableView.reloadData() }
        
    }

}
