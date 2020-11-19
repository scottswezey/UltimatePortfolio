//
//  SelectSomethingView.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import SwiftUI

struct SelectSomethingView: View {
	var body: some View {
		Text("Please select something from the menu to begin.")
			.italic()
			.foregroundColor(.secondary)
	}
}

struct SelectSomethingView_Previews: PreviewProvider {
	static var previews: some View {
		SelectSomethingView()
	}
}
