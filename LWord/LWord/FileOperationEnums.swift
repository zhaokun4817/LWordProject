//
//  FileOperationType.swift
//  LWord
//  用以判断文件操作的类型
//  Created by 赵堃 on 16/4/15.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

//文件操作类型
enum FileOperationType: Int {
    case DirecotryOperation;    //目录操作
    case FileOperation;         //文件操作
}

//文件或文件目录是否存在的枚举
enum ExistsType: Int {
    case RecordDirectoryIsExists = 0;//记录文件目录是否存在
    case RecordFileIsExists = 1;     //记录文件是否存在
}