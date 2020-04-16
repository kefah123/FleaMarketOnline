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
    }
    

    @IBAction func addToCartAction(_ sender: Any) {
    }
    
    @IBAction func buyItNowAction(_ sender: Any) {
    }
    
}
