//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import SwiftUI

struct HomeView: View {
	static let tag: String? = "Home"
	@EnvironmentObject var dataController: DataController
	
	var body: some View {
		NavigationView {
			VStack {
				Button("Add Data") {
					dataController.deleteAll()
					try? dataController.createSampleData()
				}
			}
			.navigationTitle("Home")
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
