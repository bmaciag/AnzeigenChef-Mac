//
//  new_edit_ebay.swift
//  AnzeigenChef
//
//  Created by DerDaHinten on 14.05.15.
//  Copyright (c) 2015 Anon. All rights reserved.
//

import Cocoa

class new_edit_ebay: NSWindowController {
    
    var editId = ""
    var currentfolder : Int = -10
    var mydb = dbfunc()
    var dataArray : NSArray = []
    var catSel : catselector!
    var picsel : picselect!
    var imglist : NSMutableArray = []

    @IBOutlet var catSelButton: NSButton!
    @IBOutlet var adType: NSMatrix!
    @IBOutlet var adTitle: NSTextField!
    
    @IBOutlet var adPrice: NSTextField!
    @IBOutlet var adDesc: NSTextView!
    
    @IBOutlet var adPriceType: NSMatrix!
    @IBOutlet var adPostalCode: NSTextField!
    @IBOutlet var adStreet: NSTextField!
    
    @IBOutlet var adPhone: NSTextField!
    @IBOutlet var adYourName: NSTextField!
    
    @IBOutlet var listAccount: NSComboBox!
    @IBOutlet var okButton: NSButton!
    
    @IBOutlet var picSelButton: NSButton!
    
    @IBOutlet var adCompany: NSButton!
    
    @IBOutlet var adImpress: NSTextView!
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func awakeFromNib() {
        catSelButton.toolTip = ""
        dataArray = mydb.sql_read_accounts(sqlFilter: "") as NSArray
        self.listAccount.removeAllItems()
        for i in 0 ..< dataArray.count {
            let accName : String = dataArray[i]["username"] as! String
            self.listAccount.addItem(withObjectValue: accName)
        }
        if (dataArray.count>0) {
            self.listAccount.selectItem(at: 0)
        }
        
        if (self.editId != ""){
            var ndata = self.mydb.sql_read_select(sqlStr: "SELECT * FROM items WHERE id='" + self.editId + "'")
            
            if (currentfolder != -10 && currentfolder < 0) {
                self.listAccount.isEnabled = false
            }
            
            self.adTitle.stringValue = ndata[0]["title"]!
            self.adPrice.stringValue = ndata[0]["price"]!
            self.adDesc.string = ndata[0]["desc"]!
            self.adPostalCode.stringValue = ndata[0]["postalcode"]!
            self.adStreet.stringValue = ndata[0]["street"]!
            self.adYourName.stringValue = ndata[0]["myname"]!
            self.adPhone.stringValue = ndata[0]["myphone"]!
            self.catSelButton.toolTip = ndata[0]["categoryId"]!
            self.catSelButton.title = ndata[0]["category"]!
            self.adImpress.string = ndata[0]["companyimpress"]!
            
            if ndata[0]["company"]! == "1" {
                adCompany.state = 1
            } else {
                adCompany.state = 0
            }
            
            if ndata[0]["adtype"]! == "1" {
                adType.selectCell(atRow: 1, column: 0)
            } else {
                adType.selectCell(atRow: 0, column: 0)
            }
            
            if ndata[0]["pricetype"]! == "1" {
                adPriceType.selectCell(atRow: 0, column: 0)
            } else if ndata[0]["pricetype"]! == "2" {
                adPriceType.selectCell(atRow: 1, column: 0)
            } else {
                adPriceType.selectCell(atRow: 2, column: 0)
            }
            
            for i in 0 ..< dataArray.count {
                if dataArray[i]["id"] as! String == ndata[0]["account"]! {
                    self.listAccount.selectItem(at: i)
                    break
                }
            }
            
            if (ndata[0]["image"]! != ""){
                imglist.add(ndata[0]["image"]!)
            }
            if (ndata[0]["image2"]! != ""){
                imglist.add(ndata[0]["image2"]!)
            }
            if (ndata[0]["image3"]! != ""){
                imglist.add(ndata[0]["image3"]!)
            }
            if (ndata[0]["image4"]! != ""){
                imglist.add(ndata[0]["image4"]!)
            }
            if (ndata[0]["image5"]! != ""){
                imglist.add(ndata[0]["image5"]!)
            }
            if (ndata[0]["image6"]! != ""){
                imglist.add(ndata[0]["image6"]!)
            }
            if (ndata[0]["image7"]! != ""){
                imglist.add(ndata[0]["image7"]!)
            }
            if (ndata[0]["image8"]! != ""){
                imglist.add(ndata[0]["image8"]!)
            }
            if (ndata[0]["image9"]! != ""){
                imglist.add(ndata[0]["image9"]!)
            }
            if (ndata[0]["image10"]! != ""){
                imglist.add(ndata[0]["image10"]!)
            }
            if (ndata[0]["image11"]! != ""){
                imglist.add(ndata[0]["image11"]!)
            }
            if (ndata[0]["image12"]! != ""){
                imglist.add(ndata[0]["image12"]!)
            }
            if (ndata[0]["image13"]! != ""){
                imglist.add(ndata[0]["image13"]!)
            }
            if (ndata[0]["image14"]! != ""){
                imglist.add(ndata[0]["image14"]!)
            }
            if (ndata[0]["image15"]! != ""){
                imglist.add(ndata[0]["image15"]!)
            }
            if (ndata[0]["image16"]! != ""){
                imglist.add(ndata[0]["image16"]!)
            }
            if (ndata[0]["image17"]! != ""){
                imglist.add(ndata[0]["image17"]!)
            }
            if (ndata[0]["image18"]! != ""){
                imglist.add(ndata[0]["image18"]!)
            }
            if (ndata[0]["image19"]! != ""){
                imglist.add(ndata[0]["image19"]!)
            }
            if (ndata[0]["image20"]! != ""){
                imglist.add(ndata[0]["image20"]!)
            }
            
            if (imglist.count > 0 ){
                self.picSelButton.title = String(imglist.count) + NSLocalizedString(" picture selected", comment: "picture selected text")
            }
        }
    }
    
