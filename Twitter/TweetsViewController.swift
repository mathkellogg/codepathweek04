//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetsViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetsViewLeadingConstraint: NSLayoutConstraint!
    var tweets = [Tweet]()
    var refreshControl: UIRefreshControl!
    var panOriginalCenter: CGPoint?
    var tweetsViewOriginalLeadingConstraint: CGFloat?
    var tweetsViewOriginalTrailingConstraint: CGFloat?
    var tweetsViewOpenLeadingConstraint: CGFloat?
    var tweetsViewOpenTrailingConstraint: CGFloat?
    var slideStartPoint: CGFloat?

    
    @IBOutlet weak var tweetsView: SlidableView!
    @IBOutlet weak var tweetTableView: UITableView!
    
    @IBAction func onDidPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(sender.view?.superview)
        
        if sender.state == UIGestureRecognizerState.Began {
            panOriginalCenter = point
            slideStartPoint = tweetsViewLeadingConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            let changeX = point.x - panOriginalCenter!.x
            tweetsViewTrailingConstraint.constant = (slideStartPoint! + changeX) * -1
            tweetsViewLeadingConstraint.constant = slideStartPoint! + changeX

            print("\(changeX), \(slideStartPoint)")
        } else if sender.state == UIGestureRecognizerState.Ended {
            let velocity = sender.velocityInView(sender.view?.superview)

            if velocity.x > 0 {
                UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.view.layoutIfNeeded()

                    self.tweetsViewTrailingConstraint.constant = self.tweetsViewOpenTrailingConstraint!
                    self.tweetsViewLeadingConstraint.constant = self.tweetsViewOpenLeadingConstraint!
                    }, completion: { (completed) -> Void in })

            } else {
                UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    self.tweetsViewTrailingConstraint.constant = self.tweetsViewOriginalTrailingConstraint!
                    self.tweetsViewLeadingConstraint.constant = self.tweetsViewOriginalLeadingConstraint!
                    }, completion: { (completed) -> Void in })


            }
            
        }
    }
    
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
        panOriginalCenter = tweetsView.center
        let screenWidth = tweetsView.bounds.width
        let openPositionX = screenWidth/2
        tweetsViewOriginalLeadingConstraint = tweetsViewLeadingConstraint.constant
        tweetsViewOriginalTrailingConstraint = tweetsViewTrailingConstraint.constant
        tweetsViewOpenLeadingConstraint = tweetsViewLeadingConstraint.constant + openPositionX
        tweetsViewOpenTrailingConstraint = tweetsViewTrailingConstraint.constant - openPositionX
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tweetTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets[indexPath.row]
        cell.parent = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tweetDetailSegue" {
            let vc = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tweetTableView.indexPathForCell(sender as! TweetTableViewCell)

            vc.tweet = tweets[indexPath!.row]
            vc.redrawOriginalCell = {
                self.tweetTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
            }
        } else if segue.identifier == "replySegue" {
            let vc = segue.destinationViewController as! ComposeViewController
            let button = sender as! UIButton
            vc.tweet = tweets[button.tag as Int]

        }
    }

}
