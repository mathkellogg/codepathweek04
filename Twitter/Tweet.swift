//
//  Tweet.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var createdAtShortString: String?
    var favoriteCount = 0
    var favorited = false
    var retweetCount = 0
    var retweeted = false
    var profileImageURL: NSURL?

    init(dictionary: NSDictionary){
        print("\(dictionary)")
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favoriteCount = dictionary["favorite_count"] as! Int
        favorited = dictionary["favorited"] as! Int != 0
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Int != 0
        profileImageURL = user?.profileImageUrl
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMMd HH:mm:ss Z y"
        
        createdAt = formatter.dateFromString(createdAtString!)
        formatter.dateFormat = "M/d/yy"

        createdAtShortString = formatter.stringFromDate(createdAt!)
        
    }
    
    class func tweetsWitArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }

}
