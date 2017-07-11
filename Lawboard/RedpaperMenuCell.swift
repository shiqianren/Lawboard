import UIKit

class RedpaperMenuCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var iconText: UILabel!
    
    func initView() {
        var cellWidth = self.frame.width
        var cellHeight = self.frame.height
        var fontsize = UIFont.systemFontSize
        
        if (LawBoardUtil.isPad()) {
            cellWidth = cellWidth * 0.9
            cellHeight = cellHeight * 0.9
            fontsize = fontsize * 0.9
        }
        
//        self.containerView.layer.borderColor = UIColor.red.cgColor
//        self.containerView.layer.borderWidth = 1
        
        self.containerView.snp.makeConstraints { make in
            make.width.equalTo(cellWidth * 0.8)
            make.height.equalTo(cellHeight * 0.6)
            make.center.equalTo(self.contentView)
        }
        
        self.iconImage.snp.makeConstraints { make in
            let width = self.containerView.snp.width
            make.width.height.equalTo(width)
            make.top.centerX.equalTo(self.containerView)
        }
        
        self.iconText.font = UIFont.systemFont(ofSize: fontsize)
        self.iconText.snp.makeConstraints { make in
            make.width.equalTo(self.containerView.snp.width)
            make.top.equalTo(self.iconImage.snp.bottom).offset(5)
            make.centerX.equalTo(self.iconImage)
        }
    }
    
    func update(image: UIImage?, text: String) {
        if image != nil {
            self.iconImage.image = image
            self.iconImage.isHidden = false
        } else {
            self.iconImage.isHidden = true
        }
        
        self.iconText.text = text
        self.initView()
    }
}
