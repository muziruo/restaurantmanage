//
//  OnlyTablenumViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/11/2.
//  Copyright © 2017年 李祎喆. All rights reserved.
//  中间界面提供过渡，无实际作用

import UIKit

class OnlyTablenumViewController: UIViewController {

    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var goback: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //给按钮加上边框
        complete.layer.borderColor = UIColor.white.cgColor
        complete.layer.borderWidth = 2
        goback.layer.borderWidth = 2
        goback.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
