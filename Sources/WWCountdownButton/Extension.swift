//
//  Extension+Timer.swift
//  Extension
//
//  Created by William.Weng on 2021/12/21.
//

import UIKit

// MARK: - Date (Operator Overloading)
extension Date {
    
    /// 日期的加法
    static func +(lhs: Self, rhs: Self) -> TimeInterval {
        return lhs.timeIntervalSince1970 + rhs.timeIntervalSince1970
    }
    
    /// [日期的減法](https://www.appcoda.com.tw/operator-overloading-swift/)
    static func -(lhs: Self, rhs: Self) -> TimeInterval {
        return lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970
    }
}

// MARK: - Date (class function)
extension Date {
    
    /// 時間其中一位的數值 => 年？月？日？
    /// - Parameters:
    ///   - component: 單位 => .day
    ///   - calendar: 當地的日曆基準
    /// - Returns: Int
    func _component(_ component: Calendar.Component = .day, for calendar: Calendar = .current) -> Int {
        return calendar.component(component, from: self)
    }
    
    /// 時間某幾位的數值 => 時 / 分 / 秒
    /// - Parameters:
    ///   - components: 單位 => [.hour, .minute, .second]
    ///   - calendar: Calendar
    /// - Returns: Int
    func _components(_ components: [Calendar.Component] = [.hour, .minute, .second], for calendar: Calendar = .current) -> [Int] {
        
        let result = components.map { component in
            return self._component(component, for: calendar)
        }
        
        return result
    }
}

// MARK: - CADisplayLink (static function)
extension CADisplayLink {
    
    /// [產生CADisplayLink](https://www.hangge.com/blog/cache/detail_2278.html)
    /// - Parameters:
    ///   - target: AnyObject
    ///   - selector: Selector
    /// - Returns: CADisplayLink
    static func _build(target: AnyObject, selector: Selector) -> CADisplayLink {
        return CADisplayLink(target: target, selector: selector)
    }
}

// MARK: - CADisplayLink (class function)
extension CADisplayLink {
    
    /// [執行CADisplayLink Timer](https://ios.devdon.com/archives/922)
    /// - Parameters:
    ///   - runloop: [RunLoop](https://www.jianshu.com/p/b6ffd736729c)
    ///   - mode: [RunLoop.Mode](https://www.hangge.com/blog/cache/detail_2278.html)
    func _fire(to runloop: RunLoop = .main, forMode mode: RunLoop.Mode = .default) {
        self.add(to: runloop, forMode: mode)
        self.add(to: runloop, forMode: .tracking)
    }
}
