//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Scott on 12/29/20.
//

import SwiftUI

struct ItemListView: View {
	let title: LocalizedStringKey
	let items: FetchedResults<Item>.SubSequence

	func itemRow(for item: Item) -> some View {
		HStack(spacing: 20) {
			Circle()
				.stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
				.frame(width: 24, height: 24)

			VStack(alignment: .leading) {
				Text(item.itemTitle)
					.font(.title2)
					.foregroundColor(.primary)
					.frame(maxWidth: .infinity, alignment: .leading)

				if item.itemDetail.isEmpty == false {
					Text(item.itemDetail)
						.foregroundColor(.secondary)
				}
			}
		}
		.padding()
		.background(Color.secondarySystemGroupedBackground)
		.cornerRadius(10)
		.shadow(color: Color.black.opacity(0.2), radius: 5)
	}

	var body: some View {
		if items.isEmpty {
			EmptyView()
		} else {
			Text(title)
				.font(.headline)
				.foregroundColor(.secondary)
				.padding(.top)

			ForEach(items) { item in
				NavigationLink(destination: EditItemView(item: item)) {
					itemRow(for: item)
				}
			}
		}
	}
}

// TODO: Implement preview
// 	struct ItemListView_Previews: PreviewProvider {
// 		static var previews: some View {
// 			ItemListView()
//		}
//	}
