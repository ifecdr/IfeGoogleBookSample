//
//  Favorite+CoreDataProperties.swift
//  IfeGoogleBookSample
//
//  Created by MAC Consultant on 3/14/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var author: String?
    @NSManaged public var image: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?

}
