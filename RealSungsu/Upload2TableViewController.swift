//
//  Upload2TableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/24.
//

import UIKit

class Upload2TableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
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
        if indexPath.row == 1{
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
        print(selectedLocation.loaction)
        let index = IndexPath(row: 3, section: 0)
        if let cell = tableView(tableView, cellForRowAt: index) as? CategoryTableViewCell{
            cell.locationButton.titleLabel?.text = selectedLocation.loaction
            cell.locationButton.setTitle(selectedLocation.loaction, for: .normal)
            print("afs")
        }else{
            print("not workiong")
        }
        tableView.reloadRows(at: [index], with: .automatic)
        
        print(dic)
    }
    
}


// Image만 하자 우선.

