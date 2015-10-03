//
//  ViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit


class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oath"), scope: nil, success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print(requestToken)
            var authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }, failure: {
                (error: NSError!) -> Void in
                print("failed  to get token: \(error)")
        })
    }
}

