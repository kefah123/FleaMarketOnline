//
//  HomeViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 2/24/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var postData = [String]()

    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: {(snapshot) in
            let post = snapshot.value as? String
            if let actualPost = post{
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = postData[indexPath.row]
        return cell
    }
    


}
