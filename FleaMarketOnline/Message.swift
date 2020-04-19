//
//  Message.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 4/12/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: Int?
    var toId: String?
    var toName: String?
    var fromName: String?
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid || fromId == "-M4joH77M1MuPS7j9w0r" {
                return toId
        } else {
                return fromId
        }
    }
    
}
