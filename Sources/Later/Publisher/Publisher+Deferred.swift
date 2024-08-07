extension Publisher {
    /// Initializes a `Deferred` and updates the observer's value when the deferred task completes.
    /// - Parameters:
    ///   - didSucceed: A closure that is called when the deferred task completes successfully.
    ///   - didFail: A closure that is called when the deferred task fails.
    ///   - task: The asynchronous task to be executed.
    /// - Returns: The initialized `Deferred`.
    public func deferred(
        didSucceed: (@Sendable (Value) -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable () async throws -> Value
    ) -> Deferred<Value> {
        Deferred(
            didSucceed: didSucceed,
            didFail: didFail,
            task: {
                let newValue = try await task()
                await self.update(value: newValue)
                return newValue
            }
        )
    }
}
