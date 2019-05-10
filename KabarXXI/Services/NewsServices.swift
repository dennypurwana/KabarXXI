
import Foundation
import Moya
import UIKit

let newsProviderServices = MoyaProvider<NewsServices>()

enum NewsServices{
   
    case getLatestNews(Int)
    case getMainNews(Int)
    case getPopularNews(Int)
    case getCategory()
    case getNotifications()
    case getRelatedNews(keyword:String)
    case getNewsByCategory(page:Int,categoryName:String)
    case searchNews(page:Int,searchValue:String,categoryName:String)
    case updateViews(Int)
    
    
}

extension NewsServices :TargetType{
    var baseURL: URL {
        return URL(string: Constant.ApiUrl)!
    }
    
    var path: String {
        switch self {
       
        case .getLatestNews:
            return "/public/v1/news/latest"
            
        case .getNotifications:
            return "/public/v1/pushNotification"
       
        case .getMainNews:
            return "/public/v1/news/main"
            
        case .getPopularNews:
            return "/public/v1/news/popular"
            
        case .getRelatedNews(let keyword):
            return "/public/v1/news/related/\(keyword)"
            
        case .getNewsByCategory( _,let categoryName):
            return "/public/v1/news/newsByCategory/\(categoryName)"
            
        case .searchNews(_, let searchValue, let categoryName):
           return "/public/v1/news/searchNews/\(searchValue)/\(categoryName)"
            
        case .getCategory:
            return "/public/v1/category"
            
        case .updateViews(let id):
            return "/public/v1/news/\(id)"
            
    
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .updateViews:
            return .put

        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {

        case .getLatestNews(let page):
            return .requestParameters(
                parameters: [
                    
                    "sort": "createdDate,DESC",
                    "size": 10,
                    "page": page
                    
                ],
                encoding: URLEncoding.default
            )
            
        case .getMainNews(let page):
            return .requestParameters(
                parameters: [
                    
                    "sort": "createdDate,DESC",
                    "size": 10,
                    "page": page
                    
                ],
                encoding: URLEncoding.default
            )
            
        case .getPopularNews(let page):
            return .requestParameters(
                parameters: [
                    
                    "sort": "createdDate,DESC",
                    "size": 10,
                    "page": page
                
                ],
                encoding: URLEncoding.default
            )
            
        case .getCategory():
            return .requestParameters(
                parameters: [:],
                encoding: URLEncoding.default
            )
            
            
        case .getNotifications():
            return .requestParameters(
                parameters: [:],
                encoding: URLEncoding.default
            )
            
            
        
        case .getRelatedNews(_):
            let parameters: [String: Any] =
                [:]
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.default
            )
            
        case .getNewsByCategory(let page,_):
            return .requestParameters(
                parameters: [
                    
                    "sort": "createdDate,DESC",
                    "size": 10,
                    "page": page
                    
                ],
                encoding: URLEncoding.default
            )
            
        case .searchNews( let page, _, _):
            return .requestParameters(
                parameters: [
                    
                    "sort": "createdDate,DESC",
                    "size": 10,
                    "page": page
                    
                ],
                encoding: URLEncoding.default
            )
            
        case .updateViews(_):
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
