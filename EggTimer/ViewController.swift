//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

// Soft Egg = 5 min
// Medium Egg = 8 min
// Large Egg = 12 min
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var isLightMode = true
    
    var sound: AVAudioPlayer!
    
    var timer = Timer()
    
    var titleLabel = UILabel()
    var descLabel = UILabel()
    var footNoteLabel = UILabel()
    var timerTextLabel = UILabel()
    var timerMinutesLabel = UILabel()
    var timerSecondsLabel = UILabel()
    var colonLabel = UILabel()
    var outputLabel = UILabel()
    
    var contrastModeButton = UIButton()
    
    let eggQuotes = [
        "truth and eggs are useful only while they are fresh\n-austin o'malley",
        "an egg is always an adventure;\nthe next one may be different.\n-oscar wilde",
        "a day without an argument is like an egg without salt.\n-angela carter",
        "do not put all your eggs in one basket.\n-warren buffett",
        "a hen is only an egg's way of making another egg.\n-samuel butler"
    ]
    
    let eggTimes = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    
    let eggImages = [
        "Soft": #imageLiteral(resourceName: "soft_egg"),
        "Medium": #imageLiteral(resourceName: "medium_egg"),
        "Hard": #imageLiteral(resourceName: "hard_egg")
    ]
    
    var eggs = [
        "Soft", "Medium", "Hard"
    ]
    
    var hardnessLabels: [UILabel] = []
    var hardnessButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = isLightMode ? .white : .black
        
        let screenWidth = UIScreen.main.bounds.width - 32
        let screenHeight = UIScreen.main.bounds.height - 32
        
        setTitleLabel()
        
        setDescLabel()
        
        setFootNoteLabel()
        
        setTimerTextLabel()
        
        setOutputLabel()
        
        setLabel(label: timerMinutesLabel, xOffset: 0.0)
        setLabel(label: timerSecondsLabel, xOffset: screenWidth - screenWidth / 2.3)
        
        setColonLabel(label: colonLabel)
        
        updateContrastModeButton()
        
        for i in eggs {
            hardnessLabels.append(createLabel(text: i))
            hardnessButtons.append(createButton(title: i, image: eggImages[i]!))
            print(eggImages[i]!)
        }
        for i in 0..<hardnessButtons.count {
            self.view.addSubview(hardnessButtons[i])
            self.view.addSubview(hardnessLabels[i])
            hardnessButtons[i].addTarget(self, action: #selector(hardnessSelected(_:)), for: .touchUpInside)
            setAutoConstraints(someView: hardnessButtons[i], width: screenWidth / 3.25, height: screenHeight / 4.5, xOffset: CGFloat(i) * screenWidth / 3, yOffset: 0.0, xRelative: true, yRelative: false, xLeading: true, yTop: true)
            setAutoConstraints(someView: hardnessLabels[i], width: screenWidth / 3.25, height: screenHeight / 4.5, xOffset: CGFloat(i) * screenWidth / 3, yOffset: 0.0, xRelative: true, yRelative: false, xLeading: true, yTop: false)
        }
    }
    
    @objc func hardnessSelected(_ sender: UIButton) {
        let hardnessSelected = sender.currentTitle!
        
        outputLabel.text = "Waiting..."
        timer.invalidate()
        
        var totalTime = eggTimes[hardnessSelected]! * 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { t in
            
            let min = totalTime / 60
            let sec = totalTime % 60
            
            self.timerMinutesLabel.text? = min > 9 ? "\(min)" : "0\(min)"
            self.timerSecondsLabel.text? = sec > 9 ? "\(sec)" : "0\(sec)"
            
            totalTime -= 1
            
            if totalTime == -1 {
                t.invalidate()
                self.outputLabel.text = "Your egg has been boiled"
                
                let path = Bundle.main.path(forResource: "alarm_sound.mp3", ofType: nil)!
                let url = URL(fileURLWithPath: path)

                do {
                    self.sound = try AVAudioPlayer(contentsOf: url)
                } catch {
                    print("GodDesignatedError - alarm_sound.mp3 not found")
                }
                self.sound?.play()
                
            }
        })
        
    }
    
    func setAutoConstraints(someView: UIView, width: CGFloat, height: CGFloat, xOffset: CGFloat, yOffset: CGFloat, xRelative: Bool, yRelative: Bool, xLeading: Bool, yTop: Bool) {
            
            someView.translatesAutoresizingMaskIntoConstraints = false
            
            let widthConstraint = NSLayoutConstraint(
               item: someView,
               attribute: NSLayoutConstraint.Attribute.width,
               relatedBy: NSLayoutConstraint.Relation.equal,
               toItem: nil,
               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
               multiplier: 1,
               constant: width
            )
            let heightConstraint = NSLayoutConstraint(
               item: someView,
               attribute: NSLayoutConstraint.Attribute.height,
               relatedBy: NSLayoutConstraint.Relation.equal,
               toItem: nil,
               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
               multiplier: 1,
               constant: height
            )
            var xConstraint = NSLayoutConstraint(
                item: someView,
                attribute: NSLayoutConstraint.Attribute.centerX,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view,
                attribute: NSLayoutConstraint.Attribute.centerX,
                multiplier: 1,
                constant: 0
            )
            var yConstraint = NSLayoutConstraint(
                item: someView,
                attribute: NSLayoutConstraint.Attribute.centerY,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: view,
                attribute: NSLayoutConstraint.Attribute.centerY,
                multiplier: 1,
                constant: 0
            )
            if xRelative {
                if xLeading {
                    xConstraint = NSLayoutConstraint(
                       item: someView,
                       attribute: NSLayoutConstraint.Attribute.leading,
                       relatedBy: NSLayoutConstraint.Relation.equal,
                       toItem: view,
                       attribute: NSLayoutConstraint.Attribute.leadingMargin,
                       multiplier: 1.0,
                       constant: xOffset
                    )
                }
                else {
                    xConstraint = NSLayoutConstraint(
                       item: someView,
                       attribute: NSLayoutConstraint.Attribute.trailing,
                       relatedBy: NSLayoutConstraint.Relation.equal,
                       toItem: view,
                       attribute: NSLayoutConstraint.Attribute.trailingMargin,
                       multiplier: 1.0,
                       constant: -xOffset
                    )
                }
                
            }
            if yRelative {
                if yTop {
                    yConstraint = NSLayoutConstraint(
                        item: someView,
                        attribute: NSLayoutConstraint.Attribute.top,
                        relatedBy: NSLayoutConstraint.Relation.equal,
                        toItem: view,
                        attribute: NSLayoutConstraint.Attribute.topMargin,
                        multiplier: 1.0,
                        constant: yOffset
                    )
                }
                else {
                    yConstraint = NSLayoutConstraint(
                        item: someView,
                        attribute: NSLayoutConstraint.Attribute.bottom,
                        relatedBy: NSLayoutConstraint.Relation.equal,
                        toItem: view,
                        attribute: NSLayoutConstraint.Attribute.bottomMargin,
                        multiplier: 1.0,
                        constant: -yOffset
                    )
                }
                
            }
            view.addConstraints([widthConstraint, heightConstraint, xConstraint, yConstraint])
        }
    
    fileprivate func setTitleLabel() {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        titleLabel.text = "egg timey"
        titleLabel.numberOfLines = 3
        titleLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 10 + 1)
        titleLabel.textAlignment = .right
        self.view.addSubview(titleLabel)
        setAutoConstraints(someView: titleLabel, width: screenWidth, height: screenHeight / 8, xOffset: 0.0, yOffset: 0.0, xRelative: true, yRelative: true, xLeading: true, yTop: true)
    }
    
    fileprivate func setDescLabel() {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        descLabel.text = eggQuotes.randomElement()!
        descLabel.numberOfLines = 0
        descLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        descLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 18 + 1)
        descLabel.textAlignment = .center
        self.view.addSubview(descLabel)
        setAutoConstraints(someView: descLabel, width: screenWidth, height: screenHeight / 5, xOffset: 0.0, yOffset: screenHeight / 8, xRelative: true, yRelative: true, xLeading: true, yTop: true)
    }
    
    fileprivate func setFootNoteLabel() {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        footNoteLabel.text = "made by tezz-io"
        footNoteLabel.textColor = .darkGray
        footNoteLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 20 + 1)
        footNoteLabel.textAlignment = .center
        self.view.addSubview(footNoteLabel)
        setAutoConstraints(someView: footNoteLabel, width: screenWidth, height: screenHeight / 12, xOffset: 0.0, yOffset: 0.0, xRelative: true, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func setTimerTextLabel() {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        timerTextLabel.text = "Your Egg will be ready in:"
        timerTextLabel.numberOfLines = 0
        timerTextLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        timerTextLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 18 + 1)
        timerTextLabel.textAlignment = .center
        self.view.addSubview(timerTextLabel)
        setAutoConstraints(someView: timerTextLabel, width: screenWidth, height: screenHeight / 6, xOffset: 0.0, yOffset: screenHeight / 4, xRelative: true, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func setOutputLabel() {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        outputLabel.text = ""
        outputLabel.numberOfLines = 0
        outputLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        outputLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 18 + 1)
        outputLabel.textAlignment = .center
        self.view.addSubview(outputLabel)
        setAutoConstraints(someView: outputLabel, width: screenWidth, height: screenHeight / 8, xOffset: 0.0, yOffset: screenHeight / 11, xRelative: true, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func setLabel(label: UILabel, xOffset: CGFloat) {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        label.text = "00"
        label.numberOfLines = 0
        label.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        label.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 5 + 1)
        label.textAlignment = xOffset == 0.0 ? .right : .left
        self.view.addSubview(label)
        setAutoConstraints(someView: label, width: screenWidth / 2.3, height: screenHeight / 8, xOffset: xOffset, yOffset: screenHeight / 6, xRelative: true, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func setColonLabel(label: UILabel) {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        label.text = ":"
        label.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        label.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 5 + 1)
        label.textAlignment = .center
        self.view.addSubview(label)
        setAutoConstraints(someView: label, width: screenWidth, height: screenHeight / 7.5, xOffset: 0.0, yOffset: screenHeight / 6, xRelative: false, yRelative: true, xLeading: true, yTop: false)
    }

    func createButton(title: String, image: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        return button
    }
    
    func createLabel(text: String) -> UILabel {
        let attrString = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.strokeWidth: -4.0,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)
            ]
        )
        let screenWidth = UIScreen.main.bounds.width - 32
        let label = UILabel()
        label.attributedText = attrString
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 20 + 1)
        label.textAlignment = .center
        return label
    }
    
    func updateContrastModeButton() {
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        contrastModeButton.setImage(UIImage(systemName: isLightMode ? "moon.fill" : "sun.max.fill"), for: .normal)
        contrastModeButton.imageView?.tintColor = isLightMode ? .white : .black
        contrastModeButton.backgroundColor = isLightMode ? .black : .white
        contrastModeButton.layer.cornerRadius = screenHeight / 16 * 0.45
        contrastModeButton.clipsToBounds = true
        contrastModeButton.addTarget(self, action: #selector(contrastModeToggled(_:)), for: .touchUpInside)
        
        self.view.addSubview(contrastModeButton)
        setAutoConstraints(someView: contrastModeButton, width: screenHeight / 16, height: screenHeight / 16, xOffset: 0.0, yOffset: screenHeight / 32, xRelative: true, yRelative: true, xLeading: true, yTop: true)
    }
        
    @objc func contrastModeToggled(_ sender: UIButton) {
        self.isLightMode.toggle()
        overrideUserInterfaceStyle = isLightMode ? .light : .dark
        self.view.backgroundColor = isLightMode ? .white : .black
        
        titleLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        descLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        footNoteLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        timerTextLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        contrastModeButton.setImage(UIImage(systemName: isLightMode ? "moon.fill" : "sun.max.fill"), for: .normal)
        contrastModeButton.imageView?.tintColor = isLightMode ? .white : .black
        contrastModeButton.backgroundColor = isLightMode ? .black : .white
    }
}
