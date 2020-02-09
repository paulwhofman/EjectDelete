//
//  AppDelegate.swift
//  EjectDelete
//
//  Created by Paul Hofman on 19/01/2020.
//  Copyright © 2020 Paul Hofman. All rights reserved.
//

import Cocoa
import SwiftUI
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    var statusBarMenu : NSMenu!
    var runLoopisRunning : Bool = true
    let id = "EjectDeleteApplication"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.constructMenu()
        self.createStartRunLoop()
    }
    
    func constructMenu() {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "App"
        statusBarMenu = NSMenu(title: "Hallo")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(withTitle: "Stop",
                              action: #selector(self.pauseClicked),
                              keyEquivalent: "")
        
        statusBarMenu.addItem(NSMenuItem.separator())
        
        statusBarMenu.addItem(withTitle: "Load on startup",
                              action: #selector(self.loadOnStartupClicked),
                              keyEquivalent: "")
        
        statusBarMenu.addItem(NSMenuItem.separator())
        
        statusBarMenu.addItem(withTitle: "Quit",
                              action: #selector(self.quitClicked),
                              keyEquivalent: "")
        
        //set state of load on startup based on some variable that is saved somewhere
    
        
    }
    
    
    @objc func pauseClicked() {
        let item : NSMenuItem = statusBarMenu.items[0]
        if runLoopisRunning {
            runLoopisRunning = false
            item.title = "Start"
            let currentRunLoop = CFRunLoopGetCurrent()
            CFRunLoopStop(currentRunLoop)
        } else {
            runLoopisRunning = true
            item.title = "Stop"
            createStartRunLoop()
        }
    }
    
    @objc func loadOnStartupClicked() {
        let item : NSMenuItem = statusBarMenu.items[1]
        if item.state == NSControl.StateValue.on {
            item.state = NSControl.StateValue.off
            
        } else if item.state == NSControl.StateValue.off {
            item.state = NSControl.StateValue.on
            SMLoginItemSetEnabled(id as CFString, true)
        }
    }
    
    @objc func quitClicked() {
        NSApplication.shared.terminate(self)
    }
    
    func createStartRunLoop() {
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
}

