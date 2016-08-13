//
//  SettingViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/25/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //Add Gusture Recognizer for Main List Chat
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        lblFullname.text = currentUser.fullname
        lblEmail.text = currentUser.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
