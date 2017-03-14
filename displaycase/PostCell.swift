//
//  PostCell.swift
//  displaycase
//
//  Created by JuanPa Villa on 3/3/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var displayCasePostImg: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesHeartImg: UIImageView!
    
    var post: Post!
    var request: Request?
    var likesRef: FIRDatabaseReference!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped(sender:)))
        tap.numberOfTapsRequired = 1
        likesHeartImg.addGestureRecognizer(tap)
        likesHeartImg.isUserInteractionEnabled = true
        
        
    }
    
    
    override func draw(_ rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        displayCasePostImg.clipsToBounds = true
        
    }
    


    func configureCell(post: Post, img: UIImage?) {
        
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.descriptionTxt.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        
        if post.imageUrl != nil {
            
            self.displayCasePostImg.isHidden = false
            
            if img != nil {
                

                self.displayCasePostImg.image = img
                
            } else {
                
                //This "image/*" is a special Alamofire wildcard for validating image requests
                request = Alamofire.request(post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { (result) in
                    //
                    
                    if result.error == nil {
                        
                        let img = UIImage(data: result.data!)
                        self.displayCasePostImg.image = img
                        FeedVC.imageCache.setObject(img!, forKey: self.post.imageUrl as AnyObject)
                    }
                    
                    
                })
                
            }
            
        } else {
            self.displayCasePostImg.isHidden = true
        }
        
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //
            if (snapshot.value as? NSNull) != nil {
                //This means that we checked if the snapshot.value came back as an NSNULL and if it did it means that there are no likes for this post. 
                self.likesHeartImg.image = UIImage(named: "heart-empty")
                
            } else {
                self.likesHeartImg.image = UIImage(named: "heart-full")
            }
            
        })
        
        
    }
    
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //
            if (snapshot.value as? NSNull) != nil {
                self.likesHeartImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                
            } else {
                
                self.likesHeartImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
                
            }
            
        })
        
    }

}
