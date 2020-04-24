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

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        if searching {
            return searchData.count
        }
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomePageCell
        
        if searching {
            cell.homePageCellName.text = searchData[indexPath.row][0]
//            cell.homePageCellSeller.text = "by " + searchData[indexPath.row][1]
            cell.homePageCellPrice.text = "$ " + searchData[indexPath.row][2]
        Database.database().reference().child("users").child(searchData[indexPath.row][1]).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
              
              let sellerFirstName = value?["firstName"] as? String ?? ""
              let sellerLastName = value?["lastName"] as? String ?? ""
                
                cell.homePageCellSeller.text = "by "  + sellerFirstName  + " " + sellerLastName
                
              }) { (error) in
                print(error.localizedDescription)
            }
//            cell.textLabel?.text = searchData[indexPath.row][0]
        }else{
            cell.homePageCellName.text = postData[indexPath.row][0]
            cell.homePageCellSeller.text = "by " + postData[indexPath.row][1]
            cell.homePageCellPrice.text = "$ " + postData[indexPath.row][2]
        Database.database().reference().child("users").child(postData[indexPath.row][1]).observeSingleEvent(of: .value, with: { (snapshot) in
                  // Get user value
                  let value = snapshot.value as? NSDictionary
                  
                  let sellerFirstName = value?["firstName"] as? String ?? ""
                  let sellerLastName = value?["lastName"] as? String ?? ""
                    
                    cell.homePageCellSeller.text = "by "  + sellerFirstName  + " " + sellerLastName
                    
                  }) { (error) in
                    print(error.localizedDescription)
                }
//            cell.textLabel?.text = postData[indexPath.row][0]
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
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postData = [[String]]()
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
        self.tableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
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
        self.searchBar.endEditing(true)
        self.tableView.reloadData()
    }
}
