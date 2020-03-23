//
//  ChatTableViewCell.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 3/22/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet var userNameView: UILabel!
    @IBOutlet var dateView: UILabel!
    @IBOutlet var messageView: UILabel!
    
    func setUser(user: User){
        userNameView.text = user.name
        dateView.text = user.date
        messageView.text = user.email
        
    }

}
