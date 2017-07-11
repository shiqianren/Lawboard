
import UIKit

class LWelcomeVC: UIViewController {
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginBtn.layer.cornerRadius = 15
        self.loginBtn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        self.startBtn.layer.cornerRadius = 20
        self.startBtn.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
        self.startBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }*/

    @IBAction func gotoLoginView(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showLoginView", sender: Any?.self)
    }
    
    @IBAction func gotoInterestsView(_ sender: UIButton) {
        performSegue(withIdentifier: "showInterests", sender: self)
    }
}
