//
//  TwitterCleint.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/3/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

let twitterConsumerKey = "amYhAyOupzSnZaHyPtiYRFLob"
let twitterConsumerSecret = "IePv30ACWL31sGTJkNv1n03XgqhhiOKbUyXNotF74YUWTWfcB9"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance: TwitterClient{
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

        }
        return Static.instance
    }

}
