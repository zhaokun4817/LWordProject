//
//  IOFilesControl.swift
//  文件操作类
//
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//


import Foundation


class IOFilesOperation {
    
    //文件管理
    private let fManager = NSFileManager.defaultManager();
    
    //根目录
    private var homeDirectory: String {
        return NSHomeDirectory();
    }
    
    //临时文件目录
    private var tempDirectory: String {
        return NSTemporaryDirectory();
    }
    
    //文档存放目录
    private var documentDirectory: String {
        return getWorkDirectory(searchPathDirectory:
                                    NSSearchPathDirectory.DocumentDirectory);
    }
    
    //缓存目录
    private var cachesDirctory: String {
        return getWorkDirectory(searchPathDirectory:
                                    NSSearchPathDirectory.CachesDirectory);
    }
    
    //资源文件目录
    private var libraryDirectory: String {
        return getWorkDirectory(searchPathDirectory:
                                    NSSearchPathDirectory.LibraryDirectory);
    }
    
    //以目录类型获取路径
    private func getWorkDirectory
        (searchPathDirectory pathDirectory: NSSearchPathDirectory) -> String {
        
        return NSSearchPathForDirectoriesInDomains(pathDirectory,
                                NSSearchPathDomainMask.UserDomainMask, true)[0];
    }
    
    //留言的记录文件目录
    private var recordFileDirectory: String {
        return self.documentDirectory + "/Record";
    }
    
    //留言记录文件路径
    var recordFilePath: String {
        return self.recordFileDirectory + "/msgRecord.plist";
    }
    
    //判断文件或目录是否存在
    //参数type 是枚举类型的ExistsType中的
    //RecordFileIsExists或者RecordFileDirectoryIsExists
    private func direcotryOrFileIsExist
        (existsType type: ExistsType) -> Bool {
        let path = type == .RecordFileIsExists ?
                                self.recordFilePath :
                                    self.recordFileDirectory;
        return fManager.fileExistsAtPath(path);
    }
    
    //创建文件记录目录
    func createRecordFileDirecotry() -> Bool {
        var resBool = false;
        if !self.direcotryOrFileIsExist(existsType: ExistsType.RecordDirectoryIsExists){
            do{
                try fManager.createDirectoryAtPath(self.recordFileDirectory,
                        withIntermediateDirectories: true, attributes: nil);
                //如果创建成功说执行成功
                resBool = self.direcotryOrFileIsExist(existsType: ExistsType.RecordDirectoryIsExists);
            }catch {
                resBool = false;
            }
        }
        return resBool;
    }
    
    //删除文件或目录
    //参数fileOperationType是文件或目录的操作枚举
    func removeDirectoryOrFile
        (fileOperationType operationType:FileOperationType) -> Bool {
        //返回值
        var resBool = false;
        //文件操作还是目录操作
        let exType = operationType == .FileOperation ?
            ExistsType.RecordFileIsExists :
                ExistsType.RecordDirectoryIsExists;
        
        if(self.direcotryOrFileIsExist(existsType: exType)) {
            do{
                let path = operationType == .DirecotryOperation ?
                    self.recordFileDirectory : self.recordFilePath;
                try fManager.removeItemAtPath(path);
                //如果文件不存在Exist判断就是假，这样取非假 说明删除成功 返回值为真
                resBool = !self.direcotryOrFileIsExist(existsType: exType);
            }catch{
                resBool = false;
            }
        }
        return resBool;
    }
}