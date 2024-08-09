//
//  AsyncSequence+Stream.swift
//  Later
//
//  Created by Leif on 8/8/24.
//

extension AsyncSequence {
    /// Executes a given task for each value emitted by the stream.
    /// - Parameter task: The task to be executed for each value.
    public func forEach(
        do task: @escaping (Element) async throws -> Void
    ) async throws {
        for try await value in self {
            try await task(value)
        }
    }
}
