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

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var postData = [[String]]()
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?

    @IBOutlet weak var cartTableView: UITableView!
    @IBAction func toggleEditingMode(_ sender: UIButton){
        if isEditing{
            sender.setTitle("Edit", for: .normal)
            
            //Turn off editing mode
            setEditing(false, animated: true)
        }else{
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    override func viewDidLoad() {
        print("cart test")
        //self.tableView.reloadData()
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        //Set the firebase reference
        ref = Database.database().reference()
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = snapshot.value as? [String]
            //print(post!)
            if let actualPost = post{
                //print(actualPost[6])
                if actualPost[6] == "True"{
                    self.postData.append(actualPost)
                    print(self.postData)
                    self.cartTableView.reloadData()
                }
                
            }
               }){ (error) in
                print(error.localizedDescription)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cart count : ",  postData.count)
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
          print("cart items :",postData[indexPath.row])
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
        print(postData[indexPath.row][0])
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func tableView(_ View:UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath){
//        //If the table view is asking to commit a delete command...
//        if editingStyle == .delete{
//            var item = postData[indexPath.row]
//
//            item[6] = "False"
//        }
//    }
}
