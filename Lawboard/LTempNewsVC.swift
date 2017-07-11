import UIKit

class LTempNewsVC: UIViewController,UINavigationControllerDelegate{
	var newsArray:[NewModel] = Array()
	var proTypeCell:TempCell!
	var pushing:Bool!
	private var pageNum:Int!
	private var pageSize:Int = 10
	@IBOutlet weak var tempTableView: UITableView!
	//@IBOutlet var webView: UIWebView!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.pageNum = 1;
		self.navigationController?.delegate = self
		self.tempTableView.dataSource = self
		self.tempTableView.delegate = self
		self.tempTableView.backgroundColor = UIColor.clear
		self.tempTableView.register(UINib(nibName: "TempCell", bundle: nil), forCellReuseIdentifier: "TempCell")
		self.proTypeCell = self.tempTableView.dequeueReusableCell(withIdentifier: "TempCell") as! TempCell!
		self.tempTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget:self, refreshingAction: #selector(loadMore))
		self.tempTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(pullToRefresh))
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		self.pullToRefresh()
		
		//self.webView.loadRequest(URLRequest(url: URL(string: LawBoardUtil.getUrl(shortUrl: "/news"))!))
		//self.webView.loadRequest(URLRequest(url: URL(string: "http://yournews.hengtiansoft.com/newsfeedingHomePage/page/usercenter/iframe.html?39")!))
	}

	func pullToRefresh(){
	 self.pageNum = 1;
	self.loadMore()
	}
	
	
	func loadMore(){
		LawBoardApi.shareInstance.getNewsList(userId: "", pageSize: pageSize, pageNum: pageNum) { (array) in
			if self.pageNum == 1 {
			 self.newsArray = array
			 self.tempTableView.mj_header.endRefreshing()
			}else {
			 self.newsArray = self.newsArray + array
			}
			 self.pageNum = self.pageNum + 1
             self.dataSourceFilled(count: array.count)
		}
	}
	func dataSourceFilled(count:Int){
		if count < pageSize {
			self.tempTableView.mj_footer.state = .noMoreData
		}else if count == pageSize{
			self.tempTableView.mj_footer.endRefreshing()
		}
		self.tempTableView.reloadData()
	}
	
	
	func pushViewController(viewController:UIViewController, animated: Bool ){
		if self.pushing == true{
		 return
		}else {
		 self.pushing = true
		}
	
		super.navigationController?.pushViewController(viewController, animated: animated)
	}
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		self.pushing = false
	}
	
}
extension LTempNewsVC:UITableViewDataSource,UITableViewDelegate {
	
	//设置单元格
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath) as! TempCell
		if self.newsArray.count > 0 {
	
			let newModel = self.newsArray[indexPath.row]
			if newModel.isAdv.hasPrefix("T"){
				cell.newLabel.attributedText = self.updateAttribute(str: newModel.newTitle)
			}else {
				cell.newLabel.text = newModel.newTitle
			}
		    if newModel.readed == 0 {
				cell.readCount.isHidden = true
			}else {
				cell.readCount.isHidden = false 
			}
			cell.readCount.text = "阅读量: " + String.init(newModel.readed)
			//加载中奖的图片
			if newModel.mediaImage != "" && newModel.mediaImage != "(null)" {
				cell.newImage.isHidden = false
				cell.labelLeftConstant.constant = 120
				cell.newImage.sd_setImage(with: URL(string: newModel.mediaImage)) { (image, error, cache, url) in
					if (error != nil) {
						cell.newImage.isHidden = true
						cell.labelLeftConstant.constant = 15
						//self.alert(msg: "加载图片失败")
					}
				}
			}else {
				cell.newImage.isHidden = true
				cell.labelLeftConstant.constant = 15
			}
		     cell.timeLabel.text = "更新时间：" +  self.timeStampToString(timeStamp: newModel.recommendTime)
			
			
		}
		cell.coView.layer.masksToBounds = true
		cell.coView.layer.cornerRadius = 8.0
		cell.selectionStyle = UITableViewCellSelectionStyle.none
		return cell
	}
	
	func updateAttribute(str:String) ->NSMutableAttributedString {
	
	 var mustr:NSMutableAttributedString
		mustr = NSMutableAttributedString.init(string: str)
		var textAttachment:NSTextAttachment
		textAttachment = NSTextAttachment()
		textAttachment.image = UIImage.init(named: "组-4")
		 textAttachment.bounds = CGRect.init(x: 0, y: -5, width: 26, height: 20);
		var textAttachmentString:NSAttributedString
		textAttachmentString = NSAttributedString(attachment: textAttachment)
		//在城市名称后插入图片
		mustr.insert(textAttachmentString, at: 0)
		return mustr
	}
	/**
	时间戳转时间
	
	
	:param: timeStamp <#timeStamp description#>
	
	:returns: return time
	*/
	func timeStampToString(timeStamp:Double)->String {
		let timeSta:TimeInterval = timeStamp / 1000
		let dfmatter = DateFormatter()
		dfmatter.dateFormat = "MM-dd HH:mm"
		let date = NSDate(timeIntervalSince1970: timeSta)
		return dfmatter.string(from: date as Date)
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return  self.newsArray.count
	}
	
	//点击Cell跳转到详情
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let targetVc  = NewsDetailVC()
		if self.newsArray.count > 0 {
			var newModel = self.newsArray[indexPath.row]
			//let cell = self.tempTableView.cellForRow(at: indexPath) as! TempCell
			if indexPath.row == 2 {
			  newModel.newId = 415698
			}
				LawBoardApi.shareInstance.getNewDetail(id: newModel.newId, callback: { (data) in
					let content = data["content"] as! String
					targetVc.contentStr = content
					targetVc.titleStr = data["title"] as! String
					targetVc.newModel = newModel
//					self.navigationController?.pushViewController(targetVc, animated: true)
					self.pushViewController(viewController: targetVc, animated: true)
				})
		
		
		}
	}
	

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//let cell:TempCell = self.proTypeCell
		//if self.newsArray.count > 0 {
		//	let newModel = self.newsArray[indexPath.row]
		//	cell.newLabel.text =  newModel.newTitle
		//}
		//let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
		//print("h=%f", size.height + 1);
		//return 1 + size.height;
		return 115
		
	}
	
}
