//
//  DockIcon.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 01/05/2022.
//

import Foundation
import AppKit

struct DockIcon  {
    static var standard = DockIcon()
    
    var isVisible: Bool {
        get {
            return NSApp?.activationPolicy() == .regular
        }
        set {
            setVisibility(newValue)
        }
    }
    
    
    @discardableResult
    func setVisibility(_ state: Bool) -> Bool {
        if state {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
        
        return isVisible
    }
}
