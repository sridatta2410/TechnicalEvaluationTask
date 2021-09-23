//
//  MeetingsList+CoreDataProperties.swift
//  NewMeetingScreen
//
//  Created by Sridatta Nallamilli on 23/09/21.
//
//

import Foundation
import CoreData


extension MeetingsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeetingsList> {
        return NSFetchRequest<MeetingsList>(entityName: "MeetingsList")
    }

    @NSManaged public var company: String?
    @NSManaged public var ends: String?
    @NSManaged public var location: String?
    @NSManaged public var password: String?
    @NSManaged public var starts: String?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var privacy: String?

}
