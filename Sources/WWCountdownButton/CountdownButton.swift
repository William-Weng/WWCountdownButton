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
    
    public var isPaused: Bool = false {
        willSet { pauseControl(isPaused: newValue, isCountdown: self.isCountdown) }
    }
    
    private var isCountdown = true
    private var countdownSecond: TimeInterval = 0
    private var startDate = Date()
    private var pauseDate = Date()
    private var timer: CADisplayLink?
    private var resultClourse: ((CountdownInformation) -> Void)?
    private var elapsedSecond: TimeInterval = 0
    
    @objc private func startCountdown(_ sender: CADisplayLink) { countdownAction(from: startDate, isCountdown: isCountdown) }
}

// MARK: 公開工具
public extension WWCountdownButton {
    
    /// 開始倒數 => 建議使用『等寬字型』
    /// - Parameters:
    ///   - second: UInt
    ///   - isCountdown: Bool
    ///   - reuslt: ((CountdownInformation) -> Void)
    func countdown(second: UInt = 5, isCountdown: Bool = true, reuslt: ((CountdownInformation) -> Void)? = nil) {
        
        timerClean()
        
        self.startDate = Date()
        self.countdownSecond = TimeInterval(second)
        self.resultClourse = reuslt
        self.isCountdown = isCountdown
        
        timer = CADisplayLink(target: self, selector: #selector(startCountdown))
        timer?.preferredFramesPerSecond = 1
        timer?._fire()
    }
    
    /// 回歸初始值 (歸零)
    func reset() {
        
        let times = (!isCountdown) ? dateComponents(with: 0) : dateComponents(with: self.countdownSecond)
        
        titleSetting(with: times)
        timerClean()
    }
}

// MARK: 小工具
private extension WWCountdownButton {
    
    /// 倒數的功能
    /// - Parameters:
    ///   - startDate: Date
    ///   - isCountdown: Bool
    func countdownAction(from startDate: Date, isCountdown: Bool = true) {
        
        guard let components = countdownNumbers(from: startDate, isCountdown: isCountdown) else { return }
        
        if (components.isFinish) { timerClean() }
        
        titleSetting(with: components.times)
        resultClourse?(components)
    }
    
    /// 設定Button標題 (00:00)
    /// - Parameter times: [Int]
    func titleSetting(with times: [Int]) {
        
        guard let minute = times.first,
              let second = times.last
        else {
            return
        }
        
        setTitle("\(String(format: "%02d", minute)):\(String(format: "%02d", second))", for: .normal)
    }
    
    /// 倒數的相關資訊 (與現在的時間相減)
    /// - Parameters:
    ///   - startDate: Date
    ///   - isCountdown: Bool
    /// - Returns: CountdownInformation
    func countdownNumbers(from startDate: Date, isCountdown: Bool = true) -> CountdownInformation? {
        
        let elapsedSecond = Date() - startDate
        let countdownSecond = countdownSecond - elapsedSecond + 1
        var components = dateComponents(with: elapsedSecond)
        
        if (isCountdown) { components = dateComponents(with: countdownSecond) }
        self.elapsedSecond = elapsedSecond
        
        return (components, Int(countdownSecond) <= 0)
    }
    
    /// 秒數時間轉換 (90秒 => 1分30秒)
    /// - Parameter second: TimeInterval
    /// - Returns: [Int]
    func dateComponents(with second: TimeInterval) -> [Int] {
        
        let components = Date(timeIntervalSince1970: second)._components([.minute, .second])
        return components
    }
    
    /// 倒數暫停
    /// - Parameters:
    ///   - isPaused: 是否要暫停？
    ///   - isCountdown: 是否是倒數？
    func pauseControl(isPaused: Bool, isCountdown: Bool) {
                
        let elapsedSecond = -(self.elapsedSecond + 1)
        
        timer?.isPaused = isPaused
        startDate = Date().addingTimeInterval(elapsedSecond)
    }
    
    /// Timer歸零
    func timerClean() {
        timer?.invalidate()
        timer = nil
    }
}
