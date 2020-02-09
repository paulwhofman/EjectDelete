//
//  AppDelegate.swift
//  EjectDelete
//
//  Created by Paul Hofman on 19/01/2020.
//  Copyright © 2020 Paul Hofman. All rights reserved.
//

import Cocoa
import SwiftUI
import IOKit.hid


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
        
        print("hallo")
        
        
        func myCGEventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
            
            print(type.self)
            
//            if [.keyDown , .keyUp].contains(type) {
//
//                var keyCode = event.getIntegerValueField(.keyboardEventKeycode)
////                if keyCode == 146 {
////                    keyCode = 117
////                }
//                event.setIntegerValueField(.keyboardEventKeycode, value: keyCode)
//            }
            return Unmanaged.passRetained(event)
            
        }
//        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << CGEventType.flagsChanged.rawValue)

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
    
//    func press() {
//        let keyCode: UInt16 = 0x00
//        let event = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)
//        let loc = CGEventTapLocation.cghidEventTap
//        event?.post(tap: loc)
//    }
    
    
    
}

