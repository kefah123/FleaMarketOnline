//
//  ChatLogController.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 3/25/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit

class ChatLogController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chat Log Controller"
        messageTextView.delegate = self
        
    }
    func textViewShouldReturn(_ textField: UITextField!) -> Bool {   //delegate method
      messageTextView.resignFirstResponder()
      return true
    }
}

