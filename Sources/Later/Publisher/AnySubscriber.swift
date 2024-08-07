/// A type-erased wrapper for the `Subscribing` protocol.
class AnySubscriber<Value: Sendable>: Subscribing {
    private let didUpdate: (Any) -> Void

    init<Subscriber: Subscribing>(_ subscriber: Subscriber) {
        self.didUpdate = { value in
            let mirror = Mirror(reflecting: value)

            if mirror.displayStyle != .optional {
                guard
                    let value = value as? Subscriber.Value
                else { return }

                return subscriber.didUpdate(newValue: value)
            }

            if mirror.children.isEmpty {
                return subscriber.didUpdate(newValue: nil)
            }

            guard let (_, unwrappedValue) = mirror.children.first else {
                return subscriber.didUpdate(newValue: nil)
            }

            guard let value = unwrappedValue as? Subscriber.Value else {
                return // Do no call update, this value isn't for this Subscriber
            }

            subscriber.didUpdate(newValue: value)
        }
    }

    func didUpdate(newValue: Value?) {
        didUpdate(newValue as Any)
    }
}
