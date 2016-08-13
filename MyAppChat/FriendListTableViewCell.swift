//
//  FriendListTableViewCell.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/1/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {


    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
