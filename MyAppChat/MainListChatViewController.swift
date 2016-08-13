////
//  MainListChatViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/25/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit
import Firebase

//let ref = FIRDatabase.database().reference()
//var currentUser:User!

class MainListChatViewController: UIViewController {
    
    var friendList:Array<User> = Array<User>()

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //btnMenu.target = self.revealViewController()
        //btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        

        // Do any additional setup after loading the view.
        
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
