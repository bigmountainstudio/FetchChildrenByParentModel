# Question
When you have a one-to-many relationship with a ParentModel that has many ChildModels, how do you write a predicate to get all ChildModel objects that match a ParentModel?

# Relationship
Say you have a relationship set up like so:

    @Model
    class ParentModel {
        var name: String
        @Relationship(deleteRule: .cascade, inverse: \ChildModel.parent)
        var children: [ChildModel] = []
        
        init(name: String, children: [ChildModel] = []) {
            self.name = name
            self.children = children
        }
    }

    @Model
    class ChildModel {
        var date: Date
        var value: Double
        var parent: ParentModel?
        
        init(date: Date, value: Double, parent: ParentModel? = nil) {
            self.date = date
            self.value = value
            self.parent = parent
        }
    }

# Predicate
I would like to accomplish the equivalent of this:

    let filter = #Predicate<ChildModel> { childModel in
        childModel.parent == parentModel
    }

### What I have tried
- Matching the whole model (seen above)
- Making ParentModel conform to Comparable
- Matching the ParentModel.id properties
- Matching the ParentModel.id.id properties
- Matching the ParentModel.persistentModelID properties

# Workaround
As a test, I found adding a parent id to establish your own relationship works.
For example:

### Updated Models
    @Model
    class ParentModel {
        var parentId: UUID // Some unique identifier
        ...
    }

    @Model
    class ChildModel {
        var parentId: UUID // The parent this child belongs to
        ...
    }

### Workable Predicate
    
    let parentId = parentModel.parentId
    
    let filter = #Predicate<ChildModel> { childModel in
        childModel.parentId == parentId
    }

Although this works, I can't but to think there is a better "native" way.
