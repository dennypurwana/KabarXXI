//
//  UILabel.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 23/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func htmlToString(html: String) {
        if let htmlData = html.data(using: .unicode) {
            do {
                self.attributedText = try NSAttributedString(data: htmlData,
                                                             options: [.documentType: NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil)
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
   
        var optimalHeight : CGFloat {
            get
            {
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.byWordWrapping
                label.font = self.font
                label.text = self.text
                label.sizeToFit()
                return label.frame.height
            }
            
        }
    
}
