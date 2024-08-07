extension Future {
    /// A builder struct to construct a `Future` instance.
    public class Builder {
        private var onSuccess: (@Sendable (Value) -> Void)?
        private var onFailure: (@Sendable (Error) -> Void)?
        private let task: @Sendable () async throws -> Value

        /// Initializes the builder with an asynchronous task.
        /// - Parameter task: The asynchronous task to be performed.
        public init(task: @escaping @Sendable () async throws -> Value) {
            self.task = task
        }

        /// Sets the success closure.
        /// - Parameter closure: A closure that is called when the task succeeds.
        /// - Returns: The builder instance.
        public func onSuccess(_ closure: @escaping @Sendable (Value) -> Void) -> Builder {
            self.onSuccess = closure
            return self
        }

        /// Sets the failure closure.
        /// - Parameter closure: A closure that is called when the task fails.
        /// - Returns: The builder instance.
        public func onFailure(_ closure: @escaping @Sendable (Error) -> Void) -> Builder {
            self.onFailure = closure
            return self
        }

        /// Builds and returns a `Future` instance.
        /// - Returns: A configured `Future` instance.
        public func build() -> Future {
            if let onSuccess, let onFailure {
                return Future(
                    didSucceed: onSuccess,
                    didFail: onFailure,
                    task: task
                )
            } else if let onSuccess {
                return Future(
                    didSucceed: onSuccess,
                    task: task
                )
            } else {
                return Future(
                    task: task
                )
            }
        }
    }
}
