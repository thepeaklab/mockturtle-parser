//
//  MockturtleLogger.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleLogger {

    public enum Level {
        case verbose
        case info
        case warning
        case error
    }

    public typealias LoggerClosure = (_ message: String, _ level: Level) -> Void
    private let closure: LoggerClosure

    public init(_ closure: @escaping LoggerClosure) {
        self.closure = closure
    }

    internal func verbose(_ message: String) {
        closure(message, .verbose)
    }

    internal func info(_ message: String) {
        closure(message, .info)
    }

    internal func warning(_ message: String) {
        closure(message, .warning)
    }

    internal func error(_ message: String) {
        closure(message, .error)
    }

}
