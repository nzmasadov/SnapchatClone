//
//  Singleton.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 06.02.22.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var username = ""
    var email = ""
    
    
    private init() {
        
    }
}
