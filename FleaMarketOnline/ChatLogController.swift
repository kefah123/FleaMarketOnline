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


    @IBOutlet weak var messagesView: UICollectionView!
    @IBOutlet var sendContainerView: UIView!
    @IBOutlet var messageInput: UITextView!
    var dataStore = UserDefaults.standard
    var message: Message?
    var messages = [Message]()
    var userName:String?
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if checkLogInStatus() {
            navigationItem.title = userName
            observeChatLog()
            messageInput.delegate = self
            sendContainerView.layer.borderWidth = 0.3
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            
            view.addGestureRecognizer(tap)
           
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            messagesView?.alwaysBounceVertical=true
        }
    }/*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.messagesView.scrollToItem(at:IndexPath(item: indexNumber, section: sectionNumber), at: .right, animated: false)
        self.messagesView!.scrollToItemAtIndexPath(indexForTheLast, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: false)
    }*/
    func checkLogInStatus() -> Bool{
        if Auth.auth().currentUser != nil {
            print("you are signed in")
            return true
        } else {
            print("you are not signed in")
            dataStore.set("compose", forKey: "status")
            let sb = UIStoryboard(name: "LoginSignUp", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        }

    }
    
    func observeChatLog() {
        guard let uid = Auth.auth().currentUser?.uid, let id = message?.verifyPartnerId() else { return }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(id)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
                  let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? NSDictionary else {
                return
                }
                
                let message = Message()
                message.fromId = dictionary["fromId"] as? String ?? ""
                message.text = dictionary["text"] as? String ?? ""
                message.timestamp = dictionary["timestamp"] as? Int ?? 0
                message.toId = dictionary["toId"] as? String ?? ""
                message.toName = dictionary["toUser"] as? String ?? ""
                message.fromName = dictionary["fromUser"] as? String ?? ""
                
               
                self.messages.append(message)
                self.reloadTableData()
               /* DispatchQueue.main.async {
                    self.messagesView.reloadData()
                    self.messagesView!.scrollToItem(at: IndexPath(item: self.messages.count-1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
                }*/
            }, withCancel: nil)
        }, withCancel: nil)
 
  
    }
    func reloadTableData() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        DispatchQueue.main.async {
            self.messagesView.reloadData()
            self.messagesView!.scrollToItem(at: IndexPath(item: self.messages.count-1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
            
        }
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
        let toId = message!.verifyPartnerId()!
        let toUser = message!.toName!
        let fromUser = message!.fromName!
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let fromId = Auth.auth().currentUser?.uid
        let values = ["text":messageInput.text!,"toId":toId, "fromId":fromId!, "timestamp":timestamp, "toUser":toUser, "fromUser":fromUser] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId!).child(toId)
        let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId!:1])
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId!)
            recipientUserMessagesRef.updateChildValues([messageId!:1])
        }
        messageInput.text=""
    }
}

extension ChatLogController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        var bubbleAnchor: CGFloat = 200
        if let text = messages[indexPath.row].text {
           bubbleAnchor =  getFrameSize(text: text).width + 25
        }
    
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.setMessageCell(message:message,bubbleAnchor:bubbleAnchor,to:true)
        } else {
            cell.setMessageCell(message:message,bubbleAnchor:bubbleAnchor,to:false)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.row].text {
            height = getFrameSize(text: text).height + 18
        }
        return CGSize(width: view.frame.width, height: height)
    }
    func getFrameSize(text:String) -> CGRect {
        let size = CGSize(width: 175, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string:text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        messagesView?.collectionViewLayout.invalidateLayout()
    }

}
