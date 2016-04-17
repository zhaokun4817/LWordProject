//
//  MessageObjectsArrary.swift
//  LWord
//
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

class MessageObjectsArrary{
    var items: NSMutableArray?;
    
    init(){};
    
    //将新的消息添加到消息列表
    func addNewMessageObjectToTheEnd(newMessageObject newMsgObj: MessageObject) {
        let newNSArr  = [
            "msgID":newMsgObj.msgID, "msgDate":newMsgObj.msgDate,
            "msgFromWho":newMsgObj.msgFromWho, "msgContent":newMsgObj.msgContent
            ];
        self.readFileToNSArray();
        self.items!.addObject(newNSArr);
    }
    
    
    //把留言记录写入文件
    func writeRecordsToFile() throws -> Bool {
        let resBool:Bool;
        
        guard self.checkedMessageObjectsArraryIsNotNull ==
            .TheMessageObjectsArrayIsAllReady else {
                throw self.checkedMessageObjectsArraryIsNotNull;
        }
        
        var ioFile:IOFilesOperation? = IOFilesOperation();
        resBool = self.items!.writeToFile(ioFile!.recordFilePath, atomically: true);
        ioFile = nil;
        return resBool;
    }
    
    //检查留言消息列表是不是为零
    private var checkedMessageObjectsArraryIsNotNull: MessageObjectsArrayWarning {
        let resWarning: MessageObjectsArrayWarning;
        if self.items!.count == 0 {
            resWarning = .TheMessageObjectsArrayIsEmpty;
        }else {
            resWarning = .TheMessageObjectsArrayIsAllReady;
        }
        return resWarning;
    }
    
    //将留言记录文件读取成NSMutableArray
    func readFileToNSArray() {
        self.items = NSMutableArray(contentsOfFile: IOFilesOperation().recordFilePath);
    }
    
    //清空留言文件
    func removeAllRecords() throws -> Bool {
        let resBool:Bool;
        self.readFileToNSArray();
        if self.items!.count > 0 {
            self.items!.removeAllObjects();
            var ioFile:IOFilesOperation? = IOFilesOperation();
            resBool = self.items!.writeToFile(ioFile!.recordFilePath, atomically: true);
            ioFile = nil;
            
            return resBool;
        } else {
            throw MessageObjectsArrayWarning.TheMessageObjectsArrayIsEmpty;
        }
    }
        
    deinit{
        self.items = nil;
    }
    
}




enum MessageObjectsArrayWarning: ErrorType,CustomStringConvertible {
    case TheMessageObjectsArrayIsEmpty;    //空集合
    case TheMessageObjectsArrayIsAllReady; //集合可以使用
    
    var description: String {
        switch self {
        case .TheMessageObjectsArrayIsEmpty:
            return "错误:留言消息的集合为空";
        default:
            return "留言消息的集合可以使用"
        }
    }
}