//
//  MockturtleResponse.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation


public class MockturtleResponse: Codable {

    public var code: Int
    public var header: [String: String]
    public var body: String?

}
