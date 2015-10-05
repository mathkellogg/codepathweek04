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

    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(tweetTextField.text!) { (tweet, error) -> () in
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
