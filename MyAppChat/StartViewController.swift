//
//  StartViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/4/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblWelcome.center = CGPoint(x: 100, y: 40)
        lblAppName.center = CGPoint(x: 200, y: 90)
        
        UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.lblAppName.center = CGPoint(x: self.view.bounds.width/2 - 10, y: self.view.bounds.height/2 - 40)
            
            }, completion: nil)
        
        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.OverrideInheritedDuration, animations: {
            
            self.lblAppName.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
            
            }, completion: nil)

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
    
    override func viewDidAppear(animated: Bool) {
        sleep(3)
        let scr = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController")
        if (scr != nil) {
            print("OK")
            self.presentViewController(scr!, animated: true, completion: nil)
        } else {
            print("Error with switch screen!")
        }
    }

}
