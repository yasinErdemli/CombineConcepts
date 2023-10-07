//
//  Error.swift
//  CombineConcepts
//
//  Created by Yasin Erdemli on 17.09.2023.
//

import Foundation

enum PublisherError: Error, LocalizedError {
    case bombHasBeenFound
    
    var errorDescription: String? {
        switch self {
        case .bombHasBeenFound:
            return NSLocalizedString("You found a bomb", comment: "Bomb Error")
        }
    }
}
