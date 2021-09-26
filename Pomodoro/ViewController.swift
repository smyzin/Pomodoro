//
//  ViewController.swift
//  Pomodoro
//
//  Created by Sergey Myzin on 25.09.2021.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var countDown: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var subTitle: UILabel!
    
    // MARK: - Actions -
    @IBAction func startButtonTapped(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
            isTimerRunning = true
        } else {
            pauseTimer()
            isTimerRunning = false
        }
    }
    @IBAction func pauseButtonTapped(_ sender: Any) {
        isTimerPause = true
    }
    
    // MARK: - Enum -
    enum TimerState {
        case inWorking
        case inRest
    }
    
    // MARK: - Properties -
    
    var circularProgressBarView: CircularProgressBarView!
    var circularViewDuration: TimeInterval = 2
    var seconds = 0
    var minutes = 0
    var progressToGo: CGFloat = 0
    var timer = Timer()
    var isTimerRunning = false
    var isTimerPause = false
    var resumeTapped = false
    var timerState: TimerState = .inWorking
    
    // MARK: - Constants -
    
    let minutesOnWork = 25
    let minutesOnRest = 5
    let progressToGoWork: CGFloat = 0.0006
    let progressToGoRest: CGFloat = 0.0033
    
    // MARK: - Functions timer -
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        pauseButton.isHidden = false
        startButton.isHidden = true
        pauseButton.isEnabled = true
        startButton.isEnabled = false
    }
    
    func pauseTimer() {
        timer.invalidate()
        isTimerRunning = false
        isTimerPause = true
        pauseButton.isHidden = true
        startButton.isHidden = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    func stopTimer() {
        timer.invalidate()
        isTimerRunning = false
        isTimerPause = false
        seconds = 0
        pauseButton.isHidden = true
        startButton.isHidden = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
        timerByState()
        circularProgressBarView.progressLayer.strokeEnd = 0.0
    }
    
    @objc func updateTimer() {
        if isTimerRunning {
            if minutes == 0 && seconds < 1 {
                stopTimer()
            } else {
                if (seconds == 0 && minutes > 0) {
                    minutes -= 1
                    seconds = 59
                } else {
                    seconds -= 1
                    circularProgressBarView.progressLayer.strokeEnd += progressToGo
                }
            }
            countDown.text = String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    // MARK: - Functions UI -
    
    func timerByState() {
        if timerState == .inWorking {
            timerState = .inRest
            
            subTitle.text = "Take a rest"
            subTitle.textColor = circularProgressBarView.circleColorGreen
            
            circularProgressBarView.changeColors(type: "green")
            countDown.textColor = circularProgressBarView.circleColorGreen
            
            startButton.tintColor = circularProgressBarView.circleColorGreen
            pauseButton.tintColor = circularProgressBarView.circleColorGreen
            
            minutes = minutesOnRest
            progressToGo = progressToGoRest
        } else {
            timerState = .inWorking
            
            subTitle.text = "Let's work"
            subTitle.textColor = circularProgressBarView.circleColorRed
            
            circularProgressBarView.changeColors(type: "red")
            countDown.textColor = circularProgressBarView.circleColorRed
            
            startButton.tintColor = circularProgressBarView.circleColorRed
            pauseButton.tintColor = circularProgressBarView.circleColorRed
            
            minutes = minutesOnWork
            progressToGo = progressToGoWork
        }
    }
    
    func initTimer() {
        minutes = minutesOnWork
        progressToGo = progressToGoWork
        
        subTitle.textColor = circularProgressBarView.circleColorRed
        countDown.textColor = circularProgressBarView.circleColorRed
        startButton.tintColor = circularProgressBarView.circleColorRed
        pauseButton.tintColor = circularProgressBarView.circleColorRed
        
        pauseButton.isHidden = true
        startButton.isHidden = false
        
        countDown.text = String(format: "%02i:%02i", minutes, seconds)
    }

    func setUpCircularProgressBarView() {
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.center = view.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration)
        view.addSubview(circularProgressBarView)
    }
    
    // MARK: - View did load -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countDown.center = view.center
        
        setUpCircularProgressBarView()
        initTimer()
    }
}

