//
//  HomePageCell.swift
//  FleaMarketOnline
//
//  Created by Rendong Zhang
//  Copyright © 2020 HEWZ. All rights reserved.
//
//  This class is declared to custom cells in home page


import Foundation
import UIKit



class HomePageCell : UITableViewCell{
    
    @IBOutlet weak var homePageCellName: UILabel!
    
    @IBOutlet weak var homePageCellSeller: UILabel!
    @IBOutlet weak var homePageCellPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
