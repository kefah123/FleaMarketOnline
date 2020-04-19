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
    
    @IBOutlet var bubbleView: UIView!

    @IBOutlet var bubbleViewWidthConstraint: NSLayoutConstraint!
    
    let blueMessage = UIColor(red: 0, green: 0.53, blue: 0.97, alpha: 0.8)
    let grayMessage = UIColor(red:0.82,green:0.82,blue:0.82,alpha:0.6)
    func setMessageCell(message:Message,bubbleAnchor:CGFloat, to:Bool){
        if to {
            messageCell.text = message.text
            messageCell.textColor = .white
            messageCell.backgroundColor = UIColor.clear
            bubbleView.backgroundColor = blueMessage
            bubbleViewWidthConstraint.constant = bubbleAnchor
            bubbleView.layer.cornerRadius = 16
            bubbleView.layer.masksToBounds = true
        } else {
            messageCell.text = message.text
            messageCell.textColor = .black
            messageCell.backgroundColor = UIColor.clear
            bubbleView.backgroundColor = grayMessage
            bubbleViewWidthConstraint.constant = bubbleAnchor
            bubbleView.layer.cornerRadius = 16
            bubbleView.layer.masksToBounds = true
            
        }
    }
}
