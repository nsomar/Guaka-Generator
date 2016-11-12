import PackageDescription

let package = Package(
    name: "guaka-cli",
    dependencies: [
        .Package(url: "/Users/oabdelhafith/Documents/Mac/Swift/Guaka", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/ENV.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/Runner.git", majorVersion: 0),
        .Package(url: "/Users/oabdelhafith/Documents/Mac/Swift/File", majorVersion: 0),
    ]
)
