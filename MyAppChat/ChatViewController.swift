//
//  ChatViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/2/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextField!
    
    @IBOutlet weak var tblChatContent: UITableView!
    
    var arrChatId:Array<String> = Array<String>()
    var tableName:FIRDatabaseReference!
    
    var arrChatContent:Array<String> = Array<String>()
    var arrChatUser:Array<User> = Array<User>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        showHideKeyboard()
        
        tblChatContent.dataSource = self
        tblChatContent.delegate = self
        tblChatContent.estimatedRowHeight = 83
        tblChatContent.rowHeight = UITableViewAutomaticDimension
        tblChatContent.separatorColor = UIColor.clearColor()
        //tblChatContent.contentInset = UIEdgeInsetsZero //no top space appears
        

        //Close keyboard when touching anywhere else textfield
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        arrChatId.append(currentUser.id)
        arrChatId.append(chatContact.id)
        arrChatId.sortInPlace()
        let key:String = "\(arrChatId[0])\(arrChatId[1])"
        tableName = ref.child("ChatContent").child(key)
        
        //GET CONTENT FROM DB:
        
        // Listen for new comments in the Firebase database
        tableName.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            //self.comments.append(snapshot)
            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
            let postDict = snapshot.value as? [String:AnyObject]
            
            if (postDict != nil) {
                if (postDict?["id"] as! String == currentUser.id) {
                    self.arrChatUser.append(currentUser)
                } else if (postDict?["id"] as! String == chatContact.id) {
                    self.arrChatUser.append(chatContact)
                } else {
                    self.arrChatUser.append(sysContact)
                }
                self.arrChatContent.append(postDict?["msg"] as! String)
                
                self.tblChatContent.reloadData()
                self.scrollToLastCellOfTable(false)
            }
            
        })
        
        self.tblChatContent.reloadData()
        scrollToLastCellOfTable(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollToLastCellOfTable(false)
    }
    
    
    func scrollToLastCellOfTable(animated: Bool) {
        let rowsNum:Int = tblChatContent.numberOfRowsInSection(0)
        if (rowsNum>0) {
            tblChatContent.scrollToRowAtIndexPath(NSIndexPath.init(forRow: rowsNum-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
        }
        
        //tblChatContent.setContentOffset(CGPointMake(0, CGFloat.max), animated: false)
        
        //tblChatContent.setContentOffset(CGPointMake(0, CGFloat.max), animated: true)
        //let offset = CGPoint(x: 0, y: tblChatContent.contentSize.height - tblChatContent.frame.size.height);
        //tblChatContent.contentOffset = offset;
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    func showHideKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.showKey(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.hideKey(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func showKey(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //self.view.frame.origin.y -= keyboardSize.height
            self.view.frame.origin.y = -keyboardSize.height
        }
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                self.view.frame.origin.y = 0
            }
        }*/
    }
    
    func hideKey(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //self.view.frame.origin.y += keyboardSize.height
            self.view.frame.origin.y = 0
        //}
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                self.view.frame.origin.y = 0
            }
        }*/
    }
    
    @IBAction func btnSendClicked(sender: AnyObject) {
        let msg:Dictionary<String, String> = ["id":currentUser.id, "msg":txtMessage.text!]
        tableName.child( String(NSDate()) ).setValue(msg)
        txtMessage.text = ""
        
        //add chat to Chat List
        if (arrChatContent.count == 0 ) {
            addListChat(currentUser, user2: chatContact)
            addListChat(chatContact, user2: currentUser)
            sleep(1)
            tableName.child(String(NSDate())).setValue(["id":"0","msg":"Thank you for sending question to us. We will connect you with a mentor"])
        }
        
        //scroll to the end of table
        //self.tblChatContent.reloadData()
        //scrollToLastCellOfTable()
        //tblChatContent.setContentOffset(CGPointMake(0, CGFloat.max), animated: true)
        
    }
    
    func addListChat(user1: User, user2: User) {
        let tableListChat = ref.child("ListChat").child(user1.id).child(user2.id)
        let user:Dictionary<String, String> = ["email": user2.email,
                                               "fullname": user2.fullname,
                                               "linkAvatar": (String)(user2.linkAvatar)]
        tableListChat.setValue(user)

    }
    
    @IBAction func btnBackClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrChatContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(currentUser.id, "--------CurrentUser")
        print(chatContact.id, "--------ChatContact")
        print(arrChatUser[indexPath.row].id, "----- arrChatUser[indexPath.row].id")
        if (currentUser.id == arrChatUser[indexPath.row].id) {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell_Me", forIndexPath: indexPath) as! CellMeChatViewTableViewCell
            cell.lblMessage.text = arrChatContent[indexPath.row]
            cell.imgAvatar.image = currentUser.avatar
            
            //cell.contentView.setNeedsLayout()
            //cell.contentView.layoutIfNeeded()
            
            cell.viewMsgWrapper.layoutIfNeeded()
            //cell.viewMsgWrapper.roundCorners([.TopLeft, .BottomLeft, .BottomRight], radius: 10)
            
            cell.imgAvatar.layoutIfNeeded()
            cell.imgAvatar.roundCorners([.TopLeft, .BottomLeft, .BottomRight, .TopRight], radius: 32)
            
            return cell
        } else if (chatContact.id == arrChatUser[indexPath.row].id) {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell_Guest", forIndexPath: indexPath) as! CellGuestChatViewTableViewCell
            cell.lblMessage.text = arrChatContent[indexPath.row]
            cell.imgAvatar.image = chatContact.avatar
            
            //cell.contentView.setNeedsLayout()
            //cell.contentView.layoutIfNeeded()
            
            cell.viewMsgWrapper.layoutIfNeeded()
            //cell.viewMsgWrapper.roundCorners([.BottomLeft, .BottomRight, .TopRight], radius: 10)
            
            cell.imgAvatar.layoutIfNeeded()
            cell.imgAvatar.roundCorners([.TopLeft, .BottomLeft, .BottomRight, .TopRight], radius: 32)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell_System", forIndexPath: indexPath) as! CellSystemTableViewCell
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
}
