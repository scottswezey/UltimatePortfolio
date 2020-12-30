//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import SwiftUI

struct EditProjectView: View {
	let project: Project
	
	@EnvironmentObject var dataController: DataController
	@Environment(\.presentationMode) var presentationMode
	
	@State private var title: String
	@State private var detail: String
	@State private var color: String
	@State private var showingDeleteConfirm = false
	
	let colorColumns = [
		GridItem(.adaptive(minimum: 44))
	]
	
	init(project: Project) {
		self.project = project
		
		_title = State(wrappedValue: project.projectTitle)
		_detail = State(wrappedValue: project.projectDetail)
		_color = State(wrappedValue: project.projectColor)
	}
	
	func update() {
		project.title = title
		project.detail = detail
		project.color = color
	}
	
	func delete() {
		dataController.delete(project)
		presentationMode.wrappedValue.dismiss()
	}

	var body: some View {
		Form {
			Section(header: Text("Basic Settings")) {
				TextField("Project name", text: $title.onChange(update))
				TextField("Description of this project", text: $detail.onChange(update))
			}
			
			Section(header: Text("Custom project color")) {
				LazyVGrid(columns: colorColumns) {
					ForEach(Project.colors, id: \.self, content: colorButton)
				}
			}
			
			Section(header: Text("Closing a project moves it from the Open tab to the Closed tab; Deleting it removes the project completely.")) {
				Button(project.closed ? "Reopen this project" : "Close this project") {
					project.closed.toggle()
					update()
				}

				Button("Delete this project") {
					showingDeleteConfirm = true
				}
				.accentColor(.red)
			}
		}
		.navigationTitle("Edit Project")
		.onDisappear(perform: dataController.save)
		.alert(isPresented: $showingDeleteConfirm) {
			Alert(title: Text("Delete project?"),
						message: Text("Are you sure you want to delete this project and all of its items?"),
						primaryButton: .destructive(Text("Delete"), action: delete),
						secondaryButton: .cancel())
		}
	}
	
	func colorButton(for item: String) -> some View {
		ZStack {
			Color(item)
				.aspectRatio(1, contentMode: .fit)
				.cornerRadius(6)
			
			if item == color {
				Image(systemName: "checkmark.circle")
					.foregroundColor(.white)
					.font(.largeTitle)
			}
		}
		.onTapGesture {
			color = item
			update()
		}
		.accessibilityElement(children: .ignore)
		.accessibilityAddTraits(
			item == color
				? [.isButton, .isSelected]
				: .isButton
		)
		.accessibilityLabel(LocalizedStringKey(item))
	}
}

struct EditProjectView_Previews: PreviewProvider {
	static var dataController = DataController.preview

	static var previews: some View {
		EditProjectView(project: Project.example)
			.environmentObject(dataController)
	}
}
