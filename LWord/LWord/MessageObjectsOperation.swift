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
    func addNewMessageObjectToTheEnd(newMessageObject newMsgObj: MessageObject) throws {
        let newNSArr  = [
            "msgID":newMsgObj.msgID, "msgDate":newMsgObj.msgDate,
            "msgFromWho":newMsgObj.msgFromWho, "msgContent":newMsgObj.msgContent
            ];
        do {
            self.readFileToNSArray();
            self.items!.addObject(newNSArr);
            try self.writeNSArrayToFile();
        }catch let err as MessageObjectsArrayWarning {
            throw err;
        }
    }
    
    
    //把留言记录写入文件
    private func writeNSArrayToFile() throws -> Bool {
        let resBool:Bool;
        
        guard self.checkedMessageObjectsArraryIsNotNull ==
            .TheMessageObjectsArrayIsAllReady else {
                throw self.checkedMessageObjectsArraryIsNotNull;
        }
        
        var ioFile:IOFilesOperation? = IOFilesOperation();
        resBool = self.items!.writeToFile(ioFile!.recordFilePath, atomically: true);
        ioFile = nil;
        self.items = nil;
        return resBool;
    }
    
    //将留言记录文件读取成NSMutableArray
    func readFileToNSArray()  {
        self.items = NSMutableArray(contentsOfFile: IOFilesOperation().recordFilePath);
        guard self.items != nil else {
            self.items = NSMutableArray();
            return;
        }
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
    
    
    
    //根据索引删除一条记录
    func removeOneRecordAtIndex(index ind:Int) throws -> Bool {
        let resBool: Bool;
        do {
            self.readFileToNSArray();
            let oldCount = self.items!.count;
            
            self.items!.removeObjectAtIndex(ind);
            
            try self.writeNSArrayToFile();
            self.readFileToNSArray();
            let newCount = self.items!.count;
            resBool = ((oldCount - newCount) == 1 ? true : false);
            self.items = nil;
            return resBool;
        }catch let err as MessageObjectsArrayWarning {
            throw err;
        }
    }
    
    //根据msgID删除一条记录
    func removeOneRecordByMessageID(messageID msgID: String) throws -> Bool {
        let resBool:Bool;
        do {
            self.readFileToNSArray();
            let oldCount = self.items!.count;
            
            //search for the item by the msgID is equal
            let item = self.items!.filter{ $0["msgID"] as! String == msgID; }[0];
            self.items!.removeObject(item);
            
            try self.writeNSArrayToFile();
            self.readFileToNSArray();
            let newCount = self.items!.count;
            resBool = ((oldCount - newCount) == 1 ? true : false);
            self.items = nil;
            return resBool;
        } catch let err as MessageObjectsArrayWarning {
            throw err;
        }
    }
    
    //search by keyword
    func searchMessagesByKeyword(keyword kword: String) throws -> NSArray? {
        guard kword != "" else {
            throw MessageObjectsArrayWarning.TheMessageObjectsArrayIsEmpty
        }
        self.readFileToNSArray();
        let searchStr = "msgID like[c] " + kword +
            "* or msgDate like[c] " + kword + "* or msgFromWho like[c] " + kword +
            "* or msgContent like[c] " + kword + "*";
        let predicate = NSPredicate(format: searchStr);
        let resArr = self.items!.filteredArrayUsingPredicate(predicate);
        return resArr;
    }
    
    //TODO:删除一组留言记录
    
    //清空留言文件
    func removeAllRecords() throws -> Bool {
        var resBool = false;
        self.readFileToNSArray();
        if self.items!.count > 0 {
            var ioFile: IOFilesOperation? = IOFilesOperation();
            resBool = NSMutableArray().writeToFile(ioFile!.recordFilePath, atomically: true);
            ioFile = nil;
        }
        return resBool;
    }
    
        
    deinit{
        self.items = nil;
    }
    
}

//一些消息队列的错误枚举
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