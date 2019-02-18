//
//  OrderViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/31.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var tablenum: UILabel!
    @IBOutlet weak var foodlist: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var deletebutton: UIButton!
    @IBOutlet weak var summoney: UILabel!

    var objectId:String?
    var results:[BmobObject]?
    var seatuse:[Int]!
    var tableuse:[Bool]!
    var smallnum = 0
    var mediumnum = 0
    var largenum = 0
    
    //删除用户订单
    @IBAction func deteleorder(_ sender: UIButton) {
        
        if objectId != nil{
            let delete:BmobObject = BmobObject(outDataWithClassName: "bookedtable", objectId: objectId)
            delete.deleteInBackground { (success, error) in
                if error == nil {
                    print("订单已删除")
                    self.updatedatabase()
                    
                    //修改用户是否下达订单信息
                    let user = UserDefaults.standard
                    let userid = user.value(forKey: "UserId") as! String
                    let isorder = false
                    let updateuser = BmobObject.init(outDataWithClassName: "_User", objectId: userid)
                    updateuser?.setObject(isorder, forKey: "isorder")
                    updateuser?.updateInBackground()
                    
                    OperationQueue.main.addOperation {
                        self.objectId = nil
                        self.tablenum.text = "无"
                        self.foodlist.text = "无"
                        self.summoney.text = "¥0"
                        let user = UserDefaults.standard
                        user.set(false, forKey: "isorder")
                        let successnotice = UIAlertController(title: "通知", message: "订单已完成！", preferredStyle: .alert)
                        let okaction = UIAlertAction(title: "好的", style: .default, handler: nil)
                        successnotice.addAction(okaction)
                        self.present(successnotice, animated: true, completion: nil)
                        self.getorder()
                    }
                }else{
                    print(error ?? "删除订单发生错误")
                }
            }
        }else{
            let notice = UIAlertController(title: "通知", message: "当前无订单！", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default, handler: nil)
            notice.addAction(action)
            present(notice, animated: true, completion: nil)
        }
    }
    
    //更新座位
    func updatedatabase() {
        
        let usenum:Int! = seatuse.count
        for i in 0..<usenum {
            tableuse[(seatuse[i] - 1)] = false
        }
        
        let user = UserDefaults.standard
        let id = user.value(forKey: "tableid")
        
        let update = BmobObject(outDataWithClassName: "table", objectId: id as! String)
        
        update?.setObject(tableuse, forKey: "usestatus")
        
        update?.updateInBackground(resultBlock: { (success, error) in
            if error == nil {
                print("删除订单 座位更新成功")
            }else{
                print(error ?? "删除订单时座位更新失败")
            }
        })
    }
    
    //得到当前的座位使用状态
    func gettablestatus() {
        let query = BmobQuery(className: "table")
        
        query?.findObjectsInBackground({ (result, error) in
            if error == nil{
                let firsttable = result?[0] as! BmobObject
                self.tableuse = firsttable.object(forKey: "usestatus") as! [Bool]
                
                OperationQueue.main.addOperation {
                    self.spinner.stopAnimating()
                    self.deletebutton.isEnabled = true
                }
                
            }else{
                print("取回座位数据出错")
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        deletebutton.isEnabled = false
        
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.borderWidth = 2
        deletebutton.layer.borderColor = UIColor.white.cgColor
        deletebutton.layer.borderWidth = 2
        
        getorder()
        
        gettablestatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //得到用户订单信息
    func getorder() {
        let query:BmobQuery = BmobQuery(className: "bookedtable")
        query.findObjectsInBackground({ (result, error) in
            if error == nil {
                self.results = result as? [BmobObject]
                
                let username = UserDefaults.standard
                let name = username.string(forKey: "UserId")
                for i in self.results! {
                    if i.object(forKey: "userid") as? String == name {
                        let tablelist:[Int] = (i.object(forKey: "seat") as? [Int])!
                        self.seatuse = tablelist
                        var tablestr:String = ""
                        for i in 0..<tablelist.count {
                            tablestr += String(tablelist[i])
                            tablestr += " "
                        }
                        self.tablenum.text = tablestr
                        var money:String = "¥"
                        money += i.object(forKey: "summoney") as! String
                        self.summoney.text = money
                        let dishlist:[String]? = i.object(forKey: "dishes") as? [String]
                        var dishstr:String = ""
                        
                        if dishlist != nil {
                            for i in 0..<(dishlist?.count)! {
                                dishstr += (dishlist?[i])!
                                dishstr += " "
                            }
                            self.foodlist.text = dishstr
                        }
                        self.objectId = i.object(forKey: "objectId") as? String
                        break
                    }
                }

            }else{
                print("无数据")
                self.spinner.stopAnimating()
            }
        })
    }
}
