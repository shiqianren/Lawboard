
import UIKit

class LNewDetailVC: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mediaImage: UIImageView!
    @IBOutlet var mediaName: UILabel!
    @IBOutlet var newTitle: UILabel!
    @IBOutlet var newContent: UILabel!
    
    @IBOutlet var customNavigationBar: UINavigationBar!
    var id: Int64 = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mediaName.text = ""
        self.newTitle.text = ""
        self.newContent.text = ""
        self.customNavigationBar.isTranslucent = false
        
        //获取新闻的单页数据进行渲染
        LawBoardApi.shareInstance.getNewItem(id: self.id, callback: { data in
            self.mediaImage.image = UIImage(named: "iphone")
            self.mediaName.text = data["user_name"] as? String
            self.newTitle.text = data["title"] as? String
            
            let content = data["content"] as! String
            
            do{
                let attrStr = try NSAttributedString(data: (content.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                self.newContent.attributedText = attrStr
                self.newContent.font = UIFont.systemFont(ofSize: 17)
            } catch let error as NSError {
                print(error.localizedDescription)
                self.newContent.text = ""
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = CGSize(width: 0, height: 2000)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */
    
    @IBAction func backToList(_ sender: UIBarButtonItem) {
//        self.presentingViewController!.dismiss(animated: true, completion: nil)
        self.navigationController!.popViewController(animated: true)
    }

}
