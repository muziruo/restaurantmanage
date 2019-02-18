//
//  CompleteViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/31.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController {

    @IBOutlet weak var goback: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goback.layer.borderColor = UIColor.white.cgColor
        goback.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
