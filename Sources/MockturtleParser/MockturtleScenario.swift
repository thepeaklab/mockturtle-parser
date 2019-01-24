//
//  MockturtleScenario.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleScenario: Codable {

    public var version: String
    public var identifier: String?
    public var includes: [String]?
    public var routes: [Route]

    public var includedScenarios: [MockturtleScenario]?

    private enum CodingKeys: String, CodingKey {
        case version
        case identifier
        case includes
        case routes
    }

    public static func == (lhs: MockturtleScenario, rhs: MockturtleScenario) -> Bool {
        return lhs.version == rhs.version && lhs.identifier == rhs.identifier
    }

    public static func == (lhs: MockturtleScenario, rhs: String?) -> Bool {
        return lhs.identifier == rhs
    }

    public static func load(directoryOf url: URL, logger: MockturtleLogger? = nil) -> [MockturtleScenario]? {
        let parser = MockturtleParser()
        logger?.verbose("start load scenario at `\(url.path)`")
        return parser.parse(directoryOf: url, logger: logger)
    }

    public static func load(contentsOf url: URL, logger: MockturtleLogger? = nil) -> MockturtleScenario? {
        let parser = MockturtleParser()
        logger?.verbose("start load scenario at `\(url.path)`")
        return parser.parse(contentsOf: url, logger: logger)
    }

    public func flatRoutes() -> [Route] {
        var result: [Route] = []
        for scenario in includedScenarios ?? [] {
            result.append(contentsOf: scenario.flatRoutes())
        }
        result.append(contentsOf: routes)
        return result
    }

}


public extension MockturtleScenario {

    public class Route: Codable {

        public var path: String
        public var method: String?
        public var state: String

    }

}
