//
//  NotificationCollectionViewCell.swift
//  SMFInventory
//
//  Created by Emerio-Mac2 on 18/09/18.
//  Copyright © 2018 Emerio-Mac2. All rights reserved.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vImageNotification: UIImageView!
    @IBOutlet weak var lblNotificationsTitle: UILabel!
    @IBOutlet weak var lblNotificationsDescription: UILabel!
    @IBOutlet weak var lblNotificationsDate: UILabel!
   
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame  = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }

}
