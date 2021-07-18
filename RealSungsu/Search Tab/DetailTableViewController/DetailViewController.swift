//
//  DetailViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/08.
//

import UIKit
import Firebase

class DetailViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    var imageCollectionView : UICollectionView?
    
    var itemImageName : UIImage?
    var itemLocationName : String?
    var itemTitleName : String?
    var itemContentName : String?
    var itemManagmentPay : String?
    var itemMonthlyPay : String?
    var itemPrice : String?
    var postOwner : String?
    var postDate : Double?
    
    var images : [UIImage] = []{
        didSet{
            imageCollectionView?.reloadData()
        }
    }
    
    // MARK: segue to chat
    @IBAction func chatButton(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.DetailViewController.detailVCtoChatVCsegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.DetailViewController.detailVCtoChatVCsegue{
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.postOwner = postOwner
            destinationVC.postTitle = itemTitleName
        }
    }
    
    private func configImageCollectionView() -> UICollectionView{
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: tableView.frame.width, height: tableView.frame.height / 3)
        
        imageCollectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height / 3), collectionViewLayout: flow)
        
        let nib = UINib(nibName: Constants.DetailViewController.collectionViewCellName, bundle: .none)
        
        imageCollectionView?.register(nib, forCellWithReuseIdentifier: Constants.DetailViewController.collectionViewCellIdentifier)
        imageCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        imageCollectionView!.backgroundColor = .white
        imageCollectionView?.isPagingEnabled = true
        imageCollectionView?.isUserInteractionEnabled = true
        imageCollectionView?.dataSource = self
        imageCollectionView?.delegate = self
        
        return imageCollectionView!
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = configImageCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadImagesFromStorage()
        tabBarController?.tabBar.isHidden = true
    }
    
    
    func loadImagesFromStorage(){
        if let title = itemTitleName{
            let restUrl = "photos/\(title)"
            let storageRef = Storage.storage().reference(withPath: restUrl)
            storageRef.listAll { Result, Error in
                if let e = Error{
                    print(e)
                }else{
                    for item in Result.items{
                        item.getData(maxSize: Int64(Constants.DetailViewController.maxLoadImageSize)) { Data, Error in
                            if let e = Error{
                                print(e)
                            }else{
                                if let jpegData = Data, let image = UIImage(data: jpegData) {
                                    self.images.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: Collection View Part
extension DetailViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.DetailViewController.collectionViewCellIdentifier, for: indexPath) as! DetailImageCell
        cell.detailImage.image = images[indexPath.row]
        cell.detailImage.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: Table View Part.
extension DetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailViewController.tableViewEmailCellIdeintifer, for: indexPath) as! IDTableViewCell
            cell.locationName.text = itemLocationName
            cell.locationName.numberOfLines = 0
            cell.emailLabel.text = postOwner
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailViewController.tableViewContentCellIdentfier, for: indexPath) as! Content2TableViewCell
            cell.titleLabel.text = itemTitleName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            cell.postInfo.text = dateFormatter.string(from: Date(timeIntervalSince1970: postDate!))
            cell.contentLabel.text = itemContentName
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return Constants.DetailViewController.tableViewInfoCellHeight
        }else {
            return Constants.DetailViewController.tableViewContentCellHieght
        }
    }
}

