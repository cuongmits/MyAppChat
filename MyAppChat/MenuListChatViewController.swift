//
//  MenuListChatViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/25/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit

class MenuListChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTable: UITableView!
    
    var arrCellID:[String] = ["mainChatScreenMenuItem", "SettingMenuItem", "LogoutMenuItem"]
    var arrCellName:[String] = ["Home", "Setting", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTable.delegate = self
        myTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(arrCellID[indexPath.row], forIndexPath: indexPath)
        
        cell.textLabel?.text = arrCellName[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let line:UIView = UIView.init(frame: CGRectMake(0, cell.bounds.height-1, 9999, 1))
        line.backgroundColor = UIColor.grayColor()
        line.backgroundColor = UIColor.init(red: 50, green: 0, blue: 100, alpha: 0.8)
        line.backgroundColor = UIColor.lightGrayColor()
        cell.addSubview(line)
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
