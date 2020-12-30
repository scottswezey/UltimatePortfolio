//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import SwiftUI
import CoreData

struct HomeView: View {
	static let tag: String? = "Home"
	@EnvironmentObject var dataController: DataController
	@FetchRequest(entity: Project.entity(),
								sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
								predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
	let items: FetchRequest<Item>
	var projectRows: [GridItem] { [GridItem(.fixed(100))] }

	init() {
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		let completedPredicate = NSPredicate(format: "completed = false")
		let openPredicate = NSPredicate(format: "project.closed = false")
		let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])

		request.predicate = compoundPredicate

		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \Item.priority, ascending: true)
		]
		request.fetchLimit = 10

		items = FetchRequest(fetchRequest: request)
	}

	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					ScrollView(.horizontal, showsIndicators: false) {
						LazyHGrid(rows: projectRows) {
							ForEach(projects, content: ProjectSummaryView.init)
						}
						.fixedSize(horizontal: false, vertical: true)
						.padding([.horizontal, .top])
					}

					VStack(alignment: .leading) {
						ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
						ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
					}
					.padding(.horizontal)
				}
			}
			.background(Color.systemGroupedBackground.ignoresSafeArea())
			.navigationTitle("Home")
			.toolbar {
				Button("Add Data") {
					dataController.deleteAll()
					try? dataController.createSampleData()
				}
				.padding()
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
