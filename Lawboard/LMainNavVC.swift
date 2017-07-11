import UIKit

class LMainNavVC: UINavigationController {
    var tag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        switch self.tag {
        case 100:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LMyPrizeResultVCID") as! LMyPrizeResultVC
            self.navigationController?.pushViewController(vc, animated: false)
            break;
        default:
            break;
        }
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

}
