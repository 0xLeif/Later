/// A `Deferred` represents a deferred asynchronous task that starts only when explicitly requested.
public struct Deferred<Value: Sendable>: Sendable {
    /// Errors that can occur with `Deferred`.
    public enum DeferredError: Error, Sendable {
        /// The deferred task was not started.
        case deferredNotStarted
    }

    private var task: Task<Value, Error>?
    private let startTask: @Sendable () async throws -> Value
    private let didSucceed: (@Sendable (Value) -> Void)?
    private let didFail: (@Sendable (Error) -> Void)?

    /// The value of the deferred task, which can be awaited asynchronously.
    /// - Throws: An error if the deferred task has not started or if the task fails.
    public var value: Value {
        get async throws {
            guard let task = task else {
                throw DeferredError.deferredNotStarted
            }

            return try await task.value
        }
    }

    /// Initializes a `Deferred` with a task starter closure and optional success and failure handlers.
    /// - Parameters:
    ///   - didSucceed: A closure that is called when the task succeeds.
    ///   - didFail: A closure that is called when the task fails.
    ///   - task: The asynchronous task to be executed when start is called.
    public init(
        didSucceed: (@Sendable (Value) -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable () async throws -> Value
    ) {
        self.startTask = task
        self.didSucceed = didSucceed
        self.didFail = didFail
    }

    /// Starts the deferred task.
    public mutating func start() {
        guard task == nil else { return }
        
        let startTask = startTask
        let didSucceed = didSucceed
        let didFail = didFail

        task = Task {
            do {
                let value = try await startTask()
                didSucceed?(value)
                return value
            } catch {
                didFail?(error)
                throw error
            }
        }
    }

    /// Cancels the deferred task.
    public func cancel() {
        task?.cancel()
    }
}
