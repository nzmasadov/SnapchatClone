//
//  K.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 19.02.22.
//

import Foundation
import UIKit

struct K {
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let messageSegue = "ToChat"
    
    struct BrandColors {
        static let darkBlue = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.8470588235, alpha: 1)
        static let lightBlue = #colorLiteral(red: 0.7921568627, green: 0.9411764706, blue: 0.9725490196, alpha: 1)
  
        
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
