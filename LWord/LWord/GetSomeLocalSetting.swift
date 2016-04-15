//
//  GetSomeLocalSetting.swift
//  获取一些本地设置
//
//  Created by 赵堃 on 16/4/12.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

class GetSomeLocalSettings {
    
    var localLanguages: NSArray {
        let usrDefault = NSUserDefaults.standardUserDefaults();
        let lanStr = usrDefault.objectForKey("AppleLanguages")! as! NSArray;
        return lanStr;
    }
    
    var localDefaultLanguage: String {
        return self.localLanguages[0] as! String;
    }
}