//
//  CountOnMeExtensions.swift
//  CountOnMe
//
//  Created by Richardier on 15/03/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation


extension Double {
    // Allows to format the result
    func truncateExtraDecimals() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return String(formatter.string(from: number) ?? "\(self)")
    }
}
