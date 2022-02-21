//
//  MessageCell.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 19.02.22.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        textLabel?.layer.masksToBounds = true
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 4
        label.frame.size.height = messageBubble.frame.size.height
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
}
