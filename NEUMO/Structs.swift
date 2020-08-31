import Foundation

struct Weapon: Codable {
    let key: String
    let type: WeaponType
    let name: [String:String]
    let sub: KeyAndNames
    let special: KeyAndNames
    let main_ref: String
    let main_power_up: KeyAndNames
    
    func infoInStringDictionary() -> [String:String] {
        
        var info:[String:String] = [:]
        info.updateValue(name["en_US"]!, forKey: "Name")
        info.updateValue(type.name["en_US"]!, forKey: "Weapon Type")
        info.updateValue(sub.name["en_US"]!, forKey: "Sub Weapon")
        info.updateValue(special.name["en_US"]!, forKey: "Special Weapon")
        info.updateValue(main_power_up.name["en_US"]!, forKey: "Main Power Up")
        
        return info
        
    }
    
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
    
    func infoInStringDictionary() -> [String:String] {
        
        var info:[String:String] = [:]
        info.updateValue(name["en_US"]!, forKey: "Name")
        info.updateValue(type.name["en_US"]!, forKey: "Gear Type")
        info.updateValue(brand.name["en_US"]!, forKey: "Brand")
        if primary_ability != nil {
            info.updateValue(primary_ability!.name["en_US"]!, forKey: "Primary Abiliry")
        } else {
            info.updateValue("Unspecified", forKey: "Primary Abiliry")
        }
        if brand.strength != nil { info.updateValue(brand.strength!.name["en_US"]!, forKey: "Strength") }
        if brand.weakness != nil { info.updateValue((brand.weakness?.name["en_US"])!, forKey: "Weakness") }
        
        return info
        
    }
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
