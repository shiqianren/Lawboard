import UIKit
import CellAnimator

class LNewsListVC: UIViewController {
    var models = [NewsDataModel]()
    
    @IBOutlet var newsListTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchResultView: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置表格数据源和代理
        self.newsListTableView.dataSource = self
        self.newsListTableView.delegate = self
        
        self.searchBar.delegate = self
        
        //加载新闻列表数据
        let api = LawBoardApi.shareInstance
        api.delegate = self
        api.getNewList { data in
            self.models = data
            self.newsListTableView.reloadData()
            self.newsListTableView.removeFromSuperview()
            

        }
        
        let flipper = LawBoardPageFliper.init(frame: self.view.bounds)
        flipper.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        flipper.dataSource = self

        self.view.addSubview(flipper)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "showMediaNewList":
                let index = sender as! Int
                let controller = segue.destination as! LMediaNewListVC
                controller.mediaId = self.models[index].mediaId
                controller.mediaName = self.models[index].mediaName
                break;
            case "showNewDetailView":
                let controller = segue.destination as! LNewDetailVC
                controller.id = sender as! Int64
                break;
            default:
                break;
        }
    }
    
    func getNewListFailure(msg: String) {
        let alertVC = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension LNewsListVC: LawBoardPageFliperDatasource {
    func numberOfPagesForPageFlipper(pageFlipper: LawBoardPageFliper) -> Int {
        return self.models.count
    }
    
    func viewForPage(page: Int, pageFlipper: LawBoardPageFliper) -> UIView {
        print("\(page)")
        
        if let cell = self.newsListTableView.cellForRow(at: IndexPath.init(row: Int(page), section: 0)) {
            cell.frame = self.view.bounds
            return cell
        }
        
        let textview = UITextView()
        textview.text = "\(page)"
        textview.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        textview.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        let view = UIView()
        view.backgroundColor = page >  2 ? #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1) : #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.frame = self.view.bounds
        view.addSubview(textview)
        textview.snp.makeConstraints { make in
            make.centerX.top.equalTo(view)
        }
        return view
    }
}

extension LNewsListVC: UITableViewDelegate, UITableViewDataSource {
    //跳转到媒体用户的新闻列表页面
    func gotoMediaNewListView(sender: UIButton!) {
        self.performSegue(withIdentifier: "showMediaNewList", sender: sender.tag)
    }
    //设置单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCellReUseID") as! NewsTableCell
        
        if self.models.count != 0 {
            cell.update(model: self.models[indexPath.row])
        }
        
        cell.mediaLinkBtn.tag = indexPath.row
        cell.mediaLinkBtn.addTarget(self, action: #selector(gotoMediaNewListView(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.models.count
    }
    
    //设置tableview单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.newsListTableView.frame.height - bottomLayoutGuide.length
        
        if indexPath.row == 0 {
            return height - self.searchBar.frame.height
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformFlip, andDuration: 1)
    }
    
    //点击Cell跳转到详情
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.models[indexPath.row].newId
        self.performSegue(withIdentifier: "showNewDetailView", sender: id)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("test")
    }
}

extension LNewsListVC: UISearchBarDelegate {
    
    func showSearchResultView() {
        if (searchResultView == nil) {
            searchResultView = UIView()
            searchResultView!.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.view.addSubview(searchResultView!)
            self.view.bringSubview(toFront: searchResultView!)
            
            searchResultView!.snp.makeConstraints { make in
                make.width.centerX.bottom.equalTo(self.view)
                make.top.equalTo(self.searchBar.snp.bottom)
            }
        }
        
        searchResultView!.isHidden = false
    }
    
    func hideSearchResultView() {
        searchResultView!.isHidden = true
        print("here")
    }
    
    //开始输入搜索内容字符
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.showSearchResultView()
        print(1)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(2)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hideSearchResultView()
        searchBar.resignFirstResponder()
        print(3)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print(4)
    }
    
    //实时发起搜索请求
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(5)
    }
}
