//
//  DataService.swift
//  displaycase
//
//  Created by JuanPa Villa on 3/1/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import Foundation
import Firebase


class DataService {
    
    static let ds = DataService()
    let ref = FIRDatabase.database().reference()
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
        
        let user = self.ref.child(REF_USERS).child(uid)
        return user
    }
    
    
    func createFirebaseUser(uid: String, user: Dictionary<String,String>) {
        
        self.ref.child(REF_USERS).child(uid).setValue(user)
        
    }
    
    
}
