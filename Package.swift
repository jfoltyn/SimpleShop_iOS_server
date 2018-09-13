// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "json",
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", from: "3.0.0"),
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
	.package(url: "https://github.com/PerfectlySoft/Perfect-SQLite", from: "3.0.0"),
	.package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.11.5"),
	.package(url: "https://github.com/PerfectlySoft/Perfect-CRUD.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "json",
            dependencies: ["PerfectHTTP","PerfectHTTPServer","PerfectCRUD","PerfectSQLite","SQLite"]),
    ]
)
