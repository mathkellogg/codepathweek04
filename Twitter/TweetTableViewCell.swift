//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    var indexPath: NSIndexPath?
    weak var parent: UIViewController?
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func onReplyTap(sender: AnyObject) {

        //parent!.performSegueWithIdentifier("composeSegue", sender: self)
    }
    @IBAction func onRetweetTap(sender: AnyObject) {
        isRetweeted = !isRetweeted
        
        if isRetweeted{
            retweetCount = (retweetCount + 1)
            TwitterClient.sharedInstance.retweet((tweet?.text)!, tweetId: (tweet?.id)!) { (tweet, error) -> () in
                
            }
        } else {
            retweetCount = (retweetCount - 1)
            tweet?.retweeted = false
        }
        tweet?.retweetCount = retweetCount
        tweet?.retweeted = isRetweeted
    }
    @IBAction func onFavoriteTap(sender: AnyObject) {
        isFavorite = !isFavorite
        if isFavorite{
            favoriteCount = (favoriteCount + 1)
            TwitterClient.sharedInstance.favorite((tweet?.id)!, completion: { (tweet, error) -> () in
                
            })
        } else {
            favoriteCount = (favoriteCount - 1)
            TwitterClient.sharedInstance.unfavorite((tweet?.id)!, completion: { (tweet, error) -> () in
                
            })
        }
        tweet?.favoriteCount = favoriteCount
        tweet?.favorited = isFavorite
    }
    
    var tweet: Tweet? {
        didSet {
            buildTweet()
        }
    }
    
    var isFavorite: Bool = false {
        didSet{
            favoriteButton.selected = isFavorite
        }
    }
    var isRetweeted: Bool = false {
        didSet{
            retweetButton.selected = isRetweeted
        }
    }
    var retweetCount: Int = 0 {
        didSet {
            retweetCountLabel.text = "\(retweetCount)"
        }
    }
    var favoriteCount: Int = 0 {
        didSet {
            favoriteCountLabel.text = "\(favoriteCount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func buildTweet(){
        thumbImageView.setImageWithURL(tweet!.profileImageURL)
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        nameLabel.text = tweet?.user?.name
        handleLabel.text = tweet?.user?.screenname
        isFavorite = tweet!.favorited
        isRetweeted = tweet!.retweeted
        retweetCount = tweet!.retweetCount
        favoriteCount = tweet!.favoriteCount
        tweetTextLabel.text = tweet!.text
        timeLabel.text = tweet!.createdAtShortString
        if indexPath != nil {
            replyButton.tag = indexPath!.row
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
