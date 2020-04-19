//
//  HomeCellViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 4/9/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeCellViewController: UIViewController {
    var getName = String()
    var getSeller = String()
    var getPrice = String()
    var getSB = String()
    var getContect = String()
    var getDescibption = String()
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var sellerLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var subjectLB: UILabel!
    @IBOutlet weak var contactLB: UILabel!
    @IBOutlet weak var descriptionLB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLB.text! = getName
        sellerLB.text! = getSeller
        priceLB.text! =  getPrice
        subjectLB.text! = getSB
        contactLB.text! =  getContect
        descriptionLB.text! =  getDescibption
        let currentViewControllName = UserDefaults.standard.value(forKey: "currentViewController")
    }
    

    @IBAction func addToCartAction(_ sender: Any) {
        var ref: DatabaseReference?
        let databaseHandle:DatabaseHandle?
        ref = Database.database().reference()
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            let post = snapshot.value as? [String]
            if post?[0] == self.getName &&
                post?[1] == self.getSeller &&
                post?[2] == self.getPrice &&
                post?[3] == self.getSB &&
                post?[4] == self.getContect &&
                post?[5] == self.getDescibption {
                ref!.child("Posts/\(key)/6").setValue("True")
                //dismiss
                self.navigationController?.popViewController(animated: true)
        
            }
        })
    }
    
    @IBAction func buyItNowAction(_ sender: Any) {
        var ref: DatabaseReference?
        let databaseHandle:DatabaseHandle?
        ref = Database.database().reference()
        databaseHandle = ref?.child("Posts").observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            let post = snapshot.value as? [String]
            if post?[0] == self.getName &&
                post?[1] == self.getSeller &&
                post?[2] == self.getPrice &&
                post?[3] == self.getSB &&
                post?[4] == self.getContect &&
                post?[5] == self.getDescibption {
                ref!.child("Posts/\(key)/7").setValue("True")
                //dismiss
                self.navigationController?.popViewController(animated: true)
        
            }
        })
        
    }
    
    @IBAction func chatAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Chat", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
