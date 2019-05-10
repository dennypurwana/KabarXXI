//
//  HomeTableViewCell.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 14/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit

class NewsItemTableViewCell: UITableViewCell {
    
    @IBOutlet var imageNews: UIImageView!
    @IBOutlet var bookmarkButton: UIButton!
    @IBOutlet var totalViews: UILabel!
    @IBOutlet var titleNews: UILabel!
    @IBOutlet var dateNews: UILabel!
    var save: (() -> Void)? = nil
    
    @IBAction func saveBookmark(_ sender: UIButton) {
        
         save?()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
