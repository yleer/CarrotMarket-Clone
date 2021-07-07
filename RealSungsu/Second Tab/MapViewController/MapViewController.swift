//
//  MapViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/04.
//

import UIKit
import Firebase

class MapViewController: UIViewController, MTMapViewDelegate {

    let db = Firestore.firestore()
    var data : [ItemData] = []{
        didSet{
            kakaoMap()
        }
    }
    
    func loadData() {
        data = []
        db.collection("realestate data").getDocuments { querySnapshot, error in
            if let e = error{
                print(e)
            }else{
                if let document = querySnapshot?.documents{
                    for doc in document{
                        self.data.append(
                            ItemData(
                                title: doc.data()["title"] as! String,
                                location: doc.data()["location"] as! String,
                                content: doc.data()["content"] as! String,
                                x : doc.data()["x"] as! String,
                                y : doc.data()["y"] as! String,
                                price : doc.data()["price"] as! String,
                                monthlyPay: doc.data()["monthlyPay"] as! String,
                                managementPrice: doc.data()["managmentPay"] as! String
                            )
                        )
                    
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadData()
    }
    
    private func kakaoMap(){
        
        let mapView = MTMapView(frame: view.frame)
        var marks : [MTMapPOIItem] = []
        for item in data{
            let mark = MTMapPOIItem()
            

            mark.itemName = item.location
            print(item.x)
            mark.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(item.y)!, longitude:Double(item.x)!))
            mark.markerType = .redPin
            mark.showAnimationType = .dropFromHeaven
            mark.draggable = false

            marks.append(mark)
            print(marks)

            let info = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 110))
            info.backgroundColor = .gray

            let placeName = UITextView(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
            placeName.text = item.location
            let addressName = UITextView(frame: CGRect(x: 0, y: 50, width: 180, height: 40))
            addressName.text = item.price
            
            let checkOutButton = UIButton(frame: CGRect(x: 0, y: 90, width: 180, height: 20))
            checkOutButton.setTitle("매물 확인 하기", for: .normal)

            info.addSubview(placeName)
            info.addSubview(addressName)
            info.addSubview(checkOutButton)


            mark.customCalloutBalloonView = info

            mapView.addPOIItems(marks)
        }

        // 지도 view main view에 추가.
        view.addSubview(mapView)
    }
    

}
