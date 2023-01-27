//
//  File.swift
//  
//
//  Created by René Meye on 05.06.22.
//

import Foundation

public class MobilityboxTicket: Identifiable, Codable, Equatable {
    public static func == (lhs: MobilityboxTicket, rhs: MobilityboxTicket) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id: String
    public var coupon_id: String
    public var coupon_reactivation_key: String?
    public var product: MobilityboxOrderedProduct
    public var ticket: MobilityboxTicketDetails
    public var area: MobilityboxTicketArea
    public var valid_from: String
    public var valid_until: String
    public var ticket_created_at: String
    public var sold_at: String
    public var environment: String
    public var createdAt: Date? = Date()
    var wasReactivated: Bool? = false
    
    public func getTitle() -> String {
        return "\(area.properties.city_name) - \(product.getTitle())"
    }
    
    public func validity() -> MobilityboxTicketValidity {
        if MobilityboxFormatter.isoDateTime.date(from: self.valid_until)! < Date() {
            return .expired
        } else if MobilityboxFormatter.isoDateTime.date(from: self.valid_from)! > Date() {
            return .future
        } else {
            return .valid
        }
    }
    
    func getAddedAgoText() -> String? {
        if (self.createdAt == nil) {
            return nil
        }
          
        let currentDate = Date()
        let delta = currentDate - self.createdAt!
        
        return MobilityboxFormatter.timeInterval.string(from: delta)!
    }

public enum MobilityboxTicketValidity: Error {
    case valid, expired, future
}

public struct MobilityboxTicketDetails: Codable {
    public let meta: MobilityboxTicketMetaDetails
    public let properties: MobilityboxJSONValue?
}

public struct MobilityboxTicketMetaDetails: Codable {
    public let version: String?
    public let template: String
    public let requires_engine: String
}
