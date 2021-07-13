//
//  MessageTableViewCell.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/08.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var youAvatar: UIImageView!
    @IBOutlet var meAvatar: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var messageBackground: UIView!
    


}
