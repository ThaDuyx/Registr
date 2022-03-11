//
//  Absence.swift
//  Registr
//
//  Created by Simon Andersen on 09/03/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Absence: Codable {
    @DocumentID var id: String?
    let date: Date
    let value: String
    let validated: Bool
}
