//
//  ViewController.swift
//  LWord
//
//  Created by 赵堃 on 16/4/11.
//  Copyright © 2016年 赵堃. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate,
                                UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var tbDataView: UITableView!
    
    var messageArr:NSMutableArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.firstLaunchApp();
        sbSearch.placeholder = self.getHolderWord();
        // Do any additional setup after loading the view, typically from a nib.
        var msgOp:MessageObjectsArrary? = MessageObjectsArrary();
        msgOp!.readFileToNSArray();
        self.messageArr = msgOp!.items!;
        msgOp = nil;
        //TODO:Bind Data To TableView
    }
    
    //第一次运行app
    private func firstLaunchApp(){
        let isFstLaunch = !NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch");
        if isFstLaunch {
            var ioFile:IOFilesOperation? = IOFilesOperation();
            print(ioFile!.createRecordFileDirecotry());
            ioFile = nil;
            let fstMsg = MessageObject();
            let msgOperation = MessageObjectsArrary();
            do{
                try msgOperation.addNewMessageObjectToTheEnd(newMessageObject: fstMsg);
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch");
            }catch let err as NSError{
                print(err.description);
            }
        }
    }
    
    
    //隐藏状态栏
    /*override func prefersStatusBarHidden() -> Bool {
        return true;
    }*/
    
    
    //注册临听键盘的事件
    override func viewDidAppear(animated: Bool) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyBoardIsShown(_:)),
            name: UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyBoardIsHide(_:)),
            name: UIKeyboardDidHideNotification, object: nil);
    }
    
    //键盘已弹出
    func keyBoardIsShown(noti:NSNotification) {
       
        self.removeAccessoryLayer();
        
        /*let layoutInfo:NSDictionary = noti.userInfo!;
        let keyBoradSize =
            (layoutInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue();*/
        
        //遮盖视图
        let ayView = UIView(frame: CGRect(x: 0, y: sbSearch.bounds.height +
            UIApplication.sharedApplication().statusBarFrame.size.height,
            width: UIScreen.mainScreen().bounds.width,
            height: UIScreen.mainScreen().bounds.height));
        ayView.alpha = 0.2;
        ayView.backgroundColor = UIColor.blackColor();
        ayView.restorationIdentifier = "AccessoryLayer";
        //添加点击事件到遮盖视图
        ayView.userInteractionEnabled = true;
        ayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ayViewTouchDown)));
        //事件添加结束
        self.view.addSubview(ayView);
    }
    
    //点击遮盖视图的事件
    func ayViewTouchDown(){
        if self.sbSearch.isFirstResponder() {
            self.removeAccessoryLayer();
            self.sbSearch.resignFirstResponder();
            self.sbSearch.showsCancelButton = false;
        }
    }
    
    //键盘已隐藏
    func keyBoardIsHide(noti:NSNotification) {
        self.removeAccessoryLayer();
    }
    
    //移除遮盖视图
    private func removeAccessoryLayer(){
        let views = self.view.subviews.filter{
            $0.restorationIdentifier == "AccessoryLayer";
        }
        if views.count > 0 {
            views[0].removeFromSuperview();
        }
    }
    
    //注册了临听键盘的事件
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name:  UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name:  UIKeyboardDidHideNotification, object: nil);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
    
    
    //TODO:Binding To TableView
    private func bindDataToTableView() {
        
    }
    
    //搜索框文本发生变化时调用的方法
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.sbSearch.showsCancelButton = true;
        
        if searchText != "" {
            //使用谓词搜索（NSPredicate）
            let searchCondition = "msgID like[c] %@ or msgDate like[c] %@ or " +
                " msgFromWho like[c] %@ or msgContent like[c] %@ ";
            //*代表了任意字符*keyWord*意思是中间是keyWord,keyWord前后可能还有字符
            let keyWord = "*" + searchText + "*";
            let predicate =
                NSPredicate(format: searchCondition, keyWord, keyWord, keyWord, keyWord);
            let tempArr = self.messageArr.filteredArrayUsingPredicate(predicate);
            print(tempArr.count)
            //TODO:Binding To TableView
            
        }else {
            print("No key word");
        }
    }
    
    
    //Pressed Cancel Button hide keyborad
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = "";
        searchBar.resignFirstResponder();
        searchBar.showsCancelButton = false;
        //TODO:Bind All Data To TableView
        
    }
    
    //Pressed SearchButton On Keyborad
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
        searchBar.showsCancelButton = false;
    }
    
    
    private func getHolderWord() ->String {
        let defaultLanguage = GetSomeLocalSettings().localDefaultLanguage;
        
        if defaultLanguage.hasPrefix("zh-Hans") { //中文简体
           return "查询";
        } else if defaultLanguage.hasPrefix("zh-Hant") {//中文繁体
            return "搜尋";
        } else {         //默认英语
            return "Search";
        }
    }
}

