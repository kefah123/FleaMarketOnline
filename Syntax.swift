//
//  Syntax.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang on 2/8/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//


//Please use this file for syntax check, and plase follow the format
import Foundation


/*************************    Swift *************************/

/*********Make Keyboard disappear on tap********/
/****in view did load:****/
//let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
// view.addGestureRecognizer(tap)
/****then create function and add deinit:****/
//@objc func dismissKeyboard() {
//    view.endEditing(true)
//}
//
//deinit {
//    NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillShowNotification,object:nil)
//            NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object:nil)
//}


/****Move screen up when keyboard shows to not cover input field (may need to modify values)****/
/****In view did load *****/
// NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
// NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
/****Then create function *****/
//@objc func keyboardWillChange(notification: Notification) {
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        if notification.name == UIResponder.keyboardWillShowNotification {
//            view.frame.origin.y = -keyboardRect.height
//        } else {
//            view.frame.origin.y = 0
//        }
//}

/****delay table reload if not working properly *****/
//func reloadTableData() {
//    self.timer?.invalidate()
//    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//}
//
//@objc func handleReloadTable() {
//    self.messages = Array(self.messagesDict.values)
//    self.messages.sort { (message1, message2) -> Bool in return message1.timestamp! > message2.timestamp! }
//    DispatchQueue.main.async {
//        self.tableView.reloadData()
//    }
//}
 // Use dispatchqueue when reloading data inside of closure/firebase call to re-enter main thread


/****Completion Handling format  - Use this when you need to wait for data from firebase before UI change, and you can't use reloadData() **/
//func setUserName(completion: @escaping () -> Void){
//       let userRef = Database.database().reference().child("users").child(self.buyerID!)
//       userRef.observeSingleEvent(of: .value, with: { (snapshot) in
//           if let dictionary = snapshot.value as? NSDictionary {
//               self.firstName = dictionary["firstName"] as? String ?? ""
//               self.lastName = dictionary["lastName"] as? String ?? ""
//               completion()
//           }
//       }, withCancel: nil)
//   }
/****Use it like this:**/
//setUserName {
//    Any code written inside here will not execute until data in setUserName function is loaded from firebase
//}

/*************************    database *************************/

//6: Add to cart or not (true, false)
//7: Buy or not (true, false)

/************************ *   Firebase **********************/

//Read and Write to firebase
//https://firebase.google.com/docs/database/ios/read-and-write

//Fire base auth
//if Auth.auth().currentUser != nil {
//  print("you are signed in")
//  print (Auth.auth().currentUser?.uid)
//  let uid = Auth.auth().currentUser?.uid
//  // do something with uid
//} else {
//  print("you are not  signed in")
//  let signOrLog = ViewController()
//  let signOrLogNavigationController = UINavigationController(rootViewController: signOrLog)
//  self.present(signOrLogNavigationController,animated: true, completion: nil)
//  return
//}

/*************************   References *********************/


//set up the login page
// https://medium.com/@ashikabala01/how-to-build-login-and-sign-up-functionality-for-your-ios-app-using-firebase-within-15-mins-df4731faf2f7

//firebase auth
//https://www.youtube.com/watch?v=1HN7usMROt8


/*************************  Config update *********************/
//02/24, update pods for firestore, auth, core
//02/25, product->shcame->firecore, back again



