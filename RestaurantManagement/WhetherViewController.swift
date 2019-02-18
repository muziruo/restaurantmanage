//
//  WhetherViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/24.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class WhetherViewController: UIViewController {

    @IBOutlet weak var complete: UIButton!
    @IBOutlet weak var keepon: UIButton!
    @IBOutlet weak var goback: UIButton!
    @IBOutlet weak var resultlabel: UILabel!
    
    var result:[String:Int]!
    var tablestatus:BmobObject!
    var seatstatus:[Bool]!
    var smalllimit = 0
    var mediumlimit = 0
    var largelimit = 0
    var needsmall = 0
    var needmedium = 0
    var needlarge = 0
    var booknum:[Int] = []
    var smallsum = 0
    var mediumsum = 0
    var largesum = 0
    
    //不点菜直接完成预约
    @IBAction func upload(_ sender: UIButton) {
        let data = UserDefaults.standard
        let username = data.string(forKey: "UserId")
        let uploadlist = BmobObject(className: "bookedtable")
        uploadlist?.setObject(booknum, forKey: "seat")
        uploadlist?.setObject(username, forKey: "userid")
        uploadlist?.setObject(true, forKey: "complete")
        uploadlist?.setObject("0", forKey: "summoney")
        uploadlist?.saveInBackground(resultBlock: { (success, error) in
            if error == nil {
                print("上传成功")
                
                let orderid = uploadlist?.objectId
                let user = UserDefaults.standard
                user.set(orderid, forKey: "orderid")
                user.set(true, forKey: "isorder")
                self.updatedatabase()
                
                //更改用户是否点单状态
                let userid = user.value(forKey: "UserId") as! String
                let updateuser = BmobObject(outDataWithClassName: "_User", objectId: userid)
                updateuser?.setObject(true, forKey: "isorder")
                updateuser?.updateInBackground()
                
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "withoutorderdishes", sender: nil)
                }
            }else{
                let notice = UIAlertController(title: "通知", message: "预定出错", preferredStyle: .alert)
                let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                notice.addAction(action)
                self.present(notice, animated: true, completion: nil)
            }
        })
    }
    
    //继续点菜
    @IBAction func uploadwithdishes(_ sender: UIButton) {
        updatedatabase()
        let user = UserDefaults.standard
        user.set(true, forKey: "isorder")
        performSegue(withIdentifier: "orderdishes", sender: nil)
    }
    
    //更新云端座位使用信息
    func updatedatabase() {
        let user = UserDefaults.standard
        let id = user.value(forKey: "tableid")
        
        let update = BmobObject(outDataWithClassName: "table", objectId: id as! String)
        
        update?.setObject(seatstatus, forKey: "usestatus")
        
        update?.updateInBackground(resultBlock: { (success, error) in
            if error == nil {
                print("更新成功")
            }else{
                let notice = UIAlertController(title: "通知", message: "预定出错", preferredStyle: .alert)
                let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                notice.addAction(action)
                self.present(notice, animated: true, completion: nil)
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //给按钮加上边框
        complete.layer.borderColor = UIColor.white.cgColor
        complete.layer.borderWidth = 2
        keepon.layer.borderWidth = 2
        keepon.layer.borderColor = UIColor.white.cgColor
        goback.layer.borderColor = UIColor.white.cgColor
        goback.layer.borderWidth = 2
        
        let label = gettheseatnum()
        resultlabel.text = label
    }

    
    //得到座位号，同时分析出到底占用了哪几张桌子
    func gettheseatnum() -> String{
        seatstatus = tablestatus.object(forKey: "usestatus") as! [Bool]
        smalllimit = Int(tablestatus.object(forKey: "small") as! String)! - 1
        mediumlimit = smalllimit + Int(tablestatus.object(forKey: "medium") as! String)!
        largelimit = mediumlimit + Int(tablestatus.object(forKey: "large") as! String)!
        needsmall = result["small"]!
        needmedium = result["medium"]!
        needlarge = result["large"]!
        
        for i in 0...smalllimit {
            if needsmall <= 0 {
                break
            }else{
                if !seatstatus[i] {
                    seatstatus[i] = true
                    needsmall = needsmall - 1
                    booknum += [i+1]
                }
            }
        }
        for i in smalllimit+1...mediumlimit {
            if needmedium <= 0 {
                break
            }else{
                if !seatstatus[i] {
                    seatstatus[i] = true
                    needmedium = needmedium - 1
                    booknum += [i+1]
                }
            }
        }
        for i in mediumlimit+1...largelimit {
            if needlarge <= 0 {
                break
            }else{
                if !seatstatus[i] {
                    seatstatus[i] = true
                    needlarge = needlarge - 1
                    booknum += [i+1]
                }
            }
        }
        
        var booknumstring = ""
        for i in 0..<booknum.count {
            booknumstring += String(booknum[i])
            booknumstring += " "
        }
        
        print(seatstatus)
        return booknumstring
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderdishes" {
            let dest = segue.destination as! FoodListViewController
            dest.seat = booknum
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func canel3(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func canel7(segue:UIStoryboardSegue){
        
    }
}
