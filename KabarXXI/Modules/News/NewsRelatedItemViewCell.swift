//
//  NewsRelatedItemViewCell.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 23/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

class NewsRelatedItemViewCell: UITableViewCell {
   
    @IBOutlet var titleNews: UILabel!
    @IBOutlet var dateNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleNews.numberOfLines = 0
        titleNews.adjustsFontSizeToFitWidth = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
