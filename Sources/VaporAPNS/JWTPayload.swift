//
//  APNSJWTPayload.swift
//  APNS
//
//  Created by Anthony Castelli on 4/1/18.
//
import Foundation
import JWT

struct APNSJWTPayload: JWTPayload {
    var iss: IssuerClaim
    var iat = IssuedAtClaim(value: Date())
    var exp = ExpirationClaim(value: Date(timeInterval: 3500, since: Date()))
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
}
