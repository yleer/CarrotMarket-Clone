//
//  Detail2TableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/25.
//

import UIKit
import Firebase

class Detail2TableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var itemImageName : UIImage?
    var itemLocationName : String?
    var itemTitleName : String?
    var itemContentName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView()
        imageCollectionView?.reloadData()
        loadDataFromStoreage()
    
    }
    
    var images : [UIImage] = []{
        didSet{
            print(images)
            imageCollectionView?.reloadData()
        }
    }
    
    
    func loadDataFromStoreage(){
        if let title = itemTitleName{
//            let restUrl = "photos/\(title)/1.jpeg"
            let restUrl = "photos/\(title)"
            let storageRef = Storage.storage().reference(withPath: restUrl)
            storageRef.listAll { Result, Error in
                if let e = Error{
                    print(e)
                }else{
                    for item in Result.items{
                        item.getData(maxSize:  4 * 1024 * 1024) { Data, Error in
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
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "id cell", for: indexPath) as! IDTableViewCell
            cell.idLabel.text = itemTitleName
            cell.idLabel.numberOfLines = 0
            cell.idLabel.sizeToFit()
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "content cell", for: indexPath) as! Content2TableViewCell
            cell.contetLabel.text = itemContentName
//            cell.contetLabel.textAlignment =
            cell.contetLabel.numberOfLines = 0
            cell.contetLabel.sizeToFit()
            return cell
        }
    }
    var imageCollectionView : UICollectionView?
    private func headerView() -> UICollectionView{
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: tableView.frame.width, height: tableView.frame.height / 3)
        
        imageCollectionView = UICollectionView(frame:  CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height / 3), collectionViewLayout: flow)
        
        let nib = UINib(nibName: "DetailImageCell", bundle: .none)
        
        imageCollectionView?.register(nib, forCellWithReuseIdentifier:"image collection cell")
        imageCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        
        imageCollectionView!.backgroundColor = .white
        imageCollectionView?.isPagingEnabled = true
        imageCollectionView?.isUserInteractionEnabled = true
        imageCollectionView?.dataSource = self
        imageCollectionView?.delegate = self
        
        
        return imageCollectionView!
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 70
        }else {
            return 500
        }
    }
    
    
    // MARK: collection view part
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
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
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("called")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image collection cell", for: indexPath) as! DetailImageCell
        cell.detailImage.image = images[indexPath.row]
        cell.detailImage.contentMode = .scaleAspectFill
        
        return cell
    }
    
}
