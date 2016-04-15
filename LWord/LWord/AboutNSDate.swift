//
//  AboutNSDateControl.swift
//  NSDatef封装
//
//  Created by 赵堃 on 16/4/12.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

class AboutNSDate {
    
    
    ///得到当前时间的字符串
    func getNowTimeString(formatStr formatStr: String)->String {
        let fStr = formatStr == "" ? "yyyy-MM-dd HH:mm:ss" : formatStr;
        let formatter = NSDateFormatter();
        formatter.dateFormat = fStr;
        return formatter.stringFromDate(NSDate());
    }
    
}