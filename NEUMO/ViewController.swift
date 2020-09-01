import UIKit
import EMTNeumorphicView
import Instructions

class ViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //デリゲート
        navigationController?.delegate = self
        coachMarksController.dataSource = self
       
        //ナビゲーションバー枠線消し
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.barTintColor = NeuColor.lightTheme
        //背景色適用
        view.backgroundColor = NeuColor.lightTheme
        
        //ボタン配列
        neuButtons = [firstButton, secondButton, thirdButton, fourthButton]
        
        //ボタン内メインテキスト配列
        for neuButton in neuButtons {
            neuButton.isHidden = true
        }
        
        //タイトル
        title = "INK APP"
        
        //戻るボタン
        self.navigationItem.leftItemsSupplementBackButton = false
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = UIColor.black
        backButton.target = self
        navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if opening {
            //起動時
            self.safeAreaSizeDefine()
            self.buttonSetting()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.buttonAppear()
                self.makePopLabel()
                self.coachMarksController.start(in: .window(over: self))
            }
            
            opening = false
        } else {
            //画面遷移で戻ってきたとき
            //アニメ有効化
            UIView.setAnimationsEnabled(true)
            //ラベル表示
            for n in 0...3 {
                neuButtons[n].neumorphicLayer?.elementDepth = neuButtonBasicDepth
                UIView.animate(withDuration: changeDepthDuration, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.neuButtonLabels[n].alpha = 1
                })
            }
            for eachButton in neuButtonSubButtons {
                UIView.animate(withDuration: changeDepthDuration, delay: 0.0, options: .curveEaseInOut, animations: {
                    eachButton.alpha = 1
                })
            }
        }
        
        
    }
    
    
    //--------------------IBアウトレット・その他主なインスタンス--------------------
    
    
    @IBAction func firstButtonAction(_ sender: Any) { buttonTaped(tag: 0) }
    @IBAction func secondButtonAction(_ sender: Any) { buttonTaped(tag: 1) }
    @IBAction func thirdButtonAction(_ sender: Any) { buttonTaped(tag: 2) }
    @IBAction func fourthButtonAction(_ sender: Any) { buttonTaped(tag: 3) }
    
    @IBOutlet weak var firstButton: EMTNeumorphicButton!
    @IBOutlet weak var secondButton: EMTNeumorphicButton!
    @IBOutlet weak var thirdButton: EMTNeumorphicButton!
    @IBOutlet weak var fourthButton: EMTNeumorphicButton!
    
    var neuButtons:[EMTNeumorphicButton] = []
    var selectedButton:Int?
    var selectedSubButton:Int?
    
    let neuButtonLabels = [UILabel(), UILabel(), UILabel(), UILabel()]
    var neuButtonSubButtons:[UIButton] = []
    
    //API
    var inkAPI = InkAPI()
    //起動時の確認用
    var opening = true
    
    
    //--------------------ビューサイズなど--------------------
    
    
    var neuButtonHeight:CGFloat?
    var neuButtonWidth:CGFloat?
    
    
    //--------------------ポップラベル--------------------
    

    let coachMarksController = CoachMarksController()
    var pointOfInterests:[UIView] = []
    let coachMessages = ["スプラトゥーン２に登場するブキの情報が閲覧できます",
                         "スプラトゥーン２に登場するギアの情報が閲覧できます",
                         "お気に入りのギアセットを登録できます\n（未実装）",
                         "設定変更はこちらから\n（未実装）"]
    
    
    //--------------------ボタン--------------------
    
    
    //画面サイズなど取得
    func safeAreaSizeDefine() {
        
        safeAreaTopInset = self.view.safeAreaInsets.top
        safeAreaBottomInset = self.view.safeAreaInsets.bottom
        safeAreaSideInset = self.view.safeAreaInsets.left
        safeAreaHeight = view.frame.height - safeAreaTopInset! - safeAreaBottomInset!
        safeAreaWidth = view.frame.width - safeAreaSideInset! * 2
        
    }
    //メインボタン設定
    func buttonSetting() {
        
        //ボタンサイズ
        neuButtonHeight = (safeAreaHeight! - neuButtonGap * 5 - neuButtonInset * 2) / 4
        neuButtonWidth = safeAreaWidth! - (neuButtonGap + neuButtonInset) * 2
        //ボタンラベル
        let buttonTexts = ["Weapon", "Gear", "Closet", "Setting"]
        
        for n in 0...3 {
            
            //ボタン外観設定
            neuButtons[n].neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
            neuButtons[n].neumorphicLayer?.cornerRadius = 20
            neuButtons[n].neumorphicLayer?.elementDepth = 0
            neuButtons[n].neumorphicLayer?.lightShadowOpacity = 0
            neuButtons[n].neumorphicLayer?.darkShadowOpacity = 0
            neuButtons[n].neumorphicLayer?.edged = false
            neuButtons[n].setTitle("", for: .normal)
            
            //ラベル設定
            neuButtonLabels[n].font = NeuFont.lightTheme
            neuButtonLabels[n].textColor = NeuColor.lightLetter
            neuButtonLabels[n].text = buttonTexts[n]
            neuButtonLabels[n].sizeToFit()
            neuButtonLabels[n].frame.size.height *= 1.1
            
            let labelX = (neuButtonWidth! - neuButtonLabels[n].frame.size.width) / 2
            let labelY = (neuButtonHeight! - neuButtonLabels[n].frame.size.height) / 2
            neuButtonLabels[n].frame.origin = CGPoint(x: labelX, y: labelY)
            
            neuButtons[n].addSubview(neuButtonLabels[n])
            
            //フレーム
            let buttonX = (safeAreaWidth! - neuButtonWidth!) / 2
            let buttonY = safeAreaTopInset! + neuButtonInset + (neuButtonGap + neuButtonHeight!) * CGFloat(n)
            neuButtons[n].frame = CGRect(x: buttonX, y: buttonY, width: neuButtonWidth!, height: neuButtonHeight!)
            
        }
        
    }
    //メインボタン表示
    func buttonAppear() {
        
        for n in 0...3 {
            
            //ボタンの影や深さを適用
            neuButtons[n].neumorphicLayer?.elementDepth = neuButtonBasicDepth
            neuButtons[n].neumorphicLayer?.lightShadowOpacity = 1
            neuButtons[n].neumorphicLayer?.darkShadowOpacity = 0.3
            neuButtons[n].neumorphicLayer?.edged = false
            neuButtons[n].isHidden = false
            
        }
        
    }
    
    //メインボタンアクション
    func buttonTaped(tag: Int, withNoDuration: Bool = false) {
        
        //選択ボタン番号処理
        if selectedButton == nil { //ボタンが未選択時
            selectedButton = tag
            setSubButtons(tag: selectedButton!)
        } else {
            removeSubButtons()
            if selectedButton == tag { //選択中ボタン押下
                selectedButton = nil
            } else {
                selectedButton = tag //選択中のボタンと別のボタンを押した時
                setSubButtons(tag: selectedButton!)
            }
        }
        
        if selectedButton != nil {
            
            //初期化
            inkAPI = InkAPI()
            
            let mainLabelHaight = neuButtonLabels[selectedButton!].frame.size.height
            let subLabelsHeight = neuButtonSubButtons.last!.frame.origin.y + neuButtonSubButtons.last!.frame.size.height
            let labelInset:CGFloat = 18
            let innerMargin:CGFloat = 6
            
            //各ボタンの高さ
            var heightTo:CGFloat = mainLabelHaight + subLabelsHeight + innerMargin + labelInset * 2
            if heightTo < neuButtonHeight! { heightTo = neuButtonHeight! }
            let otherButtonsHeight = (safeAreaHeight! - heightTo - neuButtonGap * 5 - neuButtonInset * 2) / 3
            let topTo = labelInset + mainLabelHaight + innerMargin
            
            for n in 0...3 {
                
                //ボタンの移動先
                var yTo = neuButtons[0].frame.origin.y
                if n != 0 {
                    let buttonAbove = neuButtons[n-1]
                    yTo = buttonAbove.frame.origin.y + buttonAbove.frame.size.height + neuButtonGap
                }
                
                //選択ボタン拡大・他ボタン縮小
                if n == selectedButton {
                    setSubButtons(topTo: topTo, tag: selectedButton!)
                    stretchNeumoButton(yTo: yTo, heightTo: heightTo, labelY: labelInset, buttonTag: n)
                } else {
                    stretchNeumoButton(yTo: yTo, heightTo: otherButtonsHeight, buttonTag: n)
                }
            }
         
            if selectedButton == 0 {
                
                //API通信・ブキ取得
                globalDispatchGroup.enter()
                inkAPI.getWeapons(closure: { () -> Void in
                    globalDispatchGroup.leave()
                })
                
            } else if selectedButton == 1 {
                
                //API通信・ギア取得
                globalDispatchGroup.enter()
                inkAPI.getGears(closure: { () -> Void in
                    globalDispatchGroup.leave()
                })
                
            } else {
                
                return
                
            }
            
        } else {
            
            for n in 0...3 {
                //すべてのボタンをデフォルト
                var yTo = neuButtons[0].frame.origin.y
                if n != 0 {
                    let buttonAbove = neuButtons[n-1]
                    yTo = buttonAbove.frame.origin.y + buttonAbove.frame.size.height + neuButtonGap
                }
                stretchNeumoButton(yTo: yTo, heightTo: neuButtonHeight!, buttonTag: n)
            }
        }
        
    }
    
    //ボタン内・小ボタンを格納
    func setSubButtons(tag:Int) {
        
        neuButtonSubButtons = []
        
        for n in 0...subItems.name[tag].count - 1 {
            let subButton = UIButton()
            subButton.tag = n
            subButton.addTarget(self, action: #selector(ViewController.moveView), for: .touchUpInside)
            subButton.titleLabel?.font = NeuFont.lightSub
            subButton.setTitleColor(NeuColor.lightLetter, for: .normal)
            subButton.setTitle(subItems.name[tag][n], for: .normal)
            subButton.sizeToFit()
            subButton.frame.size.height *= 0.8
            if n != 0 {
                subButton.frame.origin.y = neuButtonSubButtons[n-1].frame.origin.y + neuButtonSubButtons[n-1].frame.size.height
            }
            neuButtonSubButtons.append(subButton)
        }
        
    }
    //小ボタンの座標決定
    func setSubButtons(topTo:CGFloat, tag: Int) {
        var largestWidth:CGFloat = 0
        
        for eachButton in neuButtonSubButtons {
            if largestWidth < eachButton.frame.size.width { largestWidth = eachButton.frame.size.width }
        }
        let labelX = (neuButtonWidth! - largestWidth) / 2
        
        for eachButton in neuButtonSubButtons {
            eachButton.frame.origin.y += topTo
            eachButton.frame.origin.x = labelX
        }
        for eachButton in neuButtonSubButtons {
            neuButtons[tag].addSubview(eachButton)
        }
    }
    //小ボタン削除
    func removeSubButtons() {
        for eachButton in neuButtonSubButtons {
            eachButton.removeFromSuperview()
        }
    }
    
    //ニューモーフィックボタンの伸縮
    func stretchNeumoButton(yTo: CGFloat, heightTo:CGFloat, labelY:CGFloat? = nil, buttonTag:Int, noDuration: Bool = false) {
        
        //元ボタンの情報取得
        let heightFrom = neuButtons[buttonTag].frame.size.height
        let buttonWidth = neuButtons[buttonTag].frame.size.width
        let cornerRadius = neuButtons[buttonTag].neumorphicLayer?.cornerRadius
        let buttonOrigin = neuButtons[buttonTag].frame.origin
        let backGroundColor = neuButtons[buttonTag].neumorphicLayer?.elementBackgroundColor
        let buttonDepth = neuButtons[buttonTag].neumorphicLayer?.elementDepth
        let darkShadowOpacity = neuButtons[buttonTag].neumorphicLayer?.darkShadowOpacity
        let lightShadowOpacity = neuButtons[buttonTag].neumorphicLayer?.lightShadowOpacity
        
        //アニメ用素材ビュー
        let buttonTopPart = EMTNeumorphicView()
        let buttonMiddlePart = EMTNeumorphicView()
        let middlePartClipingView = UIView()
        let buttonBottomPart = EMTNeumorphicView()
        let neuLabel = UILabel()
        
        let partsInset:CGFloat = 12
     
        //ボタン上部
        buttonTopPart.clipsToBounds = false
        buttonTopPart.frame.size.height = cornerRadius! + partsInset
        buttonTopPart.frame.size.width = buttonWidth
        buttonTopPart.frame.origin = buttonOrigin
        buttonTopPart.neumorphicLayer?.cornerType = .topRow
        buttonTopPart.neumorphicLayer?.darkShadowOpacity = darkShadowOpacity!
        buttonTopPart.neumorphicLayer?.lightShadowOpacity = lightShadowOpacity!
        buttonTopPart.neumorphicLayer?.elementBackgroundColor = backGroundColor!
        buttonTopPart.neumorphicLayer?.elementDepth = buttonDepth!
        buttonTopPart.neumorphicLayer?.cornerRadius = cornerRadius!
        
        //ボタン中部クリップ用ビュー
        middlePartClipingView.clipsToBounds = true
        middlePartClipingView.frame.origin = CGPoint(x: 0,
                                                     y: buttonTopPart.frame.origin.y + buttonTopPart.frame.size.height)
        middlePartClipingView.frame.size = CGSize(width: view.frame.size.width,
                                                  height: heightFrom - (cornerRadius! + partsInset) * 2)
        
        //ボタン中部
        buttonMiddlePart.neumorphicLayer?.cornerType = .middleRow
        buttonMiddlePart.neumorphicLayer?.darkShadowOpacity = darkShadowOpacity!
        buttonMiddlePart.neumorphicLayer?.lightShadowOpacity = lightShadowOpacity!
        buttonMiddlePart.neumorphicLayer?.elementBackgroundColor = backGroundColor!
        buttonMiddlePart.neumorphicLayer?.elementDepth = buttonDepth!
        buttonMiddlePart.frame.size.height = safeAreaHeight!
        buttonMiddlePart.frame.size.width = buttonWidth
        buttonMiddlePart.frame.origin.x = buttonTopPart.frame.origin.x
        buttonMiddlePart.frame.origin.y = -partsInset
        
        //ボタン下部
        buttonBottomPart.neumorphicLayer?.cornerType = .bottomRow
        buttonBottomPart.neumorphicLayer?.darkShadowOpacity = darkShadowOpacity!
        buttonBottomPart.neumorphicLayer?.lightShadowOpacity = lightShadowOpacity!
        buttonBottomPart.neumorphicLayer?.elementBackgroundColor = backGroundColor!
        buttonBottomPart.neumorphicLayer?.elementDepth = buttonDepth!
        buttonBottomPart.neumorphicLayer?.cornerRadius = cornerRadius!
        buttonBottomPart.frame.size.height = cornerRadius! + partsInset
        buttonBottomPart.frame.size.width = buttonWidth
        buttonBottomPart.frame.origin.x = buttonTopPart.frame.origin.x
        buttonBottomPart.frame.origin.y = middlePartClipingView.frame.origin.y + middlePartClipingView.frame.size.height
        
        //ラベル
        neuLabel.frame = neuButtonLabels[buttonTag].frame
        neuLabel.font = neuButtonLabels[buttonTag].font
        neuLabel.text = neuButtonLabels[buttonTag].text
        neuLabel.textColor = neuButtonLabels[buttonTag].textColor
        neuLabel.textAlignment = neuButtonLabels[buttonTag].textAlignment
        
        //ラベル座標
        let neuLabelX = neuButtons[buttonTag].frame.origin.x + neuLabel.frame.origin.x
        var neuLabelY:CGFloat?
        neuLabelY = neuButtons[buttonTag].frame.origin.y + neuLabel.frame.origin.y
        neuLabel.frame.origin = CGPoint(x: neuLabelX, y: neuLabelY!)
        
        //ビューに追加
        view.addSubview(middlePartClipingView)
        middlePartClipingView.addSubview(buttonMiddlePart)
        view.addSubview(buttonBottomPart)
        view.addSubview(buttonTopPart)
        view.addSubview(neuLabel)
        
        //ボタン本体を非表示・移動
        neuButtons[buttonTag].isHidden = true
        self.neuButtons[buttonTag].frame.size.height = heightTo
        self.neuButtons[buttonTag].frame.origin.y = yTo
        
        //各パーツの移動先計算
        let middleTo = yTo + buttonTopPart.frame.size.height
        let middleHeightTo = heightTo - (cornerRadius! + partsInset) * 2
        let bottomTo = middleTo + middleHeightTo
        var labelTo:CGFloat?
        //ラベルの移動先指定の有無分岐
        if labelY == nil {
            labelTo = middleTo + (middleHeightTo - neuLabel.frame.size.height) / 2
            neuButtonLabels[buttonTag].frame.origin.y = (heightTo - neuButtonLabels[buttonTag].frame.size.height) / 2
        } else {
            labelTo = yTo + labelY!
            neuButtonLabels[buttonTag].frame.origin.y = labelY!
        }
        
        //アニメ
        var duration:Double?
        if noDuration { duration = 0 } else { duration = 1/3 }
        
        //アニメ用サブボタンとサブボタン用コンテナビュー
        let subButtonContainer = UIView()
        subButtonContainer.frame.origin = buttonTopPart.frame.origin
        subButtonContainer.frame.size = CGSize(width: buttonTopPart.frame.size.width, height: heightTo)
        view.addSubview(subButtonContainer)
        
        if buttonTag == selectedButton {
            let copiedSubButtons = copySubButtons()
            let startDelay = duration! / Double(3)
            let eachDuration = (duration! - startDelay) / Double(copiedSubButtons.count)
            
            for n in 0...copiedSubButtons.count - 1 {
                copiedSubButtons[n].alpha = 0
                subButtonContainer.addSubview(copiedSubButtons[n])
                
                let delay = startDelay + eachDuration * Double(n)
                UIView.animate(withDuration: eachDuration, delay: delay, options: .curveEaseInOut, animations: {
                    copiedSubButtons[n].alpha = 1
                })
            }
        }
        
        UIView.animate(withDuration: duration!, delay: 0.0, options: .curveEaseInOut, animations: {

            //ボタンの位置
            buttonTopPart.frame.origin.y = yTo
            subButtonContainer.frame.origin.y = buttonTopPart.frame.origin.y
            //ボタンサイズ
            middlePartClipingView.frame.origin.y = middleTo
            middlePartClipingView.frame.size.height = middleHeightTo
            buttonBottomPart.frame.origin.y = bottomTo
            //ラベル
            neuLabel.frame.origin.y = labelTo!
                
        }, completion: { _ in

            //ボタン本体再表示
            self.neuButtons[buttonTag].isHidden = false
            //パーツ削除
            buttonTopPart.removeFromSuperview()
            middlePartClipingView.removeFromSuperview()
            buttonMiddlePart.removeFromSuperview()
            buttonBottomPart.removeFromSuperview()
            neuLabel.removeFromSuperview()
            subButtonContainer.removeFromSuperview()

        })
        
    }
    
    //小ボタンアニメーション用のコピーラベル作成
    func copySubButtons() -> [UILabel] {
        
        var copiedItems:[UILabel] = []
        
        for n in 0...neuButtonSubButtons.count - 1 {
            let subButtonLabel = UILabel()
            subButtonLabel.frame = neuButtonSubButtons[n].frame
            subButtonLabel.font = neuButtonSubButtons[n].titleLabel?.font
            subButtonLabel.textColor = neuButtonSubButtons[n].currentTitleColor
            subButtonLabel.text = neuButtonSubButtons[n].currentTitle
            copiedItems.append(subButtonLabel)
        }
        
        return copiedItems
        
    }
    
    
    //--------------------画面遷移--------------------
    
    
    //画面遷移
    @objc func moveView(sender: UIButton) {
        
        selectedSubButton = sender.tag
        
        if selectedButton == 0 || selectedButton == 1 {
            
            //タッチ一時無効化
            view.isUserInteractionEnabled = false
            
            //ボタン非表示
            for n in 0...3 {
                neuButtons[n].neumorphicLayer?.elementDepth = 0
                UIView.animate(withDuration: changeDepthDuration, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.neuButtonLabels[n].alpha = 0
                })
            }
            
            //ボタン内サブボタン非表示
            let addionalDelay = changeDepthDuration * 1.5
            
            //各ボタンフェイドアウト
            for n in 0...neuButtonSubButtons.count - 1 {
                
                //選択されたボタンのみ遅延
                var delay:Double = 0
                if n == sender.tag { delay = addionalDelay }
                //アニメーション
                UIView.animate(withDuration: changeDepthDuration, delay: delay, options: .curveEaseInOut, animations: {
                    if n == sender.tag {
                        self.neuButtonSubButtons[n].transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
                    }
                    self.neuButtonSubButtons[n].alpha = 0
                }, completion: { finished in
                    self.neuButtonSubButtons[n].transform = CGAffineTransform(scaleX: 1, y: 1);
                })
                
            }
            
            globalDispatchGroup.notify(queue: .main) {
                
                var segueIdentifier:String?
                
                if self.selectedButton == 0 {
                    
                    //メインごとに分けて
                    self.inkAPI.groupByMain(weaponType: subItems.name[self.selectedButton!][sender.tag])
                    //画像を非同期で取得
                    self.inkAPI.getWeaponImages()
                    //画面遷移ID
                    segueIdentifier = "showWeaponList"
                    
                } else if self.selectedButton == 1 {
                    
                    switch sender.tag {
                    case 0, 1, 2 :
                        let gearType = subItems.name[self.selectedButton!][sender.tag]
                        //ブランドごとに分けて
                        self.inkAPI.groupByBrand(gearType: gearType)
                        self.inkAPI.groupByAbility(gearType: gearType)
                        //画像を非同期で取得
                        self.inkAPI.getGearImages(gearType: gearType, groupBy: "Brand")
                        //画面遷移ID
                        segueIdentifier = "showGearList"
                        
                    default :
                        print("derault")
                    }
                    
                }

                //遅延で画面遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + changeDepthDuration + addionalDelay) {
                    //一時アニメ無効
                    UIView.setAnimationsEnabled(false)
                    self.performSegue(withIdentifier: segueIdentifier!, sender: nil)
                    //タッチ一時有効化
                    self.view.isUserInteractionEnabled = true
                }
                
            }
            
        } else {
            
            return
            
        }
        
    }
    //ナビボタン操作時・一時アニメ無効化など
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ViewController && !opening {
            UIView.setAnimationsEnabled(false)
        }
        if viewController is WeaponListView || viewController is GearListView {
            UIView.setAnimationsEnabled(false)
        }
    }
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWeaponList" {
            let next = segue.destination as? WeaponListView
            next?.weaponCategory = subItems.name[selectedButton!][selectedSubButton!]
            next?.inkAPI = self.inkAPI
        } else if segue.identifier == "showGearList" {
            let next = segue.destination as? GearListView
            next?.listTitle = subItems.name[selectedButton!][selectedSubButton!]
            next?.inkAPI = self.inkAPI
        }
        
    }
 
    
    //--------------------その他メソッド--------------------
    
    
    //起動時ポップラベル
    func makePopLabel() {
        
        for n in 0...coachMessages.count - 1 {
            pointOfInterests.append(UIView())
            pointOfInterests[n].frame = neuButtons[n].frame
        }
        
        coachMarksController.overlay.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
        
    }
    
}


//--------------------起動時ポップアップ--------------------


extension ViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return coachMessages.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        return coachMarksController.helper.makeCoachMark(for: pointOfInterests[index])
        
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
    
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        
        coachViews.bodyView.hintLabel.text = coachMessages[index]
        coachViews.bodyView.nextLabel.text = "OK"
        coachViews.bodyView.hintLabel.font = NeuFont.lightCoach
        coachViews.bodyView.nextLabel.font = NeuFont.lightCoach
        coachViews.bodyView.background.innerColor = UIColor.white
        let textColor = UIColor.gray
        coachViews.bodyView.hintLabel.textColor = textColor
        coachViews.bodyView.separator.backgroundColor = textColor
        coachViews.bodyView.nextLabel.textColor = textColor
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
}
