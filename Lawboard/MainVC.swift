
import UIKit

class MainVC: UIViewController {
    var pageViewController: UIPageViewController!
    
    var newListVC: LNewsListVC!
    var redpaperVC: LRedpaperVC!
    var communityVC: LCommunityVC!
    
    var controllers = [UIViewController]()
    
    var sliderImageView: UIImageView!
    @IBOutlet var sliderView: UIView!
    
    var lastPage = 0
    var currentPage: Int = 0 {
        didSet {
            //根据当前页面计算得到便宜量
            //一个微小的动画移动提示条
            let offset = self.view.frame.width / 3.0 * CGFloat(currentPage)
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.sliderImageView.frame.origin = CGPoint(x: offset, y: -3)
            }
            
            //根据currentPage 和 lastPage的大小关系，控制页面的切换方向
            if currentPage > lastPage {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true, completion: nil)
            }
            else {
                self.pageViewController.setViewControllers([controllers[currentPage]], direction: .reverse, animated: true, completion: nil)
            }
            
            lastPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加提示条到页面中
        sliderImageView = UIImageView(frame: CGRect(x: 0, y: -3, width: self.view.frame.width / 3.0, height: 5.0))
        sliderImageView.image = UIImage(named: "slider")
        sliderView.addSubview(sliderImageView)

        
        newListVC = storyboard?.instantiateViewController(withIdentifier: "LNewsListVCID") as! LNewsListVC
        redpaperVC = storyboard?.instantiateViewController(withIdentifier: "LRedpaperVCID") as! LRedpaperVC
        communityVC = storyboard?.instantiateViewController(withIdentifier: "LCommunityVCID") as! LCommunityVC
        controllers.append(newListVC)
        controllers.append(redpaperVC)
        controllers.append(communityVC)
    
        
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.setViewControllers([newListVC], direction: .forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pageChange(_ sender: UIButton) {
        currentPage = sender.tag - 100
    }
}

extension MainVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: LNewsListVC.self) {
            return newListVC
        }
        else if viewController.isKind(of: LRedpaperVC.self) {
            return redpaperVC
        }
        else if viewController.isKind(of: LCommunityVC.self) {
            return communityVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: LNewsListVC.self) {
            return newListVC
        }
        else if viewController.isKind(of: LRedpaperVC.self) {
            return redpaperVC
        }
        else if viewController.isKind(of: LCommunityVC.self) {
            return communityVC
        }
        return nil
    }
}
