
import UIKit

class NewsTableCell: UITableViewCell {

    @IBOutlet var mediaImage: UIImageView!
    @IBOutlet var mediaName: UILabel!
    @IBOutlet var timeGap: UILabel!
    @IBOutlet var newTitle: UILabel!
    @IBOutlet var newSummary: UILabel!
    @IBOutlet var collectInfo: UILabel!
    @IBOutlet var mediaLinkBtn: UIButton!
    
    var newId: Int64!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(model: NewsDataModel) {
        self.newId = model.newId
        self.mediaImage.image = UIImage.init(named: "iphone")
        self.mediaName.text = model.mediaName
//        self.mediaLink.text = model.mediaLink
        self.mediaLinkBtn.setTitle(model.mediaLink, for: .normal)
        self.timeGap.text = model.timeGap
        self.newTitle.text = model.newTitle
        self.newSummary.text = model.newSummary
        self.collectInfo.text = model.collectInfo
        
        self.mediaImage.layer.borderWidth = 1
        self.mediaImage.layer.masksToBounds = false
        self.mediaImage.layer.cornerRadius = self.mediaImage.frame.height/2
        self.mediaImage.clipsToBounds = true
        
        
        do{
            let attrStr = try NSAttributedString(data: model.newSummary.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.newSummary.attributedText = attrStr
            self.newSummary.font = UIFont.systemFont(ofSize: 17)
            self.newSummary.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        } catch let error as NSError {
            print(error.localizedDescription)
            self.newSummary.text = ""
        }

    }
    @IBAction func mediaLinkBtnClick(_ sender: UIButton) {
        
    }
    
    //分享资讯
    @IBAction func shareBtnClick(_ sender: UIButton) {
    }
    
    //点赞资讯
    @IBAction func approveBtnClick(_ sender: UIButton) {
        LawBoardApi.shareInstance.approveNew(newId: self.newId)
    }
    
    //评论资讯
    @IBAction func commentBtnClick(_ sender: UIButton) {
    }
    
    //收藏资讯
    @IBAction func followNewBtnClick(_ sender: UIButton) {
        LawBoardApi.shareInstance.followNew(newId: self.newId)
    }
}
