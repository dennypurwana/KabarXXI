
import Foundation
import Moya
import UIKit

let applicationSettingProviderServices = MoyaProvider<ApplicationSettingServices>()

enum ApplicationSettingServices{
    
    case getApplicationSetting()
    
}

extension ApplicationSettingServices :TargetType{
    var baseURL: URL {
        return URL(string: Constant.ApiUrl)!
    }
    
    var path: String {
        switch self {
            
        case .getApplicationSetting:
            return "/public/v1/settingApplication"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getApplicationSetting:
            return .get
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case .getApplicationSetting():
            return .requestParameters(
                parameters: [:],
                encoding: URLEncoding.default
            )
            
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}

