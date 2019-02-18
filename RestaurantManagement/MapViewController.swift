//
//  MapViewController.swift
//  RestaurantManagement
//
//  Created by 李祎喆 on 2017/11/3.
//  Copyright © 2017年 李祎喆. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController ,MKMapViewDelegate{

    @IBOutlet weak var mapview: MKMapView!
    
    //商铺所在地址
    var areaname:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //进行地址查找
        let coder = CLGeocoder()
        coder.geocodeAddressString(areaname) { (placemark, error) in
            guard let placemarks = placemark else{
                print(error ?? "未得到位置数据")
                return
            }
            
            //在标记点现实信息
            let place = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.areaname
            annotation.subtitle = "餐厅所在地点"
            
            //现实地点
            if let loc = place?.location {
                annotation.coordinate = loc.coordinate
                self.mapview.showAnnotations([annotation], animated: true)
                self.mapview.selectAnnotation(annotation, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
