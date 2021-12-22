//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/12/21.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWCountdownButton

import UIKit

// MARK: 倒數計時的按鈕
open class WWCountdownButton: UIButton {
    
    public typealias CountdownInformation = (times: [Int], isFinish: Bool)
    
    private var isCountdown = true
    private var second: TimeInterval = 0
    private var startDate = Date()
    private var timer: CADisplayLink?
    private var resultClourse: ((CountdownInformation) -> Void)?
    
    /// 開始倒數 => 建議使用『等寬字型』
    /// - Parameters:
    ///   - second: UInt
    ///   - isCountdown: Bool
    ///   - reuslt: ((CountdownInformation) -> Void)
    public func countdown(second: UInt = 10, isCountdown: Bool = true, reuslt: ((CountdownInformation) -> Void)? = nil) {
        
        self.startDate = Date()
        self.second = TimeInterval(second)
        self.resultClourse = reuslt
        self.isCountdown = isCountdown
        
        timer = CADisplayLink(target: self, selector: #selector(startCountdown))
        timer?.preferredFramesPerSecond = 1
        timer?._fire()
    }
    
    @objc private func startCountdown(_ sender: CADisplayLink) { countdownAction(from: startDate, isCountdown: isCountdown) }
}

// MARK: 小工具
extension WWCountdownButton {
    
    /// 倒數的功能
    /// - Parameters:
    ///   - startDate: Date
    ///   - isCountdown: Bool
    private func countdownAction(from startDate: Date, isCountdown: Bool = true) {
        
        guard let components = countdownNumbers(from: startDate, isCountdown: isCountdown),
              let minute = components.times.first,
              let second = components.times.last
        else {
            return
        }
        
        if (components.isFinish) { timerClean() }
        
        setTitle("\(String(format: "%02d", minute)):\(String(format: "%02d", second))", for: .normal)
        resultClourse?(components)
    }
    
    /// 倒數的相關資訊
    /// - Parameters:
    ///   - startDate: Date
    ///   - isCountdown: Bool
    /// - Returns: CountdownInformation
    private func countdownNumbers(from startDate: Date, isCountdown: Bool = true) -> CountdownInformation? {
        
        let second = Date() - startDate
        let countdownSecond = self.second - second + 1
        let components = Date(timeIntervalSince1970: (isCountdown) ? countdownSecond : second)._components([.minute, .second])
        
        return (components, Int(countdownSecond) == 0)
    }
    
    /// Timer歸零
    private func timerClean() {
        timer?.invalidate()
        timer = nil
    }
}
