//
//  CartItem.swift
//  FleaMarketOnline
//
//  Created by Anyi Huang on 3/17/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
class CartItem:NSObject{
    
    var userId:String=""
    var userPrice:String=""
    var itemName: String
    var priceInDollar:String
    //create a class that init the value needs to list
    init(itemName:String,priceInDollar:String){
        self.itemName = itemName
        self.priceInDollar = priceInDollar
        super.init()
    }
    convenience init(name:String?,price:String?) {
        if name==nil && price==nil{
            self.init(itemName:" ",priceInDollar:" ")
        }else{
            self.init(itemName:name!,priceInDollar:price!)

        }
    }
}
