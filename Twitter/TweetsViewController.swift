//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets = [Tweet]()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 120
        
        fetchTweets()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "fetchTweets", forControlEvents: UIControlEvents.ValueChanged)
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tweetTableView
        dummyTableVC.refreshControl = refreshControl

        // Do any additional setup after loading the view.

    }
    
    func fetchTweets(){
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            self.tweets = tweets!
            self.tweetTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
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
