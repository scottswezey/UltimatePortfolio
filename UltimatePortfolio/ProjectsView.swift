//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import SwiftUI

struct ProjectsView: View {
	static let openTag: String? = "Open"
	static let closedTag: String? = "Closed"
	
	@EnvironmentObject var dataController: DataController
	@Environment(\.managedObjectContext) var managedObjectContext
	
	let showClosedProjects: Bool
	let projects: FetchRequest<Project>
	
	init(showClosedProjects: Bool) {
		self.showClosedProjects = showClosedProjects
		
		projects = FetchRequest<Project>(entity: Project.entity(),
																		 sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
																		 predicate: NSPredicate(format: "closed = %d", showClosedProjects))
	}
	
	var body: some View {
		NavigationView {
			List {
				ForEach(projects.wrappedValue) { project in
					Section(header: ProjectHeaderView(project: project)) {
						ForEach(project.projectItems) { item in
							ItemRowView(item: item)
						}
						.onDelete { offsets in
							let allItems = project.projectItems
							
							for offset in offsets {
								let item = allItems[offset]
								dataController.delete(item)
							}
							
							dataController.save()
						}
						
						if showClosedProjects == false {
							Button {
								withAnimation {
									let item = Item(context: managedObjectContext)
									item.project = project
									item.creationDate = Date()
									dataController.save()
								}
							} label: {
								Label("Add New Item", systemImage: "plus")
							}
						}
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				if showClosedProjects == false {
					Button {
						withAnimation {
							let project = Project(context: managedObjectContext)
							project.closed = false
							project.creationDate = Date()
							dataController.save()
						}
					} label: {
						Label("Add Project", systemImage: "plus")
					}
				}
			}
		}
	}
}

struct ProjectsView_Previews: PreviewProvider {
	static var dataController = DataController.preview
	
	static var previews: some View {
		ProjectsView(showClosedProjects: false)
			.environment(\.managedObjectContext, dataController.container.viewContext)
			.environmentObject(dataController)
	}
}
