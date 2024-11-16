# Later

**Later** is a Swift 6 library that simplifies asynchronous programming by offering simple building blocks for managing concurrency. **Later** helps you write clean, maintainable code that efficiently handles complex asynchronous tasks.

## Key Features

**Later** offers a range of tools to make asynchronous programming more straightforward and efficient:

- **SendableValue**: A generic [`Sendable`](https://developer.apple.com/documentation/swift/sendable) value that ensures thread safety using [`OSAllocatedUnfairLock`](https://developer.apple.com/documentation/os/osallocatedunfairlock).
- **Future**: Represents a value that will be available asynchronously in the future, enabling you to handle tasks that take time to complete.
- **Deferred**: Represents a value that will be computed and available asynchronously when explicitly started, giving you control over when a task begins.
- **Stream**: Represents an asynchronous sequence of values emitted over time, perfect for handling data that updates periodically.
- **Publisher**: Allows objects to subscribe to changes in state or data, notifying subscribers when updates occur, ensuring your application responds dynamically to changes.
- **Subscribing**: A protocol for objects that want to observe changes in state or data, making it easy to react to updates.
- **Simple and Intuitive API**: Make various HTTP requests (GET, POST, PUT, DELETE, etc.) with ease.
- **Flexible Request Handling**: Comprehensive support for request headers, URL encoding, and request bodies.
- **Asynchronous Requests**: Utilize Swift's `async/await` syntax for asynchronous network requests.
- **Customizable URLSession**: Customize and configure URLSession with default or custom configurations.
- **Mocking Support**: Easily mock network requests for simplified testing and development.

## Getting Started

To start using **Later**, follow our [Installation Guide](documentation/installation.md) which provides step-by-step instructions for adding **Later** to your Swift project using Swift Package Manager.

After installation, explore our [Usage Overview](documentation/usage-overview.md) to see how to implement each of the key features in your own code. From simple examples to more in-depth explorations, these guides will help you integrate **Later** into your asynchronous workflows effectively.

## Documentation

Here’s a breakdown of the **Later** documentation:

- [Installation Guide](documentation/installation.md): Instructions on how to install **Later** using Swift Package Manager.
- [Usage Overview](documentation/usage-overview.md): An overview of **Later**'s key features with example implementations.
- Detailed Usage Guides:
  - [SendableValue Usage](documentation/usage-sendablevalue.md)
  - [Future Usage](documentation/usage-future.md)
  - [Deferred Usage](documentation/usage-deferred.md)
  - [Stream Usage](documentation/usage-stream.md)
  - [Publisher and Subscribing Usage](documentation/usage-publisher.md)
  - [Schedule Task Usage](documentation/usage-schedule-task.md)
  - [Networking](documentation/networking.md)
- [Contributing](documentation/contributing.md): Information on how to contribute to the **Later** project.

## Next Steps

To continue, head over to our [Installation Guide](documentation/installation.md) and get **Later** set up in your project. After installation, you can dive into the [Usage Overview](documentation/usage-overview.md) to see how to start leveraging the power of asynchronous programming with **Later**.
