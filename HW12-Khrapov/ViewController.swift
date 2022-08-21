//
//  ViewController.swift
//  HW12-Khrapov
//
//  Created by Anton on 21.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Elements
    
    private var timer: Timer?
    private var workTime = 10
    private var relaxTime = 5
    private var currentTime = 0
    private var isActive = false
    private var isWorkTime = true
    
    private lazy var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = "00:\(correctTimeDisp(workTime))"
        timerLabel.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        timerLabel.textColor = .white
        return timerLabel
    }()
    
    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(startStopPressed), for: .touchUpInside)
        button.setImage(UIImage(named: "play"), for: .normal)
        
        button.tintColor = .white
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timerLabel, startStopButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 25
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(color: .systemYellow)
        currentTime = workTime
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    private func correctTimeDisp(_ time: Int) -> String {
        return time >= 10 ? String(time) : "0" + String(time)
    }
    
    private func setupView(color: UIColor) {
        view.backgroundColor = color
    }
    
    private func setupHierarchy() {
        view.addSubview(stack)
    }
    
    private func setupLayout() {
        stack.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    // MARK: - Actions
    
    @objc private func startStopPressed() {
        if isActive {
            isActive = false
            startStopButton.setImage(UIImage(named: "play"), for: .normal)
            timer?.invalidate()
        } else {
            isActive = true
            startStopButton.setImage(UIImage(named: "stop"), for: .normal)
            initTimer()
        }
    }
    
    @objc func fireTimer() {
        currentTime -= 1
        timerLabel.text = "00:\(correctTimeDisp(currentTime))"
        
        if currentTime <= 0 && isWorkTime == true {
            isWorkTime = false
            currentTime = relaxTime
            setupView(color: .systemGreen)
        } else if currentTime <= 0 && isWorkTime == false {
            isWorkTime = true
            currentTime = workTime
            setupView(color: .systemYellow)
        }
    }
}


//        view.addSubview(timerLabel)
//        view.addSubview(startStopButton)

//        timerLabel.snp.makeConstraints { make in
//            make.center.equalTo(view)
//        }
//
//        startStopButton.snp.makeConstraints { make in
//            make.centerX.equalTo(view)
//            make.top.equalTo(timerLabel.snp.bottom).offset(30)
//        }
