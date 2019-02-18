//
//  OrderDetailViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/12/1.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var tablenum: UILabel!
    @IBOutlet weak var dishes: UILabel!
    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var back: UIButton!
    
    //
    var detailobject:BmobObject!
    var orderid:String!
    var ordertable:[Int]!
    var orderdishes:[String]!
    var ordertime:String!
    
    //服务员完成订单，修改订单状态为已服务，并且将订单加入历史记录
    @IBAction func complete(_ sender: UIButton) {
        let deleteorder = BmobObject.init(outDataWithClassName: "bookedtable", objectId: orderid)
        deleteorder?.setObject(true, forKey: "complete")
        deleteorder?.updateInBackground(resultBlock: { (success, error) in
            if error == nil {
                let history = BmobObject(className: "orderhistory")
                history?.setObject(self.orderid, forKey: "orderid")
                history?.setObject(self.ordertable, forKey: "ordertable")
                history?.setObject(self.orderdishes, forKey: "orderdishes")
                history?.setObject(self.ordertime, forKey: "ordertime")
                history?.saveInBackground(resultBlock: { (success, error) in
                })
                
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "backtoorderlist", sender: nil)
                }
            }else{
                let notice = UIAlertController(title: "提示", message: "完成失败,请检查网络！", preferredStyle: .alert)
                let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                notice.addAction(action)
                self.present(notice, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //按钮加上边框
        complete.layer.borderColor = UIColor.white.cgColor
        back.layer.borderColor = UIColor.white.cgColor
        complete.layer.borderWidth = 2
        back.layer.borderWidth = 2
        
        //解析订单的信息并保存，以便进行历史记录更新
        orderid = detailobject.objectId
        ordertable = detailobject.object(forKey: "seat") as! [Int]
        orderdishes = detailobject.object(forKey: "dishes") as! [String]
        ordertime = detailobject.object(forKey: "createdAt") as! String
        
        //显示该订单相关信息
        var tabletext:String = ""
        for i in 0..<ordertable.count {
            tabletext += String(ordertable[i])
            tabletext += " "
        }
        var dishestext:String = ""
        for i in 0..<orderdishes.count {
            dishestext += orderdishes[i]
            dishestext += " "
        }
        tablenum.text = tabletext
        dishes.text = dishestext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
