//
//  ListTableViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class ListTableViewController: UITableViewController, UITextFieldDelegate {
    
    // need to get data from firestore
    var data : [ItemData] = []
    var loadingView = UIView() // need to stop animation when not showing.
    
    // MARK: Loading view part.
    private func configureLoading(){
        var spinner = UIActivityIndicatorView(style: .large)
        loadingView = UIView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height))
        
        let centerFrame = loadingView.center
        let spinnerSize = CGSize(width: 100, height: 100)
        
        spinner = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: centerFrame.x - spinnerSize.width / 2, y: centerFrame.y - spinnerSize.height), size: spinnerSize))
        spinner.style = .large
        spinner.startAnimating()
        loadingView.addSubview(spinner)
        loadingView.backgroundColor = .darkGray
        view.addSubview(loadingView)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoading()
        loadData()
        
        configureHeaderView()
    }
    
    let db = Firestore.firestore()
    
    func loadData() {
        view.addSubview(loadingView)
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
                                x: doc.data()["x"] as! String,
                                y : doc.data()["y"] as! String,
                                price : doc.data()["price"] as! String,
                                monthlyPay: doc.data()["monthlyPay"] as! String,
                                managementPrice: doc.data()["managmentPay"] as! String,
                                postUser: doc.data()["emai"] as! String
                            )
                            
                        )
                    }
                }
                
                for index in 0..<self.data.count{
                    let restUrl = "photos/\(self.data[index].title)/1.jpeg"
                    let storageRef = Storage.storage().reference(withPath: restUrl)
                    storageRef.getData(maxSize: Int64(Constants.maxSize)) { imageData, error in
                        if let e = error{
                            print(e)
                            return
                        }
                        if let jpegData = imageData, let image = UIImage(data: jpegData) {
                            self.data[index].images = image
                            let Ind = IndexPath(row: index, section: 0)
                            self.tableView.reloadRows(at: [Ind], with: .automatic)
                        }
                    }
                }
                self.tableView.reloadData()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    
    @IBAction func refreshTableView(_ sender: UIBarButtonItem) {
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! ItemTableViewCell
        
        cell.itemImage.image = data[indexPath.row].images
        cell.title.text = data[indexPath.row].title
        cell.place.text = data[indexPath.row].location
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    var selectIndex = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        performSegue(withIdentifier: "show detail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show detail"{
            if let destinationVC = segue.destination as? DetailViewController{
                destinationVC.itemImageName = data[selectIndex].images
                destinationVC.itemLocationName = data[selectIndex].location
                destinationVC.itemTitleName = data[selectIndex].title
                destinationVC.itemContentName = data[selectIndex].content
                destinationVC.itemPrice = data[selectIndex].price
                destinationVC.itemMonthlyPay = data[selectIndex].monthlyPay
                destinationVC.itemManagmentPay = data[selectIndex].managementPrice
                destinationVC.postOwner = data[selectIndex].postUser
            }
        }
    }
    
    
    // MARK: Header view part.
    var isHeaderUp = false
    var headerView = UIView()
    
    
    private func configureHeaderView(){
        headerView = UIView(frame: CGRect(x: 0, y: tableView.contentOffset.y + tableView.safeAreaInsets.top, width: view.frame.width, height: view.frame.height / 6))
        searchSettingHeaderView()
        view.addSubview(headerView)
        
        headerView.isHidden = true
    }
    
    @IBAction func searchSetting(_ sender: UIBarButtonItem) {
        if !isHeaderUp{
            isHeaderUp = true
            headerView.isHidden = false
            
        }else{
            isHeaderUp = false
            headerView.isHidden = true
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let prevFrame = headerView.frame
        headerView.frame = CGRect(x: prevFrame.minX, y: scrollView.contentOffset.y + scrollView.safeAreaInsets.top, width: prevFrame.width, height: prevFrame.height)
        
    }
    
    
    //  firestore itself doesnt support sub string search, maybe later need elastic.
    @objc func confirmSearchSetting(){
        let searchStirng = dic["price"]!!
        print(searchStirng)
        db.collection("realestate data").whereField("title", isGreaterThanOrEqualTo: searchStirng).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
            
        }
        
    }
    
    
    private func searchSettingHeaderView() {
        
        headerView = UIView(frame: CGRect(x: 0, y: tableView.contentOffset.y + tableView.safeAreaInsets.top, width: view.frame.width, height: view.frame.height / 6))
        headerView.tag = 1
        headerView.backgroundColor = .white
        let priceRangeTextField = UITextField()
        let livingPeriod = UITextField()
        let searchBar = UITextField()
        let searchButton = UIButton()
        
        priceRangeTextField.translatesAutoresizingMaskIntoConstraints = false
        livingPeriod.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        priceRangeTextField.placeholder = "가격을 입력해주세요"
        livingPeriod.placeholder = "얼마나 살거에요?"
        searchBar.placeholder = "지역 및 학교 검색"
        searchButton.setTitle("confirm", for: .normal)
        
        priceRangeTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        livingPeriod.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        searchBar.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        
        
        
        priceRangeTextField.tag = 1
        livingPeriod.tag = 2
        searchBar.tag = 3
        
        
        headerView.addSubview(priceRangeTextField)
        headerView.addSubview(livingPeriod)
        headerView.addSubview(searchBar)
        headerView.addSubview(searchButton)
        searchButton.backgroundColor = .gray
        searchButton.addTarget(self, action: #selector(confirmSearchSetting), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate(
            [
                // top anchor
                priceRangeTextField.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor, constant: 8),
                livingPeriod.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor, constant: 8),
                searchBar.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor, constant: (headerView.frame.height / 3) + 8),
                searchButton.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.topAnchor, constant: (headerView.frame.height / 3) * 2 + 8),
                
                
                // leading anchor
                priceRangeTextField.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor, constant: 8),
                livingPeriod.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor, constant: (headerView.frame.width / 2) + 8),
                searchBar.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor, constant: 8),
                searchButton.leadingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor, constant: (headerView.frame.width / 2) + 8),
                
                // trailing anchor
                priceRangeTextField.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.leadingAnchor, constant: (headerView.frame.width / 2) - 8),
                livingPeriod.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.trailingAnchor, constant: -8),
                searchBar.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.trailingAnchor, constant: -8),
                searchButton.trailingAnchor.constraint(equalTo: headerView.layoutMarginsGuide.trailingAnchor, constant: -8),
                
                // bottom anchor
                priceRangeTextField.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor, constant: -(headerView.frame.height/3) * 2 - 8 ),
                livingPeriod.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor, constant: -(headerView.frame.height/3) * 2 - 8 ),
                searchBar.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor, constant: -(headerView.frame.height / 3)  - 8),
                searchButton.bottomAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor, constant: -8)
            ]
        )
    }
    
    var dic : [String : String?] = ["price" : nil, "howLong" : nil, "location" : nil]
    @objc func valueChanged(_ textField: UITextField){
        switch textField.tag {
        case 1:
            if let price = textField.text{
                dic["price"] = price
            }
        case 2:
            if let howLong = textField.text{
                dic["howLong"] = howLong
            }
        case 3:
            if let location = textField.text{
                dic["location"] = location
            }
            
        default:
            print("not good.")
        }
    }
    
}




