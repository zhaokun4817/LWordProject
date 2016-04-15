//
//  IOFilesControl.swift
//  文件操作类
//
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//


import Foundation


class IOFilesControl {
    //test github
    //文件管理
    private let fManager = NSFileManager.defaultManager();
    
    //根目录
    var homeDirectory: String {
        return NSHomeDirectory();
    }
    
    //临时文件目录
    var tempDirectory: String {
        return NSTemporaryDirectory();
    }
    
    //文档存放目录
    var documentDirectory: String {
        return getWorkDirectory(searchPathDirectory:
                                    NSSearchPathDirectory.DocumentDirectory);
    }
    
    //缓存目录
    var cachesDirctory: String {
        return getWorkDirectory(searchPathDirectory:
                                    NSSearchPathDirectory.CachesDirectory);
    }
    
    //资源文件目录
    var libraryDirectory: String {
        return getWorkDirectory(searchPathDirectory:
                                    NSSearchPathDirectory.LibraryDirectory);
    }
    
    //以文件路径类型获取路径
    private func getWorkDirectory
        (searchPathDirectory pathDirectory: NSSearchPathDirectory) -> String {
        
        return NSSearchPathForDirectoriesInDomains(pathDirectory,
                                NSSearchPathDomainMask.UserDomainMask, true)[0];
    }
    
    //留言的记录文件目录
    private var recordFileDirectory: String {
        return self.documentDirectory + "/Record";
    }
    
    //留言文件的目录是否存在
    private var recordFileDirectoryIsExist: Bool {
        return fManager.fileExistsAtPath(self.recordFileDirectory);
    }
    
    //创建留言文件目录
    private func createRecordFileDirectory() -> Bool {
        var resBool = false;
        
        if !self.recordFileDirectoryIsExist {
            do{
                try fManager.createDirectoryAtPath(self.recordFileDirectory,
                                                   withIntermediateDirectories: true,
                                                   attributes: nil);
                resBool = self.recordFileDirectoryIsExist;
            }catch {
                resBool = false;
            }
        }
        return resBool;
    }
    
    //删除留言文件目录
    private func removeRecordFileDirectory() -> Bool {
        var resBool = false;
        if self.recordFileDirectoryIsExist {
            do {
                try fManager.removeItemAtPath(self.recordFileDirectory);
                //删除了说明已经不存在了，所以取‘是否存在’应该是假，不存在，取非假（真）说明执行成功
                resBool = !self.recordFileDirectoryIsExist;
            }catch {
                resBool = false;
            }
        }
        return resBool;
    }
    
    private var recordFilePath: String {
        return self.recordFileDirectory + "/msgRecord.plist";
    }
    
    //文件是否存在
    private var recordFileIsExist: Bool{
        return fManager.fileExistsAtPath(self.recordFilePath);
    }
    
    //删除留言文件
    func removeRecordFile() -> Bool {
        var resBool = false;
        if self.recordFileIsExist {
            do {
                try fManager.removeItemAtPath(self.recordFilePath);
                //道理同removeFileRecordDirectory方法
                resBool = !self.recordFileIsExist;
            }catch {
                resBool = false;
            }
        }
        return resBool;
    }
    
    //TODO:ReadRecordFile
    //TODO:WriteRecordFile
    
    
}