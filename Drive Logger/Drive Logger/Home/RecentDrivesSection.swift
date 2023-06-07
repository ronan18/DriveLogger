//
//  RecentDrivesSection.swift
//  Drive Logger
//
//  Created by Ronan Furuta on 6/4/23.
//

import SwiftUI
import DriveLoggerUI
import DriveLoggerCore
import SwiftData
struct RecentDrivesSection: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \.startTime, order: .reverse) private var drives: [Drive]
    var body: some View {
        VStack {
            HStack {
                Text("Recent Drives").font(.headline)
                Spacer()
                NavigationLink(destination: AllDrivesView(), label: {Text("View All \(Image(systemName: "chevron.right"))")})
            }
            if (drives.count > 0 ) {
                VStack {
                    List {
                        ForEach(drives.prefix(3)) {drive in
                            DriveCard(drive)
                        }.onDelete(perform: deleteItems).listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)).listRowSeparator(.hidden).listRowSpacing(0)
                    }.listStyle(.plain).listRowSpacing(0).scrollDisabled(true)
                 Spacer()
                    
                    
                }.frame(minHeight: 250)
            } else {
                VStack {
                    Spacer()
                    Text("No logged drives yet").font(.headline)
                    HStack {
                        Spacer()
                        Text("Hit the button below to start your first drive!").font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                }.background(Color("LightGray")).cornerRadius(6).frame(height: 250).padding(.vertical, 2)
            }
           
        }.padding(.vertical)
    }
    private func addItem() {
        withAnimation {
            let newItem = Drive(sampleData: true)
            modelContext.insert(newItem)
        }
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(drives[index])
            }
        }
    }
}

struct RecentDrivesSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
        RecentDrivesSection().modelContainer(previewContainer)
        Spacer()
    }.padding()
}.previewLayout(.sizeThatFits).previewDisplayName("With Drives")
        NavigationView {
            VStack {
        RecentDrivesSection()
        Spacer()
    }.padding()
}.previewLayout(.sizeThatFits).previewDisplayName("With Out Drives")
       
    }
}


private extension UIScrollView {
    open override var clipsToBounds: Bool {
        get { false }
        set {}
    }
}
