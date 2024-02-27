# WWCountdownButton
[![Swift-5.6](https://img.shields.io/badge/Swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWCountdownButton) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- A countdown button.
- 一個倒數計時的按鈕.

![WWCountdownButton](./Example.gif)

## [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWCountdownButton.git", .upToNextMajor(from: "1.2.0"))
]
```

## 可用函式
|函式|說明|
|-|-|
|countdown(second:isCountdown:displayType:preferredFramesPerSecond:reuslt:)|開始倒數 => 建議使用『等寬字型』|
|reset(displayType:)|回歸初始值 (歸零)|
|finish(displayType:)|直接設定為結束的狀態|

## Example
```swift
import UIKit
import WWPrint
import WWCountdownButton

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func countdown1(_ sender: WWCountdownButton) { sender.countdown(second: 6000, displayType: .hhmmss) }
    @IBAction func countdown2(_ sender: WWCountdownButton) { sender.countdown(second: 60, isCountdown: false) }
    @IBAction func countdown3(_ sender: WWCountdownButton) {
        sender.countdown(second: 5, displayType: .ss) { info in
            if (info.isFinish) { sender.backgroundColor = .darkGray }
            wwPrint(info)
        }
    }
}

```
