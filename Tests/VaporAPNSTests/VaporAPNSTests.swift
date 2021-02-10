//
//  VaporAPNSTests.swift
//  VaporAPNS
//
//  Created by Matthijs Logemann on 23/09/2016.
//
//

import XCTest
@testable import VaporAPNS
import JWT
import Foundation

class VaporAPNSTests: XCTestCase {
    
    let vaporAPNS: VaporAPNS! = nil
    
    func testLoadPrivateKey() throws {
        let folderPath = #file.components(separatedBy: "/").dropLast().joined(separator: "/")
        let filePath = "\(folderPath)/TestAPNSAuthKey.p8"
        
        if FileManager.default.fileExists(atPath: filePath) {
            let (privKey, pubKey) = try filePath.tokenString()
            XCTAssertEqual(privKey, "ALEILVyGWnbBaSaIFDsh0yoZaK+Ej0po/55jG2FR6u6C")
            XCTAssertEqual(pubKey, "BKqKwB6hpXp9SzWGt3YxnHgCEkcbS+JSrhoqkeqru/Nf62MeE958RIiKYsLFA/czdE7ThCt46azneU0IBnMCuQU=")
        } else {
            XCTFail("APNS Authentication key not found!")
        }
    }
    
    struct TestPayload: JWTPayload {
        var iss = IssuerClaim(value: "D86BEC0E8B")
        var iat = IssuedAtClaim(value: Date())
        
        func verify(using signer: JWTSigner) throws { }
    }
    
    func testEncoding() throws {
        // additionalHeaders: ["E811E6AE22"]
        let tokenString = try JWT(payload: TestPayload()).sign(using: .es256(key: "ALEILVyGWnbBaSaIFDsh0yoZaK+Ej0po/55jG2FR6u6C"))
        do {
            _ = try JWT<TestPayload>(from: tokenString, verifiedUsing: .es256(key: "BKqKwB6hpXp9SzWGt3YxnHgCEkcbS+JSrhoqkeqru/Nf62MeE958RIiKYsLFA/czdE7ThCt46azneU0IBnMCuQU="))
        } catch {
            XCTFail("Couldn't verify token, failed with error: \(error)")
        }
    }
    
    static var allTests : [(String, (VaporAPNSTests) -> () throws -> Void)] {
        return [
            ("testLoadPrivateKey", testLoadPrivateKey),
            ("testEncoding", testEncoding),
        ]
    }
}
