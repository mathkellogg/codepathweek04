//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit


class SettingsTable: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var performSegue: ((identifier: String, user: User) -> Void)?
    var vc: TweetsViewController?
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("selected: \(indexPath.row)")
        switch indexPath.row {
        case 0:
            break
        case 1:
            self.performSegue!(identifier: "profileSegue",user: User.currentUser!)
        case 2:
            self.vc!.closeTray()
        case 3:
            break
            //self.performSegue!(identifier: "mentionsSegue")
        default:
             break
        }

 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
            cell.profileImageView.image = UIImage(named: "favorite")
            cell.nameLabel.text = "Chim Ritchells"
            cell.descriptionLabel.text = "Brothers with Doctor Kenneth Noisewater. Great at bringing the Thunder."
            cell.sizeToFit()
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsCell
            switch indexPath.row {
            case 1:
                cell.iconView.image = UIImage(named: "favorite" )
                cell.descriptionLabel.text = "My Profile"
                
            case 2:
                cell.iconView.image = UIImage(named: "favorite")
                cell.descriptionLabel.text = "Home Timeline"
                
            default:
                cell.iconView.image = UIImage(named: "favorite")
                cell.descriptionLabel.text = "Mentions"
                
            }
            cell.sizeToFit()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
}

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
    var settingsTableDelegate: SettingsTable?
    
    var segueUser: User?
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var tweetsView: SlidableView!
    @IBOutlet weak var tweetTableView: UITableView!
    
    
    
    func closeTray() {
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
        self.view.layoutIfNeeded()
    
        self.tweetsViewTrailingConstraint.constant = self.tweetsViewOpenTrailingConstraint!
        self.tweetsViewLeadingConstraint.constant = self.tweetsViewOpenLeadingConstraint!
        }, completion: { (completed) -> Void in })
    }

    
    @IBAction func onDidPan(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(sender.view?.superview)
        
        if sender.state == UIGestureRecognizerState.Began {
            panOriginalCenter = point
            slideStartPoint = tweetsViewLeadingConstraint.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            let changeX = point.x - panOriginalCenter!.x
            tweetsViewTrailingConstraint.constant = (slideStartPoint! + changeX) * -1
            tweetsViewLeadingConstraint.constant = slideStartPoint! + changeX
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
    
    func performSegue(identifier:String, user: User) {
        self.segueUser = user
        performSegueWithIdentifier(identifier, sender: self)
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
        
        settingsTableDelegate = SettingsTable()
        settingsTableDelegate!.vc = self
        settingsTable.delegate = settingsTableDelegate
        settingsTable.dataSource = settingsTableDelegate
        settingsTableDelegate!.performSegue = performSegue
        //settingsTable.reloadData()
        settingsTable.rowHeight = UITableViewAutomaticDimension
        settingsTable.estimatedRowHeight = 120
        
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
        cell.tapFunction = {
            self.performSegue("profileSegue", user:(cell.tweet?.user!)!)
        }
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

        } else if segue.identifier == "profileSegue" {
            let vc = segue.destinationViewController as! ProfileViewController
            var aUser: User
            if segueUser != nil{
                 aUser = segueUser!
            } else {
                aUser = User.currentUser!
            }
            vc.user = aUser
            


        }
    }
 

}
