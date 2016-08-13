//
//  BaseView.swift
//  MyAppChat
//
//  Created by Nguyen Huy Cuong on 8/1/16.
//  Copyright © 2016 Nguyen Huy Cuong. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func Login() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.yellowColor().CGColor
    }
}

extension UIButton {
    func skin(b:Bool) {
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.ByClipping
        self.layer.cornerRadius = 10
        if (b) {
            self.layer.borderColor = UIColor.redColor().CGColor
            self.layer.borderWidth = 1
            self.tintColor = UIColor.redColor()
            self.backgroundColor = UIColor.whiteColor()
        }
    }
}

extension UIImageView {
    func skin() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }
    
    func loadAvatar(imgUrl:NSURL) {
        
        //let indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: self.bounds)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        indicator.color = UIColor.blueColor()
        
        self.addSubview(indicator)
        indicator.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
            do {
                let imgData:NSData? = try NSData(contentsOfURL: imgUrl)!
                //NSData(contentsOfURL: url, options: NSDataReadingOptions)

                dispatch_async(dispatch_get_main_queue()) { // 2
                    indicator.stopAnimating()
                    self.image = UIImage(data: imgData!)// 3
                }
            } catch {
                indicator.stopAnimating()
                print("Error with loading Avatar!")
            }
            
        })
        
    }
    
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)
            request.setValue("<YOUR_HEADER_VALUE>", forHTTPHeaderField: "<YOUR_HEADER_KEY>")
            NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) in
                guard let data = data where error == nil else{
                    NSLog("Image download error: \(error)")
                    return
                }
                
                if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode > 400 {
                        let errorMsg = NSString(data: data, encoding: NSUTF8StringEncoding)
                        NSLog("Image download error, statusCode: \(httpResponse.statusCode), error: \(errorMsg!)")
                        return
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    NSLog("Image download success")
                    self.image = UIImage(data: data)
                })
                }.resume()
        }
    }
}