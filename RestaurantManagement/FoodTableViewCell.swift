//
//  FoodTableViewCell.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/24.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodsmallimage: UIImageView!
    @IBOutlet weak var foodname: UILabel!
    @IBOutlet weak var foodprice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
