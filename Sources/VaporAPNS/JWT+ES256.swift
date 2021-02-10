//
//  JWT+ES256.swift
//  APNS
//
//  Created by Anthony Castelli on 4/1/18.
//
import Foundation
import CCryptoOpenSSL
import Crypto
import Bits
import JWT

public enum JWTError: Error {
    case createKey
    case createPublicKey
    case decoding
    case encoding
    case incorrectNumberOfSegments
    case incorrectPayloadForClaimVerification
    case missingAlgorithm
    case missingClaim(withName: String)
    case privateKeyRequired
    case signatureVerificationFailed
    case signing
    case verificationFailedForClaim(withName: String)
    case wrongAlgorithm
    case unknown(Error)
}

public final class ES256 {
    internal let curve = NID_X9_62_prime256v1
    internal let key: Data
    
    public var jwtAlgorithmName: String {
        return "ES256"
    }
    
    public init(key: Data) {
        self.key = key
    }
    
    // Returns DER Encoded signature
    public func sign(_ plaintext: LosslessDataConvertible) throws -> Data {
        let digest = Bytes(try SHA256.hash(plaintext))
        let ecKey = try self.newECKeyPair()
        defer { EC_KEY_free(ecKey) }
        var derEncodedSignature = Data(count: Int(ECDSA_size(ecKey)))
        var derLength: UInt32 = 0
        try derEncodedSignature.withUnsafeMutableBytes { derBytes throws -> Void in
            guard ECDSA_sign(0, digest, Int32(digest.count), derBytes.bindMemory(to: UInt8.self).baseAddress, &derLength, ecKey) == 1 else {
                throw JWTError.signing
            }
        }
        return derEncodedSignature
    }
    
    // Verifies DER Encoded signature
    public func verify(_ signature: Data, signs plaintext: Data) throws -> Bool {
        var endIndex = signature.endIndex-1
        while signature[endIndex] == 0 { endIndex -= 1 }
        // Remove trailing zeros
        var signatureBytes = Bytes(signature[0...endIndex])
        return try signatureBytes.withUnsafeMutableBufferPointer { bytes -> Bool in
            let digest = Bytes(try SHA256.hash(plaintext))
            let ecKey = try self.newECPublicKey()
            defer { EC_KEY_free(ecKey) }
            
            if ECDSA_verify(0, digest, Int32(digest.count), bytes.baseAddress, Int32(bytes.count), ecKey) == 1 {
                return true
            }
            return false
        }
    }
    
    func newECKey() throws -> OpaquePointer {
        guard let ecKey = EC_KEY_new_by_curve_name(curve) else {
            throw JWTError.createKey
        }
        return ecKey
    }
    
    func newECKeyPair() throws -> OpaquePointer {
        // Set private key
        let privateNum = BN_bin2bn(Bytes(key), Int32(key.count), nil)
        let ecKey = try newECKey()
        EC_KEY_set_private_key(ecKey, privateNum)
        
        // Derive public key
        let context = BN_CTX_new()
        BN_CTX_start(context)
        
        let group = EC_KEY_get0_group(ecKey)
        let publicKey = EC_POINT_new(group)
        EC_POINT_mul(group, publicKey, privateNum, nil, nil, context)
        EC_KEY_set_public_key(ecKey, publicKey)
        
        // Release resources
        EC_POINT_free(publicKey)
        BN_CTX_end(context)
        BN_CTX_free(context)
        BN_clear_free(privateNum)
        
        return ecKey
    }
    
    func newECPublicKey() throws -> OpaquePointer {
        var ecKey: OpaquePointer? = try self.newECKey()
        var publicBytes = Bytes(self.key)
        return try publicBytes.withUnsafeMutableBufferPointer { bytes -> OpaquePointer in
            var publicBytesPointer = UnsafePointer(bytes.baseAddress)
            if let ecKey = o2i_ECPublicKey(&ecKey, &publicBytesPointer, self.key.count) {
                return ecKey
            } else {
                throw JWTError.createPublicKey
            }
        }
    }
}

extension JWTSigner {
    /// Creates an ES256 JWT signer that handles DER encoded signature with the supplied key in base64
    public static func es256(key: String) -> JWTSigner {
        let alg = CustomJWTAlgorithm(name: "ES256", sign: { plaintext in
            return try ES256(key: Data(base64Encoded: key)!).sign(plaintext)
        }, verify: { signature, plaintext in
            return try ES256(key: Data(base64Encoded: key)!).verify(signature.convertToData(), signs: plaintext.convertToData())
        })
        return .init(algorithm: alg)
    }
}
