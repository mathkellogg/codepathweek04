//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Mathew Kellogg on 10/11/15.
//  Copyright © 2015 Mathew Kellogg. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.setImageWithURL(user!.profileImageUrl!)
        nameLabel.text = user!.name!
        descriptionLabel.text = user!.tagline!
        followerCount.text = "\(user!.followers ?? 0)"
        followingCount.text = "\(user!.following ?? 0)"
        favoriteCount.text =  "\(user!.favorites ?? 0)"
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
