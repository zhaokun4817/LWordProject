//
//  MessageObjectBusiness.swift
//  MessageObject业务类
//
//  Created by 赵堃 on 16/4/12.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

class MessageObjectBusiness {
    
    //MARK: 第一个留言
    var theFirstMsg:NSDictionary{
        //初次使用时程序的自动留言
        let fstMsgInfoArr = self.getTheFirstMsgByLocalInfo();
        var fstMsgObj:MessageObject? = MessageObject();
        fstMsgObj!.msgID = fstMsgInfoArr[0];
        fstMsgObj!.theMessageDate = fstMsgInfoArr[1];
        fstMsgObj!.theMessageFromWho = fstMsgInfoArr[2];
        fstMsgObj!.theMessageContent = fstMsgInfoArr[3];
        
        let key = "fstMsgObj";
        let resDict = NSDictionary(object: fstMsgObj!, forKey: key)
        fstMsgObj = nil;
        return resDict;
    }
    
    //MARK:以本地化的语言获取第一个留言信息
    private func getTheFirstMsgByLocalInfo() -> [String] {
        
        var frmWho: String;
        var msgContent: String;
        
        //获取默认语言
        var localSetting: GetSomeLocalSettings? = GetSomeLocalSettings();
        let defaultLanguage = localSetting!.localDefaultLanguage;
        localSetting = nil;//析构
        
        //由默认语言设置信息文本
        switch defaultLanguage {
        case "zh-Hans-US": //中文简体
            frmWho = "开发者";
            msgContent = "您好！非常感谢您使用LWord留言工具，如果您对LWord有任何改进" +
                    "建议或者您有任何好的主意都可以E-Mail至:zhaokun4817@gmail.com。" +
                    "最后再次感谢您选择了LWord!";
            
        case "zh-Hant-US": //中文繁体
            frmWho = "開發者";
            msgContent = "您好！非常感謝您使用LWord留言工具，如果您對LWord有任何改進" +
                    "建議或者您有任何好的主意都可以E-Mail至:zhaokun4817@gmail.com。" +
                    "最後再次感謝您選擇了LWord!";
            
        default:           //默认英语
            frmWho = "Developer";
            msgContent = "Dear User!Thanks very much for you choice this " +
                    "'LWord' app, if you have any suggest or any good ideas " +
                    "please E-Mail to:zhaokun4817@gmail.com.Before end of this " +
                    "message,thanks for your choice 'LWord' again! Have a good day!";
        }
        
        var abDate: AboutNSDate? = AboutNSDate();
        let resArr = [ abDate!.getNowTimeString(formatStr: "yyyyMMddHHmmss"),
                      abDate!.getNowTimeString(formatStr: ""),
                      frmWho,msgContent ];
        abDate = nil;
        return resArr;
    }
}