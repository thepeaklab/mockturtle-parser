//
//  MockturtleState.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleState: Codable, Equatable {

    public var identifier: String?
    public var version: String
    public var response: MockturtleResponse
    public var delay: MockturtleDelay?

    public static func == (lhs: MockturtleState, rhs: MockturtleState) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.version == rhs.version
    }

    public static func == (lhs: MockturtleState, rhs: String?) -> Bool {
        return lhs.identifier == rhs
    }

}
