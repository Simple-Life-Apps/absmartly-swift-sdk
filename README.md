# A/B Smartly SDK <a href="https://github.com/apple/swift-package-manager" alt="RxSwift on Swift Package Manager" title="RxSwift on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>

A/B Smartly - Swift SDK

## Compatibility

The A/B Smartly Swift SDK is supported on macOS version 10.10 or later and iOS version 10 or later.

## Installation

### Swift Package Manager

To install the A/B Smartly SDK using Swift Package Manager, following these steps:

- In Xcode go to: ```File -> Swift Packages -> Add Package Dependency...```

- Enter the A/B Smartly Swift SDK GitHub repository: ```https://github.com/absmartly/swift-sdk```

- Select the SDK version (latest recomended)

- Select the ABSmartly library

### Cocoapods

To install the A/B Smartly SDK with CocoaPods, add the following lines to your `Podfile`:

```ruby
pod 'ABSmartlySwiftSDK', '~> 1.0.2'
```

Run the following command to update your Xcode project:
```
pod install
```

## Getting Started

Please follow the [installation](#installation) instructions before trying the following code:

#### Initialization

Import the SDK into your application:

```swift
import ABSmartly
```


Initialize the client and the SDK
```swift
let sdk: ABSmartlySDK
do {
    let clientConfig = ClientConfig(
        apiKey: ProcessInfo.processInfo.environment["ABSMARTLY_API_KEY"] ?? "",
        application: ProcessInfo.processInfo.environment["ABSMARTLY_APPLICATION"] ?? "",
        endpoint: ProcessInfo.processInfo.environment["ABSMARTLY_ENDPOINT"] ?? "",
        environment: ProcessInfo.processInfo.environment["ABSMARTLY_ENVIRONMENT"] ?? ""))

    let client = try DefaultClient(config: clientConfig)
    let sdkConfig = ABSmartlyConfig(client: client)
    sdk = try ABSmartlySDK(config: sdkConfig)
} catch {
    print(error.localizedDescription)
    return
}
```

#### Creating a new Context
```swift
let contextConfig: ContextConfig = ContextConfig()
contextConfig.setUnit(unitType: "device_id", uid: UIDevice.current.identifierForVendor!.uuidString))

let context = sdk.createContext(config: contextConfig)
context.waitUntilReady().done { context in
    print("context ready")
}
```

#### Creating a new Context with pre-fetched data
When doing full-stack experimentation with A/B Smartly, we recommend creating a context only once on the server-side.
Creating a context involves a round-trip to the A/B Smartly event collector.
We can avoid repeating the round-trip on the client-side by sending the server-side data embedded with other application data.
Then we can initialize the A/B Smartly context directly with it.

```swift
let contextConfig: ContextConfig = ContextConfig()
contextConfig.setUnit(unitType: "device_id", uid: UIDevice.current.identifierForVendor!.uuidString))

let context = sdk.createContextWithData(config: anotherContextConfig, contextData: contextData)
```

#### Setting context attributes
The `setAttribute()` and `setAttributes()` methods can be called before the context is ready.
```swift
context.setAttribute(name: "device", value: UIDevice.current.model)
context.setAttributes(["customer_age": "new_customer", "screen": "product"])
```

#### Selecting a treatment
```swift
let treatment = context.getTreatment("exp_test_experiment")
if treatment == 0 {
    // user is in control group (variant 0)
} else {
    // user is in treatment group
}
```

#### Selecting a treatment variable
```swift
let variable = context.getVariableValue(key: "my_variable", defaultValue: 10)
```

#### Tracking a goal achievement
Goals are created in the A/B Smartly web console.
```swift
context.track("payment", properties: ["item_count": 1, "total_amount": 1999.99])
```

#### Publishing pending data
Sometimes it is necessary to ensure all events have been published to the A/B Smartly collector, before proceeding. You can explicitly call the `publish()` method.
```swift
context.publish().done {
    print("all pending events published")
}
```

#### Finalizing
The `close()` methods will ensure all events have been published to the A/B Smartly collector, like `publish()`, and will also "seal" the context, throwing an error if any method that could generate an event is called.
```swift
context.close().done {
    print("context closed")
}
```

#### Refreshing the context with fresh experiment data
For long-running contexts, the context is usually created once when the application is first reached.
However, any experiments being tracked in your production code, but started after the context was created, will not be triggered.
To mitigate this, we can use the `refresh()` method. This method pulls updated experiment data from the A/B Smartly collector and will trigger recently started experiments when `getTreatment()` is called again.

```swift
context.refresh().done {
    print("refreshed")
})
```

#### Peek at treatment variants
Although generally not recommended, it is sometimes necessary to peek at a treatment or variable without triggering an exposure.
The A/B Smartly SDK provides a `peekTreatment()` method for that.

```swift
let treatment = context.peekTreatment(experimentName: "exp_test_experiment")

if treatment == 0 {
    // user is in control group (variant 0)
} else {
    // user is in treatment group
}
```

##### Peeking at variables
```swift
let color = context.peekVariableValue(key: "colorGComponent", defaultValue: 255)
```

#### Overriding treatment variants
During development, for example, it is useful to force a treatment for an experiment. This can be achieved with the `override()` and/or `overrides()` methods.
The `setOverride()` and `setOverrides()` methods can be called before the context is ready.
```swift
context.setOverride(experimentName: "exp_test_experiment", variant: 1)  // force variant 1 of treatment
context.setOverrides(["exp_test_experiment": 1, "exp_another_experiment": 0])
```

## About A/B Smartly
**A/B Smartly** is the leading provider of state-of-the-art, on-premises, full-stack experimentation platforms for engineering and product teams that want to confidently deploy features as fast as they can develop them.
A/B Smartly's real-time analytics helps engineering and product teams ensure that new features will improve the customer experience without breaking or degrading performance and/or business metrics.

### Have a look at our growing list of clients and SDKs:
- [Java SDK](https://www.github.com/absmartly/java-sdk)
- [JavaScript SDK](https://www.github.com/absmartly/javascript-sdk)
- [PHP SDK](https://www.github.com/absmartly/php-sdk)
- [Vue2 SDK](https://www.github.com/absmartly/vue2-sdk)
