import UIKit

class LPrizeInfoVC: UIViewController {
    var prizeName = ""
    var prizeImageName = ""
    var prizeContent = ""
    
    @IBOutlet var prizeContentView: UITextView!
    @IBOutlet var prizeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prizeImageView.snp.makeConstraints  { make in
            make.width.height.equalTo(self.view.frame.width * 0.4)
            make.centerX.equalTo(self.view)
            make.topMargin.equalTo(15 * SCALE)
        }
        
        //加载中奖的图片
        self.prizeImageView.sd_setImage(with: URL(string: LawBoardUtil.getImageUrl(filename: self.prizeImageName))) { (image, error, cache, url) in
            if (error != nil) {
                self.alert(msg: "加载图片失败")
            }
        }
        
        //加载中奖的奖项信息
        self.prizeContentView.attributedText = LawBoardUtil.stringFromHtml(string: self.prizeContent)
        self.prizeContentView.font = UIFont.systemFont(ofSize: 7 * SCALE)
        self.prizeContentView.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width * 0.8)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.prizeImageView.snp.bottom).offset(15 * SCALE)
            make.bottom.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.backItem?.title = "返回"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.title = self.prizeName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
