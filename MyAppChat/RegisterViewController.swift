//
//  ScreenRegisterViewController.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 7/22/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import UIKit
import Firebase

// Get a reference to the storage service, using the default Firebase App
let storage = FIRStorage.storage()
// Create a storage reference from our storage service
let storageRef = storage.referenceForURL("gs://myappchat-53aff.appspot.com")

class ScreenRegisterViewController: UIViewController {

    var imgData:NSData! //save choosed image for avatar

    @IBOutlet weak var uvRegister: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPassword: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //btnRegister.skin(b: false)
        //btnLogin.skin(b: false)
        //imgAvatar.skin()
        //uvRegister.Login()
        
        imgData = UIImagePNGRepresentation(UIImage(named: "avatar")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapAvatar(sender: UITapGestureRecognizer) { //
        
        let alert:UIAlertController = UIAlertController(title: "Notification", message: "Please choose the way you upload your photo", preferredStyle: .Alert)
         
        let btnPhoto:UIAlertAction = UIAlertAction(title: "Photo", style: .Default) { (UIAlertAction) in
            let imgPicker = UIImagePickerController()
            imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imgPicker.delegate = self
            imgPicker.allowsEditing = true //false
            self.presentViewController(imgPicker, animated: true, completion: nil)
        }
         
        let btnCamera:UIAlertAction = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) in
            
            if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
                let imgPicker = UIImagePickerController()
                imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
                imgPicker.delegate = self
                imgPicker.allowsEditing = false
                self.presentViewController(imgPicker, animated: true, completion: nil)
            } else {
                print("Camera doesn't exist!")
            }
        }
         
        alert.addAction(btnPhoto)
        alert.addAction(btnCamera)
         
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    

    @IBAction func btnRegisterClicked(sender: AnyObject) {
        
        if (isValidateEnterDataSuccessfully()) { //if entered data is validated
        
            let email:String = txtEmail.text!
            let password:String = txtPassword.text!
            let fullname:String = txtFullname.text!
            
            //Create User
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                
                //if successfully
                if (error == nil) {
                    
                    //login user (then can update user's profile)
                    FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                        if (error == nil) {
                            print("Logged in successfully")
                        }
                    }
                    
                    let avatarRef = storageRef.child("images/\(email).png") //reference to user's avatar, where we will save
                    
                    // Upload the file to the path "images/rivers.jpg"
                    let uploadTask = avatarRef.putData(self.imgData, metadata: nil) { metadata, error in
                        if (error != nil) { //upload fail
                            
                            print("Error with uploading image")
                            
                        } else { //uploading successfully
                            
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            let downloadURL = metadata!.downloadURL() //if download -> return array of URL
                            
                            //update logined user's profile
                            let user = FIRAuth.auth()?.currentUser
                            if let user = user {
                                
                                let changeRequest = user.profileChangeRequest()
                                
                                changeRequest.displayName = fullname
                                changeRequest.photoURL = downloadURL
                                changeRequest.commitChangesWithCompletion({ (error) in
                                    if error == nil {
                                        print("Updating profile successfully")
                                        self.gotoScreen()
                                    } else {
                                        print("Error with updating profile")
                                    }
                                })
                            }
                        }
                    }
                    
                    uploadTask.resume()
                    
                } else {
                    print("Cannot register")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func isValidateEnterDataSuccessfully() -> Bool {
        return true
    }

}

extension ScreenRegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chooseImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //giam do phan giai cua image
        let imgValue = max(chooseImg.size.width, chooseImg.size.height)
        if (imgValue > 3000) {
            imgData = UIImageJPEGRepresentation(chooseImg, 0.1)
            
        } else if (imgValue > 2000) {
            imgData = UIImageJPEGRepresentation(chooseImg, 0.3)
        } else {
            imgData = UIImageJPEGRepresentation(chooseImg, 1)
        }
        imgAvatar.image = UIImage(data: imgData)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}












