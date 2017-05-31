import PackageDescription

let package = Package(
	name: "SwiftBot",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2)
    ]
)
