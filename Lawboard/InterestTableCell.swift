

import UIKit
import SnapKit
import SDWebImage

class InterestTableCell: UITableViewCell {
    @IBOutlet var selectBtnView: UIView!
    @IBOutlet var interestNameLabel: UILabel!
    @IBOutlet var bottomClickBtn: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIScrollView!
    @IBOutlet var unfoldBtnLabel: UILabel!
    @IBOutlet var titleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // 更新单元格数据和样式
    func update(model: InterestDataModel) {
        self.selectBtnView.layer.cornerRadius = 16
        self.selectBtnView.layer.borderWidth = 2
        self.selectBtnView.layer.borderColor = UIColor.white.cgColor
        
        self.interestNameLabel.text = model.name
        
        let imageView = UIImageView()
        self.topView.addSubview(imageView)
        self.topView.bringSubview(toFront: self.titleView)
        self.topView.bringSubview(toFront: self.selectBtnView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.width.height.centerX.equalTo(self.topView)
        }
        
        imageView.sd_setImage(with: URL(string: "http://hdwallpaperbackgrounds.net/wp-content/uploads/2016/11/Background-20.jpeg"), placeholderImage: UIImage(named: "iphone"))
        
        self.bottomView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.unfoldBtnLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    // 取消选择
    func unSelected() {
        self.selectBtnView.backgroundColor = UIColor.clear
    }
    
    // 选择
    func selected() {
        self.selectBtnView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let label = UILabel()
        label.text = "⎷"
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.selectBtnView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.centerX.centerY.equalTo(self.selectBtnView)
        }
    }
}
