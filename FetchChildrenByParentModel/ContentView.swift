// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import SwiftData
import SwiftUI

@Model
class ParentModel {
    var parentId: UUID // Some unique identifier
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \ChildModel.parent)
    var children: [ChildModel] = []
    
    init(parentId: UUID, name: String, children: [ChildModel] = []) {
        self.parentId = parentId
        self.name = name
        self.children = children
    }
}

@Model
class ChildModel {
    var parentId: UUID // The parent this child belongs to
    var date: Date
    var value: Double
    var parent: ParentModel?
    
    init(parentId: UUID, date: Date, value: Double, parent: ParentModel? = nil) {
        self.parentId = parentId
        self.date = date
        self.value = value
        self.parent = parent
    }
}

extension ParentModel {
    @MainActor
    static var previewContainer: ModelContainer {
        let container = try! ModelContainer(for: ParentModel.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        let parent1 = ParentModel(parentId: UUID(), name: "Parent Model 1")
        container.mainContext.insert(parent1)
        
        for i in 1...30 {
            let nextDate = Calendar.current.date(byAdding: .day, value: i, to: Date.now)!
            let child = ChildModel(parentId: parent1.parentId, date: nextDate, value: Double(i * 10))
            parent1.children.append(child)
        }
        
        return container
    }
}

struct ContentView: View {
    @Query private var parents: [ParentModel]
    private var childModels: [ChildModel] = []
    
    var body: some View {
        NavigationStack {
            List(parents) { parent in
                NavigationLink {
                    ChildrenView(parentModel: parent)
                } label: {
                    Text(parent.name)
                }
            }
            .navigationTitle("Parent Models")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ParentModel.previewContainer)
}
