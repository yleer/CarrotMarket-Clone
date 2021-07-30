//
//  LocationSearchViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/03.
//

import UIKit
import Alamofire

class LocationSearchViewController: UIViewController {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var selectedLocation: SelectedLocation?
    var numberOfItem = 0
    var response = JusoResponse(){
        didSet{
            searchResultTableView.reloadData()
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        let keyword = searchTextField.text!
        
        if !keyword.isEmpty {
            findAddress(keyword: keyword) { [weak self] (jusoResponse) in
                guard let self = self else { return }
                if let result = jusoResponse.results, let juso = result.juso{
                    self.numberOfItem = juso.count
                    self.response = jusoResponse
                }else{
                    print("wrong search ")
                }
            }
        }
    }
    
    private func findAddress(keyword: String, completion: @escaping ((JusoResponse) -> Void)) {
        let url = Constants.LocationSearchVC.jusoEndPoint
        let parameters: [String: Any] = ["confmKey": Constants.LocationSearchVC.jusoConfirmKet,
                                         "currentPage": "1",
                                         "countPerPage":"10",
                                         "keyword": keyword,
                                         "resultType": "json"]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { [weak self] (response) in
            guard let self = self else { return }
            
            if let value = response.value, let jusoResponse: JusoResponse = self.toJson(object: value){
                completion(jusoResponse)
            }
        }
        
    }
    
    func findingXYCoordinate(){
        let KakaoHeaders: HTTPHeaders = [
            "Authorization": Constants.LocationSearchVC.kakoAuth
        ]
        
        let KakaoParameters: [String: Any] = [
            "query": selectedLocation!.loaction
        ]
        AF.request(Constants.LocationSearchVC.kakoEndPoint, method: .get, parameters: KakaoParameters, headers: KakaoHeaders).responseJSON { response in
            switch response.result{
            case .success(let value):
                if let detailsPlace : documentResponse  = self.toJson(object: value){
                    self.selectedLocation!.x = detailsPlace.documents[0].x
                    self.selectedLocation!.y = detailsPlace.documents[0].y
                }else{
                    print("good")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func toJson<T: Decodable>(object: Any) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: object) {
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(T.self, from: jsonData) {
                return result
            } else {
                print("not able to ")
                return nil
            }
        } else {
            return nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
}


extension LocationSearchViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItem
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location result cell", for: indexPath) as! LocationSearchTableViewCell
        cell.doroLabel.text = response.results.juso[indexPath.row].roadAddr
        cell.jibunLabel.text = response.results.juso[indexPath.row].jibunAddr
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation?.loaction = response.results.juso[indexPath.row].roadAddr
        findingXYCoordinate()
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
