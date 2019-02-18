//
//  OrderManagrmentTableViewCell.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/12/1.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class OrderManagrmentTableViewCell: UITableViewCell {

    @IBOutlet weak var orderimage: UIImageView!
    @IBOutlet weak var ordername: UILabel!
    @IBOutlet weak var orderdetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
