import PackageDescription

let package = Package(
    name: "guaka-cli",
    targets: [
      Target(name: "guaka-cli", dependencies: ["GuakaClILib"]),
      Target(name: "GuakaClILib"),
    ],
    dependencies: [
        .Package(url: "file:///Users/oabdelhafith/Documents/Mac/Swift/Guaka", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/ENV.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/Runner.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/File.git", majorVersion: 0),
    ]
)
