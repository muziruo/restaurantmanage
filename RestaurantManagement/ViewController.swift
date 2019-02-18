//
//  ViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/24.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var begin: UIButton!
    @IBOutlet weak var check: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var mapbutton: UIButton!
    @IBOutlet weak var noticetext: UILabel!

    //店铺所在地以及一些登录网络是否有订单信息
    var areaname:String?
    var islogin:Bool = false
    var isnetwrong:Bool = false
    var isorder:Bool = false
    
    @IBAction func gotoregister(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoregister", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //正在获取响应信息，让相应的操作按钮消失
        begin.isHidden = true
        check.isHidden = true
        noticetext.isHidden = false
        
        //从本地取出是否已有订单数据
        let user = UserDefaults.standard
        isorder = user.bool(forKey: "isorder")
                
        //添加等待动画
        spinner.center = mapbutton.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        //按钮边框宽度
        begin.layer.borderWidth = 2
        begin.layer.borderColor = UIColor.white.cgColor
        check.layer.borderWidth = 2
        check.layer.borderColor = UIColor.white.cgColor
        
        getlocation()
        login()
    }
    
    //该界面每次出现都要进行是否结账查询
    override func viewDidAppear(_ animated: Bool) {
        let user = UserDefaults.standard
        isorder = user.bool(forKey: "isorder")
    }
    
    //登录
    func login() {
        //从本地取用户账号和密码信息
        let user = UserDefaults.standard
        let userid = user.value(forKey: "UserId")
        
        //如果本地有账号信息，则自动登录，否则提示注册账号
        if userid != nil {
            let username = user.value(forKey: "UserName")
            let userpassword = user.value(forKey: "UserPassword")
            BmobUser.loginWithUsername(inBackground: username as! String, password: userpassword as! String, block: { (user, error) in
                if error == nil {
                    self.noticetext.isHidden = true
                    self.begin.isHidden = false
                    self.check.isHidden = false
                    self.islogin = true
                    self.isnetwrong = false
                    self.spinner.stopAnimating()
                    self.begin.setTitle("开始预约", for: .normal)
                }else{
                    self.begin.isHidden = false
                    self.noticetext.isHidden = true
                    self.isnetwrong = true
                    self.begin.setTitle("重新登录", for: .normal)
                    self.spinner.stopAnimating()
                    let notice = UIAlertController(title: "提示", message: "登录失败,请检查网络！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                    notice.addAction(action)
                    self.present(notice, animated: true, completion: nil)
                }
            })
        }else{
            self.begin.isHidden = false
            self.islogin = false
            self.noticetext.isHidden = true
            self.spinner.stopAnimating()
            let notice = UIAlertController(title: "提示", message: "你需要一个账号来进行登录", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default, handler: nil)
            begin.setTitle("注册用户", for: .normal)
            notice.addAction(action)
            self.present(notice, animated: true, completion: nil)
        }
    }

    //根据用户状态来决定是前往点菜还是注册
    @IBAction func RegisterOrBegin(_ sender: UIButton) {
        if isnetwrong == false {
            if islogin {
                if isorder == false {
                    self.performSegue(withIdentifier: "gotoorder", sender: nil)
                }else{
                    let notice = UIAlertController(title: "提示", message: "您已经下达了订单，请勿重复下达订单！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                    notice.addAction(action)
                    self.present(notice, animated: true, completion: nil)
                }
            }else{
                self.performSegue(withIdentifier: "gotoregister", sender: nil)
            }
        }else{
            self.spinner.startAnimating()
            begin.isHidden = true
            check.isHidden = true
            noticetext.isHidden = false
            login()
        }
    }
    
    //前往商店管理页面
    @IBAction func management(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotomanagement", sender: nil)
    }
    
    //取回位置数据
    func getlocation() {
        let query = BmobQuery(className: "table")
        query?.findObjectsInBackground({ (result, error) in
            if error == nil {
                let results = result?[0] as! BmobObject
                self.areaname = results.object(forKey: "areaname") as? String
                
                let tableid = results.objectId
                let user = UserDefaults.standard
                user.set(tableid, forKey: "tableid")
                
                OperationQueue.main.addOperation {
                    self.mapbutton.setBackgroundImage(UIImage(named: "local"), for: .normal)
                }
            }else{
                print(error ?? "取回数据错误")
            }
        })
    }
    
    //进入地图，将位置信息传送到地图页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotomap" {
            let dest = segue.destination as? MapViewController
            dest?.areaname = self.areaname
        }
    }
    
    @IBAction func backfromregister(segue:UIStoryboardSegue){
        
    }
    
    //从管理页面返回
    @IBAction func backfrommanagement(segue:UIStoryboardSegue){
        
    }
    
    //
    @IBAction func canel(segue:UIStoryboardSegue){
        
    }
    
    //
    @IBAction func canel6(segue:UIStoryboardSegue){
        
    }
    
    //从地图界面返回
    @IBAction func canelfrommap(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func canelfromlogin(segue:UIStoryboardSegue){
        
    }
    
    //内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

