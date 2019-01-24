//
//  MockturtleParser.swift
//  MockturtleParser
//
//  Created by Christoph Pageler on 24.01.19.
//


import Foundation
import Yams


internal class MockturtleParser {

    internal func parse(contentsOf url: URL, logger: MockturtleLogger? = nil) -> MockturtleConfig? {
        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            logger?.error("could not load config file at `\(url.path)`")
            return nil
        }
        logger?.verbose("did load config file at `\(url.path)`")

        guard let config = try? YAMLDecoder().decode(MockturtleConfig.self, from: string, userInfo: [:]) else {
            logger?.error("could not parse config file at \(url.path)")
            return nil
        }
        logger?.verbose("did parse config file at `\(url.path)`")

        let baseDirectory = url.deletingLastPathComponent()

        logger?.verbose("start load states for all routes")
        for route in config.routes {
            route.states = parseStates(for: route, baseDirectory: baseDirectory, logger: logger)
        }

        return config
    }

    internal func parse(directoryOf url: URL, logger: MockturtleLogger? = nil) -> [MockturtleScenario]? {
        var urlIsDirectory: ObjCBool = false
        let urlExists = FileManager.default.fileExists(atPath: url.path, isDirectory: &urlIsDirectory)
        guard urlExists && urlIsDirectory.boolValue else {
            logger?.error("directory does not exist or is not a directory `\(url.path)`")
            return nil
        }

        guard let files = try? FileManager.default.contentsOfDirectory(at: url,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [])
        else {
            logger?.error("failed to load content of directory `\(url.path)`")
            return nil
        }

        var scenarios: [MockturtleScenario] = []
        for file in files {
            guard file.pathExtension == "yml" else { continue }
            guard let scenario = MockturtleScenario.load(contentsOf: file, logger: logger) else { continue }
            scenarios.append(scenario)
        }
        return scenarios
    }

    internal func parse(contentsOf url: URL, logger: MockturtleLogger? = nil) -> MockturtleScenario? {
        guard let string = try? String(contentsOf: url, encoding: .utf8) else {
            logger?.error("could not load scenario file at `\(url.path)`")
            return nil
        }
        logger?.verbose("did load scenario file at `\(url.path)`")

        guard let scenario = try? YAMLDecoder().decode(MockturtleScenario.self, from: string, userInfo: [:]) else {
            logger?.error("could not parse scenario file at \(url.path)")
            return nil
        }
        scenario.identifier = scenario.identifier ?? url.lastPathComponent.replacingOccurrences(of: ".yml", with: "")
        logger?.verbose("did parse scenario file at `\(url.path)`")

        let baseDirectory = url.deletingLastPathComponent()
        logger?.verbose("start load includes for scenario")
        scenario.includedScenarios = parseScenarioIncludes(for: scenario,
                                                           baseDirectory: baseDirectory,
                                                           logger: logger)

        return scenario
    }

    private func parseStates(for route: MockturtleRoute,
                             baseDirectory: URL,
                             logger: MockturtleLogger? = nil) -> [MockturtleState] {
        // resolve directory for state
        guard let stateDirectory = route.resolvedDirectory(baseDirectory: baseDirectory) else {
            logger?.warning("could not resolve directory for route `\(route.directory ?? route.url ?? "")`")
            return []
        }

        // check if directory is valid
        var stateDirectoryIsDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: stateDirectory.path,
                                                        isDirectory: &stateDirectoryIsDirectory)
        guard fileExists && stateDirectoryIsDirectory.boolValue else {
            // swiftlint:disable line_length
            logger?.warning("resolved directory for route `\(route.directory ?? route.url ?? "")` does not exist or is not a directory")
            // swiftlint:enable line_length
            return []
        }

        // parse all yml files
        guard let files = try? FileManager.default.contentsOfDirectory(at: stateDirectory,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [])
            else {
                logger?.warning("could not find state files in directory `\(stateDirectory.path)`")
                return []
        }

        guard files.count > 0 else {
            logger?.info("no state files found in direcotry `\(stateDirectory.path)`")
            return []
        }

        var states: [MockturtleState] = []
        for file in files {
            guard file.pathExtension == "yml" else { continue }
            guard let fileContent = try? String(contentsOf: file, encoding: .utf8) else { continue }
            guard let state = try? YAMLDecoder().decode(MockturtleState.self, from: fileContent, userInfo: [:]) else {
                logger?.info("failed parsing file, skipping `\(file.path)`")
                continue
            }
            state.identifier = state.identifier ?? file.lastPathComponent.replacingOccurrences(of: ".yml", with: "")
            // swiftlint:disable line_length
            logger?.verbose("did load state `\(state.identifier ?? "")` for route `\(route.url ?? route.directory ?? "")`")
            // swiftlint:enable line_length
            if let delay = state.delay, delay.from > delay.to {
                logger?.warning("invalid delay range from \(delay.from) to \(delay.to). ignoring delay")
            }
            states.append(state)
        }

        return states
    }

    private func parseScenarioIncludes(for scenario: MockturtleScenario,
                                       baseDirectory: URL,
                                       logger: MockturtleLogger? = nil) -> [MockturtleScenario] {
        var result: [MockturtleScenario] = []
        for include in scenario.includes ?? [] {
            let scenarioPath = baseDirectory.appendingPathComponent(include)
            guard let includedScenario = MockturtleScenario.load(contentsOf: scenarioPath,
                                                                 logger: logger)
                else {
                    continue
            }
            result.append(includedScenario)
        }
        return result
    }

}
