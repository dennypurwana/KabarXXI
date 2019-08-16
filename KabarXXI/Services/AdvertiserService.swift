//
//  AdvertiserService.swift
//  KabarXXI
//
//  Created by Emerio on 17/08/19.
//  Copyright © 2019 Emerio-Mac2. All rights reserved.
//


import Foundation
import Moya
import UIKit

let advertiserProviderServices = MoyaProvider<AdvertiserService>()

enum AdvertiserServices{
    
    case getAdvertiser(Int)

}

extension AdvertiserServices :TargetType{
    var baseURL: URL {
        return URL(string: Constant.ApiUrl)!
    }
    
    var path: String {
        switch self {
            
        case .getAdvertiser:
            return "/public/v1/advertiser"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
            default:
                return .get
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case .getAdvertiser(let page):
            return .requestParameters(
                parameters: [
                    
                    "sort": "createdDate,DESC",
                    "size": 10,
                    "page": page
                    
                ],
                encoding: URLEncoding.default
            )
            
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
