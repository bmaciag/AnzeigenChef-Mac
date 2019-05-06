//
//  itemstablecell.swift
//  AnzeigenChef
//
//  Created by DerDaHinten on 25.05.15.
//  Copyright (c) 2015 Anon. All rights reserved.
//

import Cocoa

class itemstablecell: NSTableCellView {
    
    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var descLabel: NSTextField!
    @IBOutlet var watchLabel: NSTextField!
    @IBOutlet var visitLabel: NSTextField!
    @IBOutlet var priceLabel: NSTextField!
    @IBOutlet var postalCodeLabel: NSTextField!
    @IBOutlet var image: NSImageView!
    @IBOutlet var rightImage : NSImageView!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
    }
    
}
