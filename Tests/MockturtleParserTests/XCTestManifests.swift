//
//  XCTestManifest.swift
//  MockturtleParserTests
//
//  Created by Christoph Pageler on 24.01.19.
//


import XCTest


#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MockturtleParserTests.allTests)
    ]
}
#endif