    convenience init(){
        self.init(windowNibName: "new_edit_ebay")
    }
    
    @IBAction func selectCatAction(sender: AnyObject) {
        if (self.catSel == nil) {
            self.catSel = catselector();
        }
        
        self.window!.beginSheet(self.catSel.window!, completionHandler: {(returnCode) -> Void in
            if (returnCode == NSModalResponseOK){
                self.catSelButton.toolTip = self.catSel.selid
                self.catSelButton.title = self.catSel.selpath
            }
        });
        
    }
    
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseCancel)
    }
    
    @IBAction func selectPicButton(sender: AnyObject) {
        self.picsel == nil
        self.picsel = picselect();
        self.picsel.picload = self.imglist
        
        self.window!.beginSheet(self.picsel.window!, completionHandler: {(returnCode) -> Void in
            if (returnCode == NSModalResponseOK){
                self.imglist.removeAllObjects()
                if (self.picsel.pic1.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic1.getmyfile())
                }
                if (self.picsel.pic2.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic2.getmyfile())
                }
                if (self.picsel.pic3.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic3.getmyfile())
                }
                if (self.picsel.pic4.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic4.getmyfile())
                }
                if (self.picsel.pic5.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic5.getmyfile())
                }
                if (self.picsel.pic6.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic6.getmyfile())
                }
                if (self.picsel.pic7.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic7.getmyfile())
                }
                if (self.picsel.pic8.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic8.getmyfile())
                }
                if (self.picsel.pic9.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic9.getmyfile())
                }
                if (self.picsel.pic10.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic10.getmyfile())
                }
                if (self.picsel.pic11.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic11.getmyfile())
                }
                if (self.picsel.pic12.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic12.getmyfile())
                }
                if (self.picsel.pic13.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic13.getmyfile())
                }
                if (self.picsel.pic14.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic14.getmyfile())
                }
                if (self.picsel.pic15.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic15.getmyfile())
                }
                if (self.picsel.pic16.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic16.getmyfile())
                }
                if (self.picsel.pic17.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic17.getmyfile())
                }
                if (self.picsel.pic18.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic18.getmyfile())
                }
                if (self.picsel.pic19.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic19.getmyfile())
                }
                if (self.picsel.pic20.getmyfile() != ""){
                    self.imglist.add(self.picsel.pic20.getmyfile())
                }
            }
        });
    }
    
    
    @IBAction func okAction(sender: AnyObject) {
        
        // Check fields
        var infoArray : NSMutableArray = []
        if (self.catSelButton.toolTip == ""){
            infoArray.add(NSLocalizedString("Category is empty", comment: "Category empty?"))
        }
        
        if (self.adTitle.stringValue == ""){
            infoArray.add(NSLocalizedString("Title is empty", comment: "Title empty?"))
        }
        if (mount(self.adTitle.stringValue, <#UnsafePointer<Int8>!#>) > 65){
            infoArray.add(NSLocalizedString("Reduce title to max 65 chars", comment: "Title Max65"))
        }
        if (mount(self.adTitle.stringValue, <#UnsafePointer<Int8>!#>) < 10){
            infoArray.add(NSLocalizedString("Title must have minimum 10 chars", comment: "Title Min10"))
        }
        
        if (self.adDesc.string == ""){
            infoArray.add(NSLocalizedString("Description is empty", comment: "Description empty?"))
        }
        if (mount(self.adDesc.string!, <#UnsafePointer<Int8>!#>) < 10){
            infoArray.add(NSLocalizedString("Description must have minimum 10 chars", comment: "Desc Min10"))
        }
        
        if (self.adPrice.stringValue == "" && self.adPriceType.selectedRow<2){
            infoArray.add(NSLocalizedString("Price is empty", comment: "Price empty?"))
        }
        
        if (self.adYourName.stringValue == ""){
            infoArray.add(NSLocalizedString("Your name is empty", comment: "Your name empty?"))
        }
        if (mount(self.adYourName.stringValue, <#UnsafePointer<Int8>!#>) > 30){
            infoArray.add(NSLocalizedString("Reduce your contactname to max 30 chars", comment: "contactname Max30"))
        }
        if (mount(self.adYourName.stringValue, <#UnsafePointer<Int8>!#>) < 2){
            infoArray.add(NSLocalizedString("Your contactname must have minimum 2 chars", comment: "contactname Min2"))
        }
        
        if (self.adPostalCode.stringValue == ""){
            infoArray.add(NSLocalizedString("Your postalcode is empty", comment: "Your postalcode empty?"))
        }
        if (mount(self.adPostalCode.stringValue, <#UnsafePointer<Int8>!#>) > 5){
            infoArray.add(NSLocalizedString("Reduce postalcode to max 5 chars", comment: "postalcode Max5"))
        }
        
        if (mount(self.adPhone.stringValue, <#UnsafePointer<Int8>!#>) > 24){
            infoArray.add(NSLocalizedString("Reduce phonenumber to max 24 chars", comment: "phone Max24"))
        } else {
            self.adPhone.stringValue = self.adPhone.stringValue.cleanToPhone()
        }
        
        if (self.adCompany.state == 1 && self.adImpress.string == ""){
            infoArray.add(NSLocalizedString("You need a impress for commercial ads", comment: "noimpress"))
        }
        
        if (infoArray.count>0){
            let errFieldList : String = infoArray.componentsJoined(by: "\n")
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Please fill the following fields", comment: "FieldsNeedHeader")
            alert.informativeText = errFieldList
            alert.addButton(withTitle: NSLocalizedString("OK", comment: "OK Button"))
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            let result = alert.runModal()
            return
        }
        
        var sqlStr = ""
        let selectedAccount = dataArray[self.listAccount.indexOfSelectedItem]["id"] as! String
        
        // Build PIC String
        var picstringupdate = ""
        var picstringnewfields = ""
        var picstringnew = ""
        var currentimagename = ""
        for i in 0 ..< self.imglist.count {
            if (i==0){
                currentimagename = "image"
            } else {
                currentimagename = "image" + String(i+1)
            }
            picstringupdate += "," + currentimagename + "=" + self.mydb.quotedstring(identifier: self.imglist[i] as AnyObject)
            picstringnewfields += "," + currentimagename
            picstringnew += ", " + self.mydb.quotedstring(identifier: self.imglist[i] as AnyObject)
        }
        
        // Build SQL
        if (self.editId == ""){
            sqlStr = "INSERT INTO items (account, state, price, title, category, categoryId, shippingprovided, folder, adtype, attribute, pricetype, postalcode, company, companyimpress, street, myname, myphone, desc\(picstringnewfields)) VALUES ("
            sqlStr += "'" + selectedAccount + "',"
            sqlStr += "'template',"
            sqlStr += "'" + String(self.adPrice.integerValue) + "',"
            sqlStr += self.mydb.quotedstring(identifier: self.adTitle.stringValue as AnyObject) + ","
            sqlStr += self.mydb.quotedstring(identifier: self.catSelButton.title as AnyObject) + ","
            sqlStr += self.mydb.quotedstring(identifier: self.catSelButton.toolTip as AnyObject) + ","
            sqlStr += "0," // shipping provided?
            sqlStr += "'" + String(self.currentfolder) + "',"
            
            if (adType.selectedRow == 0){
                sqlStr += "0,"
            } else {
                sqlStr += "1,"
            }
            
            sqlStr += "''," // attribute?
            
            if (adPriceType.selectedRow == 0){
                sqlStr += "1,"
            } else if adPriceType.selectedRow == 1 {
                sqlStr += "2,"
            } else {
                sqlStr += "3,"
            }
            
            sqlStr += self.mydb.quotedstring(identifier: self.adPostalCode.stringValue as AnyObject) + ","
            
            if self.adCompany.state == 1 {
                sqlStr += self.mydb.quotedstring(identifier: "1" as AnyObject) + ","
            } else {
                sqlStr += self.mydb.quotedstring(identifier: "0" as AnyObject) + ","
            }
            
            sqlStr += self.mydb.quotedstring(identifier: self.adImpress.string as AnyObject) + ","
            
            sqlStr += self.mydb.quotedstring(identifier: self.adStreet.stringValue as AnyObject) + ","
            sqlStr += self.mydb.quotedstring(identifier: self.adYourName.stringValue as AnyObject) + ","
            sqlStr += self.mydb.quotedstring(identifier: self.adPhone.stringValue as AnyObject) + ","
            sqlStr += self.mydb.quotedstring(identifier: self.adDesc.string as AnyObject)
            sqlStr += "\(picstringnew))"
            
            if self.mydb.executesql(sqlStr: sqlStr){
                self.editId = String(self.mydb.lastId())
                println("Gespeichert: " + self.editId)
                self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseOK)
            } else {
                // SHOW FAIL!
            }
        } else {
            sqlStr = "UPDATE items SET "
            sqlStr += "account='" + selectedAccount + "',"
            sqlStr += "price='" + String(self.adPrice.integerValue) + "',"
            sqlStr += "title=" + self.mydb.quotedstring(identifier: self.adTitle.stringValue as AnyObject) + ","
            sqlStr += "category=" + self.mydb.quotedstring(identifier: self.catSelButton.title as AnyObject) + ","
            sqlStr += "categoryId="+self.mydb.quotedstring(identifier: self.catSelButton.toolTip as AnyObject) + ","
            // sqlStr += "0,"
            // sqlStr += "'" + String(self.currentfolder) + "',"
            
            if (adType.selectedRow == 0){
                sqlStr += "adtype=0,"
            } else {
                sqlStr += "adtype=1,"
            }
            
            if self.adCompany.state == 1 {
                sqlStr += "company=1,"
            } else {
                sqlStr += "company=0,"
            }
            
            sqlStr += "companyimpress=" + self.mydb.quotedstring(identifier: self.adImpress.string as AnyObject) + ","
            
            // sqlStr += "''," // attribute?
            
            if (adPriceType.selectedRow == 0){
                sqlStr += "pricetype=1,"
            } else if adPriceType.selectedRow == 1 {
                sqlStr += "pricetype=2,"
            } else {
                sqlStr += "pricetype=3,"
            }
            
            sqlStr += "postalcode=" + self.mydb.quotedstring(identifier: self.adPostalCode.stringValue as AnyObject) + ","
            sqlStr += "street=" + self.mydb.quotedstring(identifier: self.adStreet.stringValue as AnyObject) + ","
            sqlStr += "myname=" + self.mydb.quotedstring(identifier: self.adYourName.stringValue as AnyObject) + ","
            sqlStr += "myphone=" + self.mydb.quotedstring(identifier: self.adPhone.stringValue as AnyObject) + ","
            sqlStr += "desc=" + self.mydb.quotedstring(identifier: self.adDesc.string as AnyObject)
            sqlStr += "\(picstringupdate) WHERE id=" + self.editId
            
            if self.mydb.executesql(sqlStr: sqlStr){
                self.window?.sheetParent?.endSheet(self.window!, returnCode: NSModalResponseOK)
            } else {
                // SHOW FAIL!
            }
        }
        
        
        
    }
}
