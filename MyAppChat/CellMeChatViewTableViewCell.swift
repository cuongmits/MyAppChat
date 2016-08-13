//
//  CellMeChatViewTableViewCell.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/2/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit

class CellMeChatViewTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewMsgWrapper: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
