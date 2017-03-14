//
//  Post.swift
//  displaycase
//
//  Created by JuanPa Villa on 3/5/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    
    
    
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    
    var postKey: String {
        return _postKey
    }
    
    
    
    
    init(description: String, imageUrl: String?, userName: String){
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = userName
        
    }
    
    init(postKey: String, dictionary: Dictionary<String, Any>) {
        
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        
        self._postRef = DataService.ds.ref.child(REF_POSTS).child(self.postKey)
        
    }
    
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        self._postRef.child("likes").setValue(_likes)
        
    }
    
}
