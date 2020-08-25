import Foundation
import UIKit

class NeuColor: NSObject {
    
    static let lightTheme = UIColor(red: 0.90, green: 0.88, blue: 0.87, alpha: 1)
    static let lightTitle = UIColor(red: 0.32, green: 0.22, blue: 0.36, alpha: 1)
    static let lightLetter = UIColor(red: 0.27, green: 0.26, blue: 0.28, alpha: 1)
    static let arrow = UIColor(red: 0.44, green: 0.46, blue: 0.48, alpha: 1)
    
}

class NeuFont: NSObject {
    
    static let lightTheme = UIFont(name: "AvenirNext-Medium", size: 28.0)
    static let lightSub = UIFont(name: "AvenirNext-Regular", size: 24.0)
    static let lightCell = UIFont(name: "AvenirNext-Regular", size: 21.0)
    static let lightCoach = UIFont(name: "AvenirNext-Regular", size: 15.0)
    static let arrow = UIFont(name: "HiraMaruProN-W4", size: 21)
    
}

class subItems: NSObject {
    
    static let name = [["Shooters", "Splatlings", "Nozzlenose", "Blasters", "Rollers", "Brushes",
                        "Chargers","Sloshers", "Dualies","Brellas"],
                       ["Headgear", "Clothing", "Shoes", "Brand", "Power"],
                       ["Favorites", "Cordinate"],
                       ["Change Theme", "Second Item", "Third Item"]]
    
}

//ビューサイズなど
var safeAreaTopInset:CGFloat?
var safeAreaBottomInset:CGFloat?
var safeAreaSideInset:CGFloat?
var safeAreaHeight:CGFloat?
var safeAreaWidth:CGFloat?

//ニューモーフィックビューの共通設定
let neuButtonGap:CGFloat = 20
let neuButtonInset:CGFloat = 12
let neuTableCellHeight:CGFloat = 52
let neuTableCellInset:CGFloat = 8
let neuButtonBasicDepth:CGFloat = 8
let changeDepthDuration:Double = 0.15

//異なるビュー間で共有するディスパッチグループ
let globalDispatchGroup = DispatchGroup()
