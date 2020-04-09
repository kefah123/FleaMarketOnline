//
//  ProfileViewController.swift
//  FleaMarketOnline
//
//  Created by 吴亨俊 on 2/25/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import SwiftUI
import UIKit
import FirebaseAuth

class Profile: UITabBarController {
    override func viewDidLoad() {

        
        
        super.viewDidLoad()
        checkLoggedInUserStatus()
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
struct ProfileViewController: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProfileViewController_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewController()
    }
}
