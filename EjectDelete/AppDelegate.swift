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
        

        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {

            let keyDown = 920064
            //var keyUp = 920320

            if type.rawValue == 14 {
                if NSEvent(cgEvent: event)?.data1 == keyDown {
                    print("in statemetn")
                    event.setIntegerValueField(.keyboardEventKeycode, value: 0)
                    print(event.getIntegerValueField(.keyboardEventKeycode))
                    guard let forwardDeleteEvent = CGEvent.init(keyboardEventSource: nil, virtualKey: 0x75, keyDown: true) else { return nil }
                    return Unmanaged.passRetained(forwardDeleteEvent)
                }
            }
            return Unmanaged.passRetained(event)
        }
        
              
        
        
        
        
        
        
        
        
        
        
        
//        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)
////
            let eventMask : CGEventMask = ~0
        
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                              place: .headInsertEventTap,
                                              options: .defaultTap,
                                              eventsOfInterest: CGEventMask(eventMask),
                                              callback: myCGEventCallback,
                                              userInfo: nil) else {
                                                print("failed to create event tap")
                                                exit(1)
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()

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

