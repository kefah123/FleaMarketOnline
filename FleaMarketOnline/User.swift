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
    var id: String?
    
   /* init(name: String, email: String, date: String) {
        self.name = name
        self.email = email
        self.date = date
        super.init()
    } */
     init(name: String, email: String, toId: String) {
        self.name = name
        self.email = email
        self.id = toId
        super.init()
        
    }
    
    convenience init(random: Bool = false) {
        if random {
            let myUsers = ["User1", "User2", "User3"]
            let emails = ["user1@gmail.com","user2@gmail.com","user3@gmail.coom"]
     
    
            let idx = arc4random_uniform(UInt32(myUsers.count))
            self.init(name: myUsers[Int(idx)], email: emails[Int(idx)], toId: "")
        } else {
            self.init(name: "", email: "", toId:"") }
            }
    


}

