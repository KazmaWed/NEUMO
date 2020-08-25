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
        
        //通信終了を確認して武器カテゴリー分け
        globalDispatchGroup.notify(queue: .main) {
            
            //セルを生成して
            self.makeWeaponTables()
            //画像を設定
            self.setWeaponImages()
            
            for eachCell in self.neuTableCells {
                eachCell.neumorphicLayer?.elementDepth = neuButtonBasicDepth
            }
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                for n in 0...self.neuTableCells.count - 1 {
                    self.neuTableCellLabels[n].alpha = 1
                    self.neuTableCellImages[n].alpha = 1
                    self.neuTableCellArrows[n].alpha = 1
                }
            })
        }
        
    }
    
    
    //-------------------IBアウトレットなど-------------------
    
    
    @IBOutlet weak var weaponScrollview: UIScrollView!
    
    
    //親ビューから受け取る値
    var weaponCategory:String = ""
    var inkAPI:InkAPI?
    
    var weapons:[Weapon] = []
    var weaponsInType:[String:[Weapon]] = [:]
    
    //テーブルビュー用
    var neuTableCells:[EMTNeumorphicButton] = []
    var neuTableCellLabels:[UILabel] = []
    var neuTableCellArrows:[UILabel] = []
    var neuTableCellImages:[UIImageView] = []
    
    //-------------------メソッド--------------------
    
    
    func makeWeaponTables() {
        
        //セルと作るブキ配列
        let typeWeaponsGrouped = inkAPI!.typeWeaponsGrouped
        
        guard typeWeaponsGrouped.count != 0 else { return }
        
        //セルのframe関係
        let neuTableCellWidth:CGFloat = safeAreaWidth! - (neuButtonGap + neuButtonInset) * 2
        let cellX:CGFloat = (safeAreaWidth! - neuTableCellWidth) / 2
        var cellY:CGFloat = neuButtonInset
        
        for n in 0...typeWeaponsGrouped.count - 1 {
            
            //ブキグループ
            let weaponGroup = typeWeaponsGrouped[n]
            
            for m in 0...weaponGroup.count - 1 {
                
                let neuCell = EMTNeumorphicButton()
                //ボタンの影設定
                if weaponGroup.count == 1 {
                    neuCell.neumorphicLayer?.cornerType = .all
                } else if m == 0 {
                    neuCell.neumorphicLayer?.cornerType = .topRow
                } else if m == weaponGroup.count - 1 {
                    neuCell.neumorphicLayer?.cornerType = .bottomRow
                } else {
                    neuCell.neumorphicLayer?.cornerType = .middleRow
                }
                //ボタン外観設定
                neuCell.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
                neuCell.neumorphicLayer?.cornerRadius = 12
                neuCell.neumorphicLayer?.elementDepth = 0
                neuCell.neumorphicLayer?.lightShadowOpacity = 1
                neuCell.neumorphicLayer?.darkShadowOpacity = 0.3
                neuCell.neumorphicLayer?.edged = false
                neuCell.frame.size = CGSize(width: neuTableCellWidth, height: neuTableCellHeight)
                neuCell.frame.origin = CGPoint(x: cellX, y: cellY)
                
                //セル右端の矢印
                let neuTableCellArrow = UILabel()
                neuTableCellArrow.alpha = 0
                neuTableCellArrow.textAlignment = .center
                neuTableCellArrow.font = NeuFont.arrow
                neuTableCellArrow.textColor = NeuColor.arrow
                neuTableCellArrow.text = ">"
                neuTableCellArrow.frame.size.width = neuTableCellHeight * 0.8
                neuTableCellArrow.frame.size.height = neuTableCellHeight
                neuTableCellArrow.frame.origin.x = neuTableCellWidth - neuTableCellArrow.frame.size.width
                neuTableCellArrows.append(neuTableCellArrow)
                neuCell.addSubview(neuTableCellArrows.last!)
                
                //ラベル表示領域幅
                let neuTableCellLabelX = neuTableCellHeight + neuTableCellInset * 2
                let neuTableCellLabelWidth = neuTableCellWidth - neuTableCellLabelX - neuTableCellArrow.frame.size.width
                
                //セル内ラベル
                let neuTableCellLabel = UILabel()
                neuTableCellLabel.alpha = 0
                neuTableCellLabel.font = NeuFont.lightCell
                neuTableCellLabel.textColor = NeuColor.lightLetter
                neuTableCellLabel.text = typeWeaponsGrouped[n][m].name["en_US"]
                neuTableCellLabel.sizeToFit()
                neuTableCellLabel.frame.origin = CGPoint(x: neuTableCellLabelX,
                                                         y: (neuTableCellHeight - neuTableCellLabel.frame.size.height) / 2)
                
                //ラベルの横幅確認
                let labelWidthRatio:CGFloat = neuTableCellLabelWidth / neuTableCellLabel.frame.size.width
                if labelWidthRatio < 1.0 {
                    let newLabelX = neuTableCellLabel.frame.origin.x
                    neuTableCellLabel.transform = CGAffineTransform(scaleX: labelWidthRatio, y: 1)
                    neuTableCellLabel.frame.origin.x = newLabelX
                }
                
                neuTableCellLabels.append(neuTableCellLabel)
                neuCell.addSubview(neuTableCellLabels.last!)
                
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
            weaponScrollview.addSubview(eachCell)
        }
        
        //スクロールコンテンツサイズ
        weaponScrollview.contentSize = CGSize(width: weaponScrollview.frame.size.width, height: cellY)
        
    }
    
    func setWeaponImages() {
        
        guard inkAPI?.weaponImageViews.count != 0 else { return }
        
        for n in 0...neuTableCells.count - 1 {
            //取得した画像ビュー
            let neuImageView = inkAPI?.weaponImageViews[n]
            neuImageView!.alpha = 0
            
            //frame設定
            let imageSize:CGFloat = neuTableCellHeight - neuTableCellInset * 2
            neuImageView!.frame.size = CGSize(width: imageSize, height: imageSize)
            neuImageView!.frame.origin = CGPoint(x: neuTableCellInset * 2, y: neuTableCellInset)
            
            //配列に格納・セルに表示
            neuTableCellImages.append(neuImageView!)
            neuTableCells[n].addSubview(neuTableCellImages[n])
        }
    }
    
    
}
