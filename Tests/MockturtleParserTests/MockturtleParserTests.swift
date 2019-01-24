//
//  MockturtleParserTests.swift
//  MockturtleParserTests
//
//  Created by Christoph Pageler on 24.01.19.
//


import XCTest
@testable import MockturtleParser


final class MockturtleParserTests: XCTestCase {

    static var allTests = [
        ("testSimpleContainsAllRoutes", testSimpleContainsAllRoutes),
        ("testSimpleContainsAllStatesForAuthLogin", testSimpleContainsAllStatesForAuthLogin),
        ("testSimpleScenarioImport", testSimpleScenarioImport)
    ]

    private var fixtureSimpleURL: URL {
        let path = ProcessInfo.processInfo.environment["FIXTURE_PATH_SIMPLE"]!
        return URL(fileURLWithPath: path)
    }

    private var fixtureSimpleScenarioURL: URL {
        return fixtureSimpleURL
            .deletingLastPathComponent()
            .appendingPathComponent("scenarios")
    }

    private var testLogger: MockturtleLogger {
        return MockturtleLogger({ (message, level) in
            switch level {
            case .verbose:  print("VERBOSE : \(message)")
            case .info:     print("INFO    : \(message)")
            case .warning:  print("WARNING : \(message)")
            case .error:    print("ERROR   : \(message)")
            }
        })
    }

    func testSimpleContainsAllRoutes() {
        guard let config = MockturtleConfig.load(contentsOf: fixtureSimpleURL, logger: testLogger) else {
            XCTFail("Could not load config")
            return
        }

        XCTAssertEqual(config.version, "0.1.0")
        XCTAssertTrue(config.routes.contains(where: { $0 == "v1/auth/login"}))
        XCTAssertTrue(config.routes.contains(where: { $0 == "v1/auth/logout"}))
        XCTAssertTrue(config.routes.contains(where: { $0 == "v1/users"}))
        XCTAssertTrue(config.routes.contains(where: { $0.directory == "global/error_codes"}))

        XCTAssertFalse(config.routes.contains(where: { $0 == "v1/list"}))
        XCTAssertFalse(config.routes.contains(where: { $0 == "whatever"}))
        XCTAssertFalse(config.routes.contains(where: { $0 == ""}))
    }

    func testSimpleContainsAllStatesForAuthLogin() {
        guard let config = MockturtleConfig.load(contentsOf: fixtureSimpleURL, logger: testLogger) else {
            XCTFail("Could not load config")
            return
        }

        guard let loginRoute = config.routes.first(where: { $0 == "v1/auth/login" }) else {
            XCTFail("Could not find login route")
            return
        }

        XCTAssertEqual(config.version, "0.1.0")
        XCTAssertTrue(loginRoute.states?.contains(where: { $0 == "valid"}) ?? false)
        XCTAssertTrue(loginRoute.states?.contains(where: { $0 == "invalid"}) ?? false)

        XCTAssertFalse(loginRoute.states?.contains(where: { $0 == "foo"}) ?? false)
        XCTAssertFalse(loginRoute.states?.contains(where: { $0 == "false"}) ?? false)
        XCTAssertFalse(loginRoute.states?.contains(where: { $0 == "whatever"}) ?? false)
        XCTAssertFalse(loginRoute.states?.contains(where: { $0 == ""}) ?? false)

        guard let validState = loginRoute.states?.first(where: { $0 == "valid"}) else {
            XCTFail("Could not find valid state")
            return
        }

        guard let validStateDelay = validState.delay else {
            XCTFail("Valid state delay is nil")
            return
        }

        XCTAssertEqual(validStateDelay.from, 0.0)
        XCTAssertEqual(validStateDelay.to, 1.0)
    }

    func testSimpleScenarioImport() {
        guard let scenarios = MockturtleScenario.load(directoryOf: fixtureSimpleScenarioURL) else {
            XCTFail("failed guard")
            return
        }

        XCTAssertTrue(scenarios.contains(where: { $0 == "valid_login" }))
        XCTAssertTrue(scenarios.contains(where: { $0 == "valid_bankaccounts" }))

        guard let validBankAccountsScenario = scenarios.first(where: { $0 == "valid_bankaccounts" }) else {
            XCTFail("failed guard")
            return
        }

        let validBankAccountScenarioRoutes = validBankAccountsScenario.flatRoutes()
        if let bankAccountsFirst = validBankAccountScenarioRoutes.first(where: { route in
            return route.path == "v1/bank_accounts/show" && route.method == "GET"
        }) {
            XCTAssertEqual(bankAccountsFirst.state, "user_315")
        } else {
            XCTFail("failed guard")
        }
    }

}
