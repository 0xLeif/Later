#if !os(Linux) && !os(Windows)
import os

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct SendableValue<Value: Sendable>: Sendable {
    private let lockedValue: OSAllocatedUnfairLock<Value>

    public init(_ initialValue: Value) {
        lockedValue = OSAllocatedUnfairLock(initialState: initialValue)
    }

    public var value: Value {
        get async {
            await withCheckedContinuation { continuation in
                lockedValue.withLock { value in
                    continuation.resume(returning: value)
                }
            }
        }
    }

    public func set(value newValue: Value) {
        lockedValue.withLock { value in
            value = newValue
        }
    }

    public func update(value updating: @Sendable (inout Value) -> Void) {
        lockedValue.withLock { value in
            var newValue = value
            updating(&newValue)
            value = newValue
        }
    }
}
#endif
