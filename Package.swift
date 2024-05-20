// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomTagPeopleTextView",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CustomTagPeopleTextView",
            targets: ["CustomTagPeopleTextView"]),
    ],
    targets: [
        .target(
            name: "CustomTagPeopleTextView",
            resources: [
                    .process("Resources/CustomTagPeopleTextView.xib")
                ]
        ),
        .testTarget(
            name: "CustomTagPeopleTextViewTests",
            dependencies: ["CustomTagPeopleTextView"]),
    ]
)
