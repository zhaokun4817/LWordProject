//
//  MessageObject.swift
//  This Class 'MessageObject' is Message entity object class
//  It's inherits NSObject
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

class MessageObject: NSObject{
    
    //留言id
    var msgID:String = "";
    //留言日期
    var msgDate:String = "";
    //谁留的言
    var msgFromWho: String = "";
    //留言内容
    var msgContent:String = "";
    
    ///使用不带参数的初始化会初始化一个有本地特征的TheFirstMesssage
    ///为了不重复的调用byLocalInfo方法尽量使用带参数的初始化
    override init(){
        super.init();
        let fstMsg = self.theFirstMsgByLocalInfo();
        self.msgID = fstMsg[0];
        self.msgDate = fstMsg[1];
        self.msgFromWho = fstMsg[2];
        self.msgContent = fstMsg[3];
    }
    
    init(messageID msgID:String, leaveMsgDate lMsgDate: String, fromWho fWho:String, msgContent msgCon:String) {
        self.msgID = msgID;
        self.msgDate = lMsgDate;
        self.msgFromWho = fWho;
        self.msgContent = msgCon;
        super.init();
    }
    
    
    //检查消息是否可用
    private var checkMessageNotNull: MessageWarning
    {
        let msgWarning:MessageWarning;
        
        if self.msgID == "" {
            msgWarning = MessageWarning.MessageIDNeedToSet;
        }
        else {
            if self.msgDate == "" {
                msgWarning = MessageWarning.MessageDateNeedToSet;
            }
            else{
                if self.msgFromWho == "" {
                    msgWarning = MessageWarning.MessageFromWhoNeedToSet;
                }else {
                    if self.msgContent == "" {
                        msgWarning = MessageWarning.MessageContentNeedToSet;
                    }
                    else {
                        msgWarning = MessageWarning.MessageIsAllReady;
                    }
                }
            }
        }
        
        return msgWarning;
    }
    
    deinit{
        self.msgID = "";
        self.msgDate = "";
        self.msgFromWho = "";
        self.msgContent = "";
    }
    
    //MARK:以本地化的语言初始化第一个留言信息
    private func theFirstMsgByLocalInfo() -> [String] {
        
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
        let fstMessage = [abDate!.getNowTimeString(formatStr: "yyyyMMddHHmmss"),
                                       abDate!.getNowTimeString(formatStr: ""),
                                        frmWho, msgContent];
        
        abDate = nil;
        return fstMessage;
    }
    
    //TODO:func phoneNumToBlue
}

//消息错误的枚举
enum MessageWarning: ErrorType,CustomStringConvertible {
    case MessageIDNeedToSet //= "错误:需要设置消息ID";
    case MessageDateNeedToSet //= "错误:需要设置消息的日期";
    case MessageFromWhoNeedToSet //= "错误:需要设置留言者";
    case MessageContentNeedToSet //= "错误:需要设置消息内容";
    case MessageIsAllReady //= "消息实体可以使用";
    
    var description: String{
        switch self {
        case.MessageIDNeedToSet:
            return "错误:需要设置消息ID";
        case .MessageDateNeedToSet:
            return "错误:需要设置消息的日期";
        case .MessageFromWhoNeedToSet:
            return "错误:需要设置留言者";
        case .MessageContentNeedToSet:
            return "错误:需要设置消息内容";
        default:
            return "消息实体可以使用";
        }
    }
}


