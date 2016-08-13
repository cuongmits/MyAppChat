//
//  User.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/25/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email:String!
    let fullname:String!
    let linkAvatar:NSURL!
    var avatar:UIImage!
    
    init() {
        id = ""
        email = ""
        fullname = ""
        linkAvatar = NSURL(string: "")
        avatar = UIImage(named: "avatar")
    }
    
    init(id:String, email:String, fullname:String, linkAvatar:NSURL) {
        self.id = id
        self.email = email
        self.fullname = fullname
        self.linkAvatar = linkAvatar
        self.avatar = UIImage(named: "avatar")
    }
}

