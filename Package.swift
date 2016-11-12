import PackageDescription

let package = Package(
    name: "guaka-cli",
    dependencies: [
        .Package(url: "https://github.com/oarrabi/Guaka.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/ENV.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/Runner.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/File.git", majorVersion: 0),
    ]
)
