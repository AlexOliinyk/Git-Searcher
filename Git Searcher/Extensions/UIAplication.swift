//
//  UIApplication.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 15.04.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
