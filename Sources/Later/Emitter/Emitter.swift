/// An `Emitter` is responsible for emitting values to an associated stream.
public struct Emitter<Value: Sendable>: Sendable {
    private let continuation: AsyncThrowingStream<Value, Error>.Continuation
    private let emitAction: @Sendable (Value) -> Void

    /// Initializes a new `Emitter` with a continuation and an emit action.
    ///
    /// - Parameters:
    ///   - continuation: The continuation to yield values to.
    ///   - emitAction: An additional action to perform when emitting a value.
    init(
        continuation: AsyncThrowingStream<Value, Error>.Continuation,
        emitAction: @escaping @Sendable (Value) -> Void
    ) {
        self.continuation = continuation
        self.emitAction = emitAction
    }

    /// Emits a value to the associated stream.
    ///
    /// - Parameter value: The value to emit.
    public func emit(value: Value) {
        continuation.yield(value)
        emitAction(value)
    }
}
