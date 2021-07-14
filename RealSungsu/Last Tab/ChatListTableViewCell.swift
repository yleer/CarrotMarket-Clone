//
//  ChatListTableViewCell.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/10.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var textOpponet: UILabel!
    @IBOutlet var dateLabel: UILabel!
}
