import Foundation
import Alamofire
import AlamofireImage

class InkAPI: NSObject {
    
    //ブキ情報格納配列
    var weapons:[Weapon] = []
    var weaponsInType:[String:[Weapon]] = [:]
    var typeWeaponsGrouped:[[Weapon]] = []
    var weaponImageViews:[UIImageView] = []
    
    //通信エラー確認
    var ifError = false
    
    //URL
    let baseUrl = "https://stat.ink/api/v2/"
    //json形式で取得
    let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    func getWeapons(closure: @escaping () -> Void) {
        
        let searchUrl = "\(baseUrl)weapon"
        
        AF.request(searchUrl, method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString),
                   headers: headers).responseJSON { response in
                    
                    //dataがあるかどうか確認ガード
                    guard let data = response.data else { return }
                    
                    do {
                        //data中のjsonを配列にして格納
                        self.weapons = try JSONDecoder().decode([Weapon].self, from: data)
                        self.sortbyType()
                        closure()
                    } catch let error {
                        self.ifError = true
                        print("Error: \(error)")
                        closure()
                    }
                    
        }
    }
    
    func sortbyType() {
        
        //配列初期化
        weaponsInType = [:]
        
        var weaponFiltered:[Weapon] = weapons
        var weaponTypes:[String] = []
        
        while weaponFiltered.count > 0 {
            
            //最初のブキの格納・配列から削除
            let firstWeapon = weaponFiltered.first
            weaponFiltered.remove(at: 0)
            
            //ブキタイプ
            let newWeaponType:String = (firstWeapon?.type.name["en_US"])!
            weaponTypes.append(newWeaponType)

            //最初の武器をタイプ別配列に追加
            weaponsInType[newWeaponType] = [firstWeapon!]
            
            //残りの武器のカウント
            let weaponFilteredCount = weaponFiltered.count
            
            for n in 0...weaponFilteredCount - 1 {
                //配列の後ろから確認していく
                let m = weaponFilteredCount - 1 - n
                //タイプが一致したら
                if weaponFiltered[m].type.name["en_US"] == newWeaponType {
                    //配列の2番目に追加・元配列から削除
                    weaponsInType[newWeaponType]!.insert(weaponFiltered[m], at: 1)
                    weaponFiltered.remove(at: m)
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
        var weaponsGrouped:[[Weapon]] = []
        //メイン武器の番号
        var numOfMain = 0
        
        while typeWeapon.count > 0 {
            weaponsGrouped.append([])
            
            //最初のブキの格納・配列から削除
            let firstWeapon = typeWeapon.first
            typeWeapon.remove(at: 0)
            //最初の武器格納
            weaponsGrouped[numOfMain].append(firstWeapon!)
            
            //メイン武器格納
            let mainRef = firstWeapon?.main_ref
            
            //残りの武器カウント
            let typeWeaponCount = typeWeapon.count
            
            for n in 0...typeWeaponCount - 1 {
                
                //配列の後ろから確認していく
                let m = typeWeaponCount - 1 - n
                //メインが一致したら
                if typeWeapon[m].main_ref == mainRef {
                    //配列の2番目に追加・元配列から削除
                    weaponsGrouped[numOfMain].insert(typeWeapon[m], at: 1)
                    typeWeapon.remove(at: m)
                }
            }
            //次の武器の番号
            numOfMain += 1
            
        }
        //格納
        typeWeaponsGrouped = weaponsGrouped
        
    }
    
    func getImages() {
        
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
    
}

//URLから画像取得簡易化
extension UIImage {
    public convenience init(url: URL) {
        globalDispatchGroup.enter()
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)!
            globalDispatchGroup.leave()
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
