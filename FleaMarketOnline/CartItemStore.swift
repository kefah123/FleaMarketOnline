//
//  CartItemStore.swift
//  FleaMarketOnline
//
//  Created by Anyi Huang on 3/11/20.
//  Copyright © 2020 HEWZ. All rights reserved.
//

import Foundation
import UIKit
class ItemStore{
    var allItems = [CartItem]()
    var UserId = ""
    @discardableResult func createItem()->CartItem{
        let newItem = CartItem(userId: UserId)
        
        allItems.append(newItem)
        return newItem
    }
    init(){
        for _ in 0..<20{
            createItem()
        }
    }
}
