//
//  ChatMessageCell.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 4/19/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageCell:UICollectionViewCell {
    
    @IBOutlet var messageCell: UITextView!
    
    
    func setMessageCell(message:Message){
        messageCell.text = message.text
    }
}
