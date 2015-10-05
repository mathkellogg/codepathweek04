//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/4/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func onReplyTap(sender: AnyObject) {
    }
    @IBAction func onRetweetTap(sender: AnyObject) {
        isRetweeted = !isRetweeted

    }
    @IBAction func onFavoriteTap(sender: AnyObject) {
        isFavorite = !isFavorite

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profileImage.setImageWithURL(tweet!.profileImageURL)
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
        nameLabel.text = tweet?.user?.name
        handleLabel.text = tweet?.user?.screenname
        //isFavorite = tweet!.favorited
        //isRetweeted = tweet!.retweeted
        //retweetCount = tweet!.retweetCount
        //favoriteCount = tweet!.favoriteCount
        tweetTextLabel.text = tweet!.text
        timeLabel.text = tweet!.createdAtShortString
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
