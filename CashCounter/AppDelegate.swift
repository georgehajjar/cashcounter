//
//  AppDelegate.swift
//  CashCounter
//
//  Created by George Hajjar on 2017-05-20.
//  Copyright © 2017 George Hajjar. All rights reserved.
//
//  I got bored at work and decided to see how much money I make.
//  Start the app at the begining of your work day and at quick glance you can see how much money you've made.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var time: NSMenuItem!
    
    var ones_sec = 0
    var tens_sec = 0
    var ones_min = 0
    var tens_min = 0
    var ones_hour = 0
    var tens_hour = 0
    var timer = Timer()
    var count = 0
    var ratePerHour:Float = 0
    var ratePerSec:Float = 0
    var earned:Float = 0
   
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        statusItem.title = "$cshcntr$"
        hourlyPayWindow.setIsVisible(false)
    }
    
    @IBAction func start_stop(_ sender: NSMenuItem) {
        count = count + 1
        if(count%2 == 1) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppDelegate.tick), userInfo: nil, repeats: true)
        }
        else {
            timer.invalidate()
        }
    }
    
    @IBAction func reset(_ sender: NSMenuItem) {
        count = 0
        timer.invalidate()
        ones_sec = 0
        tens_sec = 0
        ones_min = 0
        tens_min = 0
        ones_hour = 0
        tens_hour = 0
        earned = 0
        statusItem.title = String(format: "$%.2f", earned)
        time.title = String(tens_hour) + String(ones_hour) + ":" + String(tens_min) + String(ones_min) + ":" + String(tens_sec) + String(ones_sec)
    }
    
    @IBAction func hourlyPay(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        hourlyPayWindow.orderFront(self)
        hourlyPayWindow.setFrameOrigin(NSPoint(x: 2000 , y: 1200))
        //change manually inputted x and y coordinate values.
    }
    
    @IBAction func quitApplication(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self);
    }
    
    @IBOutlet weak var hourlyPayWindow: NSWindow!
    @IBOutlet weak var payBox: NSTextField!
    @IBAction func submitButton(_ sender: Any) {
        ratePerHour = self.payBox.floatValue
        hourlyPayWindow.close()
        reset(time)
    }
    
    func tick() {
        ones_sec += 1
        if (ones_sec > 9) {
            tens_sec += 1
            ones_sec = 0
        }
        if (tens_sec > 5) {
            ones_min += 1
            tens_sec = 0
        }
        if (ones_min > 9) {
            tens_min += 1
            ones_min = 0
        }
        if (tens_min > 5) {
            ones_hour += 1
            tens_min = 0
        }
        if (ones_hour > 9) {
            tens_hour += 1
            ones_hour = 0
        }
        ratePerSec = ratePerHour / 3600
        earned = earned + ratePerSec
        statusItem.title = String(format: "$%.2f", earned)
        time.title = String(tens_hour) + String(ones_hour) + ":" + String(tens_min) + String(ones_min) + ":" + String(tens_sec) + String(ones_sec)
    }
}
