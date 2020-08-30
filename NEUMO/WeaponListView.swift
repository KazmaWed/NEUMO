import UIKit

import EMTNeumorphicView

class WeaponListView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景色適用
        view.backgroundColor = NeuColor.lightTheme
        
        title = weaponCategory
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.setAnimationsEnabled(true)
        
        //通信終了を確認してブキカテゴリー分け
        globalDispatchGroup.notify(queue: .main) {
            
            //セルを生成して
            self.makeWeaponTables()
            //画像を設定
            self.setWeaponImages()
            
            //アニメーションで表示
            for eachCell in self.neuTableCells {
                eachCell.appear(duration: 0.1)
            }
            
        }
        
    }
    
    
    //-------------------IBアウトレットなど-------------------
    
    
    @IBOutlet weak var weaponScrollView: UIScrollView!
    
    
    //親ビューから受け取る値
    var weaponCategory:String = ""
    var inkAPI:InkAPI?
    
    var weapons:[Weapon] = []
    
    //テーブルビュー用
    var neuTableCells:[NeumorphicCellButton] = []
    
    //-------------------メソッド--------------------
    
    func makeWeaponTables() {
        
        //セルと作るブキ配列
        let typeWeaponsGrouped = inkAPI!.typeWeaponsGrouped
        let weaponNames:[[String]] = inkAPI!.groupedWeaponList(groupedWeapons: typeWeaponsGrouped)!
        
        guard weaponNames.count != 0 else { return }
        
        //セルのframe関係
        let neuTableCellWidth:CGFloat = safeAreaWidth! - (neuButtonGap + neuButtonInset) * 2
        let cellX:CGFloat = (safeAreaWidth! - neuTableCellWidth) / 2
        var cellY:CGFloat = neuButtonInset
        
        for n in 0...typeWeaponsGrouped.count - 1 {
            
            //ブキグループ
            let weaponGroup = typeWeaponsGrouped[n]
            
            for m in 0...weaponGroup.count - 1 {
                
                //新規セル
                let neuCell = NeumorphicCellButton()
                neuCell.initialize(backGroundColor: view.backgroundColor!,
                                   text: weaponNames[n][m])
                
                //ボタンの影設定
                if weaponGroup.count == 1 {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .all
                } else if m == 0 {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .topRow
                } else if m == weaponGroup.count - 1 {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .bottomRow
                } else {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .middleRow
                }
                
                //ボタン外観設定
                neuCell.size(width: neuTableCellWidth, height: neuTableCellHeight)
                neuCell.frame.origin = CGPoint(x: cellX, y: cellY)
                
                //ラベルの横幅確認
                neuCell.labelWidthFix()
                
                //セルを配列に格納
                neuTableCells.append(neuCell)
                
                //次のセルのY
                cellY += neuTableCellHeight
            }
            //次のグループのY
            cellY += neuButtonGap
        }
        
        //セルをビューに追加
        for eachCell in neuTableCells {
            weaponScrollView.addSubview(eachCell)
        }
        
        //スクロールコンテンツサイズ
        weaponScrollView.contentSize = CGSize(width: weaponScrollView.frame.size.width, height: cellY)
        
    }
    
    func setWeaponImages() {
        
        guard inkAPI?.weaponImageViews.count != 0 else { return }
        
        for n in 0...neuTableCells.count - 1 {
            //取得した画像ビュー
            neuTableCells[n].cellIconImage.image = inkAPI?.weaponImageViews[n].image
        }
    }
    
    
}
