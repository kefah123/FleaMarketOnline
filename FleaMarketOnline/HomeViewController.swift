//
//  HomeViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 2/24/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var postData = [[String]]()
    var searchData = [[String]]()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    var ref: DatabaseReference?
    var databaseHandle:DatabaseHandle?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        
        self.tableView.reloadData()
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //save the name of current view controller
        UserDefaults.standard.set("Home", forKey: "currentViewController")
        ref = Database.database().reference()
        //read data from data base
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: {(snapshot) in
            let post = snapshot.value as? [String]
            if let actualPost = post{
                self.postData.append(actualPost)
                self.tableView.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Post count : ",  postData.count)
        if searching {
            return searchData.count
        }
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        if searching {
            cell.textLabel?.text = searchData[indexPath.row][0]
        }else{
            cell.textLabel?.text = postData[indexPath.row][0]
        }
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
    


}
extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = postData.filter({
            item in
            return item[0].localizedCaseInsensitiveContains(searchText)
            
        })
        searching = true
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
}
