extension Publisher {
    /// Initializes a `Stream` and updates the observer's value with each emitted value.
    /// - Parameters:
    ///   - didSucceed: A closure that is called when the stream completes successfully.
    ///   - didFail: A closure that is called when the stream fails.
    ///   - task: The asynchronous task that produces values for the stream.
    /// - Returns: The initialized `Stream`.
    public func stream(
        didSucceed: (@Sendable () -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable (Emitter<Value>) async throws -> Void
    ) -> Stream<Value> {
        let stream = Stream(
            emitAction: { value in
                Task {
                    await self.update(value: value)
                }
            },
            didSucceed: didSucceed,
            didFail: didFail,
            task: task
        )

        return stream
    }
}
