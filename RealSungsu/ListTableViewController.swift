//
//  ListTableViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/19.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {
    
    // need to get data from firestore
    var data : [ItemData] = []
    

    var loadingView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    let db = Firestore.firestore()
    
    func loadData() {
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
                                content: doc.data()["content"] as! String)
                        )
                    }
                }
                
                for index in 0..<self.data.count{
                    let restUrl = "photos/\(self.data[index].title)/1.jpeg"
                    let storageRef = Storage.storage().reference(withPath: restUrl)
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { imageData, error in
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
            }
        }
    }
    
    func reloadData(){
        data = []
        loadData()
    }
    
    @IBAction func refreshTableView(_ sender: UIBarButtonItem) {
        reloadData()
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
            }
            
            
        }
    }
    
}
