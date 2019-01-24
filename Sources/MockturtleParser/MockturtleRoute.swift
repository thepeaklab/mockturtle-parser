//
//  MockturtleRoute.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleRoute: Codable, Equatable {

    public var url: String?
    public var method: String?
    public var directory: String?

    public var states: [MockturtleState]?

    private enum CodingKeys: String, CodingKey {
        case url
        case method
        case directory
    }

    public static func == (lhs: MockturtleRoute, rhs: MockturtleRoute) -> Bool {
        return lhs.url == rhs.url && lhs.method == rhs.method && lhs.directory == rhs.directory
    }

    public static func == (lhs: MockturtleRoute, rhs: String?) -> Bool {
        return lhs.url == rhs
    }

}


public extension MockturtleRoute {

    private func stringForDirectory() -> String? {
        return directory ?? url
    }

    public func resolvedDirectory(baseDirectory: URL) -> URL? {
        guard let stringForDirectory = stringForDirectory() else { return nil }
        return baseDirectory.appendingPathComponent(stringForDirectory)
    }

}
