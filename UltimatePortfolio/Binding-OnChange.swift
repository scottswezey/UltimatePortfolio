//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import SwiftUI

extension Binding {
	func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
		Binding(
			get: { self.wrappedValue },
			set: { newValue in
				self.wrappedValue = newValue
				handler()
			}
		)
	}
}
