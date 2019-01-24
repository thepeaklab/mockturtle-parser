//
//  LinuxMain.swift
//  LinuxMain
//
//  Created by Christoph Pageler on 24.01.19.
//


import XCTest
import MockturtleParserTests


var tests = [XCTestCaseEntry]()
tests += MockturtleParserTests.allTests()
XCTMain(tests)
