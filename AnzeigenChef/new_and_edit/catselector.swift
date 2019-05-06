//
//  catselector.swift
//  AnzeigenChef
//
//  Created by DerDaHinten on 18.05.15.
//  Copyright (c) 2015 Anon. All rights reserved.
//

import Cocoa

class catselector: NSWindowController {
    var catdata : NSDictionary = ["fieldName": "categoryId", "name" : "root", "fieldValue" : "root", "identifier" : "0"]
    var selpath : String = ""
    var selid : String = ""

    @IBOutlet var catlisttable: NSOutlineView!
    @IBOutlet var okButton: NSButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    convenience init(){
        self.init(windowNibName: "catselector")
    }
    
    override func awakeFromNib() {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documents.stringByAppendingPathComponent("ebaykats.ini")
        
        if (FileManager.defaultManager().fileExistsAtPath(path))
        {
            self.catdata = NSDictionary(contentsOfFile: path)!
        } else {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("No categoryfile found, please sync your accounts", comment: "NoAccounts")
            alert.addButton(withTitle: NSLocalizedString("OK", comment: "OK Button"))
            alert.alertStyle = NSAlertStyle.CriticalAlertStyle
            let result = alert.runModal()
        }
        
        self.catlisttable.reloadData()
        if(self.catlisttable.item(atRow: 0) != nil){
            self.catlisttable.expandItem(self.catlisttable.item(atRow: 0))
        }
        
        
    }
    
    @IBAction func okbuttonAction(sender: AnyObject) {
        self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseOK)
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseCancel)
    }
    
    func outlineView(outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet{
        self.okButton.isEnabled = false
        if (proposedSelectionIndexes.count>0){
            let n : NSDictionary = self.catlisttable.item(atRow: proposedSelectionIndexes.firstIndex) as! NSDictionary
            if (n["children"] != nil){
                if ((n["children"] as! NSArray).count==0){
                    self.okButton.isEnabled = true
                }
            } else {
                self.okButton.isEnabled = true
            }
        }
        
        if (self.okButton.isEnabled){
            let cpath : NSMutableArray = []
            let cpathIds : NSMutableArray = []
            var cpathIdsOK : Bool = false
            var currentObj: AnyObject? = self.catlisttable.item(atRow: proposedSelectionIndexes.firstIndex) as AnyObject
            let firstFieldName : String = (currentObj as! NSDictionary)["fieldName"]! as! String
            let firstFieldValue : String = (currentObj as! NSDictionary)["fieldValue"]! as! String
            let firstName : String = (currentObj as! NSDictionary)["name"]! as! String

            cpath.add(firstName)
            cpathIds.insert( firstFieldName + "=" + firstFieldValue, at: 0)
            
            while ((outlineView.parent(forItem: currentObj) as AnyObject).isEqual(self.catdata) == false) {
                let ob: (AnyObject?) = outlineView.parent(forItem: currentObj) as AnyObject
                
                let firstFieldName : String = (ob as! NSDictionary)["fieldName"]! as! String
                let firstFieldValue : String = (ob as! NSDictionary)["fieldValue"]! as! String
                let firstName : String = (ob as! NSDictionary)["name"]! as! String
                
                cpath.insert(firstName , at: 0)
                
                if cpathIdsOK == false {
                    cpathIds.insert( firstFieldName + "=" + firstFieldValue, at: 0)
                }
                
                if firstFieldName == "categoryId" {
                    cpathIdsOK = true
                }
                
                currentObj = ob
            }
            
            self.selid = cpathIds.componentsJoined(by: "|")
            self.selpath = cpath.componentsJoined(by: " -> ")
        }
        
        return proposedSelectionIndexes
    }
    
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if (item == nil){
            return self.catdata
        } else {
            return ((item as! NSDictionary)["children"] as! NSArray).object(at: index) as AnyObject
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let it = item as? NSDictionary {
            if (it["children"] != nil){
                if (it["children"] as! NSArray).count > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if let it = item as? NSDictionary {
            if (it["children"] != nil){
                if (it["children"] as! NSArray).count > 0 {
                    return (it["children"] as! NSArray).count
                }
            }
        }
        return 1
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject?{
        if let it = item as? NSDictionary {
            if (it == catdata) {
                return NSLocalizedString("Categories", comment: "CatselDesc") as AnyObject
            } else {
                return it["name"]
            }
        }
        return nil
    }
    
}
