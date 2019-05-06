//
//  new_edit_search.swift
//  AnzeigenChef
//
//  Created by DerDaHinten on 01.06.15.
//  Copyright (c) 2015 Anon. All rights reserved.
//

import Cocoa

class new_edit_search: NSWindowController,NSTextFieldDelegate {

    @IBOutlet var ownurl: NSTextField!
    @IBOutlet var menuname: NSTextField!
    @IBOutlet var searchactive: NSButton!
    @IBOutlet var postalcode: NSTextField!
    @IBOutlet var distance: NSComboBox!
    @IBOutlet var query: NSTextField!
    @IBOutlet var okbutton: NSButton!
    @IBOutlet var fromPrice: NSTextField!
    @IBOutlet var toPrice: NSTextField!
    
    var catSel : catselector!
    @IBOutlet var catSelButton: NSButton!
    
    var mydb = dbfunc()
    var currentEditId = ""
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
    
    convenience init(){
        self.init(windowNibName: "new_edit_search")
    }
    
    override func awakeFromNib() {
        distance.removeAllItems()
        distance.addItem(withObjectValue: NSLocalizedString("All", comment: "Show all search results"))
        distance.addItem(withObjectValue: NSLocalizedString("5 km", comment: "Show 5km"))
        distance.addItem(withObjectValue: NSLocalizedString("10 km", comment: "Show 10km"))
        distance.addItem(withObjectValue: NSLocalizedString("20 km", comment: "Show 20km"))
        distance.addItem(withObjectValue: NSLocalizedString("30 km", comment: "Show 30km"))
        distance.addItem(withObjectValue: NSLocalizedString("50 km", comment: "Show 50km"))
        distance.addItem(withObjectValue: NSLocalizedString("100 km", comment: "Show 100km"))
        distance.addItem(withObjectValue: NSLocalizedString("150 km", comment: "Show 150km"))
        distance.addItem(withObjectValue: NSLocalizedString("200 km", comment: "Show 200km"))
        distance.selectItem(at: 0)
        self.catSelButton.toolTip = ""
 
        
        if (self.currentEditId != ""){
            var ndata = self.mydb.sql_read_select(sqlStr: "SELECT * FROM searchquery WHERE id='" + self.currentEditId + "'")
            catSelButton.toolTip = ndata[0]["category"]!
            catSelButton.title = ndata[0]["category_text"]!
            query.stringValue = ndata[0]["query"]!
            postalcode.stringValue = ndata[0]["ziporcity"]!
            menuname.stringValue = ndata[0]["desc"]!
            ownurl.stringValue = ndata[0]["ownurl"]!
            fromPrice.stringValue = ndata[0]["fromprice"]!
            toPrice.stringValue = ndata[0]["toprice"]!
            
            let dist : String = ndata[0]["distance"]!
            
            // 0 is already selected
            if dist == "5" {
                distance.selectItem(at: 1)
            } else if dist == "10" {
                distance.selectItem(at: 2)
            } else if dist == "20" {
                distance.selectItem(at: 3)
            } else if dist == "30" {
                distance.selectItem(at: 4)
            } else if dist == "50" {
                distance.selectItem(at: 5)
            } else if dist == "100" {
                distance.selectItem(at: 6)
            } else if dist == "150" {
                distance.selectItem(at: 7)
            } else if dist == "200" {
                distance.selectItem(at: 8)
            } else {
                distance.selectItem(at: 0)
            }
            
            if ndata[0]["active"]! == "1" {
                self.searchactive.state = NSOnState
            } else {
                self.searchactive.state = NSOffState
            }
            
            self.checkup()
        }
    }
    
