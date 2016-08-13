//
//  FriendListViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/1/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit

//var chatContact:User!

class FriendListViewController: UIViewController {

    var friendList:Array<User> = Array<User>()
    
    @IBOutlet weak var tblFriendList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tblFriendList.dataSource = self
        tblFriendList.delegate = self
        
        // Listen for new comments in the Firebase database
        let tableName = ref.child("ListFriend")
        tableName.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject]
            
            if (postDict != nil) {
                let email:String = (postDict?["email"])! as! String
                let fullname:String = (postDict?["fullname"])! as! String
                let linkAvatar:NSURL = NSURL( string: postDict!["linkAvatar"] as! String )!
                
                let user:User = User(id: snapshot.key, email: email, fullname: fullname, linkAvatar: linkAvatar)
                
                if (user.id != currentUser.id) {
                    self.friendList.append(user)
                }
                
                self.tblFriendList.reloadData()
            }
        })
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

extension FriendListViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as!FriendListTableViewCell
        cell.imgAvatar.loadAvatar(friendList[indexPath.row].linkAvatar)
        cell.lblName.text = friendList[indexPath.row].fullname
        
        if (cell.frame.size.height < 80) {
            cell.frame.size.height = 80
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chatContact = friendList[indexPath.row]
        do {
            let imgData = try NSData(contentsOfURL: chatContact.linkAvatar)
            chatContact.avatar = UIImage(data: imgData!)
        } catch {
            print("Error with Avatar Loading")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
