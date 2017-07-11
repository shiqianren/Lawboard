import UIKit

class LWheelResultVC: UIViewController {
    var phoneValid = 0
    var wechatValid = 0
    var giveUserImageName = ""
    var info = ""
    var wheelData = [String:Any]()
    
    var prizeGiveUserImage: UIImageView!
    
    @IBOutlet var giveUserImageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var bindBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneValid = self.wheelData["phone_valid"] as! Int
        self.wechatValid = self.wheelData["wechat_valid"] as! Int
        self.giveUserImageName = self.wheelData["give_user_image_name"] as! String
        self.info = self.wheelData["info"] as! String
        
        let str = LawBoardUtil.getImageUrl(filename: self.giveUserImageName)
        
        self.giveUserImageView.snp.makeConstraints { make in
            let width = self.view.frame.width * 0.4
            make.width.height.equalTo(width)
            make.centerX.equalTo(self.view)
            make.topMargin.equalTo(30 * SCALE)
        }
        //加载图片
        self.giveUserImageView.sd_setImage(with: URL(string: str)) { (image, error, cache, url) in
            if (error != nil) {
                self.alert(msg: "加载图片失败")
            }
        }
        
        //添加文案
        self.infoLabel.attributedText = LawBoardUtil.stringFromHtml(string: self.info)
        self.infoLabel.font = UIFont.systemFont(ofSize: 17)
        self.infoLabel.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width * 0.8)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.giveUserImageView.snp.bottom).offset(15 * SCALE)
        }
        
        //添加注册按钮
        self.bindBtn.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        self.bindBtn.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        self.bindBtn.layer.borderWidth = 1
        self.bindBtn.layer.cornerRadius = NORMAL_BTN_RADIUS
        self.bindBtn.titleLabel?.font = UIFont.systemFont(ofSize: 6 * SCALE)
        
        if (phoneValid == 0) {
            self.bindBtn.setTitle("绑定手机领取", for: .normal)
            self.bindBtn.addTarget(self, action: #selector(gotoRegisterVC(sender:)), for: .touchUpInside)
        } else {
            self.bindBtn.setTitle("查看我的红包", for: .normal)
            self.bindBtn.addTarget(self, action: #selector(gotoMyPrizeResult(sender:)), for: .touchUpInside)
        }
        self.bindBtn.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width * 0.7)
            make.height.equalTo(NORMAL_BTN_HEIGHT)
            make.top.equalTo(self.infoLabel.snp.bottom).offset(15 * SCALE)
            make.centerX.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// MARK: 进入我的红包页面
    func gotoMyPrizeResult(sender: UIButton!) {
        let myPrizeResultVC = storyboard?.instantiateViewController(withIdentifier: "LMyPrizeResultVCID") as! LMyPrizeResultVC
        self.navigationController?.pushViewController(myPrizeResultVC, animated: true)
    }
    
    /// MARK: 进入注册页面
    func gotoRegisterVC(sender: UIButton!) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "LRegisterVCID") as! LRegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
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
        self.title = "转盘结果"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
