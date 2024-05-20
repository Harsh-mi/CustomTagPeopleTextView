# CustomTagPeopleTextView

## Installation

- To install this package, import `https://github.com/Harsh-mi/CustomTagPeopleTextView.git` in SPM.
- iOS version should be eqaul or greater than 13.0

## How to use CustomTagPeopleTextView

- First take a view in your storyboard.
- Then assign the class of your view CustomTagPeopleTextView.
- You can add CustomTagPeopleTextView in your project by following below example.
- You need to assign `frame` and `users list` to display user names as per your requirement to mention or tag in the CustomTagPeopleTextView  and To add CustomTagPeopleTextView you need to call the `CustomTagPeopleTextView.initView(frame:)` in the `Task` as it is an async function.
- Here is an example of loading and adding CustomTagPeopleTextView:

```swift

        Task {
            do {
                let addPostView = await CustomTagPeopleTextView.initView(frame: customView.frame)
                addPostView.configTagPeopleView()
                addPostView.arrayUsers = ["Alice", "Bob", "Mitchel", "Siri", "Tom"]
                self.view.addSubview(addPostView)
            }
        }
```
