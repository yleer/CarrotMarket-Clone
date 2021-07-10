//
//  LocationSearchViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/03.
//

import UIKit
import Alamofire

class LocationSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfItem
    }
    
    var selectedLocation: SelectedCategory?

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location result cell", for: indexPath) as! LocationSearchTableViewCell
        cell.doroLabel.text = response.results.juso[indexPath.row].roadAddr
        cell.jibunLabel.text = response.results.juso[indexPath.row].jibunAddr
    
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLocation?.loaction = response.results.juso[indexPath.row].roadAddr
        print(selectedLocation?.loaction)
        
        urlPart()
        navigationController?.popViewController(animated: true)
    }
    
    var numberOfItem = 0
    var response = JusoResponse(){
        didSet{
//            print(response)
            searchResultTableView.reloadData()
        }
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        let keyword = searchTextField.text!
        
        if !keyword.isEmpty {
            findAddress(keyword: keyword) { [weak self] (jusoResponse) in
                
                guard let self = self else { return }
                if (!jusoResponse.results.juso.isEmpty) {
                    // 뷰에있는 결과라벨에 텍스트 설정
//                    print(jusoResponse.results.juso.count)
                    self.numberOfItem = jusoResponse.results.juso.count
                    self.response = jusoResponse
                    
                }
            }
        }
    }
    
    private func findAddress(keyword: String, completion: @escaping ((JusoResponse) -> Void)) {
        let url = "https://www.juso.go.kr/addrlink/addrLinkApi.do"
        let parameters: [String: Any] = ["confmKey": "devU01TX0FVVEgyMDIxMDcwMzE1MjYxNzExMTM1MzQ=",
                                         "currentPage": "1",
                                         "countPerPage":"10",
                                         "keyword": keyword,
                                         "resultType": "json"]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { [weak self] (response) in
            guard let self = self else { return }
            
            
            if let value = response.value {
                
//                print(value)
                if let jusoResponse: JusoResponse = self.toJson(object: value) {
                    completion(jusoResponse)
                } else {
                    print("serialize error")
                }
            }
        }
        
    }
    
    func urlPart(){
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 8e455de386571ac030cfe8651e82b8cd"
        ]
        
        let parameters: [String: Any] = [
            "query": selectedLocation!.loaction
        ]
        
        AF.request("https://dapi.kakao.com/v2/local/search/address.json", method: .get,
                   parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { response in
                switch response.result {
                
                    case .success(let value):
                        
                        if let detailsPlace : documentResponse  = self.toJson(object: value){
    
                            print(detailsPlace.documents)
                            self.selectedLocation!.x = detailsPlace.documents[0].x
                            self.selectedLocation!.y = detailsPlace.documents[0].y
                        }else{
                            print("asdfadsf")
                        }
                        
                    case .failure(let error):
                        print(error)
                }
            })
        
        
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
    
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self

    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}




