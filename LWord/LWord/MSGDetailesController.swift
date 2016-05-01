//
//  MSGDetailesController.swift
//  LWord
//
//  Created by 赵堃 on 16/4/30.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import UIKit

class MSGDetailesController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var lblFromWho: UILabel!
    @IBOutlet weak var lblMsgDate: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    var msgObject:MessageObject! = MessageObject();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.lblFromWho.text = msgObject.msgFromWho;
        self.lblMsgDate.text = msgObject.msgDate;
        self.txtView.text = msgObject.msgContent;
        
        self.txtView.editable = false;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
