//
//  ChatLogController.swift
//  FleaMarketOnline
//
//  Created by Kwasi Efah on 3/25/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UIViewController, UITextViewDelegate {

    @IBOutlet var messageInput: UITextView!
    @IBOutlet var sendContainerView: UIView!
    var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user?.name
        messageInput.delegate = self
        sendContainerView.layer.borderWidth = 0.3
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification,object:nil)
                NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object:nil)
    }

    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
}
    @IBAction func sendMessage(_ sender: UIButton) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
       // let toId = user!.id!
        let values = ["text":messageInput.text!]//,"toId":toId]
        childRef.updateChildValues(values)
        messageInput.text=""
        
    }
    

}
