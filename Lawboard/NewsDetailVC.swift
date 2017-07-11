//
//  NewsDetailVC.swift
//  Lawboard
//
//  Created by shiqianren on 2017/5/4.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import Foundation
class NewsDetailVC: UIViewController,UIWebViewDelegate {
	var contentStr:String!
	var titleStr : String!
	var newModel: NewModel!
	 var newsWebView: UIWebView!
	var nesLabel: UILabel!
	
	let guideUrl = "https://helloboard.oss-cn-shanghai.aliyuncs.com/docs/guide.html"
	override func viewDidLoad() {
		super.viewDidLoad()
		self.newsWebView = UIWebView()
		self.view.addSubview(self.newsWebView)
		self.newsWebView.scrollView.contentInset = UIEdgeInsetsMake(145, 0, 0, 0)
		print("之前的"+contentStr)
		contentStr = contentStr.replacingOccurrences(of: "<img", with: "<img style=\"width:100%\"")
		contentStr = contentStr.replacingOccurrences(of: "width=", with: "")
		contentStr = contentStr.replacingOccurrences(of: "height=", with: "")
		contentStr = contentStr.replacingOccurrences(of: "<td", with: "<td style = font-size:17px;color:#5E5E5E;line-height:30px;")
		contentStr = contentStr + "</a><div style=\"background:#E8E8E8;padding:10px\">" +
			"<h4 style=\"color:#AB4B56;margin:0px\">版权声明</h4>" +
			"<p style=\"font-size:14px;color:#5E5E5E;\">“黑萝Helloboard" +
			"”是一款基于数据挖掘技术的推荐引擎产品。文章内容来源于互联网，版权归属于原作者。如需转载须注明原出处及原作者姓名或名称。如果权利人认为本文内容侵犯了您的合法权益，请仔细阅读<a href=\"https://helloboard.oss-cn-shanghai.aliyuncs.com/docs/guide.html\">“黑萝Helloboard”投诉指引</a>后，按照指引建议的方式与我们联络。</p>" +
		"</div>";
		contentStr = "<div style=\"font-size:17px;color:#5E5E5E;line-height:30px;\"/>" + contentStr + "</div>"
		
		
		self.newsWebView.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
		self.newsWebView.frame = CGRect.init(x: 0, y: 0, width: WIDTH, height: HEIGHT-69)
		self.newsWebView.delegate = self
		
		print("之后的"+contentStr)
		self.newsWebView.loadHTMLString(contentStr, baseURL: nil)
		self.setHeadView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		if (self.newsWebView != nil) {
		  self.newsWebView.loadHTMLString(contentStr, baseURL: nil)
		}
		
		self.view.backgroundColor =  UIColor(patternImage: UIImage(named:"background")!)
			self.title = "资讯详情"
		self.navigationController?.setNavigationBarHidden(false, animated: animated)
		self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		//self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backAction))
	}
	
	// 调整行间距
	fileprivate func getAttributeStringWithString(_ string: String,lineSpace:CGFloat
		) -> NSAttributedString{
		let attributedString = NSMutableAttributedString(string: string)
		let paragraphStye = NSMutableParagraphStyle()
		
		//调整行间距
		paragraphStye.lineSpacing = lineSpace
		let rang = NSMakeRange(0, CFStringGetLength(string as CFString!))
		attributedString .addAttribute(NSParagraphStyleAttributeName, value: paragraphStye, range: rang)
		return attributedString
		
	}
	
	
	func setHeadView() {
		
		self.newsWebView.scrollView.backgroundColor = UIColor(patternImage: UIImage(named:"background")!)
		let  headView = UIView.init()
		headView.frame = CGRect.init(x: 0, y: -145, width: WIDTH, height: 145)
		let  label = UILabel.init()
	    label.frame = CGRect.init(x: 15, y: 0, width: WIDTH-30, height: 85)
		//label.text = newModel.newTitle
		label.attributedText = self.getAttributeStringWithString(newModel.newTitle, lineSpace: 5)
		label.textAlignment = .left
		label.numberOfLines = 0
		label.textColor = UIColor.darkGray
		label.font = UIFont.boldSystemFont(ofSize: 22)
		label.backgroundColor = UIColor.clear
		headView.addSubview(label)
		let orginLabel = UILabel.init()
		orginLabel.frame = CGRect.init(x: 15, y: label.bottom, width: label.width, height: 40)
		orginLabel.text = newModel.site + " | " + self.timeStampToString(timeStamp: newModel.recommendTime)
		orginLabel.font = UIFont.systemFont(ofSize: 15)
		orginLabel.textColor = UIColor.lightGray
		label.bottom = orginLabel.top
		headView.addSubview(orginLabel)
		let lineLabel = UILabel.init()
		lineLabel.frame = CGRect.init(x: 15, y: orginLabel.bottom, width: label.width, height: 1)
		lineLabel.backgroundColor = UIColor.lightGray
		headView.addSubview(lineLabel)
		self.newsWebView.scrollView.addSubview(headView)
		headView.backgroundColor = UIColor.white
	
	}
	/**
	时间戳转时间
	
	
	:param: timeStamp <#timeStamp description#>
	
	:returns: return time
	*/
	func timeStampToString(timeStamp:Double)->String {
		
		//let string = NSString(string: timeStamp)
		let timeSta:TimeInterval = timeStamp / 1000
		let dfmatter = DateFormatter()
		dfmatter.dateFormat = "YY-MM-dd HH:mm:ss"
		
		let date = NSDate(timeIntervalSince1970: timeSta)
		return dfmatter.string(from: date as Date)
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
	}
	
	/// MARK: 翻页按钮响应事件
	func backAction() {
		let _ = self.navigationController?.popViewController(animated: true)
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		
			let scrollView: UIScrollView = self.newsWebView.subviews[0] as! UIScrollView
			scrollView.setContentOffset(CGPoint.init(x: 0, y: -145), animated: false)

	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		
		let requestUrl = (request.url?.absoluteString)! as String
		if requestUrl != "about:blank" && requestUrl.contains(guideUrl) {
			let copyRightvc =  CopyrightVC()
				copyRightvc.url = guideUrl
			self.hidesBottomBarWhenPushed = true
			self.navigationController?.pushViewController(copyRightvc, animated: true)
			self.hidesBottomBarWhenPushed = false
		}
		return true;
	}
	
	
}
