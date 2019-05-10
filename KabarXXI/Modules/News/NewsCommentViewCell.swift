//
//  NewsCommentViewCell.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 24/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

class NewsCommentViewCell: UITableViewCell {
    
    @IBOutlet var imageProfile: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var descComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
