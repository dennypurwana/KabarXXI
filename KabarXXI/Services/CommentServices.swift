
import Foundation
import Moya
import UIKit

let commentProviderServices = MoyaProvider<CommentServices>()

enum CommentServices{
    
    case getAllCommented(Int)
    case getMostCommented(Int)
    case createComment(description:String, newsId:Int)
    
}

extension CommentServices :TargetType{
    var baseURL: URL {
        return URL(string: Constant.ApiUrl)!
    }
    
    var path: String {
        switch self {
            
       
            ///public/v1/newsComment/getByNewsId/{newsId}
           // getList
        case .getAllCommented(let newsId):
            return "/public/v1/newsComment/getByNewsId/\(newsId)"
            
        case .getMostCommented(let newsId):
            return "/most/\(newsId)"
        
        case .createComment:
            return "/auth/v1/newsComment"
            
            
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .createComment:
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
            
        case .getMostCommented(_):
            return .requestParameters(
                parameters: [
                    :
                    
                ],
                encoding: URLEncoding.default
            )
            
        case .getAllCommented(_):
            return .requestParameters(
                parameters: [
                    
                  :
                    
                ],
                encoding: URLEncoding.default
            )
            
        case .createComment(let description,let newsId):
            
            print(description)
            print(newsId)
            print(userDefaults.integer(forKey: "userId") )
            return .requestParameters(
                parameters: [
                    
                    "description": description,
                    "id": 0,
                    "newsId": newsId,
                    "userId": userDefaults.integer(forKey: "userId") 
                    
                ],
                
                encoding: JSONEncoding.default
            )
            
        }
        
        
        
    }
    
    var headers: [String : String]? {
        let parameters: [String: String] = [
            "Authorization": "Bearer \(userDefaults.string(forKey: "accessToken") ?? "")"
        ]
        
        switch self {
            
        case .createComment:
            return parameters
            
        default:
            return nil
        }
    }
    
}
