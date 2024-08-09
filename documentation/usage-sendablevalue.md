
# SendableValue Usage

`SendableValue` is a powerful tool provided by **Later** that allows you to manage thread-safe, mutable values across concurrent tasks in a Swift project. It wraps a value that can be safely shared between different contexts, ensuring that the value is handled properly even when accessed by multiple tasks simultaneously.

## Overview

The `SendableValue` type ensures that the value it holds is safely accessible in a concurrent environment. It uses [`OSAllocatedUnfairLock`](https://developer.apple.com/documentation/os/osallocatedunfairlock) to manage locking, making it efficient and secure for multi-threaded operations.

### Key Features

- **Thread-Safe Mutability**: Ensures values can be safely mutated across concurrent tasks.
- **Concurrency Control**: Built-in locking mechanisms manage access in a multi-threaded environment.
- **Compatibility with `Sendable`**: Allows classes or structs using `SendableValue` to be marked as `Sendable` even when they contain mutable state.

## Example Usage

### Using SendableValue in a Sendable Class

One of the most common use cases for `SendableValue` is in a `Sendable` class, where you need to safely share mutable state across multiple tasks.

```swift
import Later

final class Counter: Sendable {
    private let value: SendableValue<Int>

    init(initialValue: Int) {
        self.value = SendableValue(initialValue)
    }

    func increment() {
        value.update { $0 += 1 }
    }

    func getValue() async -> Int {
        await value.value
    }
}

let counter = Counter(initialValue: 0)

// Increment concurrently
let tasks = (1 ... 10).map { _ in
    Task {
        counter.increment()
    }
}

for task in tasks {
    await task.value
}

let finalValue = await counter.getValue()
print(finalValue)  // Prints "10"
```

In this example, `Counter` is a `Sendable` class that safely manages a mutable integer value using `SendableValue`. The value is incremented concurrently across multiple tasks, demonstrating thread-safe access and mutation.

### Safely Sharing Mutable State

Another key use of `SendableValue` is to allow safe sharing of mutable state in `Sendable` contexts, where direct use of `var` would otherwise make the class or struct non-conformant.

```swift
final class SharedData: Sendable {
    private let data: SendableValue<String>

    init(initialData: String) {
        self.data = SendableValue(initialData)
    }

    func updateData(newData: String) {
        data.set(value: newData)
    }

    func getData() async -> String {
        await data.value
    }
}

let sharedData = SharedData(initialData: "Initial Value")

// Update data safely and ensure the update is completed before accessing the value
Task {
    sharedData.updateData(newData: "Updated Value")
    let currentValue = await sharedData.getData()
    print(currentValue)  // Prints "Updated Value"
}
```

This updated example ensures that the value is only accessed after the task responsible for updating the data has completed, preventing any indeterminate results.

### Ensuring Safe Access in Actors

`SendableValue` can also be used in actors to manage mutable state safely and efficiently.

```swift
actor SafeCounter {
    private let value: SendableValue<Int>

    init(initialValue: Int) {
        self.value = SendableValue(initialValue)
    }

    func increment() {
        value.update { $0 += 1 }
    }

    func getValue() async -> Int {
        await value.value
    }
}

let safeCounter = SafeCounter(initialValue: 0)

// Increment the counter safely within the actor
await safeCounter.increment()
let safeValue = await safeCounter.getValue()
print(safeValue)  // Prints "1"
```

In this actor example, `SendableValue` provides additional safety and efficiency, ensuring that the state is not only protected by the actor’s isolation but also optimized for concurrent access.

## Best Practices

- **Use in Concurrent Environments**: Utilize `SendableValue` whenever you need to share and mutate values across multiple concurrent tasks.
- **Incorporate in `Sendable` Classes**: Use `SendableValue` in `Sendable` classes to safely manage mutable state without violating `Sendable` conformance.
- **Combine with Actors**: Consider using `SendableValue` within actors to enhance safety and efficiency in managing mutable state.

## Conclusion

`SendableValue` is an essential component of the **Later** library that provides a simple, safe way to manage mutable state in asynchronous Swift programming. By using `SendableValue`, you can ensure that your values are handled correctly across concurrent tasks, making your code more robust and maintainable.

For more advanced usage, explore other components of the **Later** library like [Future](usage-future.md), [Deferred](usage-deferred.md), and [Stream](usage-stream.md).
