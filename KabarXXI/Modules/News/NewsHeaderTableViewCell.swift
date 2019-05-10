//
//  HomeHeaderTableViewCell.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 14/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

class NewsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet var totalViews: UILabel!
    
    @IBOutlet var imageNews: UIImageView!
    
    @IBOutlet var titleNews: UILabel!
    
    @IBOutlet var dateNews: UILabel!
    
    @IBOutlet var bookmarkButton: UIButton!
    
    var save: (() -> Void)? = nil
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        
        save?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
