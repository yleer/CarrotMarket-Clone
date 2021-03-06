//
//  Upload2TableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/24.
//

import UIKit
import Firebase
import PhotosUI
import Alamofire

class UploadTableViewController: UITableViewController {
    
    // MARK: Data
    var houseImages : [UIImage] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  
    var selectedLocation = SelectedLocation()
    var dic : [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: segue to location search vc
    @objc func segueToCategory(){
        performSegue(withIdentifier: Constants.UploadTableViewController.locationSearchSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.UploadTableViewController.locationSearchSegue{
            if let destinationVC = segue.destination as? LocationSearchViewController{
                destinationVC.selectedLocation = selectedLocation
                
            }else{
                print("Not good when seguing.")
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UploadTableViewController.Cellidenteifer[indexPath.row], for: indexPath) as! Image2TableViewCell
            cell.imageCollectionView.delegate = self
            cell.imageCollectionView.alwaysBounceHorizontal = true
            cell.imageCollectionView.dataSource = self
            cell.imageCollectionView.reloadData()
            
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UploadTableViewController.Cellidenteifer[indexPath.row], for: indexPath) as! TitleTableViewCell
            cell.titleTextField.tag = indexPath.row
            cell.titleTextField.delegate = self
            cell.titleTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
            return cell
            
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UploadTableViewController.Cellidenteifer[indexPath.row], for: indexPath) as! CategoryTableViewCell
            cell.locationButton.setTitle(selectedLocation.loaction, for: .normal)
            cell.locationButton.addTarget(self, action: #selector(segueToCategory), for: .touchUpInside)
            
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UploadTableViewController.Cellidenteifer[indexPath.row], for: indexPath) as! PriceTableViewCell
            cell.priceTextField.tag = indexPath.row
            cell.priceTextField.delegate = self
            cell.priceTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
            return cell
            
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UploadTableViewController.Cellidenteifer[indexPath.row], for: indexPath) as! ContentTableViewCell
            cell.contentTextView.tag = indexPath.row
            cell.contentTextView.delegate = self
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.UploadTableViewController.Cellidenteifer[indexPath.row], for: indexPath)
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return Constants.UploadTableViewController.uploadImageCellHeight
        }else if indexPath.row == 4{
            return Constants.UploadTableViewController.contentCellHeight
        }else{
            return Constants.UploadTableViewController.otherCellHieght
        }
    }

    
    
    // MARK: save data to storage.
    let db = Firestore.firestore()
    @IBAction func saveData(_ sender: UIBarButtonItem) {
        
        let user = Auth.auth().currentUser
        if let user = user , let email = user.email{
            
            if let title = dic["title"], let content = dic["content"], let price = dic["price"]
            {
                var num = 1
                
                for img in houseImages{
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
                            //  print(downloadMetaData)
                        }
                    }
                }
              
                let ref = db.collection(Constants.FireStoreUsedItemCollectionName)
                ref.document(title).setData([
                    "emai" : email,
                    "title" : title,
                    "location" : selectedLocation.loaction, // location == category
                    "price" : price,
                    "content" : content,
                    "date" : Date().timeIntervalSince1970,
                    "phoneNumb" : "010",
                    "monthlyPay" : "123",
                    "managmentPay" : "123",
                    "x" : selectedLocation.x!,
                    "y" : selectedLocation.y!
                ]) { error in
                    if let e = error{
                        print(e)
                    }else{
                        self.performSegue(withIdentifier: Constants.UploadTableViewController.segueToSuccessScreen, sender: self)
                    }
                }
                
                
            }
        }
    }
}



extension UploadTableViewController :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.UploadTableViewController.collectionCellSize
    }
    
    
    // MARK: Collection View data
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.UploadTableViewController.addImageCollectionViewCellId, for: indexPath) as! AddImageButtonCollectionViewCell
            
            cell.addImageButton.setTitle("+", for: .normal)
            cell.addImageButton.addTarget(self, action: #selector(imagePickerPopUp), for: .touchUpInside)
            
            for sub in collectionView.subviews{
                if sub.backgroundColor == .red{
                    sub.removeFromSuperview()
                }
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.UploadTableViewController.uploadedImagesCollectionViewCellId, for: indexPath) as! ImageCollectionViewCell
            cell.imageCollectionViewCell.image = houseImages[indexPath.row - 1]
            cell.imageCollectionViewCell.contentMode = .scaleAspectFill
            
            let deleteButton = UIButton(frame: CGRect(x: cell.frame.maxX - 15, y: 15, width: 15, height: 15))
            
            deleteButton.setTitle("X", for: .normal)
            deleteButton.backgroundColor = .red
            deleteButton.tag = indexPath.row - 1
            collectionView.addSubview(deleteButton)
            
            deleteButton.addTarget(self, action: #selector(tapToDeleteImage), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func tapToDeleteImage(_ button : UIButton){
        houseImages.remove(at: button.tag)
    }
    
}


extension UploadTableViewController : UITextFieldDelegate, UITextViewDelegate{
    
    // when enter a text into textfield, save text to dic.
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
    
}


extension UploadTableViewController : PHPickerViewControllerDelegate{

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
                    self.houseImages.append(img)
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    @objc func imagePickerPopUp(){
        presentPickerView()
    }
}
