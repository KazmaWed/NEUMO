import Foundation

struct Weapon: Codable {
    let key: String
    let type: WeaponType
    let name: [String:String]
    let sub: keyAndNames
    let special: keyAndNames
    let main_ref: String
    let main_power_up: keyAndNames
}

struct WeaponType: Codable {
    let key: String
    let name: [String:String]
    let category: keyAndNames
}

struct keyAndNames: Codable {
    let key: String
    let name: [String:String]
}
