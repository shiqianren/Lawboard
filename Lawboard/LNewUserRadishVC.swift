//
//  LNewUserRadishVC.swift
//  Lawboard
//
//  Created by Saxonzh on 2017/2/18.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import UIKit

class LNewUserRadishVC: UIViewController {
    @IBOutlet var radishImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.radishImageView.snp.makeConstraints { make in
            var width = self.view.frame.width * 0.7
            
            if (LawBoardUtil.isPad()) {
                width = width * 0.8
            }
            
            make.width.height.equalTo(width)
            make.topMargin.equalTo(15 * SCALE)
            make.centerX.equalTo(self.view)
        }
        
        //给金萝卜绑定点击事件
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoWheel(tapGestureRecognizer:)))
        radishImageView.isUserInteractionEnabled = true
        radishImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let labelBtn = UILabel()
        labelBtn.numberOfLines = 0
        labelBtn.attributedText = LawBoardUtil.stringFromHtml(string: "<div style='text-align: center;color:#fff'><span style='color: #f2eb9f'>恭喜您！挖到一颗\"金萝卜\"！</span><br/>即刻点击<span style='color: #f2eb9f'>金萝卜抽红包</span></div>")
        labelBtn.font = UIFont.systemFont(ofSize: 6 * SCALE)
        labelBtn.layer.borderColor = UIColor.white.cgColor
        labelBtn.layer.borderWidth = 1
        labelBtn.layer.cornerRadius = 10 * SCALE
        self.view.addSubview(labelBtn)
        labelBtn.snp.makeConstraints { make in
            make.top.equalTo(radishImageView.snp.bottom).offset(20)
            make.width.equalTo(self.view.bounds.width * 0.7)
            make.height.equalTo(20 * SCALE)
            make.centerX.equalTo(self.view)
        }
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(gotoWheel(tapGestureRecognizer:)))
        labelBtn.isUserInteractionEnabled = true
        labelBtn.addGestureRecognizer(tapGestureRecognizer2)
        
        
        
        let labelLink = UILabel()
        labelLink.numberOfLines = 0
        labelLink.attributedText = LawBoardUtil.stringFromHtml(string: "<div style='color:#fff;text-align: center;text-decoration: underline;'>挖\"金萝卜\"参与终极争霸赛，<br/>故事霸王可获高达50万人民币版权费！</div>")
        labelLink.font = UIFont.systemFont(ofSize: 5 * SCALE)
        self.view.addSubview(labelLink)
        labelLink.snp.makeConstraints { make in
            make.top.equalTo(labelBtn.snp.bottom).offset(15)
            make.width.equalTo(self.view.bounds.width * 0.7)
            make.centerX.equalTo(self.view)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gotoMoreDetailVC))
        labelLink.isUserInteractionEnabled = true
        labelLink.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoWheel(tapGestureRecognizer: UITapGestureRecognizer) {
        let wheelVC = storyboard?.instantiateViewController(withIdentifier: "LWheelVCID") as! LWheelVC
        wheelVC.wheelType = "newuser"
        self.navigationController?.pushViewController(wheelVC, animated: true)
    }
    
    func gotoMoreDetailVC() {
        let webVC = LWebVC()
        webVC.navTitle = "查看详情"
        webVC.url = LawBoardUtil.getUrl(shortUrl: "/page/radishdetail")
        self.navigationController?.pushViewController(webVC, animated: true)
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
        self.title = "抢红包"
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
