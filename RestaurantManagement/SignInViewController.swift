//
//  SignInViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/12/7.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var notice: UILabel!

    var isorder:Bool = false
    
    @IBAction func signin(_ sender: UIButton) {
        
        let signname = name.text
        let signpassword = password.text
        
        if signname != nil && signpassword != nil {
            notice.isHidden = false
            BmobUser.loginInbackground(withAccount: signname, andPassword: signpassword, block: { (loginuser, error) in
                if error == nil {
                    let userid = loginuser?.objectId!
                    let user = UserDefaults.standard
                    user.set(userid, forKey: "UserId")
                    user.set(signname, forKey: "UserName")
                    user.set(signpassword, forKey: "UserPassword")
                    
                    self.isorder = loginuser?.object(forKey: "isorder") as! Bool
                    self.notice.isHidden = true
                    user.set(self.isorder, forKey: "isorder")
                    
                    print(self.isorder)
                    
                    self.performSegue(withIdentifier: "loginsuccess", sender: nil)
                }else{
                    let notice = UIAlertController(title: "提示", message: "登录失败,请检查账号密码或网络连接！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                    notice.addAction(action)
                    self.present(notice, animated: true, completion: nil)
                    self.notice.isHidden = true
                }
            })
        }else{
            let notice = UIAlertController(title: "提示", message: "密码或账号不能为空！", preferredStyle: .alert)
            let action = UIAlertAction(title: "好的", style: .default, handler: nil)
            notice.addAction(action)
            self.present(notice, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notice.isHidden = true
        
        enter.layer.borderWidth = 2
        enter.layer.borderColor = UIColor.white.cgColor
        back.layer.borderColor = UIColor.white.cgColor
        back.layer.borderWidth = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginsuccess" {
            let dest = segue.destination as! ViewController
            dest.islogin = true
            dest.isnetwrong = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
