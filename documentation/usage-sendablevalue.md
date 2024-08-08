
# SendableValue Usage

`SendableValue` is a powerful tool provided by **Later** that allows you to manage thread-safe, mutable values across concurrent tasks in a Swift project. It wraps a value that can be safely shared between different contexts, ensuring that the value is handled properly even when accessed by multiple tasks simultaneously.

## Overview

The `SendableValue` type ensures that the value it holds is safely accessible in a concurrent environment. It uses [`OSAllocatedUnfairLock`](https://developer.apple.com/documentation/os/osallocatedunfairlock) to manage locking, making it efficient and secure for multi-threaded operations.

## Example Usage

Here’s how to use `SendableValue` in a typical scenario:

### Creating and Setting a Value

You can create a `SendableValue` by initializing it with a value. You can then set the value asynchronously using the `set(value:)` method.

```swift
import Later

let sendableValue = SendableValue<Int>(42)
sendableValue.set(value: 100)
```

### Accessing the Value Asynchronously

The value stored in `SendableValue` can be accessed asynchronously using the `value` property.

```swift
let value = await sendableValue.value
print(value)  // Prints "100"
```

### Ensuring Thread Safety

Because `SendableValue` is designed to be thread-safe, you can confidently use it in environments where multiple tasks might attempt to read or write the value simultaneously.

### Full Example

Here’s a complete example that demonstrates creating a `SendableValue`, updating it, and accessing it from an asynchronous context:

```swift
import Later

let sendableValue = SendableValue<Int>(42)

// Update the value asynchronously
Task {
    sendableValue.set(value: 100)
}

// Access the value asynchronously
Task {
    let value = await sendableValue.value
    print(value)  // Prints "100"
}
```

In this example, the value is set and then accessed in separate asynchronous tasks, showcasing the thread safety and ease of use provided by `SendableValue`.

## Best Practices

- **Use in Concurrent Environments**: Utilize `SendableValue` whenever you need to share and mutate values across multiple concurrent tasks.
- **Avoid Excessive Locking**: Although `SendableValue` handles locking internally, be mindful of performance when frequently updating the value in a highly concurrent environment.

## Conclusion

`SendableValue` is an essential component of the **Later** library that provides a simple, safe way to manage mutable state in asynchronous Swift programming. By using `SendableValue`, you can ensure that your values are handled correctly across concurrent tasks, making your code more robust and maintainable.

For more advanced usage, explore other components of the **Later** library like [Future](usage-future.md), [Deferred](usage-deferred.md), and [Stream](usage-stream.md).

