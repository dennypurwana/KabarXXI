//
//  LoginResponse.swift
//  KabarXXI_
//
//  Created by Emerio-Mac2 on 26/04/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//

import Foundation
struct LoginResponse : Codable {
    
    let access_token:String?
    let token_type:String?
    let refresh_token:String?
    let expires_in:Int?
    let scope:String?
    let error:String?
    let error_description:String?
    
}
