//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

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
    
    @IBAction func onRetweetTap(sender: AnyObject) {
        isRetweeted = !isRetweeted
    }
    
    @IBAction func onFavoriteTap(sender: AnyObject) {
        isFavorite = !isFavorite
    }
    
    @IBAction func onReplyTap(sender: AnyObject) {
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
        print("\(self.tweet)")
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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
