import UIKit
import EMTNeumorphicView

class ItemDetailView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景色適用
        view.backgroundColor = NeuColor.lightTheme
        
        title = itemInfo!["Name"]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //アニメ有効化
        UIView.setAnimationsEnabled(true)
        
        let duration = changeDepthDuration
        itemImabeViewAppear(duration: duration)
        neumorphicLayerAppear(duration: duration)
        likeButtonAppear(duration: duration)
        
        
    }
    
    
    //--------------------IBアウトレットなど--------------------
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBAction func likeButtonAction(_ sender: Any) { likeButtonAction() }
    @IBOutlet weak var likeButton: UIButton!
    let neumorphicView = EMTNeumorphicView()
    let innerView = UIView()
    
    //親ビューから受け取る
    var itemImage:UIImage?
    var itemInfo:[String:String]?
    
    //お気に入りボタン
    var liked = false
    
    
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
    
    func likeButtonAppear(duration:Double) {
        
        let likeButtonSize:CGFloat = 54
        let likeButtonX:CGFloat = itemImageView.frame.origin.x + itemImageView.frame.size.width
        let likeButtonY:CGFloat = itemImageView.frame.origin.y + itemImageView.frame.size.height - likeButtonSize
        likeButton.tintColor = NeuColor.lightLetter
        likeButton.frame.size = CGSize(width: likeButtonSize, height: likeButtonSize)
        likeButton.frame.origin = CGPoint(x: likeButtonX, y: likeButtonY)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            self.likeButton.alpha = 1
        })
        
    }
    
    func likeButtonAction() {
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut, animations: {
            if self.liked {
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.likeButton.imageView?.tintColor = NeuColor.lightLetter
            } else {
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.likeButton.imageView?.tintColor = NeuColor.heart
            }
        })
        liked = !liked
        
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
        
        innerView.frame.size.width = neumorphicView.frame.size.width - sideInset * 2
        innerView.frame.origin = CGPoint(x: sideInset, y: sideInset)
        innerView.alpha = 0
        
        neumorphicView.addSubview(innerView)
        scrollView.addSubview(neumorphicView)
        
        var labelY:CGFloat = 0
        let eachInfoInset:CGFloat = 20
        let bodyValueInset:CGFloat = 0
        for eachInfo in itemInfo! {
            
            let keyLabel = UILabel()
            keyLabel.font = NeuFont.itemKey
            keyLabel.textColor = NeuColor.lightTitle
            keyLabel.text = eachInfo.key
            keyLabel.sizeToFit()
            keyLabel.frame.origin.y = labelY
            labelY += keyLabel.frame.size.height + bodyValueInset
            
            let valueLabel = UILabel()
            valueLabel.font = NeuFont.itemValue
            valueLabel.textColor = NeuColor.lightLetter
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
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.neumorphicView.neumorphicLayer?.elementDepth =  neuButtonBasicDepth
            self.innerView.alpha = 1
        })
        
    }
    
}
