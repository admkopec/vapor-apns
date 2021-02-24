//
//  VaporAPNSPush.swift
//  VaporAPNS
//
//  Created by Matthijs Logemann on 23/09/2016.
//
//

import Foundation

/// Apple Push Notification Message
public struct ApplePushMessage {
    /// Message ID
    public let messageId: String = UUID().uuidString
    
    public let topic: String?
    
    public let collapseIdentifier: String?

    public let expirationDate: Date?
    
    /// APNS Type
    public let type: NotififcationType
    
    /// Push notification type
    ///
    /// - alert: Default type for push notifications, for use with alerts, banners and badges.
    /// - background: Push notification type for background refresh notifications.
    /// - voip: Push notification type for PushKit VoIP notifications.
    /// - complication: Push notification type for PushKit complication notifications, only available on watchOS.
    /// - fileprovider: Push notification type for PushKit FileProvider refresh notifications.
    /// - mdm: Push notification type for MDM device management notifications.
    public enum NotififcationType: String {
        case alert
        case background
        case voip
        case complication
        case fileprovider
        case mdm
    }
    
    /// APNS Priority
    public let priority: Priority
    
    /// Push notification delivery priority
    ///
    /// - energyEfficient: Send the push message at a time that takes into account power considerations for the device.
    /// - immediately:     Send the push message immediately. Notifications with this priority must trigger an alert, sound, or badge on the target device. It is an error to use this priority for a push notification that contains only the content-available key.
    public enum Priority: Int {
        case energyEfficient = 5
        case immediately = 10
    }
    
    /// APNS Payload
    public let payload: Payload
    
    /// Use sandbox server URL or not
    public let sandbox:Bool
    
    public init(topic: String? = nil, type: NotififcationType = .alert, priority: Priority, expirationDate: Date? = nil, payload: Payload, sandbox:Bool = true, collapseIdentifier: String? = nil) {
        self.topic = topic
        self.type = type
        self.priority = priority
        self.expirationDate = expirationDate
        self.payload = payload
        self.sandbox = sandbox
        self.collapseIdentifier = collapseIdentifier
    }
    
}
