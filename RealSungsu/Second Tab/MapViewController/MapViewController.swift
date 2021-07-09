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
        mapView.delegate = self
        var marks : [MTMapPOIItem] = []
        
        var tagNum = 0
        for item in data{
            let mark = MTMapPOIItem()
            

            mark.itemName = item.location

            mark.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(item.y)!, longitude:Double(item.x)!))
            mark.markerType = .redPin
            mark.showAnimationType = .dropFromHeaven
            mark.draggable = false
            mark.tag = tagNum
            tagNum += 1
            marks.append(mark)

            let info = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 110))
            info.backgroundColor = .gray

            let placeName = UITextView(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
            placeName.text = item.location
            let addressName = UITextView(frame: CGRect(x: 0, y: 50, width: 180, height: 40))
            addressName.text = item.price
            
//            let checkOutButton = UIButton(frame: CGRect(x: 0, y: 90, width: 180, height: 20))
            
            
            
            let checkOutButton = UIButton(frame: CGRect(x: 0, y: 90, width: 180, height: 20), primaryAction:  UIAction(title: "Button Title", handler: { _ in
                print("Button tapped!")
                
            }))
            checkOutButton.setTitle("매물 확인 하기", for: .normal)
            checkOutButton.backgroundColor = .green
            checkOutButton.isUserInteractionEnabled = true
            info.addSubview(placeName)
            info.addSubview(addressName)
            info.addSubview(checkOutButton)
            
            mark.customCalloutBalloonView = info
            mapView.addPOIItems(marks)
        }
        view.addSubview(mapView)
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        selectedPOI = poiItem.tag
        performSegue(withIdentifier: "map to detail segue", sender: self)
    }
    
    var selectedPOI = 0

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "map to detail segue"{
            if let destinationVC = segue.destination as? DetailViewController{
                destinationVC.itemImageName = data[selectedPOI].images
                destinationVC.itemLocationName = data[selectedPOI].location
                destinationVC.itemTitleName = data[selectedPOI].title
                destinationVC.itemContentName = data[selectedPOI].content
                destinationVC.itemPrice = data[selectedPOI].price
                destinationVC.itemMonthlyPay = data[selectedPOI].monthlyPay
                destinationVC.itemManagmentPay = data[selectedPOI].managementPrice
            }
        }
    }
    
    

    

}
