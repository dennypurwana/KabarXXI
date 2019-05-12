import Foundation
struct ApplicationSetting : Codable {
    
    let appName:String?
    let version:String?
    let versionCode:Int
    let description:String?
    let copyright:String?
    let base64Image:String?
    let mimeType:String?
    
    
}
