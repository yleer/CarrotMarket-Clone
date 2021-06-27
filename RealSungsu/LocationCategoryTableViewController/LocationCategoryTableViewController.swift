//
//  LocationCategoryTableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/25.
//

import UIKit

class LocationCategoryTableViewController: UITableViewController, UINavigationControllerDelegate{
    
    let locations = ["서울시", "경기도", "제주도", "강원도", "경상남도", "경상북도", "전라남도", "전라북도", "충천북도","충천남도"]
    var selectedCategory = SelectedCategory()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //선택된 정보 가지고
        selectedCategory.loaction = locations[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }

}
