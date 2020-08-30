import Foundation
import EMTNeumorphicView

class NeumorphicCellButton: UIButton {
    
    let visibleButton = EMTNeumorphicButton()
    let cellLabel = UILabel()
    let cellIconImage = UIImageView()
    let arrow = UILabel()
    
    let neuTableCellHeight:CGFloat = 52
    let neuTableCellInset:CGFloat = 8
    let neuButtonBasicDepth:CGFloat = 8
    
    func initialize(backGroundColor:UIColor, text:String) {
        self.addSubview(visibleButton)
        self.addSubview(cellLabel)
        self.addSubview(cellIconImage)
        self.addSubview(arrow)
        
        //ボタン外観の設定
        visibleButton.neumorphicLayer?.elementBackgroundColor = backGroundColor.cgColor
        visibleButton.neumorphicLayer?.cornerRadius = 12
        visibleButton.neumorphicLayer?.elementDepth = 0
        visibleButton.neumorphicLayer?.lightShadowOpacity = 1
        visibleButton.neumorphicLayer?.darkShadowOpacity = 0.3
        visibleButton.neumorphicLayer?.edged = false
        
        //ラベル
        cellLabel.alpha = 0
        cellLabel.font = NeuFont.lightCell
        cellLabel.textColor = NeuColor.lightLetter
        cellLabel.text = text
        cellLabel.sizeToFit()
        
        //右端矢印
        arrow.alpha = 0
        arrow.textAlignment = .center
        arrow.font = NeuFont.arrow
        arrow.textColor = NeuColor.arrow
        arrow.text = ">"
    }
    
    func size(width:CGFloat, height:CGFloat) {
        
        //ボタン本体・外観サイズ
        self.frame.size = CGSize(width: width, height: height)
        visibleButton.frame.size = CGSize(width: width, height: height)
        
        //矢印サイズ
        arrow.frame.size.width = neuTableCellHeight * 0.8
        arrow.frame.size.height = neuTableCellHeight
        arrow.frame.origin.x = width - arrow.frame.size.width
        
        //画像サイズ
        let iconImageSize = height - neuTableCellInset
        let iconImageY = (height - iconImageSize) / 2
        cellIconImage.frame.size = CGSize(width: iconImageSize, height: iconImageSize)
        cellIconImage.frame.origin = CGPoint(x: neuTableCellInset, y: iconImageY)
        
        //ラベルサイズ
        let cellLabelX = height + neuTableCellInset
        let cellLabelHeight = cellLabel.frame.size.height
        cellLabel.frame.size.height = cellLabelHeight
        cellLabel.frame.origin = CGPoint(x: cellLabelX, y: (height - cellLabelHeight) / 2)
        
    }
    
    func labelWidthFix() {
        
        let maxWidth = self.frame.size.width - cellLabel.frame.origin.x - arrow.frame.size.width
        let widthRatio = maxWidth / cellLabel.frame.size.width
        
        if widthRatio < 1 {
            let labelX = cellLabel.frame.origin.x
            cellLabel.transform = CGAffineTransform(scaleX: widthRatio, y: 1)
            cellLabel.frame.origin.x = labelX
        }
        
    }
    
    func appear(duration:Double = 0.1) {
        
        visibleButton.neumorphicLayer?.elementDepth = neuButtonBasicDepth
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.cellLabel.alpha = 1
            self.arrow.alpha = 1
            self.cellIconImage.alpha = 1
        })
        
    }
    
    func disappear(duration:Double = 0.1) {
        
        visibleButton.neumorphicLayer?.elementDepth = 0
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0
            self.cellLabel.alpha = 0
            self.arrow.alpha = 0
            self.cellIconImage.alpha = 0
        })
        
    }
    
}
