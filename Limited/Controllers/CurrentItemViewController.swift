//
//  CurrentItemViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 9.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class CurrentItemViewController: UIViewController, SideEditItemDelegate {

    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var currentItemBarNavigator: UINavigationItem!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeForLabel: UILabel!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var stopTimerButton: UIButton!
    
    var work : Bool = true
    
    var seconds = 10
    var timer = Timer()
    var cycleCounter : Int = 0
    var timerSeconds = "0"
    var timerMinutes = "0"
    let workTime = 1500
    let shortBreak = 300
    let longBreak = 1500
    
    var audioPlayer = AVAudioPlayer()
    
    
    let realm = try! Realm()
    var selectedItem : Item? {
        didSet {
            currentItemBarNavigator.title = selectedItem?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
        setupUI()
        setAudioPlayer()
        
    }
    
    //    MARK: - Setup methods
    
    func setupUI() {
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        timeForLabel.text = (work == true) ? "Time for work!" : "Time for break!"
        
        numberLabel.textColor = UIColor(hex: selectedItem!.color)
        startTimerButton.backgroundColor = UIColor(hex: selectedItem!.color)
        stopTimerButton.backgroundColor = UIColor(hex: selectedItem!.color)
        
        startTimerButton.setImage(#imageLiteral(resourceName: "play_white1"), for: .normal)
        startTimerButton.contentMode = .center
        startTimerButton.imageView?.contentMode = .scaleAspectFit
        
        stopTimerButton.setImage(#imageLiteral(resourceName: "stop_white1"), for: .normal)
        stopTimerButton.contentMode = .center
        startTimerButton.imageView?.contentMode = .scaleAspectFit
        
        stopTimerButton.isHidden = true
    }
    
    func setAudioPlayer() {
        do {
            let audioPath = Bundle.main.path(forResource: "timerDone", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            print("Error setting audioPlayer: \(error)")
        }
    }
    
    func itemEdited(isImportant: Bool) {
        do { try realm.write {
                selectedItem?.isImportant = isImportant
            }
        } catch {
            print("Error editing item: \(error)")
        }
        loadItem()
    }
    
    func loadItem() {
        
        if let desc = selectedItem?.itemDescription {
            descriptionLabel.text = desc
        } else {
            descriptionLabel.text = "No description."
        }
        
        if let count = selectedItem?.numberOfDone {
            numberLabel.text = String(count)
        } else {
            numberLabel.text = "0"
        }
        
    }
    
    @objc func counter() {
        seconds -= 1
        
        updateTime(seconds: seconds)
        
        if (seconds == 0) {
            stopTimer()
        }
    }
    
    
    func updateTime(seconds: Int) {
        
        let (_, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
        
        timerSeconds = (s < 10 ) ? "0" + String(s) : String(s)
        timerMinutes = (m < 10) ? "0" + String(m) : String(m)
        timerLabel.text = timerMinutes + " : " + timerSeconds
    }
    
    //    MARK: - Buttons and segue methods
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goEditItem", sender: self)
    }
    
    @IBAction func startTimerPressed(_ sender: UIButton) {
        
        startTimer()
        
    }
    
    func stopTimer() {
        
        timer.invalidate()
        audioPlayer.play()
        
        print("stop timer method. cyclecounter: \(cycleCounter)")
        
        
        if (work) {
            if cycleCounter < 4 {
                cycleCounter += 1
                // short break
                seconds = shortBreak
                timeForLabel.text = "time for short break!"
                work = false
            } else {
                cycleCounter = 0
                //long break
                seconds = longBreak
                timeForLabel.text = "Time for long break!"
                work = false
            }
            do {
                try realm.write {
                    selectedItem?.numberOfDone += 1
                }
            } catch {
                print("Error updating numberOfDone after timer is done: \(error)")
            }
            loadItem()
            
        } else {
            work = true
            seconds = workTime
            timeForLabel.text = "Time for work!"
        }
        
        stopTimerButton.isHidden = true
        startTimerButton.isHidden = false
        updateTime(seconds: seconds)
        
    }
    
    func startTimer() {
        
        startTimerButton.isHidden = true
        stopTimerButton.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CurrentItemViewController.counter), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func stopTimerPressed(_ sender: UIButton) {
        
        timer.invalidate()
        
        //skips the break.
        seconds = workTime
        
        updateTime(seconds: seconds)
        
        stopTimerButton.isHidden = true
        startTimerButton.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditCurrentItemViewController
        destinationVC.editDelegate = self
        destinationVC.isImportant = selectedItem!.isImportant
    }
    
}
