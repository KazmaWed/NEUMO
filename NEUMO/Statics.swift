import Foundation
import UIKit

class NeuColor: NSObject {
    
    static let lightTheme = UIColor(red: 0.90, green: 0.88, blue: 0.87, alpha: 1)
    static let lightTitle = UIColor(red: 0.34, green: 0.20, blue: 0.38, alpha: 1)
    static let lightLetter = UIColor(red: 0.30, green: 0.29, blue: 0.32, alpha: 1)
    static let arrow = UIColor(red: 0.44, green: 0.46, blue: 0.48, alpha: 1)
    static let heart = UIColor(red: 0.55, green: 0.30, blue: 0.36, alpha: 1)
    
}

class NeuFont: NSObject {
    
    static let lightTheme = UIFont(name: "AvenirNext-Medium", size: 28.0)
    static let lightSub = UIFont(name: "AvenirNext-Regular", size: 24.0)
    
    static let lightCell = UIFont(name: "AvenirNext-Regular", size: 21.0)
    static let groupLabel = UIFont(name: "AvenirNext-Medium", size: 20.0)
   
    static let arrow = UIFont(name: "HiraMaruProN-W4", size: 21)
    static let cegmentedControl = UIFont(name: "Futura-Medium", size: 16)
   
    static let itemKey = UIFont(name: "Futura-Medium", size: 15)
    static let itemValue = UIFont(name: "AvenirNext-Regular", size: 21)
    
    static let lightCoach = UIFont(name: "AvenirNext-Regular", size: 15.0)
    
}

class subItems: NSObject {
    
    static let name = [["Shooters", "Splatlings", "Nozzlenose", "Blasters", "Rollers", "Brushes",
                        "Chargers","Sloshers", "Dualies","Brellas"],
                       ["Headgear", "Clothing", "Shoes"],
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
