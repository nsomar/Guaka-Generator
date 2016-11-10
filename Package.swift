import PackageDescription

let package = Package(
    name: "mytest",
    dependencies: [
        .Package(url: "https://github.com/oarrabi/Guaka.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/ENV.git", majorVersion: 0)
    ]
)
