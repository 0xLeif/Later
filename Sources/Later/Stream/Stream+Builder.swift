extension Stream {
    /// A builder class to construct a `Stream` instance.
    public class Builder {
        private var onSuccess: (@Sendable () -> Void)?
        private var onFailure: (@Sendable (Error) -> Void)?
        private let task: @Sendable (Emitter<Value>) async throws -> Void

        public init(task: @escaping @Sendable (Emitter<Value>) async throws -> Void) {
            self.task = task
        }

        /// Sets the success closure.
        /// - Parameter closure: A closure that is called when the stream completes successfully.
        /// - Returns: The builder instance.
        public func onSuccess(_ closure: @escaping @Sendable () -> Void) -> Builder {
            self.onSuccess = closure
            return self
        }

        /// Sets the failure closure.
        /// - Parameter closure: A closure that is called when the stream fails.
        /// - Returns: The builder instance.
        public func onFailure(_ closure: @escaping @Sendable (Error) -> Void) -> Builder {
            self.onFailure = closure
            return self
        }

        /// Builds and returns a `Stream` instance.
        /// - Returns: A configured `Stream` instance.
        public func build() -> Stream<Value> {
            if let onSuccess, let onFailure {
                return Stream<Value>(
                    didSucceed: onSuccess,
                    didFail: onFailure,
                    task: task
                )
            } else if let onSuccess {
                return Stream<Value>(
                    didSucceed: onSuccess,
                    task: task
                )
            } else if let onFailure {
                return Stream<Value>(
                    didFail: onFailure,
                    task: task
                )
            } else {
                return Stream<Value>(
                    task: task
                )
            }
        }
    }
}
