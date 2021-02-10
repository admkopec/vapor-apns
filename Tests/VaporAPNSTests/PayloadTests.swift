//
//  PayloadTests.swift
//  VaporAPNS
//
//  Created by Matthijs Logemann on 01/10/2016.
//
//

import Foundation
import XCTest
@testable import class VaporAPNS.Payload

class PayloadTests: XCTestCase {
    
    func testInitializer() throws {
    }
    
    func testSimplePush() throws {
        let expectedJSON = ["aps": ["alert": ["body": "Test"]]]
        
        let payload = Payload(message: "Test")
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? [String : [String: [String: String]]]
        
        XCTAssertNotNil(plNode?["aps"]?["alert"]?["body"])
        XCTAssertEqual(plNode?["aps"]?["alert"]?["body"], expectedJSON["aps"]?["alert"]?["body"])
    }

    func testTitleBodyPush() throws {
        let expectedJSON = ["aps": ["alert": ["body": "Test body", "title": "Test title"]]]
        
        let payload = Payload.init(title: "Test title", body: "Test body")
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? [String : [String: [String: String]]]
        
        XCTAssertNotNil(plNode?["aps"]?["alert"]?["body"])
        XCTAssertEqual(plNode?["aps"]?["alert"]?["body"], expectedJSON["aps"]?["alert"]?["body"])
        XCTAssertNotNil(plNode?["aps"]?["alert"]?["title"])
        XCTAssertEqual(plNode?["aps"]?["alert"]?["title"], expectedJSON["aps"]?["alert"]?["title"])
    }
    
    func testTitleBodyBadgePush() throws {
        let expectedJSON = ["aps": ["alert": ["body": "Test body", "title": "Test title"], "badge": 10]]
        
        let payload = Payload.init(title: "Test title", body: "Test body", badge: 10)
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? [String : [String: Any]]

        XCTAssertNotNil((plNode?["aps"]?["alert"] as? Dictionary<String, String>)?["body"])
        XCTAssertEqual((plNode?["aps"]?["alert"] as? Dictionary<String, String>)?["body"], (expectedJSON["aps"]?["alert"] as? Dictionary<String, String>)?["body"])
        XCTAssertNotNil((plNode?["aps"]?["alert"] as? Dictionary<String, String>)?["title"])
        XCTAssertEqual((plNode?["aps"]?["alert"] as? Dictionary<String, String>)?["title"], (expectedJSON["aps"]?["alert"] as? Dictionary<String, String>)?["title"])
        XCTAssertNotNil(plNode?["aps"]?["badge"] as? Int)
        XCTAssertEqual(plNode?["aps"]?["badge"] as? Int, expectedJSON["aps"]?["badge"] as? Int)
    }

    func testTitleSubtitleBodyPush() throws {
        let expectedJSON = ["aps": ["alert": ["body": "Test body", "title": "Test title", "subtitle": "Test subtitle"]]]

        let payload = Payload.init(title: "Test title", body: "Test body")
        payload.subtitle = "Test subtitle"
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? [String : [String: [String: String]]]

        XCTAssertNotNil(plNode?["aps"]?["alert"]?["body"])
        XCTAssertEqual(plNode?["aps"]?["alert"]?["body"], expectedJSON["aps"]?["alert"]?["body"])
        XCTAssertNotNil(plNode?["aps"]?["alert"]?["title"])
        XCTAssertEqual(plNode?["aps"]?["alert"]?["title"], expectedJSON["aps"]?["alert"]?["title"])
        XCTAssertNotNil(plNode?["aps"]?["alert"]?["subtitle"])
        XCTAssertEqual(plNode?["aps"]?["alert"]?["subtitle"], expectedJSON["aps"]?["alert"]?["subtitle"])
    }

    func testSimpleWithThreadIdPush() throws {
        let expectedJSON = ["aps": ["alert": ["body": "Test"], "thread-id": "Test Thread Id"]]

        let payload = Payload(message: "Test")
        payload.threadId = "Test Thread Id"
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? Dictionary<String, Dictionary<String, Any>>

        XCTAssertNotNil((plNode?["aps"]?["alert"] as? Dictionary<String, String>)?["body"])
        XCTAssertEqual((plNode?["aps"]?["alert"] as? Dictionary<String, String>)?["body"], (expectedJSON["aps"]?["alert"] as? Dictionary<String, String>)?["body"])
        XCTAssertNotNil(plNode?["aps"]?["thread-id"] as? String)
        XCTAssertEqual(plNode?["aps"]?["thread-id"] as? String, expectedJSON["aps"]?["thread-id"] as? String)
    }

    func testContentAvailablePush() throws {
        let expectedJSON = ["aps": ["content-available": true]]
        
        let payload = Payload.contentAvailable
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? Dictionary<String, Dictionary<String, Bool>>

        XCTAssertNotNil(plNode?["aps"]?["content-available"])
        XCTAssertEqual(plNode?["aps"]?["content-available"], expectedJSON["aps"]?["content-available"])
    }
    
    func testContentAvailableWithExtrasPush() throws {
        let expectedJSON = ["aps": ["content-available": true], "IntKey": 101, "StringKey": "StringExtra1"] as [String : Any]
        
        let payload = Payload.contentAvailable
        payload.extra["StringKey"] = "StringExtra1"
        payload.extra["IntKey"] = 101
        let plJSON = try payload.makeJSON()
        let plNode = try JSONSerialization.jsonObject(with: plJSON, options: .init(rawValue: 0)) as? [String : Any]

        XCTAssertNotNil((plNode?["aps"] as? [String: Bool])?["content-available"])
        XCTAssertEqual((plNode?["aps"] as? [String: Bool])?["content-available"], (expectedJSON["aps"] as? [String: Bool])?["content-available"])
        XCTAssertNotNil(plNode?["StringKey"] as? String)
        XCTAssertEqual(plNode?["StringKey"] as? String, expectedJSON["StringKey"] as? String)
        XCTAssertNotNil(plNode?["IntKey"] as? Int)
        XCTAssertEqual(plNode?["IntKey"] as? Int, expectedJSON["IntKey"] as? Int)
    }
    
    static var allTests : [(String, (PayloadTests) -> () throws -> Void)] {
        return [
            ("testSimplePush", testSimplePush),
            ("testTitleBodyPush", testTitleBodyPush),
            ("testTitleBodyBadgePush", testTitleBodyBadgePush),
            ("testSimpleWithThreadIdPush", testSimpleWithThreadIdPush),
            ("testContentAvailablePush", testContentAvailablePush),
            ("testContentAvailableWithExtrasPush", testContentAvailableWithExtrasPush),
        ]
    }
}
