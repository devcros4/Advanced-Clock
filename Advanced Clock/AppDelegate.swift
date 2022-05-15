//
//  AppDelegate.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 25/04/2022.
//

import Cocoa
import UserNotifications

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer: Timer? = nil
    var separatorsStatus: NSControl.StateValue = .on
    let REMINDERS_WINDOW_CONTROLLER: NSWindowController = NSWindowController(window: nil)

    var reminders: [Reminder] = [] {
        didSet {
            if let menu = statusBarItem.menu, let item = menu.item(withTag: 5) {
                item.submenu = self.getRemindersMenu()
                item.isEnabled = reminders.count > 0
            }
        }
    }
    
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
//        UserDefaults.resetStandardUserDefaults()
        if Preferences.firstRunGone == false {
            self.requestAuthorization()
            Preferences.firstRunGone = true
            Preferences.restore()
        }
        DockIcon.standard.setVisibility(Preferences.showDockIcon)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let statusButton = self.statusBarItem.button else { return }
        
        statusButton.title = Preferences.showSeconds ? Date.now.stringTimeWithSeconds : Date.now.stringTime
        Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateStatusText),
            userInfo: nil,
            repeats: true)
        
        let statusMenu: NSMenu = NSMenu()
        
        statusMenu.addItem(withTitle: "Good \(Date.now.dayPart)", action: nil, keyEquivalent: "")
        statusMenu.addSeparator()
        
        let toggleFlashingSeparatorsItem: NSMenuItem = {
            let item = NSMenuItem(title: "Flashing separators", action: #selector(toggleFlashingSeparators), keyEquivalent: "")
            item.tag = 1
            item.target = self
            item.state = Preferences.useFlashDots.stateValue
            
            return item
        }()
        
        let toggleDockIconItem: NSMenuItem = {
            let item = NSMenuItem(title: "Toggle Dock Icon", action: #selector(toggleDockIcon), keyEquivalent: "")
            item.tag = 2
            item.target = self
            item.state = Preferences.showDockIcon.stateValue
            
            return item
        }()
        
        let toggleSecondsItem: NSMenuItem = {
            let item = NSMenuItem(title: "Show seconds", action: #selector(toggleSeconds), keyEquivalent: "")
            item.tag = 3
            item.target = self
            item.state = Preferences.showSeconds.stateValue
            
            return item
        }()
        
        let quitApplicationItem: NSMenuItem = {
            let item = NSMenuItem(title: "Quit", action:  #selector(toggleSeconds), keyEquivalent: "")
            item.target = self
            
            return item
        }()
        
        let remindersItem: NSMenuItem = {
            let item = NSMenuItem(title: "Reminders", action: nil, keyEquivalent: "")
            item.tag = 5

            let menu = NSMenu()

            for reminder in self.reminders {
                menu.addItem(.init(title: reminder.title, action: nil, keyEquivalent: ""))
            }

            item.isEnabled = reminders.count > 0

            return item
        }()
        
        let addReminderItem: NSMenuItem = {
            let item = NSMenuItem(title: "New Reminder", action: #selector(addReminder), keyEquivalent: "")
            item.tag = 6
            item.target = self
            return item
        }()
        
        statusMenu.addItems(
            toggleFlashingSeparatorsItem,
            toggleDockIconItem,
            .separator(),
            toggleSecondsItem,
            .separator(),
            quitApplicationItem,
            remindersItem,
            addReminderItem
            )
        statusBarItem.menu = statusMenu
    }


    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

/*
 * -----------------------
 * MARK: - Actions
 * ------------------------
 */
extension AppDelegate {
    
    @objc
    func updateStatusText(_ sender: Timer) {
        guard let statusButton = self.statusBarItem.button else { return }
        var title = Preferences.showSeconds ? Date.now.stringTimeWithSeconds : Date.now.stringTime
        
        if Preferences.useFlashDots && self.separatorsStatus == .on {
            separatorsStatus = .off
            title = title.replacingOccurrences(of: ":", with: " ")
        } else {
            separatorsStatus = .on
        }
        
        statusButton.title = title
        
    }
    
    @objc
    func toggleFlashingSeparators(_ sender: NSMenuItem) {
        Preferences.useFlashDots = !Preferences.useFlashDots
        
        if let menu = statusBarItem.menu, let item = menu.item(withTag: 1) {
            item.state = Preferences.useFlashDots.stateValue
        }
    }
    
    @objc
    func toggleDockIcon(_ sender: NSMenuItem) {
        Preferences.showDockIcon = !Preferences.showDockIcon
        
        DockIcon.standard.setVisibility(Preferences.showDockIcon)
        
        if let menu = statusBarItem.menu, let item = menu.item(withTag: 2) {
            item.state = Preferences.showDockIcon.stateValue
        }
    }
    
    @objc
    func toggleSeconds(_ sender: NSMenuItem) {
        Preferences.showSeconds = !Preferences.showSeconds
        
        if let menu = statusBarItem.menu, let item = menu.item(withTag: 3) {
            item.title = "Show seconds"
            item.state = Preferences.showSeconds.stateValue
        }
    }
    
    @objc
    func terminate(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }
    
    @objc
    func addReminder(_ sender: NSMenuItem) {
        if let vc = WindowsManager.getVC(withIdentifier: "NewReminderVC", ofType: NewReminderVC.self) {
            vc.delegate = self
            let window: NSWindow = {
                let w = NSWindow(contentViewController: vc)
                
                w.styleMask.remove(.fullScreen)
                w.styleMask.remove(.resizable)
                w.styleMask.remove(.miniaturizable)
                
                w.level = .floating
                
                return w
            }()
            
            if REMINDERS_WINDOW_CONTROLLER.window == nil {
                REMINDERS_WINDOW_CONTROLLER.window = window
            }
            
            REMINDERS_WINDOW_CONTROLLER.showWindow(self)
        }
    }
    
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { authorized, error in
            if authorized {
                print("authorized")
            } else if !authorized {
                print("Not authorized")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    private func getRemindersMenu() -> NSMenu {
            let menu = NSMenu()
            
            for reminder in self.reminders {
                menu.addItem(.init(title: reminder.title, action: nil, keyEquivalent: ""))
            }
            
            return menu
        }
}

extension AppDelegate: NewReminderVCDelegate, ReminderDelegate {
    func onSubmit(_ sender: NSButton, reminder: Reminder) {
        reminder.delegate = self
                if reminder.tag == nil {
                    reminder.tag = reminders.count
                }
                
                REMINDERS_WINDOW_CONTROLLER.close()
                reminders.append(reminder)
    }
    
    func onReminderfired(_ reminder: Reminder) {
        reminders.removeAll(where: { $0.tag == reminder.tag })
    }
    
    
}
