//
//  NewModel.swift
//  Lawboard
//
//  Created by shiqianren on 2017/5/5.
//  Copyright © 2017年 Saxonzh. All rights reserved.
//

import Foundation
struct NewModel {
	
	var newId: Int
	var mediaImage: String
	var newTitle: String
	var newSummary: String
	var recommendTime :Double
	var readed :Int
	var site :String
	var isAdv :String
	init(data: [String:Any]) {
		self.newId = data["id"] as! Int
		self.mediaImage =  data["first_image"] as! String
		self.newTitle = data["title"] as! String
		self.newSummary = data["content"] as! String
		self.recommendTime = data["createTime"] as! Double
		self.readed = data["readed"] as! Int
		self.site = data["site"] as! String
		self.isAdv = data["isAdv"] as! String
	}
	
	
}
