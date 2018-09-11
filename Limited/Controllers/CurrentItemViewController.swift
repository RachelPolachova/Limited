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
    @IBOutlet weak var importantLabel: UILabel!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var stopTimerButton: UIButton!
    
    var seconds = 15
    var timer = Timer()
    var cycleCounter : Int = 0
    var timerSeconds = "0"
    var timerMinutes = "0"
    
    var audioPlayer = AVAudioPlayer()
    
    
    let realm = try! Realm()
    var selectedItem : Item? {
        didSet {
            currentItemBarNavigator.title = selectedItem?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        
        loadItem()
        updateButtons()
        
        do {
            let audioPath = Bundle.main.path(forResource: "timerDone", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
        } catch {
            print("Error print playing alarm when timer is done: \(error)")
        }
        
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goEditItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditCurrentItemViewController
        destinationVC.editDelegate = self
        destinationVC.isImportant = selectedItem!.isImportant
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
        importantLabel.text = selectedItem!.isImportant ? "Important" : "Not important"
        
        
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
    
    func updateButtons() {
        
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
    
    @IBAction func startTimerPressed(_ sender: UIButton) {
        
        if cycleCounter < 4 {
            cycleCounter += 1
        } else {
            cycleCounter = 0
        }
        
        startTimerButton.isHidden = true
        stopTimerButton.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CurrentItemViewController.counter), userInfo: nil, repeats: true)
        
    }
    
    @objc func counter() {
        seconds -= 1
        
        updateTime(seconds: seconds)
        
        if (seconds == 0) {
            timer.invalidate()
            audioPlayer.play()
            
            do {
                try realm.write {
                    selectedItem?.numberOfDone += 1
                }
            } catch {
                print("Error updating numberOfDone after timer is done: \(error)")
            }
            loadItem()
        }
    }
    
    @IBAction func stopTimerPressed(_ sender: UIButton) {
        
        seconds = (cycleCounter < 4) ? 15 : 5

        timer.invalidate()
        
        updateTime(seconds: seconds)

        stopTimerButton.isHidden = true
        startTimerButton.isHidden = false
        
        audioPlayer.stop()
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func updateTime(seconds: Int) {
        
        let (_, m, s) = secondsToHoursMinutesSeconds(seconds: seconds)
        
        
        
        timerSeconds = (s < 10 ) ? "0" + String(s) : String(s)
        timerMinutes = (m < 10) ? "0" + String(m) : String(m)
        
        timerLabel.text = timerMinutes + " : " + timerSeconds
    }
    
    
}
