import UIKit
import EMTNeumorphicView

class ItemDetailView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景色適用
        view.backgroundColor = NeuColor.lightTheme
        
        title = itemInfo!["Name"]
        print(itemInfo)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //アニメ有効化
        UIView.setAnimationsEnabled(true)
        
        let duration = changeDepthDuration
        itemImabeViewAppear(duration: duration)
        neumorphicLayerAppear(duration: duration)
        
        
    }
    
    
    //--------------------IBアウトレットなど--------------------
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    let neumorphicView = EMTNeumorphicView()
    let innerView = UIView()
    
    var itemImage:UIImage?
    var itemInfo:[String:String]?
    
    
    //--------------------メソッド--------------------

    
    func itemImabeViewAppear(duration:Double) {
        
        let imageSize:CGFloat = 144
        let imageX:CGFloat = (view.frame.size.width - imageSize) / 2
        let imageY:CGFloat = 0
        itemImageView.frame.size = CGSize(width: imageSize, height: imageSize)
        itemImageView.frame.origin = CGPoint(x: imageX, y: imageY)
        itemImageView.image = itemImage!
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.itemImageView.alpha = 1
        })
        
    }
    
    func neumorphicLayerAppear(duration:Double) {
        
        let sideInset:CGFloat = 32
        neumorphicView.neumorphicLayer?.elementBackgroundColor = NeuColor.lightTheme.cgColor
        neumorphicView.neumorphicLayer?.cornerRadius = 20
        neumorphicView.neumorphicLayer?.elementDepth =  0
        neumorphicView.frame.size.width = view.frame.size.width - sideInset * 2
        neumorphicView.frame.origin.x = sideInset
        neumorphicView.frame.origin.y = itemImageView.frame.origin.y + itemImageView.frame.size.height + sideInset / 2
        neumorphicView.alpha = 1
        neumorphicView.isHidden = false
        print(neumorphicView.frame)
        
        innerView.frame.size.width = neumorphicView.frame.size.width - sideInset * 2
        innerView.frame.origin = CGPoint(x: sideInset, y: sideInset)
        innerView.alpha = 0
        
        neumorphicView.addSubview(innerView)
        scrollView.addSubview(neumorphicView)
        
        var labelY:CGFloat = 0
        let eachInfoInset:CGFloat = 20
        let bodyValueInset:CGFloat = 8
        for eachInfo in itemInfo! {
            
            let keyLabel = UILabel()
            keyLabel.text = eachInfo.key
            keyLabel.sizeToFit()
            keyLabel.frame.origin.y = labelY
            labelY += keyLabel.frame.size.height + bodyValueInset
            
            let valueLabel = UILabel()
            valueLabel.text = eachInfo.value
            valueLabel.sizeToFit()
            valueLabel.frame.origin.y = labelY
            labelY += valueLabel.frame.size.height + eachInfoInset
            
            innerView.addSubview(keyLabel)
            innerView.addSubview(valueLabel)
            
        }
        
        innerView.frame.size.height = labelY - eachInfoInset + sideInset
        neumorphicView.frame.size.height = innerView.frame.size.height + sideInset
        scrollView.contentSize.height = sideInset
        
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut, animations: {
            self.neumorphicView.neumorphicLayer?.elementDepth =  neuButtonBasicDepth
            self.innerView.alpha = 1
        })
        
    }
    
}
