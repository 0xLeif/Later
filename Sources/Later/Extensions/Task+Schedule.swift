extension Task {
    /// Schedules a task to be executed after a specified duration.
    ///
    /// - Parameters:
    ///   - duration: The duration to wait before executing the task.
    ///   - tolerance: An optional tolerance for the duration.
    ///   - clock: The clock to use for measuring the duration. Defaults to `ContinuousClock`.
    ///   - task: The task to execute after the specified duration.
    ///
    /// - Throws: An error if the task fails or if the sleep is interrupted.
    ///
    /// - Note: This method is only available on macOS 13.0, iOS 16.0, watchOS 9.0, and tvOS 16.0 or newer.
    ///
    /// Example usage:
    /// ```swift
    /// do {
    ///     try await Task.schedule(for: .seconds(5)) {
    ///         print("Task executed after 5 seconds")
    ///     }
    /// } catch {
    ///     print("Failed to execute task: \(error)")
    /// }
    /// ```
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public static func schedule<TaskClock: Clock>(
        for duration: TaskClock.Instant.Duration,
        tolerance: TaskClock.Instant.Duration? = nil,
        clock: TaskClock = ContinuousClock(),
        task: @escaping () async throws -> Void
    ) async throws where Success == Never, Failure == Never {
        try await sleep(for: duration, tolerance: tolerance, clock: clock)
        try await task()
    }
}
