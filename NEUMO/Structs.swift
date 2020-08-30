import Foundation

struct Weapon: Codable {
    let key: String
    let type: WeaponType
    let name: [String:String]
    let sub: KeyAndNames
    let special: KeyAndNames
    let main_ref: String
    let main_power_up: KeyAndNames
}

struct WeaponType: Codable {
    let key: String
    let name: [String:String]
    let category: KeyAndNames
}

struct Gear: Codable {
    let key: String
    let name: [String:String]
    let type: KeyAndNames
    let brand: Brand
    let primary_ability: KeyAndNames?
}

struct Brand: Codable {
    let key:String
    let name:[String:String]
    let strength: KeyAndNames?
    let weakness: KeyAndNames?
}

struct KeyAndNames: Codable {
    let key: String
    let name: [String:String]
}
