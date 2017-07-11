//
//  ImageTool.swift
//  Lawboard
//
//  Created by shiqianren on 2017/5/11.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import Foundation

class ImageTool: NSObject {
	
	// const
	static let IMG_URL = "splash_img_url"
	static let ACT_URL = "splash_act_url"
	static let IMG_PATH = String(format: "%@/Documents/splash_image.jpg", NSHomeDirectory())
	
	
	class func isExistsSplashData() -> Bool{
		let latestImgUrl = UserDefaults.standard.value(forKey: IMG_URL) as? String
		let isFileExists = FileManager.default.fileExists(atPath: IMG_PATH)
		
		return nil != latestImgUrl && isFileExists
	}
	
	class func updateSplashData(imgUrl: String?, actUrl: String?) {
		if nil == imgUrl {
			// no data
			return
		}
		UserDefaults.standard.setValue(imgUrl, forKey: IMG_URL)
		UserDefaults.standard.synchronize()
		DispatchQueue.global().async {
			do {
				guard let url = URL.init(string: imgUrl!) else {
					return
				}
				let data = try Data.init(contentsOf: url)
				if let image = UIImage.init(data: data) {
					do {
						try UIImagePNGRepresentation(image)?.write(to: URL.init(string: IMG_PATH)!)
						
					}catch {
						print(error)
					}
				}
			}catch {
				
			}
		}
	}

	
	
	
	
	
	static func getfilePath(imgName: String) -> String {
		
		let arrayPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		
		let imgPath = arrayPaths[0].appending(imgName)
		return imgPath
	}
	
	
	static func isFileExits(filePath:String) -> Bool{
	let fileManager = FileManager.default
	 return fileManager.fileExists(atPath: filePath)
		
	}
	
	
	static func downloadImage(imageUrl: String,iamgeName:String) {
		DispatchQueue.global().async {
			do {
				guard let url = URL.init(string: imageUrl) else {
					return
				}
				let data = try Data.init(contentsOf: url)
				if let image = UIImage.init(data: data) {
					do {
						let loacalPath = self.getfilePath(imgName: iamgeName)
						try UIImagePNGRepresentation(image)?.write(to: URL.init(string: loacalPath)!)
						
						self.deleteOldImage()
						print("保存成功")
						UserDefaults.standard.set(iamgeName, forKey: "adImageName")
						
					}catch {
						print(error)
					}
				}
			}catch {
				
			}
		}
	}
	
	static func deleteOldImage() {
		let iamgeName = UserDefaults.standard.value(forKey: "adImageName")
		if (iamgeName != nil) {
		  let filePath = self.getfilePath(imgName: iamgeName as! String)
			do {
			try  FileManager.default.removeItem(atPath: filePath)
			}catch {

			}
		}
	
	}
}
