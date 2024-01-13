// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

@main
struct FetchChildrenByParentModelApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ParentModel.previewContainer)
        }
    }
}
