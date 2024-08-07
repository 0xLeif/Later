/// A `Future` represents a value that will be available at some point in the future.
/// It encapsulates an asynchronous task and provides a way to handle success and failure.
public struct Future<Value: Sendable>: Sendable {
    private let task: Task<Value, Error>

    /// The value of the future, which can be awaited asynchronously.
    public var value: Value {
        get async throws {
            try await task.value
        }
    }

    /// Initializes a `Future` with a task starter closure and optional success and failure handlers.
    /// - Parameters:
    ///   - didSucceed: A closure that is called when the task succeeds.
    ///   - didFail: A closure that is called when the task fails.
    ///   - task: The asynchronous task to be executed when start is called.
    @discardableResult
    public init(
        didSucceed: (@Sendable (Value) -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable () async throws -> Value
    ) {
        self.task = Task {
            do {
                let result = try await task()
                didSucceed?(result)
                return result
            } catch {
                didFail?(error)
                throw error
            }
        }
    }

    /// Cancels the task.
    public func cancel() {
        task.cancel()
    }
}
