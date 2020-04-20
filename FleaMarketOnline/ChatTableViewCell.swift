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
        messageView.text = user.email
    }
    func setMessage(message:Message,name:String,date:NSDate){
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date as Date) {
        dateFormatter.dateFormat = "hh:mm a"
        } else {
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }
        userNameView.text = name
        dateView.text = dateFormatter.string(from: date as Date)
        messageView.text = message.text
        dateView.textColor = UIColor.darkGray
        dateView.font = UIFont.systemFont(ofSize: 15)
        messageView.textColor = UIColor.darkGray
        messageView.font = UIFont.systemFont(ofSize:14)
        userNameView.font = UIFont.systemFont(ofSize:18)
    }
    

}
