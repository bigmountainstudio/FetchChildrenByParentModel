// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftData
import SwiftUI

struct ChildrenView: View {
    @Query private var children: [ChildModel]
    
    init(parentModel: ParentModel) {
        /*
         The intent is to return the most recent 7 ChildModels
         If there's a better way, let me know! (or update this repo)
         */
        let parentId = parentModel.parentId
        
        var fetch = FetchDescriptor<ChildModel>()
        let sort = [SortDescriptor(\ChildModel.date, order: .reverse)]
        let filter = #Predicate<ChildModel> { childModel in
            childModel.parentId == parentId
        }
        fetch.fetchLimit = 7 // Just get the last 7 days of data.
        fetch.predicate = filter
        fetch.sortBy = sort
        _children = Query(fetch)
    }
    
    var body: some View {
        // Reverse the models because right now they are sorted in descending order.
        List(children.reversed()) { childModel in
            LabeledContent {
                Text(childModel.value, format: .number)
            } label: {
                Text(childModel.date, format: .dateTime)
            }
        }
        .navigationTitle("Last 7 Children")
    }
}

#Preview {
    // Preview doesn't seem to work with ChildrenView init.
    let container = ParentModel.previewContainer
    let parent = try! container.mainContext.fetch(FetchDescriptor<ParentModel>())[0]
    
    return NavigationStack {
        ChildrenView(parentModel: parent)
    }
}
