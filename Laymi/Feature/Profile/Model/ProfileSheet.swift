//
//  ProfileSheet.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

enum ProfileSheet: String, Identifiable {
    case photo
    case name
    case birthday
    case gender
    
    var id: Self { self }
}
