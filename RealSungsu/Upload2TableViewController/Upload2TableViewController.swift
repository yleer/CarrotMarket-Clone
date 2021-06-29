//
//  Upload2TableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/24.
//

import UIKit
import Firebase
import PhotosUI

class Upload2TableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, PHPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // when view will appear reload data to reflect the change.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: Data
    // images data
    var images : [UIImage] = []
    {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    // category
    var selectedLocation = SelectedCategory()
    
    // dic -> title, price, content dictionary.
    var dic : [String : String] = [:]
    
    
    // MARK: Getting title, price and content from text field and text view.
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // In storyboard there is a placeholder.
        // when begin editing, change text color to black.
        textView.text = nil
        textView.textColor = .black
    }
    // For content : text view.
    func textViewDidChange(_ textView: UITextView) {
        if let itemContent = textView.text{
            dic["content"] = itemContent
        }
    }
    // For title and price : text field.
    @objc func valueChanged(_ textField: UITextField){
        switch textField.tag {
        case 1:
            if let itemTitle = textField.text{
                dic["title"] = itemTitle
            }
        case 3:
            if let itemPrice = textField.text{
                dic["price"] = itemPrice
            }
        default:
            print("not good.")
        }
    }
    
    // MARK: when click category button, segue to LocationCategoryTableViewController to select category.
    
    @objc func segueToCategory(){
        performSegue(withIdentifier: "select category", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select category"{
            if let destinationVC = segue.destination as? LocationCategoryTableViewController{
                destinationVC.selectedCategory = selectedLocation
            }else{
                print("Not good when seguing.")
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    let identeifer = ["1","2","3","4","5"]
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath) as! Image2TableViewCell
            cell.imageCollectionView.delegate = self
            cell.imageCollectionView.alwaysBounceHorizontal = true
            cell.imageCollectionView.dataSource = self
            cell.imageCollectionView.reloadData()
            
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath) as! TitleTableViewCell
            cell.titleTextField.tag = indexPath.row
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
            return cell
            
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath) as! CategoryTableViewCell
            cell.locationButton.setTitle(selectedLocation.loaction, for: .normal)
            cell.locationButton.addTarget(self, action: #selector(segueToCategory), for: .touchUpInside)
            
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath) as! PriceTableViewCell
            cell.priceTextField.tag = indexPath.row
            cell.priceTextField.delegate = self
            cell.priceTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
            return cell
            
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath) as! ContentTableViewCell
            cell.contentTextView.tag = indexPath.row
            cell.contentTextView.delegate = self
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath)
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        }else if indexPath.row == 1{
            return 70
        }else if indexPath.row == 2{
            return 70
        }else if indexPath.row == 3{
            return 70
        }else if indexPath.row == 4{
            return 500
        }else{
            return 100
        }
    }
    
    // MARK: image picking part.
    func presentPickerView(){
        var config : PHPickerConfiguration = PHPickerConfiguration()
        config.filter = PHPickerFilter.images
        config.selectionLimit = 10
        
        let picker : PHPickerViewController = PHPickerViewController(configuration: config)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results{
            item.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let img = image as? UIImage{
                    self.images.append(img)
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    @objc func imagePickerPopUp(){
        presentPickerView()
    }
    
    
    // MARK: Collection View data
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView add Button", for: indexPath) as! AddImageButtonCollectionViewCell
            
            cell.addImageButton.setTitle("+", for: .normal)
            cell.addImageButton.addTarget(self, action: #selector(imagePickerPopUp), for: .touchUpInside)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection view image cell", for: indexPath) as! ImageCollectionViewCell
            cell.imageCollectionViewCell.image = images[indexPath.row - 1]
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    // MARK: save data to storage.
    let db = Firestore.firestore()
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        
        print(dic)
        
        let user = Auth.auth().currentUser
        if let user = user , let email = user.email{
            
            if let title = dic["title"], let content = dic["content"], let price = dic["price"]{
                var num = 1
                
                for img in images{
                    let restUrl = "photos/\(title)/\(num).jpeg"
                    let storageRef = Storage.storage().reference(withPath: restUrl)
                    num += 1
                    guard let imageData = img.jpegData(compressionQuality: 0.1) else {return}
                    
                    let uploadMetaData = StorageMetadata.init()
                    uploadMetaData.contentType = "image/jpeg"
                    
                    storageRef.putData(imageData, metadata: uploadMetaData) { downloadMetaData, error in
                        if let er = error{
                            print(er)
                        }else{
//                            print(downloadMetaData)
                        }
                    }
                }
    
                // need to add time.
                db.collection("realestate data").addDocument(data: [
                    "emai" : email,
                    "title" : title,
                    "location" : selectedLocation.loaction, // location == category
                    "price" : price,
                    "content" : content
//                    "date" : Timestamp.
                ]) { error in
                    if let e = error{
                        print(e)
                    }else{
                        print("succ")
                    }
                }
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
