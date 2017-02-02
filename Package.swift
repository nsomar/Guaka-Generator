import PackageDescription

let package = Package(
    name: "guaka-cli",
    targets: [
      Target(name: "guaka-cli", dependencies: ["GuakaClILib"]),
      Target(name: "Swiftline"),
      Target(name: "GuakaClILib", dependencies: ["Swiftline"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/oarrabi/Guaka.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/Env.git", majorVersion: 0),
        .Package(url: "https://github.com/oarrabi/FileUtils.git", majorVersion: 0),
    ]
)
