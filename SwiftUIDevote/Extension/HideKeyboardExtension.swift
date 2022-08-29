//
//  HideKeyboardExtension.swift
//  SwiftUIDevote
//
//  Created by Kaori Persson on 2022-08-29.
//

import SwiftUI

// This will be only executed if we can import UIKit
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
