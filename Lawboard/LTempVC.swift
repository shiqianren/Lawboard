//
//  LTempVC.swift
//  Lawboard
//
//  Created by Saxonzh on 2017/3/1.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import UIKit

class LTempVC: UIViewController {
    @IBOutlet var logoutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.logoutBtn.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        self.logoutBtn.layer.cornerRadius = NORMAL_BTN_RADIUS
        self.logoutBtn.addTarget(self, action: #selector(onLogout(sender:)), for: .touchUpInside)
        self.logoutBtn.snp.makeConstraints { make in
            make.height.equalTo(NORMAL_BTN_HEIGHT)
        }
    }
    
    func onLogout(sender: UIButton!) {
        LawBoardStore.instance.removeWechatData()
        LawBoardStore.instance.removeApiData()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "WXLoginNAVVCID") as! WXLoginNAVVC
        
        self.present(loginVC, animated: true, completion: nil)
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
