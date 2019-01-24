//
//  MockturtleConfig.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleConfig: Codable {

    public var version: String
    public var routes: [MockturtleRoute]

    public static func load(contentsOf url: URL, logger: MockturtleLogger? = nil) -> MockturtleConfig? {
        let parser = MockturtleParser()
        logger?.verbose("start load config at `\(url.path)`")
        return parser.parse(contentsOf: url, logger: logger)
    }

}
