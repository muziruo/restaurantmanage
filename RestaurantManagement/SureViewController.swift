//
//  SureViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/26.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class SureViewController: UIViewController {

    @IBOutlet weak var surebutton: UIButton!
    @IBOutlet weak var thinkmore: UIButton!
    
    var tablenum:[Int]!
    var foodslist:[String]!
    var foodsid:[String]!
    var money:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //为按钮加上边框
        surebutton.layer.borderWidth = 2
        surebutton.layer.borderColor = UIColor.white.cgColor
        thinkmore.layer.borderColor = UIColor.white.cgColor
        thinkmore.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    //上传用户点菜信息
    @IBAction func savethisbook(_ sender: Any) {
        let username = UserDefaults.standard
        let name = username.string(forKey: "UserId")
        let moneystring = String(money)
        let bookhistory = BmobObject(className: "bookedtable")
        bookhistory?.setObject(foodsid, forKey: "foodsid")
        bookhistory?.setObject(moneystring, forKey: "summoney")
        bookhistory?.setObject(tablenum, forKey: "seat")
        bookhistory?.setObject(foodslist, forKey: "dishes")
        bookhistory?.setObject(name, forKey: "userid")
        bookhistory?.setObject(false, forKey: "complete")
        bookhistory?.saveInBackground(resultBlock: { (succes, error) in
            if error == nil {
                username.set(true, forKey: "isorder")
                let updateuser = BmobObject(outDataWithClassName: "_User", objectId: name)
                updateuser?.setObject(true, forKey: "isorder")
                updateuser?.updateInBackground()
                print("预定成功")
            }else{
                print(error ?? "预定失败")
            }
        })
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
