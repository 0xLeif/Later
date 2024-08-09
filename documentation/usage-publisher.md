
# Publisher Usage

`Publisher` is a component of the **Later** library that allows you to manage and notify subscribers about changes to a value over time. It is particularly useful for implementing reactive systems where multiple components need to be kept in sync with changing data.

## Overview

A `Publisher` allows you to manage a value and notify any subscribers whenever that value changes. Subscribers can be added or removed dynamically, and they will be updated whenever the publisher’s value is modified.

### Key Features

- **Subscriber Notification**: Automatically notifies subscribers when the value changes.
- **Multiple Subscribers**: Supports multiple subscribers receiving updates.
- **Integration with `Future`, `Deferred`, and `Stream`**: Can generate `Future`, `Deferred`, and `Stream` objects directly, ensuring that these objects and the `Publisher` stay synchronized.

## Example Usage

### Creating a Publisher and Adding Subscribers

You can create a `Publisher` by initializing it with an optional initial value. Subscribers can be added using the `add(subscriber:)` method.

```swift
import Later

final class TestSubscriber: Subscribing, Sendable {
    typealias Value = String
    let observedValues: SendableValue<[String?]> = SendableValue([])

    func didUpdate(newValue: String?) {
        observedValues.update { values in
            values.append(newValue)
        }
    }
}

let publisher = Publisher<String?>(initialValue: "Initial value")
let testSubscriber = TestSubscriber()
await publisher.add(subscriber: testSubscriber)

// Update the value using a Future generated from the publisher
let future = await publisher.future(
    didSucceed: nil,
    didFail: nil,
    task: {
        return "Updated value"
    }
)

let value = try await future.value
let values = await testSubscriber.observedValues.value
print(values)  // Prints ["Initial value", "Updated value"]
```

In this example, the `TestSubscriber` class conforms to the `Subscribing` protocol, which allows it to observe changes in the publisher's value. The `Publisher` notifies the subscriber whenever the value is updated via the `Future`.

### Handling Multiple Subscribers

`Publisher` can handle multiple subscribers simultaneously, ensuring that all subscribers are notified when the value changes.

```swift
let publisher = Publisher<String?>(initialValue: "Initial value")

let testSubscriber1 = TestSubscriber()
let testSubscriber2 = TestSubscriber()

await publisher.add(subscriber: testSubscriber1)
await publisher.add(subscriber: testSubscriber2)

var deferred = await publisher.deferred(
    didSucceed: nil,
    didFail: nil,
    task: {
        return "Updated value for all"
    }
)

deferred.start()

try await deferred.value

let values1 = await testSubscriber1.observedValues.value
let values2 = await testSubscriber2.observedValues.value

print(values1)  // Prints ["Initial value", "Updated value for all"]
print(values2)  // Prints ["Initial value", "Updated value for all"]
```

Both subscribers receive the same updates, ensuring that their observed values are consistent.

### Using Publisher Without Subscribers

Even if there are no subscribers, a `Publisher` can still be used to manage a value. You can access the current value directly, typically via an operation like a `Future`, `Deferred`, or `Stream`.

```swift
let publisher = Publisher<String?>()

let future = await publisher.future(
    didSucceed: nil,
    didFail: nil,
    task: {
        return "Updated value"
    }
)

let value = try await future.value
let currentValue = await publisher.currentValue
print(currentValue)  // Prints "Updated value"
```

This demonstrates that `Publisher` can still manage and update values even when no subscribers are present, but updates are typically done through operations like `Future`.

### Integrating Publisher with Future

`Publisher` can generate a `Future` that is synchronized with the publisher’s updates. The `Future` will complete when the task completes, and the `Publisher` will update its value accordingly.

```swift
let future = await publisher.future(
    didSucceed: nil,
    didFail: nil,
    task: {
        try await Task.catNap()
        return "Future completed"
    }
)

let value = try await future.value
let values = await testSubscriber.observedValues.value

print(values)  // Prints [nil, "Future completed"]
print(value)   // Prints "Future completed"
```

### Integrating Publisher with Deferred

Similarly, a `Deferred` can be generated from a `Publisher`, which will update the `Publisher` when the `Deferred` task is completed.

```swift
var deferred = await publisher.deferred(
    didSucceed: nil,
    didFail: nil,
    task: {
        try await Task.catNap()
        return "Deferred completed"
    }
)

deferred.start()

let value = try await deferred.value
let values = await testSubscriber.observedValues.value

print(values)  // Prints [nil, "Deferred completed"]
print(value)   // Prints "Deferred completed"
```

### Integrating Publisher with Stream

`Publisher` and `Stream` can be used together by generating a `Stream` from the `Publisher`. This stream will emit values as the `Publisher` updates.

```swift
let stream = await publisher.stream(
    didSucceed: nil,
    didFail: nil,
    task: { emitter in
        await Task.catNap()
        emitter.emit(value: "Stream value 1")
        await Task.catNap()
        emitter.emit(value: "Stream value 2")
    }
)

for try await value in stream {
    print("Stream received: \(value ?? "nil")")
}
```

In this example, the `Publisher` updates are synchronized with the `Stream`, allowing subscribers to react to an ongoing sequence of changes.

## Best Practices

- **Use for Reactive Systems**: Utilize `Publisher` to keep multiple components in sync with changing data.
- **Manage Subscribers Effectively**: Be mindful of adding and removing subscribers to avoid memory leaks or unnecessary updates.
- **Combine with Future, Deferred, and Stream**: Use `Publisher` to generate and synchronize `Future`, `Deferred`, and `Stream` objects, ensuring all components stay in sync.

## Conclusion

`Publisher` is a versatile component for managing and notifying subscribers about changes in data over time. It simplifies the implementation of reactive systems, ensuring that multiple components can stay synchronized with the latest data. Explore other components of the **Later** library, such as [Future](usage-future.md), [Deferred](usage-deferred.md), and [Stream](usage-stream.md), to continue building your asynchronous programming skills.
