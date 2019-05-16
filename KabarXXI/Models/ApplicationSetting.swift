import Foundation
struct ApplicationSetting : Codable {
    
    let id :Int
    let appName:String?
    let version:String?
    let androidVersionCode:Int
    let iosVersionCode:Int
    let description:String?
    let copyright:String?
    let base64Image:String?
    let mimeType:String?
    let createdDate : String?
    let updatedDate:String?
    
    
}
