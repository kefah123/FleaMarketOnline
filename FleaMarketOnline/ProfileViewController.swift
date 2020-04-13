//
//  ProfileViewController.swift
//  FleaMarketOnline
//
//  Created by 吴亨俊 on 4/13/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//
import UIKit
import FirebaseAuth

class ProfileViewController: UITabBarController {
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkLoggedInUserStatus()
    }
    fileprivate func checkLoggedInUserStatus(){
        
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let signOrLog = ViewController()
                let signOrLogNavigationController = UINavigationController(rootViewController: signOrLog)
                self.present(signOrLogNavigationController,animated: true, completion: nil)
                return
            }
        }
    }
}

