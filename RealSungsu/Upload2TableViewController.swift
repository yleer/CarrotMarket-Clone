//
//  Upload2TableViewController.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/06/24.
//

import UIKit
// five sections
// 1. upload image section
// 2. title
// 3. category
// 4. price
// 5. contents
class Upload2TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var cellIdenteifiers = ["image Section","title Section","category","price","contents"]
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSection = indexPath.section
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdenteifiers[indexPath.section], for: indexPath)
        
        switch currentSection {
        case 0:
            cell = cell as! image2TableViewCell

        case 1:
            cell = cell as! TitleTableViewCell
        case 2:
            cell = cell as! CategoryTableViewCell
        case 3:
            cell = cell as! PriceTableViewCell
        case 4:
            cell = cell as! ContentTableViewCell
        default:
            print("hello")
        }
        
        return cell
    }
    
    
    

    // MARK: cell height.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }else if indexPath.section == 1{
            return 70
        }else if indexPath.section == 2{
            return 70
        }else if indexPath.section == 3{
            return 70
        }else if indexPath.section == 4{
            return 500
        }
        return 100
    }
}
