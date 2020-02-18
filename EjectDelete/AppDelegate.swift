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
import LaunchAtLogin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    var statusBarMenu : NSMenu!
    var runLoopisRunning : Bool = true
    var runLoopSource : CFRunLoopSource!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.constructMenu()
        self.createRunLoopSource()
        self.start()
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
        
        //Set it to correct launchatlogin state
        if LaunchAtLogin.isEnabled {
            statusBarMenu.items[2].state = NSControl.StateValue.on
        } else {
            statusBarMenu.items[2].state = NSControl.StateValue.off
        }
        
        statusBarMenu.addItem(NSMenuItem.separator())
        
        statusBarMenu.addItem(withTitle: "Quit",
                              action: #selector(self.quitClicked),
                              keyEquivalent: "")
    }
    
    
    @objc func pauseClicked() {
        let item : NSMenuItem = statusBarMenu.items[0]
        if runLoopisRunning {
            runLoopisRunning = false
            item.title = "Start"
            self.stop()
        } else {
            runLoopisRunning = true
            item.title = "Stop"
            self.start()
        }
    }
    
    @objc func loadOnStartupClicked() {
        //item 2 because of seperator
        let item : NSMenuItem = statusBarMenu.items[2]
        if item.state == NSControl.StateValue.on {
            LaunchAtLogin.isEnabled = false
            item.state = NSControl.StateValue.off
            
        } else if item.state == NSControl.StateValue.off {
            LaunchAtLogin.isEnabled = true
            item.state = NSControl.StateValue.on
        }
    }
    
    @objc func quitClicked() {
        NSApplication.shared.terminate(self)
    }
    
    func createRunLoopSource() {
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
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }
    
    func start() {
        self.createRunLoopSource()
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CFRunLoopRun()
    }
    
    func stop() {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CFRunLoopRun()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

