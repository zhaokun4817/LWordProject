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
    var msgID:String;
    //留言日期
    var theMessageDate:String;
    //谁留的言
    var theMessageFromWho: String;
    //留言内容
    var theMessageContent:String;
    
    
    override init(){
        self.msgID = "";
        self.theMessageDate = AboutNSDate().getNowTimeString(formatStr: "");
        self.theMessageFromWho = "";
        self.theMessageContent = "";
        super.init();
    }
    
    init(messageID msgID:String, leaveMsgDate lMsgDate: String, fromWho fWho:String, msgContent msgCon:String) {
        self.msgID = msgID;
        self.theMessageDate = lMsgDate;
        self.theMessageFromWho = fWho;
        self.theMessageContent = msgCon;
        super.init();
    }
    
    deinit{
        self.msgID = "";
        self.theMessageDate = "";
        self.theMessageFromWho = "";
        self.theMessageContent = "";
    }
    
    //TODO:func phoneNumToBlue
    
}