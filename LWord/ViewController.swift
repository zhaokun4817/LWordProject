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
        
        
        /*var alert:UIAlertController? = UIAlertController(title: "runtime", message: "第\(AppDelegate.runtime)次运行", preferredStyle: UIAlertControllerStyle.Alert);
        alert!.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(alert!, animated: true, completion: nil);
        
        alert = nil;
        
        alert = UIAlertController(title: "WriteFile", message: "写入文件\(AppDelegate.writeFileBool)",
                                  preferredStyle: UIAlertControllerStyle.Alert);
        alert!.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(alert!, animated: true, completion: nil);
        alert = nil;*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

