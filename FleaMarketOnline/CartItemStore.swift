//
//  CartItemStore.swift
//  FleaMarketOnline
//
//  Created by Anyi Huang on 3/17/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class ItemStore{
    var allItems = [CartItem]()
    var userName:String?
    var userPrice:String?
    @discardableResult func createItem()->CartItem{
        let newItem = CartItem(name:userName,price:userPrice)

        allItems.append(newItem)
        return newItem
    }
    init(){
        //the number of products stored in this user collection
        //will change later
        for _ in 0..<20{
            createItem()
        }
    }
    func getdata() -> (String?,String?){
        //connect to Database
        let db = Firestore.firestore()
        //use the email address to read to user ID from server(*how to pass the user info from login page to here)
        //use rendong@test.com as a example to test, will change to variable later
        db.collection("users").whereField("email", isEqualTo:"rendong@test.com").getDocuments {(snapshot, error) in
        if error == nil && snapshot != nil{
            for document in snapshot!.documents{
                let documentData = document.data()
                //grab the item info from server within userID
                //It takes the specific data below,will change later
                self.userName = documentData["id"] as? String
                self.userPrice = documentData["email"] as? String
                       }
                   }
               }
            return (userName,userPrice)
    }
}
