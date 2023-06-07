//
//  AllDrivesView.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/5/23.
//

import SwiftUI
import DriveLoggerCore
import DriveLoggerUI
import SwiftData

struct AllDrivesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var body: some View {
        VStack {
            List {
                ForEach(drives) {drive in
                    DriveCard(drive)
                }.onDelete(perform: deleteItems).listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)).listRowSeparator(.hidden).listRowSpacing(0)
            }.listStyle(.plain).listRowSpacing(0)
            
        }.padding().navigationTitle("All Drives").toolbar {
            ToolbarItem(placement: .primaryAction, content: {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            })
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(drives[index])
            }
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = Drive(sampleData: true)
            modelContext.insert(newItem)
        }
    }
}

struct AllDrives_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            AllDrivesView().modelContainer(previewContainer)
        }
    }
}