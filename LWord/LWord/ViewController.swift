//
//  ViewController.swift
//  LWord
//
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblPath: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let ioFile = IOFilesOperation();
        //print("\(nsArr.writeToFile(ioFile.recordFilePath, atomically: true))");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO:append to msgList
    @IBAction func btnCreateMsg(sender: AnyObject) {
        print(IOFilesOperation().recordFilePath);
        var msgArr:MessageObjectsArrary? = MessageObjectsArrary();
        msgArr!.readFileToNSArray();
        let newMsg = MessageObject();
        msgArr!.addNewMessageObjectToTheEnd(newMessageObject: newMsg);
        print(msgArr!.items!);
        //print(newMsg.msgID);
        print(msgArr!.items!.count);
        msgArr = nil;
    }
    
    //清空记录
    @IBAction func btnClearMsg(sender: AnyObject) {
        var msgArr:MessageObjectsArrary? = MessageObjectsArrary();
        do {
            try msgArr!.removeAllRecords();
        }catch {}
        msgArr = nil;
    }
}

