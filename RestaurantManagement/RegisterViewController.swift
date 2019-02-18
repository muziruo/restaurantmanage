//
//  RegisterViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/11/30.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noticetext: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noticetext.isHidden = true
        
        register.layer.borderColor = UIColor.white.cgColor
        register.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Register(_ sender: UIButton) {
        let bmobuser = BmobUser()
        noticetext.isHidden = false
        if name != nil && password != nil {
            let username = name.text!
            let userpassword = password.text!
            bmobuser.username = username
            bmobuser.password = userpassword
            let isorder = false
            bmobuser.setObject(isorder, forKey: "isorder")
            bmobuser.signUpInBackground({ (success, error) in
                if error == nil {
                    self.noticetext.isHidden = true
                    let userid = bmobuser.objectId
                    let user = UserDefaults.standard
                    user.set(userid, forKey: "UserId")
                    user.set(username, forKey: "UserName")
                    user.set(userpassword, forKey: "UserPassword")
                    self.noticetext.isHidden = true
                    self.performSegue(withIdentifier: "backtologin", sender: nil)
                }else{
                    let notice = UIAlertController(title: "提示", message: "注册失败,请检查网络！", preferredStyle: .alert)
                    let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                    notice.addAction(action)
                    self.present(notice, animated: true, completion: nil)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
