

import UIKit

class LCommunityVC: UIViewController {
    @IBOutlet var topView: UIView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var followMediaUserCountLabel: UILabel!
    @IBOutlet var followNewsCountLabel: UILabel!
    @IBOutlet var beUserFollowCountLabel: UILabel!
    @IBOutlet var followUserCountLabel: UILabel!
    @IBOutlet var opTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatar.layer.borderWidth = 1
        self.avatar.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        self.avatar.layer.cornerRadius = 48
        
        let user = LawboardUser.shareInstance.getUser()
        if user == nil {
            self.displayLoginBtn()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayLoginBtn() {
        self.opTableView.isHidden = true
        
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 2
        infoLabel.textAlignment = .center
        infoLabel.textColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        infoLabel.text = "收藏喜爱的资讯，结识朋友，即刻注册，立即拥有"
        
        let wxLoginBtn = UIButton()
        wxLoginBtn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        wxLoginBtn.setTitle("使用微信登录", for: .normal)
//        
//        let registerBtn = UIButton()
//        registerBtn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
//        registerBtn.setTitle("注册账号", for: .normal)
//        registerBtn.addTarget(self, action: #selector(gotoRegisterView(sender:)), for: .touchUpInside)
//        
//        let loginInfoLabel = UILabel()
//        loginInfoLabel.text = "已经有账号了？"
//        
//        let loginBtn = UIButton();
//        loginBtn.setTitle("请登录", for: .normal)
//        loginBtn.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
//        loginBtn.addTarget(self, action: #selector(gotoLoginView(sender:)), for: .touchUpInside) //绑定点击事件
        
        self.view.addSubview(infoLabel)
        self.view.addSubview(wxLoginBtn)
//        self.view.addSubview(registerBtn)
//        self.view.addSubview(loginInfoLabel)
//        self.view.addSubview(loginBtn)
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.topView)
            make.width.equalTo(self.topView).offset(-100)
            make.top.equalTo(self.topView.snp.bottom).offset(70)
        }
        
        wxLoginBtn.snp.makeConstraints { make in
            make.centerX.equalTo(infoLabel)
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.width.equalTo(self.topView.snp.width).offset(-50)
            make.height.equalTo(45)
        }
        
//        registerBtn.snp.makeConstraints { make in
//            make.centerX.width.height.equalTo(wxLoginBtn)
//            make.top.equalTo(wxLoginBtn.snp.bottom).offset(20)
//        }
//        
//        loginInfoLabel.snp.makeConstraints { make in
//            make.top.equalTo(registerBtn.snp.bottom).offset(20)
//            make.centerX.equalTo(registerBtn)
//        }
//        
//        loginBtn.snp.makeConstraints { make in
//            make.top.equalTo(loginInfoLabel.snp.bottom).offset(5)
//            make.centerX.equalTo(loginInfoLabel)
//        }
    }
    
    func diaplayOpTableView() {
        self.opTableView.isHidden = false
    }
    
//    func gotoRegisterView(sender: UIButton!) {
//        let registerVC = storyboard?.instantiateViewController(withIdentifier: "LRegisterVCID") as! LRegisterVC
//        self.present(registerVC, animated: true, completion: nil)
//    }
//    
//    func gotoLoginView(sender: UIButton!) {
//        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LLoginVCID") as! LLoginVC
//        self.present(loginVC, animated: true, completion: nil)
//    }
}
