//
//  ViewController.swift
//  HW12-Khrapov
//
//  Created by Anton on 21.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - CALayers
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    // MARK: - Elements
    
    private var timer = Timer()
    private var workTime = 25
    private var relaxTime = 5
    private var currentTime: Double = 0
    
    private var isActive = false
    private var isWorkTime = true
    
    private var workColor: UIColor = .red
    private var relaxColor: UIColor = .systemGreen
    
    private lazy var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = correctTimeDisp(Double(workTime))
        timerLabel.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        return timerLabel
    }()
    
    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(startStopPressed), for: .touchUpInside)
        button.setImage(UIImage(named: "play"), for: .normal)
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
        setupView()
        currentTime = Double(workTime)
        setupHierarchy()
        setupItemsColor(color: workColor)
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    private func correctTimeDisp(_ time: Double) -> String {
        let time = Int(time)
        let minutes = time / 60
        let seconds = time % 60
        return "\(minutes / 10)\(minutes % 10):\(seconds / 10)\(seconds % 10)"
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupItemsColor(color: UIColor) {
        startStopButton.tintColor = color
        timerLabel.textColor = color
    }
    
    private func setupHierarchy() {
        createShapeLayer()
        progressLayer.speed = 0
        progressAnimation(duration: TimeInterval(currentTime))
        view.addSubview(stack)
    }
    
    private func setupLayout() {
        stack.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    private func createShapeLayer() {
        let center = view.center
        let path = UIBezierPath(arcCenter: center, radius: 150, startAngle: -Double.pi / 2, endAngle: 3 * Double.pi / 2, clockwise: true)
        
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 5
        
        circleLayer.shadowColor = UIColor.black.cgColor
        circleLayer.shadowOpacity = 0.4
        circleLayer.shadowOffset = .zero
        circleLayer.shadowRadius = 8
        circleLayer.shouldRasterize = true
        circleLayer.rasterizationScale = UIScreen.main.scale
        
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemRed.cgColor
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(circleLayer)
        view.layer.addSublayer(progressLayer)
    }
    
    private func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.toValue = 1
        circularProgressAnimation.duration = CFTimeInterval(duration)
        circularProgressAnimation.fillMode = CAMediaTimingFillMode.forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnimation")
    }
    
    private func pauseAnimation() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    private func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 1.0
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
    }
    
    // MARK: - Actions
    
    @objc private func startStopPressed() {
        if isActive {
            isActive = false
            startStopButton.setImage(UIImage(named: "play"), for: .normal)
            pauseAnimation()
            timer.invalidate()
        } else {
            isActive = true
            startStopButton.setImage(UIImage(named: "stop"), for: .normal)
            resumeAnimation()
            initTimer()
        }
    }
    
    @objc func fireTimer() {
        currentTime -= 0.001
        timerLabel.text = correctTimeDisp(Double(currentTime))
        
        guard currentTime <= 0 else { return }
        
        if  isWorkTime == true {
            currentTime = Double(relaxTime)
            setupItemsColor(color: relaxColor)
            progressLayer.strokeColor = relaxColor.cgColor
            progressAnimation(duration: TimeInterval(currentTime))
        } else {
            currentTime = Double(workTime)
            setupItemsColor(color: workColor)
            progressLayer.strokeColor = workColor.cgColor
            progressAnimation(duration: TimeInterval(currentTime))
        }
        
        isWorkTime.toggle()
    }
}
