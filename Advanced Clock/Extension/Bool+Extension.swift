//
//  Bool+Extension.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 27/04/2022.
//

import Foundation
import AppKit

extension Bool {
    var stateValue: NSControl.StateValue {
        return self.toStateValue()
    }
    
    private func toStateValue() -> NSControl.StateValue {
        return self ? .on : .off
    }
}
