//
//  ChatListViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/1/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit
import Firebase

let ref = FIRDatabase.database().reference()
var currentUser:User!
var chatContact:User!
var sysContact:User!

class ChatListViewController: UIViewController {
    
    var arrUserChat:Array<User> = Array<User>()
   
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var tblChatList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblChatList.dataSource = self
        tblChatList.delegate = self

        // Do any additional setup after loading the view.
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
            
            currentUser = User(id:uid, email:email!, fullname: name!, linkAvatar: photoUrl!)
            sysContact = User(id: "0", email: "admin@myappchat", fullname: "System", linkAvatar: photoUrl!) //!!! TODO: Update photoUrl for System User
            
            //add new logged in user in to real time table list
            let tableName = ref.child("ListFriend")
            let userID = tableName.child(currentUser.id)
            let user:Dictionary<String,String> = ["email":currentUser.email,
                                                  "fullname": currentUser.fullname,
                                                  "linkAvatar":String(currentUser.linkAvatar)]
            userID.setValue(user)
            
            do {
                let data:NSData = try NSData(contentsOfURL: currentUser.linkAvatar)!
                currentUser.avatar = UIImage(data: data)
            } catch {
                print("Cannot load current User's Avatar")
            }
            
        } else {
            // No user is signed in.
            print("No user for chat")
        }
        
        //UPDATE CHAT LIST
        
        let tableName = ref.child("ListChat").child(currentUser.id)
        
        // Listen for new comments in the Firebase database
        tableName.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            let postDict = snapshot.value as? [String : AnyObject]
            
            if (postDict != nil) {
                let email:String = (postDict?["email"])! as! String
                let fullname:String = (postDict?["fullname"])! as! String
                let linkAvatar:NSURL = NSURL( string: postDict!["linkAvatar"] as! String )!
                
                let user:User = User(id: snapshot.key, email: email, fullname: fullname, linkAvatar: linkAvatar)
                
                self.arrUserChat.append(user)
                
                self.tblChatList.reloadData()
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

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arrUserChat.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatListCell", forIndexPath: indexPath) as! ChatListTableViewCell
        cell.lblFullname.text = arrUserChat[indexPath.row].fullname
        cell.imgAvatar.loadAvatar(arrUserChat[indexPath.row].linkAvatar)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chatContact = arrUserChat[indexPath.row]
        do {
            let data:NSData = try NSData(contentsOfURL: chatContact.linkAvatar)!
            chatContact.avatar = UIImage(data: data)
        } catch {
            print("Error with loading avatar")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
}
