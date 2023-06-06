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
    @Query private var drives: [Drive]
    var body: some View {
        VStack {
            List {
                ForEach(drives){drive in
                DriveCard(drive).listRowInsets(.none).listRowSeparator(.hidden).listRowSpacing(0)
            }.onDelete(perform: deleteItems)
            }.listStyle(.plain).listRowSpacing(0)
            
        }.navigationTitle("All Drives").toolbar {
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

#Preview {
    
    NavigationView {
        AllDrivesView()
    }.onAppear {
       
    }
}
