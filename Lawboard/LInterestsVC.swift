
import UIKit

class LInterestsVC: UIViewController {
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var startBtn: UIButton!
    
    @IBOutlet var interestTableView: UITableView!
    
    var _selectedIds = [Int]()
    var models = [InterestDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoLabel.text = ""
        self.startBtn.layer.cornerRadius = 15
        
        self.setInfo(num: 0)
        
        self.interestTableView.dataSource = self
        self.interestTableView.delegate = self
        
        LawBoardApi.shareInstance.getInterestList { data in
            for item in data {
                self.models.append(InterestDataModel(model: item))
            }
            self.interestTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goNewListView(_ sender: UIButton) {
        // 本地存储
        LawboardUser.shareInstance.setInterestIds(interestIds: _selectedIds)
        
        // 跳转到新闻页
        self.performSegue(withIdentifier: "showNewList", sender: _selectedIds)
    }
    
    // MARK: 设置导航栏的文字信息
    func setInfo(num: Int) {
        do{
            var infoStr: String = ""
            
            if num < 1 {
                infoStr = "<p style='color: black'>请选择你的兴趣（<span style='color: red'>2</span>个以上）</p>"
            } else if num >= 2 {
                infoStr = "<p style='color: black'>已选择<span style='color: red'>\(num)</span>个兴趣</p>"
            } else {
                infoStr = "<p style='color: black'>请在选择至少<span style='color: red'>\(num)</span>个兴趣</p>"
            }
            
            if num >= 2 {
                self.startBtn.isHidden = false
            } else {
                self.startBtn.isHidden = true
            }
            
            
            let attrStr = try NSAttributedString(data: infoStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.infoLabel.attributedText = attrStr
            self.infoLabel.font = UIFont.systemFont(ofSize: 17)
        } catch let error as NSError {
            print(error.localizedDescription)
            self.infoLabel.text = ""
        }
    }
}

extension LInterestsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestTableCellID") as! InterestTableCell
        cell.update(model: self.models[indexPath.row])
        
        if _selectedIds.contains(self.models[indexPath.row].id) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let interestId = self.models[indexPath.row].id
        if let index = _selectedIds.index(of: interestId) {
            _selectedIds.remove(at: index)
        } else {
            _selectedIds.append(interestId)
        }
        
        self.interestTableView?.reloadRows(at: [indexPath], with: .automatic)
        self.setInfo(num: _selectedIds.count)
    }
}
