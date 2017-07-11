import UIKit

class PrizeResultTableCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var prizeImageVIew: UIImageView!
    @IBOutlet var value: UILabel!
    @IBOutlet var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        layoutMargins = UIEdgeInsetsMake(3, 0, 3, 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(image: String, name: String, value: String) {
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.masksToBounds = true
        
        self.prizeImageVIew.snp.makeConstraints { make in
            make.width.height.equalTo(self.containerView.snp.height)
            make.top.left.equalTo(self.containerView)
        }
        
        self.name.snp.makeConstraints { make in
            make.left.equalTo(self.prizeImageVIew.snp.right).offset(5 * SCALE)
            make.top.right.equalTo(self.containerView).offset(5 * SCALE)
        }
        
        self.value.snp.makeConstraints { make in
            make.left.right.equalTo(self.name)
            make.bottom.equalTo(self.containerView).offset(-5 * SCALE)
        }
        
        self.prizeImageVIew.sd_setImage(with: URL(string: LawBoardUtil.getImageUrl(filename: image))) { (image, error, cache, url) in
            if (error != nil) {
                
            }
        }
        
        self.name.text = name
        self.name.font = UIFont.systemFont(ofSize: 7 * SCALE)
        self.value.text = value
        self.value.font = UIFont.systemFont(ofSize: 10 * SCALE)
    }
}
