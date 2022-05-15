//
//  ViewController.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 25/04/2022.
//

import Cocoa

protocol NewReminderVCDelegate {
    func onSubmit(_ sender: NSButton, reminder: Reminder) -> Void
}

class NewReminderVC: NSViewController {

    @IBOutlet weak var taskTitle: NSTextField!
    @IBOutlet weak var taskDescr: NSTextView!
    @IBOutlet weak var taskDate: NSDatePicker!
    
    var delegate: NewReminderVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.stringValue = ""
        taskDescr.string = ""
        taskDate.calendar = Calendar.current
        taskDate.dateValue = Date.now
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onSubmit(_ sender: NSButton) {
        let reminder = Reminder(taskTitle.stringValue, description: taskDescr.string, fireOnDate: taskDate.dateValue, tag: nil)
        delegate.onSubmit(sender, reminder: reminder)
    }
    
}

