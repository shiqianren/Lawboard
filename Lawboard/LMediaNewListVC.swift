
import UIKit

class LMediaNewListVC: UIViewController {
    @IBOutlet var newTableView: UITableView!
    
    @IBOutlet var navigationBar: UINavigationBar!
    var models = [NewsDataModel]()
    var mediaName: String = ""
    var mediaId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.topItem?.title = self.mediaName

        self.newTableView.dataSource = self
        self.newTableView.delegate = self
        self.newTableView.register(UINib(nibName: "WholePageTableViewCell", bundle: nil), forCellReuseIdentifier: "WholePageTableViewCellID")
        
        //加载新闻列表数据
        LawBoardApi.shareInstance.getNewList { data in
            self.models = data
            self.newTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewDetailFromMediaNewList" {
            let controller = segue.destination as! LNewDetailVC
            controller.id = sender as! Int64
        }
    }
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.navigationController!.popViewController(animated: true)
    }
}

extension LMediaNewListVC: UITableViewDelegate, UITableViewDataSource {
    //设置单元格
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WholePageTableViewCellID", for: indexPath) as! WholePageTableViewCell
        
        if self.models.count != 0 {
            cell.update(model: self.models[indexPath.row])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.models.count
    }
    
    //点击Cell跳转到详情
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.models[indexPath.row].newId
        self.performSegue(withIdentifier: "showNewDetailFromMediaNewList", sender: id)
    }
}
