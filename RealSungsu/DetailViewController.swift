//
//  DetailViewController.swift
//  RealEstate
//
//  Created by Yundong Lee on 2021/06/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var itemImages: UIImageView!
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemContent: UILabel!
    
    
    var itemImageName : UIImage?
    var itemTitleName : String?
    var itemLocationName : String?
    var itemContentName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImages.image = itemImageName
        itemTitle.text = itemTitleName
        itemLocation.text = itemLocationName
        itemContent.text = itemContentName
        

        // Do any additional setup after loading the view.
    }
    


}
