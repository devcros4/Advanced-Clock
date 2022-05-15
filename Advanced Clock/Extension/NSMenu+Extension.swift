//
//  NSMenu+Extension.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 27/04/2022.
//

import Foundation
import AppKit

extension NSMenu {
    func addSeparator() -> Void {
        addItem(.separator())
    }
    
    func addItems(_ items: NSMenuItem...) {
        for item in items {
            addItem(item)
        }
    }
}
