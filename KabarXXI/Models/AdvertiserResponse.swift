//
//  AdvertiserResponse.swift
//  KabarXXI
//
//  Created by Emerio on 17/07/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import Foundation

struct AdvertiserResponse : Codable {
    
    let message:String
    let status:Int
    let data: [Advertiser]
    
}
