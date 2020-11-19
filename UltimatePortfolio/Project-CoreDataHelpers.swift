//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Scott on 11/18/20.
//

import Foundation

extension Project {
	static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
	var projectTitle: String { title ?? "New Project" }
	var projectDetail: String { detail ?? "" }
	var projectColor: String { color ?? "Light Blue" }
	
	var projectItems: [Item] {
		let itemsArray = items?.allObjects as? [Item] ?? []
		
		return itemsArray.sorted { first, second in
			if first.completed == false {
				if second.completed == true {
					return true
				}
			} else if first.completed == true {
				if second.completed == false {
					return false
				}
			}
			
			if first.priority > second.priority {
				return true
			} else if first.priority < second.priority {
				return false
			}
			
			return first.itemCreationDate < second.itemCreationDate
		}
	}
	
	var completionAmount: Double {
		let originalItems = items?.allObjects as? [Item] ?? []
		guard originalItems.isEmpty == false else { return 0 }
		
		let completedItems = originalItems.filter(\.completed)
		return Double(completedItems.count) / Double(originalItems.count)
	}
	
	static var example: Project {
		let controller = DataController(inMemory: true)
		let viewContext = controller.container.viewContext
		
		let project = Project(context: viewContext)
		project.title = "Example Project"
		project.detail = "This is an example project."
		project.closed = true
		project.creationDate = Date()
		
		return project
	}
}
