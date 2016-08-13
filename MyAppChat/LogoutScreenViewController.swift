//
//  LogoutScreenViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/30/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit
import Firebase

class LogoutScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        try! FIRAuth.auth()!.signOut()
        
        let scr = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController")
        if (scr != nil) {
            self.presentViewController(scr!, animated: true, completion: nil)
        } else {
            print("Error with switch screen!")
        }
        
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
