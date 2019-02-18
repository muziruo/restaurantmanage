//
//  ReservationViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/24.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var sure: UIButton!
    @IBOutlet weak var canel: UIButton!
    @IBOutlet weak var getnum: UITextField!
    @IBOutlet weak var lastlabel: UILabel!
    
    //准备变量，为了防止出现座位数据未取回就进行分配操作
    var ready:Bool = false
    var lasttable:BmobObject!
    var usestatus:[Bool] = []
    
    //存放桌位剩余量
    //一下表示桌数
    var small = 0
    var medium = 0
    var large = 0
    //一下表示每种桌子剩余的座位数
    var smallnum = 0
    var mediumnum = 0
    var largenum = 0
    //总剩余座位
    var lastseatnum = 0
    
    //分配结果
    var result:[String:Int]?
    
    //点击预约之后进行预约，并且检测是否预约成功
    @IBAction func checkorder(_ sender: Any) {
        //利用输入框中是否有值来决定是否进行预约操作
        if getnum.text != "" {
            if ready {
                let bookpeoplesum = Int(getnum.text!)
                if bookpeoplesum! <= lastseatnum {
                    if bookpeoplesum! > 12 {
                        print(bookpeoplesum)
                        result = fourlevel(num: bookpeoplesum!)
                        print(result ?? "无")
                    }else if bookpeoplesum! <= 12 && bookpeoplesum! > 8 {
                        result = threelevel(num: bookpeoplesum!)
                    }else if bookpeoplesum! <= 8 && bookpeoplesum! > 4 {
                        result = twolevel(num: bookpeoplesum!)
                    }else if bookpeoplesum! <= 4 {
                        result = onelevel(num: bookpeoplesum!)
                    }
                    performSegue(withIdentifier: "booksuccess", sender: nil)
                }else{
                    print("座位已不够啦，请稍后再来")
                }
            }else{
                print("网络不太好哦，请稍后再试")
            }
        }else{
            print("未输入人数!")
        }
    }
    
    //跳转到成功界面前所要做的数据传递
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "booksuccess" {
            let dest = segue.destination as! WhetherViewController
            dest.result = result
            dest.tablestatus = lasttable
            dest.smallsum = small
            dest.mediumsum = medium
            dest.largesum = large
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置textfield的代理，实现下面监控输入的方法
        getnum.delegate = self
        
        //给按钮加上边框
        sure.layer.borderColor = UIColor.white.cgColor
        sure.layer.borderWidth = 2
        canel.layer.borderWidth = 2
        canel.layer.borderColor = UIColor.white.cgColor
        
        gettable()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //取回剩余座位信息
    func gettable() {
        let query = BmobQuery(className: "table")
        query?.findObjectsInBackground({ (result, error) in
            if error == nil {
                self.lasttable = result?[0] as! BmobObject
                OperationQueue.main.addOperation {
                    //得到剩余桌数情况
                    let usestatus:[Bool] = self.lasttable.object(forKey: "usestatus") as! [Bool]
                    let smalllimit = Int(self.lasttable.object(forKey: "small") as! String)!
                    let mediumlimit = Int(self.lasttable.object(forKey: "medium") as! String)!
                    let largelimit = Int(self.lasttable.object(forKey: "large") as! String)!
                
                    var tempsmall = 0
                    var tempmedium = 0
                    var templarge = 0
                    for i in 0..<smalllimit {
                        if !usestatus[i] {
                            tempsmall = tempsmall + 1
                        }
                    }
                    for i in smalllimit..<(mediumlimit + smalllimit) {
                        if !usestatus[i] {
                            tempmedium = tempmedium + 1
                        }
                    }
                    for i in (mediumlimit + smalllimit)..<(smalllimit + mediumlimit + largelimit) {
                        if !usestatus[i] {
                            templarge = templarge + 1
                        }
                    }
                    
                    //现实剩余桌数
                    var labeltext = "大桌:"
                    labeltext += String(templarge)
                    labeltext += " 中桌:"
                    labeltext += String(tempmedium)
                    labeltext += " 小桌:"
                    labeltext += String(tempsmall)
                    
                    //计算剩余位置和保存每种桌子的数量
                    self.small = tempsmall
                    self.medium = tempmedium
                    self.large = templarge
                    
                    self.smallnum = self.small * 4
                    self.mediumnum = self.medium * 8
                    self.largenum = self.large * 12
                    self.lastseatnum = self.large * 12 + self.medium * 8 + self.small * 4
                    
                    labeltext += "  剩余位置:"
                    labeltext += String(self.lastseatnum)
                    self.lastlabel.text = labeltext
                    
                    //将准备变量设置为准备完成的状态
                    self.ready = true
                    self.usestatus = self.lasttable.object(forKey: "usestatus") as! [Bool]
                }
            }else{
                print(error ?? "取回数据出错")
            }
        })
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            if char < 48 {
                return false
            }
            if char > 57 {
                return false
            }
        }
        return true
    }
    
    //从预约成功的界面返回
    @IBAction func canel2(segue:UIStoryboardSegue){
        
    }
    
    //在点击textfield之外的区域的时候停止输入
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //人数小与等于4,返回字典，用来表示什么类型的桌子多少张
    func onelevel(num:Int) -> [String:Int] {
        if small != 0 {
            small = small - 1
            return ["small":1,"medium":0,"large":0]
        }else{
            if medium != 0 {
                return ["small":0,"medium":1,"large":0]
            }else{
                return ["small":0,"medium":0,"large":1]
            }
        }
    }
    
    //人数大于4小于等于8
    func twolevel(num:Int) -> [String:Int] {
        if medium != 0 {
            return ["small":0,"medium":1,"large":0]
        }else{
            if large != 0 {
                return ["small":0,"medium":0,"large":1]
            }else{
                return ["small":2,"medium":0,"large":0]
            }
        }
    }
    
    //人数大于8小于等于12
    func threelevel(num:Int) -> [String:Int] {
        if large != 0 {
            return ["small":0,"medium":0,"large":1]
        }else{
            if medium != 0 {
                if medium == 1 {
                    return ["small":1,"medium":1,"large":0]
                }else{
                    return ["small":0,"medium":2,"large":0]
                }
            }else{
                return ["small":3,"medium":0,"large":0]
            }
        }
    }
    
    //人数大于12
    func fourlevel(num:Int) -> [String:Int] {
        var remainder = 0
        var largetable = 0
        var mediumtable = 0
        var smalltable = 0
        if large != 0 {
            if largenum >= num {
                largetable = num/12 + 1
                remainder = 0
                //return ["small":smalltable,"medium":mediumtable,"large":largetable]
            }else{
                largetable = large
                remainder = num - large * 12
                if mediumnum >= remainder {
                    mediumtable = remainder/8 + 1
                    remainder = 0
                }else{
                    mediumtable = medium
                    remainder = remainder - medium * 8
                    //最后肯定够
                    smalltable = remainder/4 + 1
                    remainder = 0
                }
            }
        }else{
            if medium != 0 {
                if mediumtable >= num {
                    mediumtable = num/8 + 1
                    remainder = 0
                    //return ["small":smalltable,"medium":mediumtable,"large":largetable]
                }else{
                    mediumtable = medium
                    remainder = num - medium * 8
                    smalltable = remainder/4 + 1
                    remainder = 0
                }
            }else{
                smalltable = num/4 + 1
                remainder = 0
                //return ["small":smalltable,"medium":mediumtable,"large":largetable]
            }
        }
        return ["small":smalltable,"medium":mediumtable,"large":largetable]
    }
}
