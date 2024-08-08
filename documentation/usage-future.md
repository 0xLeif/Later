
# Future Usage

`Future` is a core component of the **Later** library that represents a value that will be available asynchronously. It allows you to manage asynchronous tasks that may take time to complete, providing a clean and structured way to handle these operations in Swift.

## Overview

A `Future` is used to encapsulate an asynchronous operation that will eventually produce a value or an error. The operation begins running immediately when the `Future` is created. The result of this operation is cached, meaning that once the operation completes, the result (or error) is stored for future accesses.

### Key Features

- **Immediate Execution**: The `Future` starts executing its task as soon as it is created.
- **Caching**: The result of the `Future`'s task is cached, so subsequent accesses do not re-execute the task.
- **Error Handling**: The `Future` allows for handling errors both during the task execution and when accessing the result.
- **Cancellation**: A `Future` can be canceled, and such cancellation can be detected via the `.value` property.

## Example Usage

### Creating a Future

You can create a `Future` by defining an asynchronous task. The task runs immediately upon `Future` creation.

```swift
import Later

@Sendable func asyncTask() async throws -> String {
    return "Hello"
}

let future = Future {
    do {
        let result = try await asyncTask()
        return result
    } catch {
        throw error
    }
}
```

### Accessing the Value

You can access the value of a `Future` using the `value` property. This is an asynchronous operation that suspends until the result is available. If the task is already completed, the cached result is returned.

```swift
do {
    let result = try await future.value
    print(result)  // Prints "Hello" if the task succeeded
} catch {
    print("Error: \(error)")  // Handles cancellation or other errors
}
```

### Handling Success and Failure

You can pass `didSucceed` and `didFail` closures to a `Future` to handle the outcome of the task. These closures are executed when the task completes, before the value is accessed.

```swift
let future = Future(
    didSucceed: { value in
        print("Task succeeded with value: \(value)")
    },
    didFail: { error in
        print("Task failed with error: \(error)")
    },
    task: {
        try await asyncTask()
    }
)
```

### Cancellation

A `Future` can be canceled if it hasn't completed yet. If you try to access the value of a canceled `Future`, it will throw a `CancellationError`.

```swift
let future = Future<String> {
    try await Task.catNap()
    return "Completed"
}

future.cancel()

do {
    _ = try await future.value
    Issue.record("Future should have been canceled")
} catch {
    _ = try #require(error as? CancellationError)
}
```

## Builder Pattern

The `Future` component in **Later** also supports a builder pattern, allowing for more complex configurations before the `Future` is built and executed.

### Example Using the Builder

```swift
import Later

let future = Future<String>.Builder {
    try await Task.catNap()
    return "Data fetched"
}
.onSuccess { value in
    print("Successfully fetched: \(value)")
}
.onFailure { error in
    print("Failed with error: \(error)")
}
.build()

let result = try await future.value
print(result)  // Prints "Data fetched"
```

### Error Handling in Builder

The builder pattern allows you to specify success and failure handlers, which are invoked based on the task's outcome.

```swift
let future = Future<String>.Builder {
    try await Task.catNap()
    throw FutureError.mockError
}
.onSuccess { _ in
    Issue.record("Task should not succeed")
}
.onFailure { error in
    print("Failed with error: \(error)")
}
.build()

do {
    _ = try await future.value
    Issue.record("Task should throw an error")
} catch {
    print("Caught error: \(error)")
}
```

In this example, the `Future` is configured with a task that throws an error. The `onFailure` closure handles this error, while the `onSuccess` closure is not called.

## Best Practices

- **Use for Long-Running Operations**: Utilize `Future` for operations like network requests or file I/O that might take time to complete.
- **Handle Cancellations**: Always consider the possibility of a `Future` being canceled and handle `CancellationError` appropriately.
- **Leverage the Builder**: Use the builder pattern for more complex `Future` configurations, especially when you need custom success or failure handling.

## Conclusion

`Future` is a powerful tool for managing asynchronous operations in Swift. It simplifies the process of handling tasks that produce values over time, with built-in support for error handling, cancellation, and result caching. The builder pattern adds further flexibility, allowing you to configure your `Future` objects to suit your specific needs.

Explore other components of the **Later** library, such as [Deferred](usage-deferred.md) and [Stream](usage-stream.md), to continue building your asynchronous programming skills.
