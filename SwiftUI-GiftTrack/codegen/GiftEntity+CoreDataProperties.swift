//
//  GiftEntity+CoreDataProperties.swift
//  SwiftUI-GiftTrack
//
//  Created by R. Mark Volkmann on 11/22/21.
//
//

import Foundation
import CoreData


extension GiftEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GiftEntity> {
        return NSFetchRequest<GiftEntity>(entityName: "GiftEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Int64
    @NSManaged public var url: URL?
    @NSManaged public var reason: OccasionEntity?
    @NSManaged public var to: PersonEntity?

}

extension GiftEntity : Identifiable {

}
