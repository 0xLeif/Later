extension Publisher {
    /// Initializes an `Publisher` with a `Future` and updates its value when the future completes.
    /// - Parameter future: The future to observe.
    public func future(
        didSucceed: (@Sendable (Value) -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable () async throws -> Value
    ) -> Future<Value> {
        Future(
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
