
import Foundation

struct ApplicationSettingResponse : Codable {
    
    let message:String?
    let status:Int?
    let data:[ApplicationSetting]?
    
}
