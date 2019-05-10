import Foundation
struct NotificationsResponse : Codable {
   
    let message:String
    let status:Int
    let data: [Notifications]
    
    
}
