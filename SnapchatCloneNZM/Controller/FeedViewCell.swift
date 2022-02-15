//
//  FeedViewCell.swift
//  SnapchatCloneNZM
//
//  Created by Nazim Asadov on 07.02.22.
//

import UIKit

class FeedViewCell: UITableViewCell {

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedUserNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
