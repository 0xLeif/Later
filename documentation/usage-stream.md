
# Stream Usage

`Stream` is a powerful component of the **Later** library that represents an asynchronous sequence of values emitted over time. It is particularly useful for handling data that updates periodically or in response to external events.

## Overview

A `Stream` allows you to work with a sequence of values that are produced asynchronously. You can subscribe to a `Stream` and react to each value as it is emitted, handling them in a sequential manner.

### Key Features

- **Asynchronous Value Emission**: Values are emitted over time and can be handled asynchronously.
- **Transformation Operations**: `Stream` supports common operations like `map`, `filter`, and `compactMap`.
- **Error Handling**: Streams can handle errors that occur during value emission.
- **Completion Handling**: Streams can signal the successful completion of value emission.

## Example Usage

### Creating a Stream

You can create a `Stream` by defining an emitter block that produces values over time. The block runs asynchronously and emits values using the `emitter.emit(value:)` method.

```swift
import Later

let stream = Stream<String> { emitter in
    try await Task.catNap()
    emitter.emit(value: "First value")
    try await Task.catNap()
    emitter.emit(value: "Second value")
}
```

### Subscribing to a Stream

You can subscribe to a `Stream` and react to each emitted value using `forEach`.

```swift
var values: [String] = []
try await stream.forEach { value in
    values.append(value)
}
print(values)  // Prints ["First value", "Second value"]
```

### Transforming Streams

Streams in **Later** support various transformation operations, including `map`, `filter`, and `compactMap`.

#### Mapping Values

The `map` function allows you to transform each value emitted by the stream.

```swift
let mappedStream = stream.map { value in
    "Mapped \(value)"
}

var mappedValues: [String] = []
try await mappedStream.forEach { value in
    mappedValues.append(value)
}
print(mappedValues)  // Prints ["Mapped First value", "Mapped Second value"]
```

#### Filtering Values

The `filter` function allows you to only include values that meet certain criteria.

```swift
let filteredStream = stream.filter { value in
    value.contains("First")
}

var filteredValues: [String] = []
try await filteredStream.forEach { value in
    filteredValues.append(value)
}
print(filteredValues)  // Prints ["First value"]
```

#### Compact Mapping Values

The `compactMap` function allows you to transform and filter out `nil` values.

```swift
let compactMappedStream = stream.compactMap { value in
    value == "First value" ? value : nil
}

var compactMappedValues: [String] = []
try await compactMappedStream.forEach { value in
    compactMappedValues.append(value)
}
print(compactMappedValues)  // Prints ["First value"]
```

### Handling Errors

Streams can handle errors that occur during value emission using a `do-catch` block.

```swift
let stream = Stream<String> { emitter in
    try await Task.catNap()
    emitter.emit(value: "First value")
    try await Task.catNap()
    emitter.emit(value: "Second value")
    throw StreamError.mockError  // Simulate an error
}

do {
    var values = [String]()
    for try await value in stream {
        values.append(value)
    }
} catch {
    print("Stream error: \(error)")
}
```

### Handling Completion

You can handle the successful completion of a stream using the `onSuccess` closure.

```swift
let stream = Stream<String> { emitter in
    try await Task.catNap()
    emitter.emit(value: "Only value")
}

stream.onSuccess {
    print("Stream completed successfully")
}
```

## Builder Pattern

The `Stream` component in **Later** also supports a builder pattern, allowing for more complex configurations before the `Stream` is built and executed.

### Example Using the Builder

```swift
import Later

let stream = Stream<String>.Builder { emitter in
    try await Task.catNap()
    emitter.emit(value: "First value")
    try await Task.catNap()
    emitter.emit(value: "Second value")
}
.onSuccess {
    print("Stream completed successfully")
}
.onFailure { error in
    print("Stream failed with error: \(error)")
}
.build()

var values = [String]()
do {
    for try await value in stream {
        values.append(value)
    }
} catch {
    print("Stream error: \(error)")
}

print(values)  // Prints ["First value", "Second value"]
```

### Error Handling in Builder

The builder pattern allows you to specify success and failure handlers, which are invoked based on the stream's outcome.

```swift
let stream = Stream<String>.Builder { emitter in
    try await Task.catNap()
    throw StreamError.mockError
}
.onSuccess {
    Issue.record("Stream should not succeed")
}
.onFailure { error in
    print("Failed with error: \(error)")
}
.build()

var values = [String]()
do {
    for try await value in stream {
        values.append(value)
    }
} catch {
    print("Stream error: \(error)")
}
```

## Best Practices

- **Use for Asynchronous Data**: Utilize `Stream` when dealing with data that updates over time or in response to events.
- **Handle Errors Appropriately**: Implement robust error handling to manage any issues that may arise during value emission.
- **Leverage the Builder**: Use the builder pattern for more complex `Stream` configurations, especially when you need custom success or failure handling.

## Conclusion

`Stream` is a versatile component for managing asynchronous sequences of values in Swift. It simplifies the process of reacting to and transforming values over time, with built-in support for error handling, completion handling, and flexible configuration through the builder pattern. Explore other components of the **Later** library, such as [Future](usage-future.md) and [Deferred](usage-deferred.md), to continue building your asynchronous programming skills.
