
import UIKit

class LRegisterVC: UIViewController {
    @IBOutlet var phone: UITextField!
    @IBOutlet var code: UITextField!
    @IBOutlet var sendCodeSms: UIButton!
    @IBOutlet var bindPhoneBtn: UIButton!
    
    var isBindPhone = true
    let api = LawBoardApi.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phone.attributedPlaceholder = NSAttributedString(string: self.phone.placeholder!, attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.4246836901, green: 0.4075239897, blue: 0.4952622652, alpha: 1)])
        self.phone.borderStyle = .none
        self.phone.textColor = #colorLiteral(red: 0.4246836901, green: 0.4075239897, blue: 0.4952622652, alpha: 1)
        self.phone.font = UIFont.systemFont(ofSize: 6 * SCALE)
        self.phone.snp.makeConstraints { make in
            make.topMargin.equalTo(10 * SCALE)
            make.width.equalTo(self.view.frame.width * 0.7)
            make.centerX.equalTo(self.view)
        }
        
        self.code.attributedPlaceholder = NSAttributedString(string: self.code.placeholder!, attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.4246836901, green: 0.4075239897, blue: 0.4952622652, alpha: 1)])
        self.code.borderStyle = .none
        self.code.textColor = #colorLiteral(red: 0.4246836901, green: 0.4075239897, blue: 0.4952622652, alpha: 1)
        self.code.font = UIFont.systemFont(ofSize: 6 * SCALE)
        self.code.snp.makeConstraints  { make in
            make.left.equalTo(self.phone)
            make.top.equalTo(self.phone.snp.bottom).offset(15 * SCALE)
            make.width.equalTo(self.view.frame.width * 0.4)
        }
        
        self.sendCodeSms.layer.borderColor = UIColor.white.cgColor
        self.sendCodeSms.layer.borderWidth = 1
        self.sendCodeSms.layer.cornerRadius = 6 * SCALE
        self.sendCodeSms.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        self.sendCodeSms.snp.makeConstraints { make in
            make.right.equalTo(self.phone)
            make.left.equalTo(self.code.snp.right).offset(2 * SCALE)
            make.centerY.equalTo(self.code)
            make.height.equalTo(12 * SCALE)
        }
        
        self.bindPhoneBtn.layer.borderColor = UIColor.white.cgColor
        self.bindPhoneBtn.layer.borderWidth = 1
        self.bindPhoneBtn.layer.cornerRadius = NORMAL_BTN_RADIUS
        self.bindPhoneBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        if (isBindPhone == true) {
            self.bindPhoneBtn.setTitle("绑定手机号", for: .normal)
            self.title = "绑定手机"
        } else {
            self.bindPhoneBtn.setTitle("登录", for: .normal)
            self.title = "手机登录"
        }
        self.bindPhoneBtn.snp.makeConstraints { make in
            make.height.equalTo(NORMAL_BTN_HEIGHT)
            make.width.centerX.equalTo(self.phone)
            make.top.equalTo(self.code.snp.bottom).offset(15 * SCALE)
        }
        
        let border1 = UIView()
        border1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(border1)
        border1.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.centerX.equalTo(self.phone)
            make.top.equalTo(self.phone.snp.bottom).offset(5)
        }
        
        let border2 = UIView()
        border2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(border2)
        border2.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.centerX.equalTo(self.code)
            make.top.equalTo(self.code.snp.bottom).offset(5)
        }
        
        api.delegate = self
    }

    /// MARK: 发送验证码
    @IBAction func sendCodeSms(_ sender: UIButton) {
        let phoneNumber = self.phone.text!
        
        if (phoneNumber == "") {
            alert(msg: "请填写手机号")
            return
        }
        
        //验证手机号码格式
        let mailPattern = "^1[0-9]{10}$"
        let matcher = MyRegex(mailPattern)
        if matcher.match(input: phoneNumber) {
            api.sendCodeSms(type: self.isBindPhone == true ? "register": "login", phone: phoneNumber, callback: {
                self.alert(msg: "验证码已发送")
                
                //处理发送验证码按钮的效果
            })
        }else{
            alert(msg: "请输入正确的手机号")
        }
    }
    
    /// MARK: 绑定手机号
    @IBAction func bindPhone(_ sender: UIButton) {
        let phoneNumber = self.phone.text!
        let code = self.code.text!
        
        if (phoneNumber == "") {
            alert(msg: "请填写手机号")
            return
        }
        
        //验证手机号码格式
        let mailPattern = "^1[0-9]{10}$"
        let matcher = MyRegex(mailPattern)
        if matcher.match(input: phoneNumber) == false {
            alert(msg: "请输入正确的手机号")
            return
        }
        
        if (code == "") {
            alert(msg: "请填写验证码")
            return
        }
        
        let data = [
            "phone": phoneNumber,
            "code": code
        ];
        
        if (isBindPhone == true) {
            //注册，成功跳转到红包首页
            api.userBind(type: .phone, extendData: data, {
                let myPrizeResultVC = self.storyboard?.instantiateViewController(withIdentifier: "LTempNewsVCID") as! LMyPrizeResultVC
                self.navigationController?.pushViewController(myPrizeResultVC, animated: true)
            })
        } else {
            api.userLogin(type: .phone, extendData: data, {
                //跳转到红包页面
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVCID") as! LMainNavVC
                self.present(vc, animated: false, completion: nil)
            })
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
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
