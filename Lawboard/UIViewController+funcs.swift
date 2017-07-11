//
//  UIViewController+funcs.swift
//  Lawboard
//
//  Created by Saxonzh on 2017/2/18.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import UIKit

// MARK: 扩展后端请求代理方法
extension UIViewController: LawBoardApiDelegate {
    // MARK: 弹出提示信息
    func alert(msg: String) {
        let alertVC = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: 弹出提示信息，在接口调用失败的时候会触发
    func apiRequestError(msg: String) {
        let alertVC = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
