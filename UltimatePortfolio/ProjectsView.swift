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
					}
				}
			}
			.listStyle(InsetGroupedListStyle())
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
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
