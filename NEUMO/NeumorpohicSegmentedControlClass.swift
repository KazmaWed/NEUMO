import Foundation
import EMTNeumorphicView

class NeumorphicSegmentedControl: UIView {
    
    var titles:[String]?
    var buttonNeumorphicLayerFrame:[UIView] = []
    var buttons:[UIButton] = []
    var buttonNeumorphicLayer:[EMTNeumorphicView] = []
    var selectedButttonTag:Int = 0
    
    func initialize(backgroundColor:UIColor, titles inputTitles :[String]) {
        
        titles = inputTitles
        
        for n in 0...titles!.count - 1 {
            
            //ニューモーフィックレイヤー
            buttonNeumorphicLayer.append(EMTNeumorphicView())
            buttonNeumorphicLayer[n].neumorphicLayer?.elementBackgroundColor = backgroundColor.cgColor
            buttonNeumorphicLayer[n].neumorphicLayer?.elementDepth = 0
            buttonNeumorphicLayer[n].neumorphicLayer?.cornerRadius = 8
            
            //フレーム内にニューモーフィックレイヤーを加える
            buttonNeumorphicLayerFrame.append(UIView())
            buttonNeumorphicLayerFrame[n].clipsToBounds = true
            
            //セグメンテッドボタン
            let button = UIButton()
            button.tag = n
            button.setTitle(titles![n], for: .normal)
            button.titleLabel!.font = NeuFont.cegmentedControl
            button.setTitleColor(NeuColor.arrow, for: .normal)
            button.alpha = 0
            buttons.append(button)
            
            buttonNeumorphicLayerFrame[n].addSubview(buttonNeumorphicLayer[n])
            self.addSubview(buttonNeumorphicLayerFrame[n])
            self.addSubview(buttons[n])
        }
    }
    
    func size(width:CGFloat, height:CGFloat) {
        
        //コントロール全体のサイズ
        self.frame.size = CGSize(width: width, height: height)
        //
        let edgeInset = neuButtonBasicDepth * 1.2
        
        //各要素のサイズ
        let buttonWidth:CGFloat = (width - edgeInset * 2) / CGFloat(titles!.count)
        let buttonHeight = height - edgeInset * 2
        let sideButtonFrameWidth:CGFloat = buttonWidth + edgeInset
        
        //各要素のフレーム設定
        for n in 0...buttons.count - 1 {
            
            //両端のフレームは影の分の幅を確保
            if n == 0 || n == buttons.count - 1 {
                buttonNeumorphicLayerFrame[n].frame.size.width = sideButtonFrameWidth
            } else {
                buttonNeumorphicLayerFrame[n].frame.size.width = buttonWidth
            }
            buttonNeumorphicLayerFrame[n].frame.size.height = height
            
            //フレームのX
            if n != 0 {
                let frameX = buttonNeumorphicLayerFrame[n-1].frame.origin.x + buttonNeumorphicLayerFrame[n-1].frame.size.width
                buttonNeumorphicLayerFrame[n].frame.origin.x = frameX
            }
            
            //要素の座標
            let buttonX:CGFloat = buttonWidth * CGFloat(n) + edgeInset
            let buttonY:CGFloat = edgeInset
            
            //ボタン
            buttons[n].frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
            //ニューモーフィックレイヤー
            var neumorphicLayerX = -buttonWidth * CGFloat(n)
            if n == 0 { neumorphicLayerX = edgeInset }
            buttonNeumorphicLayer[n].frame = CGRect(x: neumorphicLayerX, y: buttonY,
                                                    width: width - edgeInset * 2, height: height - edgeInset * 2)
            
        }
    }
    
    @objc func invert(at:Int) {
        selectedButttonTag = at
        for n in 0...buttons.count - 1 {
            if n == at {
                buttons[n].setTitleColor(NeuColor.lightTheme, for: .normal)
                buttonNeumorphicLayer[n].neumorphicLayer?.elementBackgroundColor = NeuColor.arrow.cgColor
            } else {
                buttons[n].setTitleColor(NeuColor.arrow, for: .normal)
                buttonNeumorphicLayer[n].neumorphicLayer?.elementBackgroundColor = NeuColor.lightTheme.cgColor
            }
        }
    }
    
    func appear(duration:Double) {
        for n in 0...titles!.count - 1 {
            buttonNeumorphicLayer[n].neumorphicLayer?.elementDepth = neuButtonBasicDepth * 0.8
            
            self.buttons[n].alpha = 1
            self.buttonNeumorphicLayerFrame[n].alpha = 1
        }
    }
    
    func disappear(duration:Double) {
        for n in 0...titles!.count - 1 {
            buttonNeumorphicLayer[n].neumorphicLayer?.elementDepth = 0
            
            self.buttons[n].alpha = 0
            self.buttonNeumorphicLayerFrame[n].alpha = 0
        }
    }
    
}
