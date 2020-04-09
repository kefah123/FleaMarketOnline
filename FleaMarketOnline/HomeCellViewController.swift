//
//  HomeCellViewController.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 4/9/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit

class HomeCellViewController: UIViewController {
    var getName = String()
    var getSeller = String()
    var getPrice = String()
    var getSB = String()
    var getContect = String()
    var getDescibption = String()
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Seller: UILabel!
    @IBOutlet weak var Price: UILabel!
    @IBOutlet weak var SB: UILabel!
    @IBOutlet weak var Contect: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var AddtoCart: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        Name.text! = "Name :" + getName
        Seller.text! = "Seller : " + getSeller
        Price.text! = "Price : " + getPrice
        SB.text! = "Subject / Usage : " + getSB
        Contect.text! = "Contect : " + getContect
        Description.text! = "Description : " + getDescibption
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
