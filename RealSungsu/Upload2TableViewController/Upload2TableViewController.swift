//
//  Upload2TableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/24.
//

import UIKit
import PhotosUI

class Upload2TableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, PHPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Image Picker part.
    var images : [UIImage] = []
    {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
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
    
    
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    let identeifer = ["1","2","3","4","5"]
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: identeifer[indexPath.row], for: indexPath) as! Image2TableViewCell
            
            cell.addImageButton.addTarget(self, action: #selector(imagePickerPopUp), for: .touchUpInside)
            if images.count != 0{
                cell.addImageButton.setImage(images[0], for: .normal)
            }
            
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
    
    var dic : [String : String] = [:]
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if let itemContent = textView.text{
            dic["content"] = itemContent
        }
    }
    
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
            print("DSF")
        }
    }
    
    @objc func segueToCategory(){
        performSegue(withIdentifier: "select category", sender: self)
    }
    @objc func imagePickerPopUp(){
        presentPickerView()
    }

    
    var selectedLocation = SelectedCategory()
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select category"{
            if let destinationVC = segue.destination as? LocationCategoryTableViewController{
                destinationVC.selectedCategory = selectedLocation
            }else{
                print("Gdfsg")
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        }else if indexPath.row == 1{
            return 100
        }else if indexPath.row == 2{
            return 100
        }else if indexPath.row == 3{
            return 100
        }else if indexPath.row == 4{
            return 100
        }else{
            return 100
        }
    }
    
    @IBAction func saveData(_ sender: UIBarButtonItem) {

    }
    
}


// Image만 하자 우선.

