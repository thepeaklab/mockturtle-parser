//
//  MockturtleDelay.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleDelay: Codable, Equatable {

    public var from: Double
    public var to: Double

    public static func == (lhs: MockturtleDelay, rhs: MockturtleDelay) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
    }

}
