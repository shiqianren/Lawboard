//
//  NSCalendar+Extension.swift
//  ShareLibrary-swift
//
//  Created by wansy on 15/12/21.
//  Copyright © 2015年 com.hengtiansoft. All rights reserved.
//

import Foundation
struct DateFormater {
	static let YMD = "yyyy-MM-dd"
	static let otherYMD = "yyyyMMdd"
	static let MD = "MM-dd"
	static let YMDHMS = "yyyy-MM-dd HH:mm:ss"
	static let HM = "HH:mm"
	static let HMS = "HH:mm:ss"
}
extension NSDate {
    
    private class func calendar() ->NSCalendar!
    {
        var cal = NSCalendar.current
        cal.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
        return cal as NSCalendar!;
    }
	
	
    
    /**
     比较两个日期的年月日是不是相同
	
     - parameter date: 被比较的时间
     
     - returns: ture(是)/false(否)
     */
 
    /**
     判断是不是今天
     
     - returns: ture(是)/false(否)
     */
 
    /**
     根据日期返回几号
     
     - returns: day
     */
    func day() -> Int
    {
        let components:NSDateComponents = NSDate.calendar().components(NSCalendar.Unit.day, from: self as Date) as NSDateComponents
        return components.day
    }
    
    /**
     根据日期返回星期几
     
     - returns: weekDay
     */
    func weekDay() -> Int
    {
        let components:NSDateComponents = NSDate.calendar().components(NSCalendar.Unit.weekday, from: self as Date) as NSDateComponents
        return components.weekday - 1
    }
    
    /**
     根据日期返回月份
     
     - returns: month
     */
    func month() -> Int
    {
        let components:NSDateComponents = NSDate.calendar().components(NSCalendar.Unit.month, from: self as Date) as NSDateComponents
        return components.month
    }
    
    /**
     根据日期返回年份
     
     - returns: year
     */
	
    /**
     获取标准时间（yyyy-MM-dd 00:00:00）
     
     - returns: 标准时间
     */
    func standardizationDate() ->NSDate
    {
        let dateStr = self.stringFormDate(date: self,formatter: DateFormater.YMD)
        return self.dateFromString(string: dateStr)
    }
	/**
	将string转化成指定格式的date
	
	- parameter string:    要转换的string
	- parameter formatter: 转化的格式 (默认格式为"yyyy-MM-dd HH:mm:ss")
	
	- returns: 转换好的date
	*/
	 func dateFromString(string:String,formatter:String = DateFormater.YMDHMS) ->NSDate
	{
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
		dateFormatter.dateFormat = formatter
		return dateFormatter.date(from: string)! as NSDate
	}
	/**
	将date转化成指定格式的string
	
	- parameter date:      要转化的date
	- parameter formatter: 转化的格式 (默认格式为"yyyy-MM-dd HH:mm:ss")
	
	- returns: 转化好的string
	*/
    func stringFormDate(date:NSDate,formatter:String = DateFormater.YMDHMS) ->String
	{
		let dateFormatter = DateFormatter()
		
		dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
		dateFormatter.dateFormat = formatter
		return dateFormatter.string(from: date as Date)
	}
	
	/**
	时间戳转时间
	
	
	:param: timeStamp <#timeStamp description#>
	
	:returns: return time
	*/
	 func timeStampToString(timeStamp:Double)->String {
		
		//let string = NSString(string: timeStamp)
		let timeSta:TimeInterval = timeStamp
		let dfmatter = DateFormatter()
		dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		let date = NSDate(timeIntervalSince1970: timeSta)
		
		print(dfmatter.string(from: date as Date))
		return dfmatter.string(from: date as Date)
	}
	
}
