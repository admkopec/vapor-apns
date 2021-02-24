//
//  ApplePushMessageTests.swift
//  VaporAPNS
//
//  Created by Matthijs Logemann on 09/10/2016.
//
//

import Foundation
import XCTest
@testable import VaporAPNS

class ApplePushMessageTests: XCTestCase {
    
    func testInitializer() {
        let simplePayload = Payload(message: "Test message")
        let pushMessage = ApplePushMessage(topic: "com.apple.Test", type: .alert, priority: .immediately, expirationDate: nil, payload: simplePayload,sandbox: true, collapseIdentifier: "collapseID")
        
        XCTAssertEqual(pushMessage.topic, "com.apple.Test")
        XCTAssertTrue(pushMessage.sandbox)
        XCTAssertEqual(pushMessage.collapseIdentifier, "collapseID")
        XCTAssertEqual(pushMessage.type, .alert)
        XCTAssertEqual(pushMessage.priority, .immediately)
        XCTAssertNil(pushMessage.expirationDate)
        XCTAssertEqual(try! pushMessage.payload.makeJSON(), try! simplePayload.makeJSON())
    }
    
    func testPushTypes() {
        XCTAssertEqual(ApplePushMessage.NotififcationType.alert.rawValue, "alert")
        XCTAssertEqual(ApplePushMessage.NotififcationType.background.rawValue, "background")
        XCTAssertEqual(ApplePushMessage.NotififcationType.complication.rawValue, "complication")
        XCTAssertEqual(ApplePushMessage.NotififcationType.fileprovider.rawValue, "fileprovider")
        XCTAssertEqual(ApplePushMessage.NotififcationType.mdm.rawValue, "mdm")
    }
}
