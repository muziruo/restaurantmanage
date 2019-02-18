//
//  FoodListViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/10/24.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class FoodListViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    @IBOutlet weak var booked: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //云端取回数组
    var foodlist:[BmobObject] = []
    //用户所要订的菜
    var bookedtable:[Bool] = []
    //用户的座位
    var seat:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //为窗口加上加载标志
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        //为按钮加上边框
        booked.layer.borderColor = UIColor(red: 249/255, green: 205/255, blue: 121/255, alpha: 1).cgColor
        booked.layer.borderWidth = 1
        
        getallfood()
        
        tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    
    
    //取回菜单
    func getallfood() {
        let query:BmobQuery = BmobQuery(className: "foodlist")
        
        query.findObjectsInBackground { (result, error) in
            if error == nil {
                self.foodlist = result as! [BmobObject]
                OperationQueue.main.addOperation {
                    self.tableview.reloadData()
                    self.spinner.stopAnimating()
                    //建立起预定标记表
                    for _ in 0..<self.foodlist.count {
                        self.bookedtable.append(false)
                    }
                }
            }else{
                print(error ?? "取回数据发生错误")
            }
        }
        

        /*
        //从该类中取出结果
        //let query = AVQuery(className: "FoodKinds")
        let query = LCQuery(className: "FoodKinds")
        //按照时间降序排列
        //query.order(byDescending: "createdAt")
        query.whereKey("createdAt", .descending)
        
        //取回数据
        /*
         query.findObjectsInBackground { (results, error) in
         if let result = results as? [AVObject] {
         //将所得数据给列表
         self.foodlist = result
         //主线程刷新
         OperationQueue.main.addOperation {
         self.tableview.reloadData()
         }
         }
         }
         */
        /*query.find() { result in
         if let results = result as? [LCObject] {
         self.foodlist = results
         OperationQueue.main.addOperation {
         self.tableview.reloadData()
         }
         }
         }
         */
        //let query2 = LCQuery(className: "Foodkinds")
        
        
        foodlist = query.find().objects!
        
        /*
        query.find { (result) in
            switch result {
            case .success(let results):
                self.foodlist = results
                break
            case .failure(let error):
                print(error)
                print("以上是错误信息")
            }
        }
         */
         */
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //列表有多少块儿
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //列表有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodlist.count
    }
    
    //tableview的建立
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodcell", for: indexPath) as! FoodTableViewCell
        
        //let foods = foodlist[indexPath.row]
        let foods = foodlist[indexPath.row]
        //设置占位图片
        cell.foodsmallimage.image = UIImage(named:"someone")
        
        cell.foodname.text = foods.object(forKey: "name") as? String
        cell.foodprice.text = foods.object(forKey: "price") as? String
        cell.foodsmallimage.image = UIImage(named: "food")
        
        //注意，从云端取回的是url，并不是图片！！！！！！！！！！！！！
        //而且要异步执行，防止阻塞UI
        if let largeimage = foods.object(forKey: "image") as? BmobFile {
            let imageurl = URL(string: largeimage.url)
            //let imagedata = NSData(contentsOf: imageurl!)
            let session = URLSession.shared
            
            let datadask = session.dataTask(with: imageurl!, completionHandler: { (dataimg, respone, error) in
                let imagedata = UIImage(data: dataimg!)
                //得到图片之后在主线程中更新UI
                OperationQueue.main.addOperation {
                    cell.foodsmallimage.image = imagedata
                }
            }) as URLSessionTask
            datadask.resume()
        }
        
        
        /*
        if let largeimage = foods["image"] as? AVFile {
            largeimage.getDataInBackground({ (data, error) in
                if let data = data {
                    //主线程中更新图片
                    OperationQueue.main.addOperation {
                        cell.foodsmallimage.image = UIImage(data: data)
                    }
                }
            })
        }
        */
        /*
        if let smallimage = foods.get("image") as? LCData {
            OperationQueue.main.addOperation {
                cell.foodsmallimage.image = UIImage(data: smallimage.dataValue!)
            }
        }
        */
        return cell
    }
    
    
    
    //为转场做相应的数据传递工作
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotobook" {
            let dest = segue.destination as!BookFoodViewController
            dest.foodkind = foodlist[(tableview.indexPathForSelectedRow?.row)!]
            dest.listindex = tableview.indexPathForSelectedRow?.row
            dest.status = bookedtable[(tableview.indexPathForSelectedRow?.row)!]
        }else if segue.identifier == "surethisbook" {
            
            var tempfoodslist:[String] = []
            var tempfoodsid:[String] = []
            var money:Double = 0
            print(bookedtable.count)
            for i in 0..<bookedtable.count {
                if bookedtable[i] {
                    tempfoodslist += [foodlist[i].object(forKey: "name") as! String]
                    tempfoodsid += [foodlist[i].objectId]
                    money += Double(foodlist[i].object(forKey: "price") as! String)!
                }
            }
            //tempfoodslist.remove(at: tempfoodslist.index(before: tempfoodslist.endIndex))
            let dest = segue.destination as! SureViewController
            dest.foodslist = tempfoodslist
            dest.foodsid = tempfoodsid
            dest.money = money
            dest.tablenum = seat
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //取回预定消息，并且将相应的cell改为选中
    @IBAction func canel4(segue:UIStoryboardSegue){
        let getbooked = segue.source as! BookFoodViewController
        //bookedtable[getbooked.listindex] = getbooked.booked
        let index = tableview.visibleCells
        /*
        if bookedtable[getbooked.listindex] {
            index[getbooked.listindex].accessoryType = .checkmark
        }
        */
        if getbooked.booked {
            if bookedtable[getbooked.listindex] {
                index[getbooked.listindex].accessoryType = .none
                bookedtable[getbooked.listindex] = false
            }else{
                index[getbooked.listindex].accessoryType = .checkmark
                bookedtable[getbooked.listindex] = true
            }
        }
    }
    
    
    @IBAction func canel5(segue:UIStoryboardSegue){
        
    }
}
