import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        print("frame:\(self.tabBar.frame)")
		
        self.tabBar.backgroundImage = #imageLiteral(resourceName: "tabbar_bg")
		self.selectedIndex = 1
        //设置 tabBar 图标选中时的颜色
        self.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        for item in self.tabBar.items! {
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
            item.setTitleTextAttributes([
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 16)!
                ], for: .normal)
        }
    }
    
    func imageFromView(myView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(myView.bounds.size, false, UIScreen.main.scale)
        myView.drawHierarchy(in: myView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func tabbarSelect (){
	 self.selectedIndex = 1
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("返回到了首页")
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
