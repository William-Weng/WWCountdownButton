//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint
import WWCountdownButton

// MARK: - ViewController
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
