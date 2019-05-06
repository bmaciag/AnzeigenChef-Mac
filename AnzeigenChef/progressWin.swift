//
//  progressWin.swift
//  AnzeigenChef
//
//  Created by DerDaHinten on 19.07.15.
//  Copyright (c) 2015 Anon. All rights reserved.
//

import Cocoa

class progressWin: NSWindowController {

    var mytimer : Timer!
    var doarray : NSMutableArray = []
    var mydb = dbfunc()
    var myhttpcl = httpcl()
    var mustreload = false
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var cancelButton: NSButton!
    
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window!.level = Int(CGWindowLevelForKey(Int32(kCGStatusWindowLevelKey)))
        self.mytimer = Timer.scheduledTimerWithTimeInterval(20, target: self, selector: Selector("checkJob"), userInfo: nil, repeats: true)
    }
    
    convenience init(){
        self.init(windowNibName: "progressWin")
    }
    
    
    func checkJob(){
        if self.cancelButton.isEnabled == false {
            self.doarray.removeAllObjects()
            self.tableView.reloadData()
            self.cancelButton.isEnabled = true
            self.window!.close()
        }
        
        if self.mustreload {
            self.tableView.reloadData()
            self.mustreload = false
        }
        var found : Bool = false
        for i in (0 ... (doarray.count-1)).reversed() {
            if doarray.objectAtIndex(i).objectForKey("status") as! String == "none" {
                let nsdic : [String : String] = doarray.objectAtIndex(i).objectForKey("data")! as! [String : String]
                (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("progress",forKey: "status")
                found = true
                if self.window?.visible == false {
                    self.showWindow(self)
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                    let current_account : String = nsdic["account"]!
                    let current_id : String = nsdic["id"]!
                    let current_itemid : String = nsdic["itemid"]!
                    
                    var dataArray : [[String : String]] = self.mydb.sql_read_accounts("id=" + current_account)
                    if (dataArray.count>0){
                        self.myhttpcl.logout_ebay_account()
                        if (self.myhttpcl.check_ebay_account(dataArray[0]["username"]!, password: dataArray[0]["password"]!)){
                            
                            let ok = self.myhttpcl.addItem(nsdic)
                            if (ok){
                                if current_itemid != "" {
                                    (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("done",forKey: "status")
                                    (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("Update success",forKey: "statustext")
                                } else {
                                    (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("done",forKey: "status")
                                    (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("Inser ad success",forKey: "statustext")
                                }
                            } else {
                                (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("fail",forKey: "status")
                                (self.doarray.objectAtIndex(i) as! NSMutableDictionary).setObject("Operation fails: " + self.myhttpcl.lastError,forKey: "statustext")
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadDataForRowIndexes(NSIndexSet(index: i), columnIndexes: NSIndexSet(index: 0))
                    }
                }
                break
            }
        }
        if !found{
            // ....
        }
    }
    
    

    
    @IBAction func cancelAction(sender: AnyObject) {
        self.cancelButton.isEnabled = false
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int{
        return doarray.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let cell = tableView.make(withIdentifier: "progressWinCell", owner: self) as! progressWinCell?
        
        
        
        let nsdic : [String : String] = (doarray.objectAtIndex(row) as AnyObject).objectForKey("data")! as! [String : String]

        
        cell?.titleLabel.stringValue = nsdic["title"]!
        
        cell?.titleLabel2.stringValue = "Waiting..."
        if ((doarray.objectAtIndex(row) as AnyObject).objectForKey("statustext") != nil){
            cell?.titleLabel2.stringValue = doarray.objectAtIndex(row).objectForKey("statustext") as! String
        }
        
        if (doarray.objectAtIndex(row) as AnyObject).objectForKey("status") as! String == "none" {
            cell?.image.image = NSImage(named: "Open-folder-full")
        }
        
        if (doarray.objectAtIndex(row) as AnyObject).objectForKey("status") as! String == "done" {
            cell?.image.image = NSImage(named: "Open-folder-accept")
        }
        
        if (doarray.objectAtIndex(row) as AnyObject).objectForKey("status") as! String == "fail" {
            cell?.image.image = NSImage(named: "Open-folder-warning")
        }
        
        if (doarray.objectAtIndex(row) as AnyObject).objectForKey("status") as! String == "progress" {
            cell?.image.image = NSImage(named: "Order")
        }
        
        (doarray.objectAtIndex(row) as AnyObject).setObject(cell.image, forKey: "myimage")
        
        return cell
    }
    
}
