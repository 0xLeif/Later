import Testing

extension Task where Success == Never, Failure == Never {
    static func catNap() async throws {
        try await Task.schedule(for: .milliseconds(100), task: {})
    }
}
