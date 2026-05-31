//
//  ChatService.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation

protocol ChatService {
    func sendMessageStream(_ text: String) -> AsyncThrowingStream<String, Error>
}
