

import UIKit
import SnapKit

class LLoginVC: UIViewController {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var wxLoginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置用户名的下划线
        let usernameLineView = UIView()
        usernameLineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.username.borderStyle = .none
        self.view.addSubview(usernameLineView)
        usernameLineView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.username)
            make.height.equalTo(1)
            make.centerX.equalTo(self.username)
            make.top.equalTo(self.username.snp.bottom)
        }
        
        // 设置密码的下划线
        self.password.borderStyle = .none
        let passwordLineView = UIView()
        passwordLineView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.password.borderStyle = .none
        self.view.addSubview(passwordLineView)
        passwordLineView.snp.makeConstraints{ (make) -> Void in
            make.width.equalTo(self.password)
            make.height.equalTo(1)
            make.centerX.equalTo(self.password)
            make.top.equalTo(self.password.snp.bottom)
        }
        
        self.username.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        self.password.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        // 设置登录按钮的样式
        self.disableLoginBtn()
        
        // 设置微信登录按钮的样式
        self.wxLoginBtn.layer.cornerRadius = 20
        self.wxLoginBtn.layer.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor
        self.wxLoginBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidChange(sender: UITextField!) {
        if (self.username.text != "" && self.password.text != "") {
            self.enableLoginBtn()
        } else {
            self.disableLoginBtn()
        }
    }
    
    // 激活登录按钮
    func enableLoginBtn() {
        self.loginBtn.isEnabled = true
        self.loginBtn.layer.cornerRadius = 20
        self.loginBtn.layer.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1).cgColor
        self.loginBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }

    // 失效登录按钮
    func disableLoginBtn() {
        self.loginBtn.isEnabled = false
        self.loginBtn.layer.cornerRadius = 20
        self.loginBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.loginBtn.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
    }
    
    // 登录操作
    @IBAction func doLogin(_ sender: UIButton) {
//        let username = self.username.text!
//        let password = self.password.text!
    }
    
    // 微信登录
    @IBAction func doWeixinLogin(_ sender: UIButton) {
    }
    
    // 返回欢迎页面
    @IBAction func backToWelcome(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    // 点击注册进入注册页面
    @IBAction func gotoRegisterView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showRegisterViewFromLogin", sender: self)
    }
}

extension LLoginVC: LawboardUserDelegate {
    func loginSuccess() {
        //登录成功跳转到新闻主页
        self.performSegue(withIdentifier: "gotoMainVC", sender: self)
    }
    
    func loginFailure(msg: String) {
        let alertVC = UIAlertController(title: "登录失败", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
