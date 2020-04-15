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
            print(post)
            if let actualPost = post{
                print(actualPost[6])
                if actualPost[6] == "true"{
                    self.postData.append(actualPost)
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

}
