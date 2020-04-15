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
    func setMessage(message:Message,name:String,date:NSDate){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        userNameView.text = name
        dateView.text = dateFormatter.string(from: date as Date)
        messageView.text = message.text
        dateView.textColor = UIColor.lightGray
        dateView.font = UIFont.systemFont(ofSize: 13)
    }
    

}
