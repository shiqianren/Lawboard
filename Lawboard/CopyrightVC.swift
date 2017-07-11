//
//  CopyrightVC.swift
//  Lawboard
//
//  Created by shiqianren on 2017/5/12.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import Foundation

class CopyrightVC: UIViewController {
	
	var navTitle = "版权声明"
	var url:String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor =  UIColor(patternImage: UIImage(named:"background")!)
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
		
		
		webV.loadRequest(URLRequest(url: URL(string: url)!))
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
		self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		//self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		//self.navigationController?.navigationBar.backItem?.title = "返回"
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
