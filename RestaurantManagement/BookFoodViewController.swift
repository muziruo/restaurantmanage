//
//  BookFoodViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/24.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class BookFoodViewController: UIViewController {

    @IBOutlet weak var foodlargeimage: UIImageView!
    @IBOutlet weak var foodname: UILabel!
    @IBOutlet weak var foodprice: UILabel!
    @IBOutlet weak var bookbutton: UIButton!
    @IBOutlet weak var canelbutton: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var booked:Bool = false
    var listindex:Int!
    var status:Bool = false
    
    @IBAction func gobacktofoodlist(_ sender: Any) {
        booked = true
        performSegue(withIdentifier: "gobacktolist", sender: sender)
    }
    
    //注意结构体的使用
    var foodkind : BmobObject!
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.center = foodlargeimage.center
        foodlargeimage.addSubview(spinner)
        spinner.startAnimating()
        
        if status {
            bookbutton.setTitle("取消预订", for: .normal)
        }
        
        foodname.text = foodkind.object(forKey: "name") as? String
        var price = "¥"
        price += foodkind.object(forKey: "price") as! String
        foodprice.text = price
        //foodprice.text = foodkind.object(forKey: "price") as? String
        //设置占位图片
        foodlargeimage.image = UIImage(named: "someone")
        
        if let largeimage = foodkind.object(forKey: "image") as? BmobFile {
            let imageurl = URL(string: largeimage.url)
            let session = URLSession.shared
            
            let datadask = session.dataTask(with: imageurl!, completionHandler: { (dataimg, respone, error) in
                let imagedata = UIImage(data: dataimg!)
                //得到图片之后在主线程中更新UI
                OperationQueue.main.addOperation {
                    self.spinner.stopAnimating()
                    self.foodlargeimage.image = imagedata
                }
            }) as URLSessionTask
            datadask.resume()
        }

        
        //为按钮加上边框
        bookbutton.layer.borderWidth = 2
        bookbutton.layer.borderColor = UIColor.white.cgColor
        canelbutton.layer.borderWidth = 2
        canelbutton.layer.borderColor = UIColor.white.cgColor
        
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