    @IBAction func okaction(sender: AnyObject) {
        
        
        if (self.currentEditId != ""){
            var sqlarray : NSMutableArray = []
            sqlarray.add("category='" + self.catSelButton.toolTip! + "'")
            sqlarray.add("category_text='" + self.catSelButton.title + "'")
            sqlarray.addObject("query=" + self.mydb.quotedstring(identifier: self.query.stringValue))
            sqlarray.addObject("desc=" + self.mydb.quotedstring(identifier: self.menuname.stringValue))
            sqlarray.addObject("ziporcity=" + self.mydb.quotedstring(identifier: self.postalcode.stringValue))
            
            if distance.indexOfSelectedItem == 0 {
                sqlarray.add("distance=0")
            } else if distance.indexOfSelectedItem == 1 {
                sqlarray.add("distance=5")
            } else if distance.indexOfSelectedItem == 2 {
                sqlarray.add("distance=10")
            } else if distance.indexOfSelectedItem == 3 {
                sqlarray.add("distance=20")
            } else if distance.indexOfSelectedItem == 4 {
                sqlarray.add("distance=30")
            } else if distance.indexOfSelectedItem == 5 {
                sqlarray.add("distance=50")
            } else if distance.indexOfSelectedItem == 6 {
                sqlarray.add("distance=100")
            } else if distance.indexOfSelectedItem == 7 {
                sqlarray.add("distance=150")
            } else if distance.indexOfSelectedItem == 8 {
                sqlarray.add("distance=200")
            } else {
                sqlarray.add("distance=0")
            }
            
            if self.searchactive.state == NSOnState {
                sqlarray.add("active=1")
            } else {
                sqlarray.add("active=0")
            }
            
            sqlarray.addObject("ownurl=" + self.mydb.quotedstring(identifier: self.ownurl.stringValue))
            
            sqlarray.addObject("fromprice=" + self.mydb.quotedstring(identifier: String(self.fromPrice.integerValue)))
            sqlarray.addObject("toprice=" + self.mydb.quotedstring(identifier: String(self.toPrice.integerValue)))
            
            if self.mydb.executesql(sqlStr: "UPDATE searchquery SET " + sqlarray.componentsJoinedByString(", ") + " WHERE id=" + self.currentEditId) {
                self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseOK)
            } else {
                println("NO!")
            }
            
        } else {
            var sqlarray : NSMutableArray = []
            var sqlstart = "INSERT INTO searchquery (category,category_text,query,desc,ziporcity,distance,active,ownurl,fromprice,toprice) VALUES ("
            sqlarray.addObject(self.mydb.quotedstring(identifier: self.catSelButton.toolTip!))
            sqlarray.addObject(self.mydb.quotedstring(identifier: self.catSelButton.title))
            sqlarray.addObject(self.mydb.quotedstring(identifier: self.query.stringValue))
            sqlarray.addObject(self.mydb.quotedstring(identifier: self.menuname.stringValue))
            sqlarray.addObject(self.mydb.quotedstring(identifier: self.postalcode.stringValue))
            
            if distance.indexOfSelectedItem == 0 {
                sqlarray.add("0")
            } else if distance.indexOfSelectedItem == 1 {
                sqlarray.add("5")
            } else if distance.indexOfSelectedItem == 2 {
                sqlarray.add("10")
            } else if distance.indexOfSelectedItem == 3 {
                sqlarray.add("20")
            } else if distance.indexOfSelectedItem == 4 {
                sqlarray.add("30")
            } else if distance.indexOfSelectedItem == 5 {
                sqlarray.add("50")
            } else if distance.indexOfSelectedItem == 6 {
                sqlarray.add("100")
            } else if distance.indexOfSelectedItem == 7 {
                sqlarray.add("150")
            } else if distance.indexOfSelectedItem == 8 {
                sqlarray.add("200")
            } else {
                sqlarray.add("0")
            }
            
            if self.searchactive.state == NSOnState {
                sqlarray.add("1")
            } else {
                sqlarray.add("0")
            }
            
            sqlarray.addObject(self.mydb.quotedstring(identifier: self.ownurl.stringValue))
            sqlarray.addObject(self.mydb.quotedstring(identifier: String(self.fromPrice.integerValue)))
            sqlarray.addObject(self.mydb.quotedstring(identifier: String(self.toPrice.integerValue)))
            
            if self.mydb.executesql(sqlStr: sqlstart + sqlarray.componentsJoinedByString(", ") + ")") {
                self.currentEditId = String(self.mydb.lastId())
                self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseOK)
            } else {
                println("NO!")
            }
        }
        
        
        
    }
    
    @IBAction func cancelaction(sender: AnyObject) {
        self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseCancel)
    }
    
    @IBAction func selectcataction(sender: AnyObject) {
        if (self.catSel == nil) {
            self.catSel = catselector();
        }
        
        self.window!.beginSheet(self.catSel.window!, completionHandler: {(returnCode) -> Void in
            if (returnCode == NSModalResponseOK){
                self.catSelButton.toolTip = self.catSel.selid
                self.catSelButton.title = self.catSel.selpath
                self.checkup()
            }
        });
    }
    
    override func controlTextDidChange(obj: NSNotification){
        self.checkup()
    }
    
    func checkup(){
        if (menuname.stringValue != "" && ownurl.stringValue != "") {
            okbutton.isEnabled = true
            return
        }
        
        if (menuname.stringValue != "" && postalcode.stringValue != "" && query.stringValue != "" && self.catSelButton.toolTip != "" && distance.indexOfSelectedItem >= 0){
            okbutton.isEnabled = true
        } else {
            okbutton.isEnabled = false
        }
    }
}
