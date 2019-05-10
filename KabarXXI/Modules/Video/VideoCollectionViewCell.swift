//
//  VideoCollectionViewCell.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 22/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleVideo: UILabel!
    @IBOutlet var thumbnailVideo: UIImageView!
    @IBOutlet var durationVideo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with video: Video) {
       
        let imageUrl = Constant.ApiUrlImage+"\(video.base64Thumbnail ?? "")"
        thumbnailVideo.kf.setImage(with: URL(string: imageUrl),placeholder: UIImage(named: "default_image"))
        titleVideo.text = video.title ?? ""
        durationVideo.text = video.duration ?? ""
      
        
        
    }
    
}
