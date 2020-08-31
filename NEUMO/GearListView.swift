//
//  GearListView.swift
//  NEUMO
//
//  Created by KazMacBook Pro on 2020/08/28.
//  Copyright © 2020 KAZMA WED. All rights reserved.
//

import UIKit

class GearListView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //背景色適用
        view.backgroundColor = NeuColor.lightTheme
        
        title = listTitle
        
        //戻るボタン
        self.navigationItem.leftItemsSupplementBackButton = false
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor.black
        backButton.target = self
        navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.setAnimationsEnabled(true)
        
        if fromTop {
            
            //通信終了を確認してギアカテゴリー分け
            globalDispatchGroup.notify(queue: .main) {
                
                //セルを生成して
                self.makeTables(groupBy: self.titles.first!)
                //画像を設定
                self.setWeaponImages()
                
                let duration = changeDepthDuration
                //アニメーションでセル表示
                for eachCell in self.neuTableCells {
                    eachCell.appear(duration: duration)
                }
                
                //アニメーションでラベル
                for eachLabel in self.neuTableGroupLabels {
                    UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                        eachLabel.alpha = 1
                    })
                }
                
                //セグメンテッドコントロール表示
                self.makeSegmentedControl()
                self.segmentedControl.invert(at: 0)
                
                self.fromTop = false
                
            }
            
        } else {
        
            let duration = changeDepthDuration
            for eachcCell in neuTableCells {
                eachcCell.appear(duration: duration)
            }
            tableLabelsAppear(duration: duration)
            segmentedControl.appear(duration: duration)
            
        }
    }
    
    
    //-------------------IBアウトレットなど-------------------
    
    
    @IBOutlet weak var viewForSegmentedControl: UIView!
    @IBOutlet weak var gearScrollView: UIScrollView!
    
    
    //トップから来たかどうか
    var fromTop = true
    
    //親ビューから受け取る値
    var inkAPI:InkAPI?
    var listTitle:String?
    
    var gears:[Gear] = []
    
    //テーブルビュー用
    var neuTableCells:[NeumorphicCellButton] = []
    var neuTableGroupLabels:[UIView] = []
    var segmentedControl = NeumorphicSegmentedControl()
    
    //小ビューに渡す値
    var itemSelected:Gear?
    var itemImage:UIImage?
    
    
    //-------------------メソッド-------------------
    
    
    //セグメントコントロール生成
    let titles = ["Brand", "Ability"]
    func makeSegmentedControl() {
        
        //ビューに追加
        viewForSegmentedControl.addSubview(segmentedControl)
        
        segmentedControl.initialize(backgroundColor: view.backgroundColor!, titles: titles)
        
        let segmentedControlWidth:CGFloat = 300
        let segmentedControlHeight:CGFloat = viewForSegmentedControl.frame.size.height - neuButtonBasicDepth * 2
        segmentedControl.size(width: segmentedControlWidth, height: segmentedControlHeight)
        
        let segmentedControlX:CGFloat = (viewForSegmentedControl.frame.size.width - segmentedControlWidth) / 2
        let segmentedControlY:CGFloat = (viewForSegmentedControl.frame.size.height - segmentedControlHeight) / 2
        segmentedControl.frame.origin = CGPoint(x: segmentedControlX, y: segmentedControlY)
        
        for eachButton in segmentedControl.buttons {
            eachButton.addTarget(self, action: #selector(segmentChanged), for: .touchUpInside)
        }
        
        segmentedControl.appear(duration: 0.1)
        
    }
    //セグメントコントロール選択
    @objc func segmentChanged(sender: UIButton) {
        
        let tag = sender.tag
        
        self.segmentedControl.invert(at: tag)
        
        self.removeCells()
        
        //通信終了を確認してギアカテゴリー分け
        globalDispatchGroup.notify(queue: .main) {
            
            //スクロールを最上部へ
            self.gearScrollView.contentOffset.y = 0

            //画像取得
            self.inkAPI?.getGearImages(gearType: self.listTitle!, groupBy: self.titles[tag])
            
            //セルを生成して
            self.makeTables(groupBy: self.titles[tag])
            //画像を設定
            self.setWeaponImages()

            //アニメーションでラベル
            for eachLabel in self.neuTableGroupLabels {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    eachLabel.alpha = 1
                })
            }

            //アニメーションでセル表示
            for eachCell in self.neuTableCells {
                eachCell.appear(duration: 0.1)
            }

        }
        
        
    }
    
    //テーブルビュー生成
    func makeTables(groupBy:String) {
        
        neuTableCells = []
        
        //ギアの名前リスト取得
        var typeGearsGrouped:[[Gear]]
        
        if groupBy == "Brand" {
            typeGearsGrouped = inkAPI!.typeGearsBrandGrouped
        } else {
            typeGearsGrouped = inkAPI!.typeGearsAbilityGrouped
        }
        
        let gearNames = inkAPI!.groupedGearList(groupedGears: typeGearsGrouped)!
        
        guard gearNames.count != 0 else { return }
        
        //セルのframe関係
        let neuTableCellWidth:CGFloat = safeAreaWidth! - (neuButtonGap + neuButtonInset) * 2
        let cellX:CGFloat = (safeAreaWidth! - neuTableCellWidth) / 2
        var cellY:CGFloat = neuButtonInset
        
        //グループ名ラベル関係
        let groupLabelHeight:CGFloat = 32
        let insetOnGroupLabel:CGFloat = 8
        
        //ボタン番号
        var tag = 0
        
        for n in 0...typeGearsGrouped .count - 1 {
            
            //ブキグループ
            let gearGroup = typeGearsGrouped[n]
            
            //グループ名ラベル
            let groupLabel = UILabel()
            
            if groupBy == "Brand" {
                groupLabel.text = gearGroup.first!.brand.name["en_US"]
            } else if gearGroup.first!.primary_ability?.name["en_US"] != nil {
                groupLabel.text = gearGroup.first!.primary_ability?.name["en_US"]
            } else {
                groupLabel.text = "Unspecified"
            }
            
            groupLabel.font = NeuFont.groupLabel
            groupLabel.textColor = NeuColor.lightLetter
            groupLabel.sizeToFit()
            groupLabel.frame.size.height = groupLabelHeight
            groupLabel.frame.origin = CGPoint(x: cellX + neuButtonBasicDepth, y: cellY)
            groupLabel.alpha = 0
            neuTableGroupLabels.append(groupLabel)
            
            cellY += groupLabelHeight + insetOnGroupLabel
            
            //グループ内のアイテムセル
            for m in 0...gearGroup.count - 1 {
                
                //新規セル
                let neuCell = NeumorphicCellButton()
                neuCell.initialize(backGroundColor: view.backgroundColor!,
                                   text: gearNames[n][m])
                
                //ボタンの影設定
                if gearGroup.count == 1 {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .all
                } else if m == 0 {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .topRow
                } else if m == gearGroup.count - 1 {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .bottomRow
                } else {
                    neuCell.visibleButton.neumorphicLayer?.cornerType = .middleRow
                }
                
                //ボタン外観設定
                neuCell.size(width: neuTableCellWidth, height: neuTableCellHeight)
                neuCell.frame.origin = CGPoint(x: cellX, y: cellY)
                
                //ラベルの横幅確認
                neuCell.labelWidthFix()
                
                //ボタンアクション
                neuCell.visibleButton.tag = tag
                neuCell.visibleButton.addTarget(self, action: #selector(tapCell(sender:)), for: .touchUpInside)
                
                //セルを配列に格納
                neuTableCells.append(neuCell)
                
                //次のセルのY
                cellY += neuTableCellHeight
                
                //ボタンタグ
                tag += 1
            }
            //次のグループのY
            cellY += neuButtonGap - insetOnGroupLabel
        }
        
        //ラベルをビューに追加
        for eachLabel in neuTableGroupLabels {
            gearScrollView.addSubview(eachLabel)
        }
        
        //セルをビューに追加
        for eachCell in neuTableCells {
            gearScrollView.addSubview(eachCell)
        }
        
        //スクロールコンテンツサイズ
        gearScrollView.contentSize = CGSize(width: gearScrollView.frame.size.width, height: cellY)
        
    }
    //画像イメージ表示
    func setWeaponImages() {
        
        guard inkAPI?.gearImageViews.count != 0 else { return }
        
        for n in 0...neuTableCells.count - 1 {
            //取得した画像ビュー
            neuTableCells[n].cellIconImage.image = inkAPI?.gearImageViews[n].image
        }
    }
    
    //テーブルのグループラベル表示・非表示
    func tableLabelsAppear(duration:Double = 0.1) {
        for eachLabel in neuTableGroupLabels {
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                eachLabel.alpha = 1
            })
        }
    }
    func tableLabelsDisappear(duration:Double = 0.1) {
        for eachLabel in neuTableGroupLabels {
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
                eachLabel.alpha = 0
            })
        }
    }
    
    //セル全削除
    func removeCells(completion: @escaping () -> Void) {
        
        globalDispatchGroup.enter()
        
        let dissappearDuration = 0.1
        
        for eachCell in neuTableCells {
            eachCell.disappear(duration: dissappearDuration)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dissappearDuration) {
            completion()
            globalDispatchGroup.leave()
        }
        
    }
    
    func removeCells() {
        
        globalDispatchGroup.enter()
        
        removeCells(completion: {() -> Void in
            for eachCell in self.neuTableCells {
                eachCell.removeFromSuperview()
            }
            for eachLabel in self.neuTableGroupLabels {
                eachLabel.removeFromSuperview()
            }
            self.neuTableCells = []
            self.neuTableGroupLabels = []
        })
        
        globalDispatchGroup.leave()
        
    }
    
    @objc func tapCell(sender:UIButton) {
        var cellNum = sender.tag
        
        //ギアの名前リスト取得
        var typeGearsGrouped:[[Gear]]
        
        if segmentedControl.selectedButttonTag == 0 {
            typeGearsGrouped = inkAPI!.typeGearsBrandGrouped
        } else {
            typeGearsGrouped = inkAPI!.typeGearsAbilityGrouped
        }
        
        //タップされたセルのアイテム画像取得
        itemImage = inkAPI?.gearImageViews[cellNum].image
        
        //タップされたセルのアイテム取得
        var ifFound = false
        for n in 0...typeGearsGrouped.count - 1 {
            for m in 0...typeGearsGrouped[n].count - 1 {
                if cellNum == 0 {
                    itemSelected = typeGearsGrouped[n][m]
                    ifFound = true
                    break
                } else {
                    cellNum -= 1
                }
            }
            if ifFound { break }
        }
        
        let disappearDuration = changeDepthDuration * 1.5
        //セルの非表示
        for n in 0...neuTableCells.count - 1 {
            if n == sender.tag {
                UIView.animate(withDuration: changeDepthDuration, delay: disappearDuration, options: .curveEaseInOut, animations: {
                    self.neuTableCells[n].cellLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
                    self.neuTableCells[n].alpha = 0
                }, completion: { finished in
                    self.neuTableCells[n].cellLabel.transform = CGAffineTransform(scaleX: 1, y: 1);
                })
                neuTableCells[n].disappear(duration: disappearDuration, labelRemain: true)
            } else {
                neuTableCells[n].disappear(duration: disappearDuration)
            }
        }
        //ラベルの非表示
        tableLabelsDisappear(duration: changeDepthDuration)
        segmentedControl.disappear(duration: changeDepthDuration)
        
        
        //画面遷移
        DispatchQueue.main.asyncAfter(deadline: .now() + changeDepthDuration + disappearDuration) {
            self.moveView()
        }
        
        
    }
    
    
    //--------------------
    
    
    //遷移
    func moveView() {
        
        //タッチ一時無効化
        view.isUserInteractionEnabled = false
        
        //遅延で画面遷移
        let duration = 0.1
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            //一時アニメ無効
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "showDetail", sender: nil)
            //タッチ一時有効化
            self.view.isUserInteractionEnabled = true
//        }
        
    }
    
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let next = segue.destination as? ItemDetailView
            next?.itemImage = itemImage
            next?.itemInfo = itemSelected?.infoInStringDictionary()
        }
        
    }
    
}
