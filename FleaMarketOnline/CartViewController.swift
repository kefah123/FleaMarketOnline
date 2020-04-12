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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        print("cart test")
        //self.tableView.reloadData()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //Set the firebase reference
        ref = Database.database().reference()
        //Retrieve the posts and listen for changes
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            //code to execute when a chld is added user "Posts"
            //take the value from the snapshot and added it to the post data array
            let post = snapshot.value as? [String]
            if let actualPost = post{
                //append the data to our postData array
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
               })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cart count : ",  postData.count)
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
          print(postData[indexPath.row])
          cell.textLabel?.text = postData[indexPath.row][0]
          return cell
      }
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let Storyboard = UIStoryboard(name: "Cart", bundle: nil)
          let vc = Storyboard.instantiateViewController(withIdentifier: "HomeCellViewController") as! HomeCellViewController
          vc.getName = postData[indexPath.row][0]
          print(postData[indexPath.row][0])
          self.navigationController?.pushViewController(vc, animated: true)
      }
}
