//
//  Flashcard+CoreDataProperties.swift
//  Flashcard App
//
//  Created by Ryan Mesa on 4/23/23.
//
//

import Foundation
import CoreData


extension Flashcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashcard> {
        return NSFetchRequest<Flashcard>(entityName: "Flashcard")
    }

    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var subject: String?

}

extension Flashcard : Identifiable {

}
