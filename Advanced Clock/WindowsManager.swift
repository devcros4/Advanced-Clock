//
//  WindowsManager.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 01/05/2022.
//

import Foundation
import AppKit

struct WindowsManager {
    static func getVC<T: NSViewController>(withIdentifier identifier: String, ofType: T.Type?, storyboard: String = "Main", bundle: Bundle? = nil) -> T? {
        let storyboard = NSStoryboard(name: storyboard, bundle: bundle)
        
        guard let vc: T = storyboard.instantiateController(withIdentifier: identifier) as? T else {
            let alert = NSAlert()
            alert.alertStyle = .critical
            alert.messageText = "Error initiating the viewcontroller"
            alert.runModal()
            
            return nil
        }
        
        return vc
    }
}
