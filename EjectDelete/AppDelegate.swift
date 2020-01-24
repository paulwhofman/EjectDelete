//
//  AppDelegate.swift
//  EjectDelete
//
//  Created by Paul Hofman on 19/01/2020.
//  Copyright © 2020 Paul Hofman. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    var manger: IOHIDManager
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        
        
        
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        statusBarItem.button?.title = "App"
        
        let statusBarMenu = NSMenu(title: "Hallo")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(withTitle: "Pause",
                              action: #selector(AppDelegate.pauseClicked),
                              keyEquivalent: "")
        
        statusBarMenu.addItem(withTitle: "Load on startup",
                              action: #selector(AppDelegate.loadOnStartupClicked),
                              keyEquivalent: "")
        
        statusBarMenu.addItem(withTitle: "Quit",
                              action: #selector(AppDelegate.quitClicked),
                              keyEquivalent: "")
        
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func pauseClicked() {
        // stop functionality
        // change button to resume
    }
    
    @objc func loadOnStartupClicked() {
        // load on startup
    }
    
    @objc func quitClicked() {
        NSApplication.shared.terminate(self)
    }


}

