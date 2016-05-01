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
    @IBOutlet weak var btnDelRecords: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var messageArr:NSArray = [];
    var bindArr:NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstLaunch");
        print(IOFilesOperation().recordFilePath);
        self.toolBar.hidden = true;
        self.btnDelRecords.hidden = true;
        
        self.firstLaunchApp();
        
        sbSearch.placeholder = self.getHolderWord();
        
        
        var msgOp:MessageObjectsOperation? = MessageObjectsOperation();
        msgOp!.readFileToNSArray();
        self.messageArr = msgOp!.items!;
        bindArr = self.messageArr;
        msgOp = nil;
        
        self.tbDataView.delegate = self;
        self.tbDataView.dataSource = self;
    }
    
    //第一次运行app
    private func firstLaunchApp(){
        let isFstLaunch = !NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch");
        if isFstLaunch {
            var ioFile:IOFilesOperation? = IOFilesOperation();
            ioFile!.createRecordFileDirecotry();
            ioFile = nil;
            let fstMsg = MessageObject();
            let msgOperation = MessageObjectsOperation();
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
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ViewController.keyBoardIsShown(_:)),
            name: UIKeyboardDidShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(ViewController.keyBoardIsHide(_:)),
            name: UIKeyboardDidHideNotification, object: nil);
    }
    
    //键盘已弹出
    func keyBoardIsShown(noti:NSNotification) {
       
        self.removeAccessoryLayer();
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
        ayView.addGestureRecognizer(UITapGestureRecognizer(target: self,
            action: #selector(ayViewTouchDown)));
        //事件添加结束
        self.view.addSubview(ayView);
    }
    
    //点击遮盖视图的事件
    func ayViewTouchDown(){
        if self.sbSearch.isFirstResponder() {
            self.removeAccessoryLayer();
            self.sbSearch.resignFirstResponder();
            self.sbSearch.showsCancelButton = false;
            self.tbDataView.reloadData();
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
    
    //注销了临听键盘的事件
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
        return bindArr.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //这个id很重要，要和在故事板中设置的一样
        
        let cellID = "MyTableViewCell";
        let tabCell:MyUITableViewCell =
            self.tbDataView.dequeueReusableCellWithIdentifier(cellID) as! MyUITableViewCell ;
        let dictSoruce = (bindArr[indexPath.row] as? NSDictionary)!;
        tabCell.lblMsgID?.text = dictSoruce.valueForKey("msgID") as? String;
        tabCell.lblMsgID?.hidden = true;
        tabCell.lblMsgFromWho?.text = dictSoruce.valueForKey("msgFromWho") as? String;
        tabCell.lblMsgDate?.text = dictSoruce.valueForKey("msgDate") as? String;
        tabCell.lblMsgContent?.text = dictSoruce.valueForKey("msgContent") as? String;
        
        //添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(_:)));
        longPress.minimumPressDuration = 1;
        tabCell.contentView.addGestureRecognizer(longPress);
        return tabCell;
    }
    
    //响应单元格长按事件
    func cellLongPress(lPress:UILongPressGestureRecognizer){
        if lPress.state == .Began{
            self.tbDataView.editing = true;
            self.toolBar.hidden = false;
            self.btnDelRecords.hidden = false;
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard self.tbDataView.editing == false else { return; }   

        //可以理解为获取第二个界面对像
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let msgDetailesController =
            sb.instantiateViewControllerWithIdentifier("msgDetailes")
                as! MSGDetailesController
        
        msgDetailesController.msgObject?.msgID =
            (self.tbDataView.cellForRowAtIndexPath(indexPath)
                as! MyUITableViewCell).lblMsgID!.text!
        msgDetailesController.msgObject?.msgFromWho =
            (self.tbDataView.cellForRowAtIndexPath(indexPath)
                as! MyUITableViewCell).lblMsgFromWho!.text!
        msgDetailesController.msgObject?.msgDate =
            (self.tbDataView.cellForRowAtIndexPath(indexPath)
                as! MyUITableViewCell).lblMsgDate!.text!
        msgDetailesController.msgObject?.msgContent =
            (self.tbDataView.cellForRowAtIndexPath(indexPath)
                as! MyUITableViewCell).lblMsgContent!.text!
        
        self.presentViewController(msgDetailesController, animated: true, completion: nil);
    }
    
    //滑动删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            var opMsg:MessageObjectsOperation? = MessageObjectsOperation();
            do{
                switch bindArr.count {
                case 1:
                    try opMsg!.removeAllRecords();
                default:
                    try opMsg!.removeOneRecordAtIndex(index: indexPath.row);
                }
                opMsg!.readFileToNSArray();
                self.messageArr = opMsg!.items!;
                opMsg = nil;
                bindArr = self.messageArr;
                self.tbDataView.reloadData();
            }catch {}
        }
    }
    //点击删除按钮
    @IBAction func btnDelRecordsClick(sender: AnyObject) {
        guard self.tbDataView.editing else { return; }
        guard self.tbDataView.indexPathsForSelectedRows?.count > 0 else { return; }
        
        var msgOperation:MessageObjectsOperation? = MessageObjectsOperation();
        
        //如果是全选
        if self.tbDataView.indexPathsForSelectedRows!.count ==
            bindArr.count {
            do {
                try msgOperation!.removeAllRecords();
                self.toolBar.hidden = true;
                self.btnDelRecords.hidden = true;
                self.tbDataView.editing = false;
            }catch{}
        }else {
            //获取已选中的记录id map搜索
            let msgIDArr = self.tbDataView.indexPathsForSelectedRows!.map{
                (((self.tbDataView.cellForRowAtIndexPath($0)) as!
                    MyUITableViewCell).lblMsgID?.text!)!;
            };
            msgOperation!.removeRecordsByMsgIDArray(msgIDArr: msgIDArr)
        }
        
        self.messageArr = msgOperation!.items!;
        bindArr = self.messageArr;
        msgOperation = nil;
        
        self.tbDataView.reloadData();
    }
    
    //搜索框文本发生变化时调用的方法
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            bindArr = self.messageArr;
            return;
        }
        self.sbSearch.showsCancelButton = true;
        //使用谓词搜索（NSPredicate）
        let searchCondition = "msgID like[c] %@ or msgDate like[c] %@ or " +
        " msgFromWho like[c] %@ or msgContent like[c] %@ ";
        //*代表了任意字符*keyWord*意思是中间是keyWord,keyWord前后可能还有字符
        let keyWord = "*" + searchText + "*";
        let predicate =
            NSPredicate(format: searchCondition, keyWord, keyWord, keyWord, keyWord);
        bindArr = self.messageArr.filteredArrayUsingPredicate(predicate) as NSArray;
        self.tbDataView.reloadData();
    }
    
    //全选按钮
    @IBAction func tbBtnSelectAll(sender: AnyObject) {
        for row in 0 ..< bindArr.count {
            let ind = NSIndexPath(forRow: row, inSection: 0)
            self.tbDataView.selectRowAtIndexPath(ind, animated: false,
                                                 scrollPosition: UITableViewScrollPosition.None)
        }
    }
    //取消按钮
    @IBAction func tbBtnCancel(sender: AnyObject) {
        self.tbDataView.editing = false;
        self.toolBar.hidden = true;
        self.btnDelRecords.hidden = true;
    }
    
    
    //Pressed Cancel Button hide keyborad
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = "";
        searchBar.resignFirstResponder();
        searchBar.showsCancelButton = false;
        bindArr = self.messageArr;
        self.tbDataView.reloadData();
    }
    
    //Pressed SearchButton On Keyborad
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder();
        searchBar.showsCancelButton = false;
        self.tbDataView.reloadData();
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

