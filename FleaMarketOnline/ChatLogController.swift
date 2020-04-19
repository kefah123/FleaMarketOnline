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


    @IBOutlet var sendContainerView: UIView!
    @IBOutlet var messageInput: UITextView!
  //  var toId:String?
    var userName:String?
    var message: Message?


    override func viewDidLoad() {
        
        super.viewDidLoad()


        if userName != nil {
            navigationItem.title = userName
           }
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
        let toId = message!.toId!
        let toUser = message!.toName!
        let fromUser = message!.fromName!
        let timestamp = Int(NSDate().timeIntervalSince1970)
        var fromId = Auth.auth().currentUser?.uid
        let values = ["text":messageInput.text!,"toId":toId, "fromId":fromId ?? "-M4joH77M1MuPS7j9w0r", "timestamp":timestamp, "toUser":toUser, "fromUser":fromUser] as [String : Any]
       // childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
        fromId = "-M4joH77M1MuPS7j9w0r"
        let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!)
        let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId!:1])
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId!:1])
        }
        messageInput.text=""
        
    }
    

}
