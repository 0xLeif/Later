/// A `Stream` represents an asynchronous sequence of values that are emitted over time.
final public class Stream<Value: Sendable>: AsyncSequence, Sendable {
    public typealias Element = Value
    public typealias AsyncIterator = AsyncThrowingStream<Value, Error>.AsyncIterator

    private let asyncStream: AsyncThrowingStream<Value, Error>

    internal init(
        emitAction: (@Sendable (Value) -> Void)? = nil,
        didSucceed: (@Sendable () -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable (Emitter<Value>) async throws -> Void
    ) {
        asyncStream = AsyncThrowingStream<Value, Error> { continuation in
            Task {
                do {
                    let emitter = Emitter(
                        continuation: continuation,
                        emitAction: emitAction ?? { _ in }
                    )

                    try await task(emitter)
                    didSucceed?()
                    continuation.finish()
                } catch {
                    didFail?(error)
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    /// Initializes a `Stream` with a task starter closure and optional success and failure handlers.
    /// - Parameters:
    ///   - didSucceed: A closure that is called when the stream completes successfully.
    ///   - didFail: A closure that is called when the stream fails.
    ///   - task: The asynchronous task that produces values for the stream.
    public convenience init(
        didSucceed: (@Sendable () -> Void)? = nil,
        didFail: (@Sendable (Error) -> Void)? = nil,
        task: @escaping @Sendable (Emitter<Value>) async throws -> Void
    ) {
        self.init(emitAction: nil, didSucceed: didSucceed, didFail: didFail, task: task)
    }

    /// Executes a given task for each value emitted by the stream.
    /// - Parameter task: The task to be executed for each value.
    public func forEach(
        do task: @escaping (Value) async throws -> Void
    ) async throws {
        for try await value in self {
            try await task(value)
        }
    }

    /// Transforms the values emitted by the stream using a given closure.
    /// - Parameter transform: The closure to transform each value.
    /// - Returns: A new stream with the transformed values.
    public func map<Result: Sendable>(
        _ transform: @escaping @Sendable (Value) async throws -> Result
    ) -> Stream<Result> {
        Stream<Result> { emitter in
            for try await value in self {
                let newValue = try await transform(value)
                emitter.emit(value: newValue)
            }
        }
    }

    /// Filters the values emitted by the stream using a given closure.
    /// - Parameter isIncluded: The closure to determine if a value should be included.
    /// - Returns: A new stream with the filtered values.
    public func filter(
        _ isIncluded: @escaping @Sendable (Value) async throws -> Bool
    ) -> Stream<Value> {
        Stream<Value> { emitter in
            for try await value in self {
                if try await isIncluded(value) {
                    emitter.emit(value: value)
                }
            }
        }
    }

    /// Transforms the values emitted by the stream using a given closure and removes nil values.
    /// - Parameter transform: The closure to transform each value.
    /// - Returns: A new stream with the transformed and non-nil values.
    public func compactMap<Result: Sendable>(
        _ transform: @escaping @Sendable (Value) async throws -> Result?
    ) -> Stream<Result> {
        Stream<Result> { emitter in
            for try await value in self {
                if let newValue = try await transform(value) {
                    emitter.emit(value: newValue)
                }
            }
        }
    }

    /// Reduces the values emitted by the stream to a single value using a given closure.
    /// - Parameters:
    ///   - initialResult: The initial value for the reduction.
    ///   - nextPartialResult: The closure to combine the current result and the next value.
    /// - Returns: The reduced value.
    public func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: @escaping (Result, Value) async throws -> Result
    ) async throws -> Result {
        var result = initialResult
        for try await value in self {
            result = try await nextPartialResult(result, value)
        }
        return result
    }

    /// Reduces the values emitted by the stream into the provided initial result using a given closure.
    /// - Parameters:
    ///   - initialResult: The initial value for the reduction.
    ///   - updateAccumulatingResult: The closure to update the accumulating result with the next value.
    /// - Returns: The reduced value.
    public func reduce<Result>(
        into initialResult: Result,
        _ updateAccumulatingResult: @escaping (inout Result, Value) async throws -> Void
    ) async throws -> Result {
        var result = initialResult
        for try await value in self {
            try await updateAccumulatingResult(&result, value)
        }
        return result
    }

    /// Collects all the values emitted by the stream into an array.
    /// - Returns: An array of all the values emitted by the stream.
    public func intoArray() async throws -> [Value] {
        var values: [Value] = []
        for try await value in self {
            values.append(value)
        }
        return values
    }

    // MARK: - AsyncSequence

    /// Provides an asynchronous iterator for the stream.
    public func makeAsyncIterator() -> AsyncThrowingStream<Value, Error>.AsyncIterator {
        asyncStream.makeAsyncIterator()
    }
}
