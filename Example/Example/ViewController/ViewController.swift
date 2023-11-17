//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/9/15.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWCountdownButton
//  等寬字型 / Monospaced Font

import UIKit
import WWCountdownButton
import WWPrint

final class ViewController: UIViewController {

    override func viewDidLoad() { super.viewDidLoad() }
    
    @IBAction func countdown1(_ sender: WWCountdownButton) { sender.countdown(second: 3600, displayType: .hhmmss) }
    @IBAction func countdown2(_ sender: WWCountdownButton) { sender.countdown(second: 60, isCountdown: false) }
    @IBAction func countdown3(_ sender: WWCountdownButton) {
        
        sender.countdown(second: 5) { info in
            if (info.isFinish) { sender.backgroundColor = .darkGray }
            wwPrint(info)
        }
    }
}

