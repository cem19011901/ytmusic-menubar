// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YTMusicMenuBar",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "YTMusicMenuBar",
            path: "Sources/YTMusicMenuBar",
            resources: [
                .process("Info.plist")
            ]
        )
    ]
)
