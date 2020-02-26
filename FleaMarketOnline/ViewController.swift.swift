//
//  ViewController.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 2/8/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import FirebaseDatabase
<<<<<<< HEAD

=======
>>>>>>> d24b682c0ce8a6577bffc92ee9ad19b551e5acc1
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let ref = Database.database().reference();
        ref.child("id/name").setValue("key")
    }

   
}

