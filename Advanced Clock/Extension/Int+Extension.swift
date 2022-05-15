//
//  Int+Extension.swift
//  Advanced Clock
//
//  Created by jean-baptiste delcros on 26/04/2022.
//

import Foundation

extension Int {
    /// ---
    ///      var n: Int = 5
    ///      n = n.safeString
    ///      print(n)       // "05"
    /// ---
    var safeString: String {
        return self >= 10 ? "\(self)" : "0\(self)"
    }
}
