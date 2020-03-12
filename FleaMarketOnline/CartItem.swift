//
//  CartItem.swift
//  FleaMarketOnline
//
//  Created by Anyi Huang on 3/11/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class CartItem:NSObject{
    
    var itemName: String
    var priceInDollar:String
    //create a class that init the value needs to list
    init(itemName:String,priceInDollar:String){
        self.itemName = itemName
        self.priceInDollar = priceInDollar
        super.init()
    }
    convenience init(userId:String?) {
        if userId == nil{
            self.init(itemName:"",priceInDollar:"")
        }else{
            let ListItems = getdata().userId
            let ListPrice = getdata().UserPrice
            self.init(itemName:ListItems,priceInDollar:ListPrice)
        }
    }
    func getdata() -> (userId:String,UserPrice:String){
        //connect to Database
        let db = Firestore.firestore()
        var userId:String
        var userPrice:String
        //use the email address to read to user ID from server(*how to pass the user info from login page to here)
        //use rendong@test.com as a example to test, will change to variable later
        db.collection("users").whereField("email", isEqualTo:"rendong@test.com").getDocuments {(snapshot, error) in
        if error == nil && snapshot != nil{
            for document in snapshot!.documents{
                let documentData = document.data()
                //grab the item info from server within userID
                //It takes the specific data below,will change later
                userId = documentData["id"] as! String
                userPrice = documentData["email"] as! String
                       }
                   }
               }
        return (userId,userPrice)
    }
}
