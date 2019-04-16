//
//  Category.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 04/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import UIKit

/// Enum which represents available Quiz categories.
enum Category: String {
    
    case sports = "SPORTS"
    case science = "SCIENCE"
    
    /// Color representation of category.
    var color: UIColor {
        switch self {
        case .sports:
            return UIColor.blue
        case .science:
            return UIColor.green
        }
    }
    
}
