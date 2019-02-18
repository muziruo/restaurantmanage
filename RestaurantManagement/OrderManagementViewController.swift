//
//  OrderManagementViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/12/1.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit

class OrderManagementViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var ordertable: UITableView!
    
    //所有的订单信息
    var lists:[BmobObject] = []
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //添加等待动画
        spinner.center = view.center
        spinner.startAnimating()
        
        refresh.addTarget(ordertable, action: #selector(self.getallorder), for: .valueChanged)
        
        //消除表格下部不需要的分割线
        ordertable.tableFooterView = UIView(frame: .zero)
        
        //得到所有未服务订单信息
        getallorder()
    }

    //每次页面出现都进行更新
    override func viewDidAppear(_ animated: Bool) {
        getallorder()
    }
    
    //取回所有的订单
    func getallorder() {
        let orderlist = BmobQuery(className: "bookedtable")
        
        //按时间升序，即最早的放在最前面
        orderlist?.order(byAscending: "createdAt")
        
        //查找订单
        orderlist?.findObjectsInBackground({ (result, error) in
            if error == nil {
                if result != nil {
                    let results = result as! [BmobObject]
                    var uselist:[BmobObject] = []
                    for i in results {
                        if (i.object(forKey: "complete") as! Bool == false) {
                            uselist.append(i)
                        }
                    }
                    self.lists = uselist
                    OperationQueue.main.addOperation {
                        self.spinner.stopAnimating()
                        self.refresh.endRefreshing()
                        self.ordertable.reloadData()
                    }
                }
            }else{
                let notice = UIAlertController(title: "提示", message: "获取订单失败，请检查网络！", preferredStyle: .alert)
                let action = UIAlertAction(title: "好的", style: .default, handler: nil)
                notice.addAction(action)
                self.present(notice, animated: true, completion: nil)
            }
        })
    }
    
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //返回列表块儿数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回列表对象总数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    //对每一个cell进行数据添加
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as! OrderManagrmentTableViewCell
        
        let list = lists[indexPath.row]
        cell.orderdetail.text = list.object(forKey: "createdAt") as? String
        let name = "订单" + String(indexPath.row + 1)
        cell.ordername.text = name
        
        return cell
    }
    
    //从订单详细界面返回
    @IBAction func backfromdetail(segue:UIStoryboardSegue){
        
    }
    
    //进入订单详情界面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderdetail" {
            let dest = segue.destination as! OrderDetailViewController
            dest.detailobject = lists[(ordertable.indexPathForSelectedRow?.row)!]
        }
        
    }
}
