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
    
    /// 顯示類型 (hh:mm:ss)
    public enum DisplayType {
        
        case hhmmss     // 時:分:秒
        case mmss       // 分:秒
        case ss         // 秒
    }
    
    public typealias CountdownInformation = (times: [Int], isFinish: Bool)
    
    public var isPaused: Bool = false {
        willSet { pauseControl(isPaused: newValue, isCountdown: self.isCountdown) }
    }
    
    private var isCountdown = true
    private var countdownSecond: TimeInterval = 0
    private var elapsedSecond: TimeInterval = 0
    private var startDate = Date()
    private var pauseDate = Date()
    private var timer: CADisplayLink?
    private var displayType: DisplayType = .hhmmss
    private var resultClourse: ((CountdownInformation) -> Void)?
    
    @objc private func startCountdown(_ sender: CADisplayLink) {
        countdownAction(from: startDate, displayType: displayType, isCountdown: isCountdown)
    }
}

// MARK: 公開工具
public extension WWCountdownButton {
    
    /// 開始倒數 => 建議使用『等寬字型』
    /// - Parameters:
    ///   - second: 秒數
    ///   - isCountdown: 倒數 / 正數
    ///   - displayType: 顯示類型 (hh:mm:ss)
    ///   - preferredFramesPerSecond: 更新率 (最大值跟手機硬體有關)
    ///   - reuslt: ((CountdownInformation) -> Void)
    func countdown(second: UInt = 5, isCountdown: Bool = true, displayType: DisplayType = .mmss, preferredFramesPerSecond: Int = 3, reuslt: ((CountdownInformation) -> Void)? = nil) {
        
        timerClean()
        
        self.displayType = displayType
        self.startDate = Date()
        self.countdownSecond = TimeInterval(second)
        self.resultClourse = reuslt
        self.isCountdown = isCountdown
        
        timer = CADisplayLink(target: self, selector: #selector(self.startCountdown(_:)))
        timer?.preferredFramesPerSecond = preferredFramesPerSecond
        timer?._fire()
    }
    
    /// 回歸初始值 (歸零)
    func reset(displayType: DisplayType) {
        resetTitleSetting(isCountdown: isCountdown, displayType: displayType)
        timerClean()
    }
    
    /// 直接設定為結束的狀態
    func finish(displayType: DisplayType) {
        finishTitleSetting(isCountdown: isCountdown, displayType: displayType)
        timerClean()
    }
}

// MARK: 小工具
private extension WWCountdownButton {
    
    /// 倒數的功能
    /// - Parameters:
    ///   - startDate: Date
    ///   - displayType: DisplayType
    ///   - isCountdown: Bool
    func countdownAction(from startDate: Date, displayType: DisplayType, isCountdown: Bool = true) {
        
        guard let components = countdownNumbers(from: startDate, displayType: displayType, isCountdown: isCountdown) else { return }
        
        titleSetting(with: components.times, displayType: displayType)
        
        if (components.isFinish) { timerClean(); finishTitleSetting(isCountdown: isCountdown, displayType: displayType) }
        resultClourse?(components)
    }
    
    /// 設定Button標題 (00:00)
    ///   - times: [Int]
    ///   - displayType: DisplayType
    func titleSetting(with times: [Int], displayType: DisplayType) {
        
        guard let hour = times[safe: 0],
              let minute = times[safe: 1],
              let second = times[safe: 2]
        else {
            return
        }
        
        let title: String
        
        switch displayType {
        case .hhmmss: title = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
        case .mmss: title = "\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
        case .ss: title = "\(String(format: "%02d", second))"
        }
        
        setTitle(title, for: .normal)
    }
    
    /// 倒數的相關資訊 (與現在的時間相減)
    /// - Parameters:
    ///   - startDate: Date
    ///   - isCountdown: Bool
    /// - Returns: CountdownInformation
    func countdownNumbers(from startDate: Date, displayType: DisplayType, isCountdown: Bool = true) -> CountdownInformation? {
        
        let elapsedSecond = Date() - startDate
        let countdownSecond = countdownSecond - elapsedSecond + 1
        var components = dateComponents(with: elapsedSecond)
        
        if (isCountdown) { components = dateComponents(with: countdownSecond, calendar: Calendar._build()) }
        self.elapsedSecond = elapsedSecond
                
        return (components, Int(countdownSecond) <= 0)
    }
    
    /// 秒數時間轉換 (90秒 => 1分30秒)
    /// - Parameters:
    ///   - second: TimeInterval
    ///   - calendar: Calendar
    /// - Returns: [Int]
    func dateComponents(with second: TimeInterval, calendar: Calendar = .current) -> [Int] {
        
        let date = Date(timeIntervalSince1970: second)
        let components = date._components([.hour, .minute, .second], for: calendar)
        
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
    
    /// reset時的Title的設定
    ///   - isPaused: Bool
    ///   - isCountdown: DisplayType
    func resetTitleSetting(isCountdown: Bool, displayType: DisplayType) {
        let times = (!isCountdown) ? dateComponents(with: 0) : dateComponents(with: self.countdownSecond)
        titleSetting(with: times, displayType: displayType)
    }
    
    /// 倒數完成後的Title的設定
    ///   - isPaused: Bool
    ///   - isCountdown: DisplayType
    func finishTitleSetting(isCountdown: Bool, displayType: DisplayType) {
        resetTitleSetting(isCountdown: !isCountdown, displayType: displayType)
    }
}
