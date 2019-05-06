//
//  myimageview.swift
//  AnzeigenChef
//
//  Created by DerDaHinten on 23.05.15.
//  Copyright (c) 2015 Anon. All rights reserved.
//

import Cocoa

class myimageview: NSImageView {

    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseUp(theEvent: NSEvent) {
        var openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                if let da = NSData(contentsOfURL: openPanel.URL!){
                    self.image = NSImage(data: da)
                    self.toolTip = openPanel.urlurl?.absoluteString
                }
            }
        }
    }
    
    func loadPicFromFile(fileName : String) -> Bool{
        if let da = NSData(contentsOfURL: NSURL(string: fileName)! as URL){
            self.image = NSImage(data: da)
            self.toolTip = NSURL(string: fileName)?.absoluteString
            return true
        }
        return false
    }
    
    func getmyfile() -> String{
        if (self.toolTip != nil){
            return self.toolTip!
        } else {
            return ""
        }
    }
    
}
