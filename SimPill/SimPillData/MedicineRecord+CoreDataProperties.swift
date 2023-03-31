//
//  MedicineRecord+CoreDataProperties.swift
//  SimPill
//


import Foundation
import CoreData


extension MedicineRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicineRecord> {
        return NSFetchRequest<MedicineRecord>(entityName: "MedicineRecord")
    }

    @NSManaged public var mDate: String?
    @NSManaged public var mDescription: String?
    @NSManaged public var mFood: String?
    @NSManaged public var mId: NSNumber?
    @NSManaged public var mSchedule: String?
    @NSManaged public var mStrength: String?
    @NSManaged public var mTime: String?
    @NSManaged public var mTitle: String?
    @NSManaged public var mType: String?
    @NSManaged public var flag: Bool

}
