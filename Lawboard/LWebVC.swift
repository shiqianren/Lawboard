import UIKit

class LWebVC: UIViewController {
    var navTitle = "黑萝"
    var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "background"))
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        let webV = UIWebView()
        self.view.addSubview(webV)
        webV.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.view)
        }
        
        //组织授权参数信息
        let store = LawBoardStore.instance
        let accessToken = store.getApiData(key: store.KEY_API_ACCESS_TOKEN)
        let loginUserId = store.getApiData(key: store.KEY_API_LOGIN_USER_ID)
        
        webV.loadRequest(URLRequest(url: URL(string: "\(self.url)?_i=\(loginUserId)&_t=\(accessToken)&_v=\(VERSION)")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        self.title = self.navTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
