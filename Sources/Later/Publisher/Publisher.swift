/// A `Publisher` actor that allows objects to subscribe to changes in state or data.
public actor Publisher<Value: Sendable> {
    typealias ValueSubscriber = Publisher where Value == Value

    private var value: Value?
    private var subscribers: [ObjectIdentifier: AnySubscriber<Value>]

    /// Gets the current value.
    public var currentValue: Value? {
        value
    }

    /// Initializes a new `Publisher` with an optional initial value and an array of initial subscribers.
    ///
    /// - Parameters:
    ///   - initialValue: An optional initial value for the publisher. Defaults to `nil`.
    ///   - subscribers: An array of initial subscribers. Defaults to an empty array.
    ///
    /// This initializer sets the initial value of the publisher and registers the initial subscribers.
    /// Each subscriber is identified by an `ObjectIdentifier` and stored in the `subscribers` dictionary.
    ///
    /// Example usage:
    /// ```swift
    /// class MySubscriber: Subscribing {
    ///     typealias Value = String
    ///
    ///     func didUpdate(newValue: String?) {
    ///         print("New value: \(String(describing: newValue))")
    ///     }
    /// }
    ///
    /// let subscriber = MySubscriber()
    /// let publisher = Publisher(initialValue: "Hello", subscribers: [subscriber])
    /// ```
    public init(
        initialValue value: Value? = nil,
        subscribers: [any Subscribing] = []
    ) {
        self.value = value

        var initialSubscribers: [ObjectIdentifier: AnySubscriber<Value>] = [:]
        for subscriber in subscribers {
            let id = ObjectIdentifier(subscriber)
            initialSubscribers[id] = AnySubscriber(subscriber)
        }

        self.subscribers = initialSubscribers
    }

    /// Adds a subscriber to the publisher.
    /// - Parameter subscriber: The subscriber that will be notified of value updates.
    public func add(subscriber: some Subscribing) {
        let id = ObjectIdentifier(subscriber)
        subscribers[id] = AnySubscriber(subscriber)
        subscribers[id]?.didUpdate(newValue: value)
    }

    /// Removes a subscriber.
    /// - Parameter subscriber: The subscriber to be removed.
    public func remove(subscriber: some Subscribing) {
        let id = ObjectIdentifier(subscriber)
        subscribers.removeValue(forKey: id)
    }

    /// Updates the value and notifies all subscribers.
    /// - Parameter newValue: The new value to set.
    internal func update(value newValue: Value?) {
        value = newValue
        for subscriber in subscribers.values {
            subscriber.didUpdate(newValue: newValue)
        }
    }
}
