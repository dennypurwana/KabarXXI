
import Foundation
import Moya
import UIKit

let userDefaults = UserDefaults.standard
let providerUserService = MoyaProvider<UserServices>(
    plugins: [CredentialsPlugin { _ -> URLCredential? in
        return URLCredential(user: "kabarxxi-client-portal", password: "VlVjNWVXUkhSbk5WZWs1cVkycE9NRWt3Um5waFJFVjVUVlJWTVUxcVdUSk5lbXQ1VFVSVk1VNW5QVDA9VlVjNWVXUkhSbk5WZWs1cVkycE9NRQ==", persistence: .none)
        }
    ])

enum UserServices{
    case createUser(  username:String,  email:String,  phone:String, password:String)
    case loginUser(username:String,password:String)
    case getUserByUsername(username:String)
}



extension UserServices :TargetType{

    
    
    var baseURL: URL {
        return URL(string: Constant.ApiUrl)!
    }
    
    var path: String {
        switch self {
            
        case .createUser:
            return "/public/v1/users"
            
        case .loginUser:
            return "/oauth/token"
            
        case .getUserByUsername(let username):
            return "/auth/v1/users/\(username)"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
       
        case .createUser:
            return .post
            
        case .loginUser:
            return .post
            
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
       
        case .createUser(let username, let email, let phone, let password):
            return .requestParameters(
                parameters: [
                   
                    "username": username,
                    "email": email,
                    "phoneNumber": phone,
                    "password": password.encryptToMD5!,
                    "roleId":2
            
                    ],
                
                encoding: JSONEncoding.default
            )
            
        case .loginUser(let username, let password):
            let parameters: [String: Any] = [
               
                "username": username,
                "password": password.encryptToMD5!,
                "grant_type":"password"
                
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
           
        case .getUserByUsername(_):
            let parameters: [String: Any] = [
                :
            ]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
            
        }
        
    }
    
    var headers: [String : String]? {
    
        let parameters: [String: String] = [
            "Authorization": "Bearer \(userDefaults.string(forKey: "accessToken") ?? "")"
        ]
        
        switch self {
            
        case .getUserByUsername:
            return parameters
        
        default:
            return nil
        }
        
    }
    
    
    
    
}
