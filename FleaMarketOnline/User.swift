//
//  User.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 3/21/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    var date: String?
    
    init(name: String, email: String, date: String) {
        self.name = name
        self.email = email
        self.date = date
        super.init()
    }
}

