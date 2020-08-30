import Foundation
import Alamofire
import AlamofireImage

class InkAPI: NSObject {
    
    //ブキ情報格納配列
    var weapons:[Weapon] = []
    var gears:[Gear] = []
    var weaponsInType:[String:[Weapon]] = [:]
    var gearsInType:[String:[Gear]] = [:]
    var gearsInBrand:[String:[Gear]] = [:]
    
    var typeWeaponsGrouped:[[Weapon]] = []
    var typeGearsBrandGrouped:[[Gear]] = []
    var typeGearsAbilityGrouped:[[Gear]] = []
    var weaponImageViews:[UIImageView] = []
    var gearImageViews:[UIImageView] = []
    
    //通信エラー確認
    var ifError = false
    
    //URL
    let baseUrl = "https://stat.ink/api/v2/"
    //json形式で取得
    let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    //ブキ取得・ブキ種ごとにグルーピング
    func getWeapons(closure: @escaping () -> Void) {
        
        let searchUrl = "\(baseUrl)weapon"
        
        AF.request(searchUrl, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString),
                   headers: headers).responseJSON { response in
                    
                    //dataがあるかどうか確認ガード
                    guard let data = response.data else { return }
                    
                    do {
                        //data中のjsonを配列にして格納
                        self.weapons = try JSONDecoder().decode([Weapon].self, from: data)
                        self.sortByType()
                        closure()
                    } catch let error {
                        self.ifError = true
                        print("Error: \(error)")
                        closure()
                    }
                    
        }
    }
    //ギア取得・ギア種・ブランドごとにグループ
    func getGears(closure: @escaping () -> Void) {
        
        let searchUrl = baseUrl + "gear"
        
        AF.request(searchUrl, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString),
                   headers: headers).responseJSON { response in
        
                    //dataがあるかどうか確認ガード
                    guard let data = response.data else { return }
                    
                    do {
                        //data中のjsonを配列にして格納
                        self.gears = try JSONDecoder().decode([Gear].self, from: data)
                        self.sortByType()
                        self.sortByBrand()
                        closure()
                    } catch let error {
                        self.ifError = true
                        print("Error: \(error)")
                        closure()
                    }
                    
        }
        
    }
    
    //ブキ・ギアの種類ごとにグループ
    func sortByType() {
        
        //配列初期化
        weaponsInType = [:]
        gearsInType = [:]
        
        if weapons.count != 0 {
            
            var itemsFiltered:[Weapon] = weapons
            
            while itemsFiltered.count > 0 {
                
                //最初のアイテムの格納・配列から削除
                let firstItem = itemsFiltered.first
                itemsFiltered.remove(at: 0)
                
                //残りのアイテムのカウント
                let itemsFilteredCount = itemsFiltered.count
                guard itemsFilteredCount != 0 else { break }
                
                //アイテムのタイプ
                let newItemType:String = (firstItem?.type.name["en_US"])!
                
                //最初のアイテムをタイプ別配列に追加
                weaponsInType[newItemType] = [firstItem!]
                
                for n in 0...itemsFilteredCount - 1 {
                    //配列の後ろから確認していく
                    let m = itemsFilteredCount - 1 - n
                    //タイプが一致したら
                    if itemsFiltered[m].type.name["en_US"] == newItemType {
                        //配列の2番目に追加・元配列から削除
                        weaponsInType[newItemType]!.insert(itemsFiltered[m], at: 1)
                        itemsFiltered.remove(at: m)
                    }
                }
                
            }
            
        } else if gears.count != 0 {
            
            var itemsFiltered:[Gear] = gears
            
            while itemsFiltered.count > 0 {
                
                //最初のアイテムの格納・配列から削除
                let firstItem = itemsFiltered.first
                itemsFiltered.remove(at: 0)
                
                //残りのアイテムのカウント
                let itemsFilteredCount = itemsFiltered.count
                guard itemsFilteredCount != 0 else { break }
                
                //アイテムのタイプ
                let newItemType:String = (firstItem?.type.name["en_US"])!
                
                //最初のアイテムをタイプ別配列に追加
                gearsInType[newItemType] = [firstItem!]
                
                for n in 0...itemsFilteredCount - 1 {
                    //配列の後ろから確認していく
                    let m = itemsFilteredCount - 1 - n
                    //タイプが一致したら
                    if itemsFiltered[m].type.name["en_US"] == newItemType {
                        //配列の2番目に追加・元配列から削除
                        gearsInType[newItemType]!.insert(itemsFiltered[m], at: 1)
                        itemsFiltered.remove(at: m)
                    }
                }
                
            }
            
        }
        
    }
    //ギアのブランドごとにグループ
    func sortByBrand() {
        
        gearsInBrand = [:]
        
        var itemsFiltered:[Gear] = gears
        
        while itemsFiltered.count > 0 {
            
            //最初のギアの格納・配列から削除
            let firstItem = itemsFiltered.first
            itemsFiltered.remove(at: 0)
            
            //残りのギアのカウント
            let itemsFilteredCount = itemsFiltered.count
            guard itemsFilteredCount != 0 else { break }
            
            //ブランド
            let newGearBrand:String = (firstItem?.brand.name["en_US"])!
            
            //最初のギアをタイプ別配列に追加
            gearsInBrand[newGearBrand] = [firstItem!]
            
            for n in 0...itemsFilteredCount - 1 {
                //配列の後ろから確認していく
                let m = itemsFilteredCount - 1 - n
                //タイプが一致したら
                if itemsFiltered[m].brand.name["en_US"] == newGearBrand {
                    //配列の2番目に追加・元配列から削除
                    gearsInBrand[newGearBrand]!.insert(itemsFiltered[m], at: 1)
                    itemsFiltered.remove(at: m)
                }
            }
            
        }
        
    }
    
    func groupByMain(weaponType:String) {
        
        //事前にタイプ分けしてるかガード
        guard weaponsInType[weaponType] != nil else { return }
        
        //グループ分けするタイプのブキ
        var typeWeapon:[Weapon] = weaponsInType[weaponType]!
        //出力用配列
        var itemsGrouped:[[Weapon]] = []
        //メイン武器の番号
        var numOfMain = 0
        
        while typeWeapon.count > 0 {
            itemsGrouped.append([])
            
            //最初のブキの格納・配列から削除
            let firstWeapon = typeWeapon.first
            typeWeapon.remove(at: 0)
            //最初の武器格納
            itemsGrouped[numOfMain].append(firstWeapon!)
            
            //残りの武器カウント
            let typeWeaponCount = typeWeapon.count
            guard typeWeaponCount != 0 else { break }
            
            //メイン武器格納
            let mainRef = firstWeapon?.main_ref
            
            for n in 0...typeWeaponCount - 1 {
                
                //配列の後ろから確認していく
                let m = typeWeaponCount - 1 - n
                //メインが一致したら
                if typeWeapon[m].main_ref == mainRef {
                    //配列の2番目に追加・元配列から削除
                    itemsGrouped[numOfMain].insert(typeWeapon[m], at: 1)
                    typeWeapon.remove(at: m)
                }
            }
            //次の武器の番号
            numOfMain += 1
            
        }
        //格納
        typeWeaponsGrouped = itemsGrouped
        
    }
    
    func groupByBrand(gearType:String) {
        
        guard  gearsInType.count != 0 else { return }
        
        var typeGears = gearsInType[gearType]!
        
        //出力用
        var gearsTypeGrouped:[[Gear]] = []
        
        //ブランドの番号
        var numOfBrand = 0
        
        while typeGears.count > 0 {
            gearsTypeGrouped.append([])
            
            //最初のギアの格納・配列から削除
            let firstGear = typeGears.first!
            typeGears.remove(at: 0)
            
            //最初のギア格納
            gearsTypeGrouped[numOfBrand].append(firstGear)
            
            //残りのギアカウント
            let typeGearsCount = typeGears.count
            guard typeGearsCount != 0 else { break }
            
            //ブランド名格納
            let brandName = firstGear.brand.name
            
            for n in 0...typeGearsCount - 1 {
                
                //配列の後ろから確認していく
                let m = typeGearsCount - 1 - n
                
                //ブランドが一致したら
                if typeGears[m].brand.name == brandName {
                    //配列の2番目に追加・元配列から削除
                    gearsTypeGrouped[numOfBrand].insert(typeGears[m], at: 1)
                    typeGears.remove(at: m)
                }
                
            }
            //次のブランドの番号
            numOfBrand += 1
        }
        //格納
        typeGearsBrandGrouped = gearsTypeGrouped
        
    }
    
    func groupByAbility(gearType:String) {
        
        guard  gearsInType.count != 0 else { return }
        
        var typeGears = gearsInType[gearType]!
        
        //出力用
        var gearsAbilityGrouped:[[Gear]] = []
        
        //パワーの番号
        var numOfAbility = 0
        
        while typeGears.count > 0 {
            gearsAbilityGrouped.append([])
            
            //最初のギアの格納・配列から削除
            let firstGear = typeGears.first!
            typeGears.remove(at: 0)
            
            //最初のギア格納
            gearsAbilityGrouped[numOfAbility].append(firstGear)
            
            //残りのギアカウント
            let typeGearsCount = typeGears.count
            guard typeGearsCount != 0 else { break }
            
            //パワー名格納
            let abilityName = firstGear.primary_ability?.name
            
            for n in 0...typeGearsCount - 1 {
                
                //配列の後ろから確認していく
                let m = typeGearsCount - 1 - n
                
                //パワーが一致したら
                if typeGears[m].primary_ability?.name == abilityName {
                    gearsAbilityGrouped[numOfAbility].insert(typeGears[m], at: 1)
                    typeGears.remove(at: m)
                }
                
            }
            //次のブランドの番号
            numOfAbility += 1
        }
        //格納
        typeGearsAbilityGrouped = gearsAbilityGrouped
        
    }
    
    func groupedWeaponList(groupedWeapons:[[Weapon]]) -> [[String]]? {
        
        var itemNameList:[[String]] = []
        
        guard groupedWeapons.count != 0 else { return nil }
        
        for n in 0...groupedWeapons.count - 1 {
            itemNameList.append([])
            for m in 0...groupedWeapons[n].count - 1 {
                let weaponName = groupedWeapons[n][m].name["en_US"]!
                itemNameList[n].append(weaponName)
            }
        }
        
        return itemNameList
        
    }
    
    func groupedGearList(groupedGears:[[Gear]]) -> [[String]]? {
        
        var itemNameList:[[String]] = []
        
        guard  groupedGears.count != 0 else { return nil }
        
        for n in 0...groupedGears.count - 1 {
            itemNameList.append([])
            for m in 0...groupedGears[n].count - 1 {
                let gearName = groupedGears[n][m].name["en_US"]!
                itemNameList[n].append(gearName)
            }
        }
        
        return itemNameList
        
    }
    
    func getWeaponImages() {
        
        //ガード
        guard typeWeaponsGrouped.count != 0 else { return }
        //初期化
        weaponImageViews = []
        //配列にインスタンスを必要数用意
        for n in 0...typeWeaponsGrouped.count - 1 {
            for _ in 0...typeWeaponsGrouped[n].count - 1 {
                weaponImageViews.append(UIImageView())
            }
        }
        
        //画像取得(AlamoFireImage)
        var weaponNum = 0
        for n in 0...typeWeaponsGrouped.count - 1 {
            for m in 0...typeWeaponsGrouped[n].count - 1 {
                //画像URL
                let url = URL(string: "https://cdn.wikimg.net/en/splatoonwiki/images/6/60/S2_Weapon_Main_Splattershot.png")!
                
                let neuImageView = UIImageView()
                neuImageView.af.setImage(withURL: url)
                weaponImageViews[weaponNum] = neuImageView
                weaponNum += 1
            }
        }
    }
    
    func getGearImages(gearType:String) {
        
        //
        guard typeGearsBrandGrouped.count != 0 else { return }
        //
        gearImageViews = []
        //
        for n in 0...typeGearsBrandGrouped.count - 1 {
            for _ in 0...typeGearsBrandGrouped[n].count - 1 {
                gearImageViews.append(UIImageView())
            }
        }
        
        var gearNum = 0
        for n in 0...typeGearsBrandGrouped.count - 1 {
            for _ in 0...typeGearsBrandGrouped[n].count - 1 {
                var url:URL?
                if gearType == "Headgear" {
                //画像URL
                    url = URL(string: "https://cdn.wikimg.net/en/splatoonwiki/images/9/9b/S2_Gear_Headgear_Knitted_Hat.png")!
                } else if gearType == "Clothing" {
                    url = URL(string: "https://cdn.wikimg.net/en/splatoonwiki/images/4/44/S2_Gear_Clothing_White_King_Tank.png")!
                } else {
                    url = URL(string: "https://cdn.wikimg.net/en/splatoonwiki/images/9/94/S2_Gear_Shoes_Black_Dakroniks.png")!
                }
                
                let neuImageView = UIImageView()
                neuImageView.af.setImage(withURL: url!)
                gearImageViews[gearNum] = neuImageView
                gearNum += 1
            }
        }
        
    }
    
}

//URLから画像取得簡易化
//extension UIImage {
//    public convenience init(url: URL) {
//        globalDispatchGroup.enter()
//        do {
//            let data = try Data(contentsOf: url)
//            self.init(data: data)!
//            globalDispatchGroup.leave()
//            return
//        } catch let err {
//            print("Error : \(err.localizedDescription)")
//        }
//        self.init()
//    }
//}
