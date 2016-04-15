//
//  MessageObjectsArrary.swift
//  LWord
//
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import Foundation

class MessageObjectsArrary{
    var items: Array<MessageObject>;
    
    init(){
        self.items = Array<MessageObject>();
    }
    
    init(msgObjectsArr moArr:Array<MessageObject> ){
        self.items = moArr;
    }
    
}
