//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/4/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var tweetTextField: UITextField!
    
    var tweet: Tweet?

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBAction func onTweet(sender: AnyObject) {
        if tweet == nil {
            TwitterClient.sharedInstance.tweet(tweetTextField.text!) { (tweet, error) -> () in
                
            }
        } else {
            TwitterClient.sharedInstance.reply(tweetTextField.text!, tweetId: (tweet?.id)!, completion: { (tweet, error) -> () in
                
            })
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if tweet != nil{
            tweetTextField.text = "@\((tweet?.user?.screenname)!): "
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
