/// A protocol that defines the methods for an observer.
public protocol Subscribing: AnyObject {
    associatedtype Value: Sendable

    /// Notifies the observer of a value update.
    /// - Parameter newValue: The new value.
    func didUpdate(newValue: Value?)
}
