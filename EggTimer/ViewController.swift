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
import SwiftUI

let totalScreenWidth = UIScreen.main.bounds.width
let totalScreenHeight = UIScreen.main.bounds.height





class ViewController: UIViewController {
    
    var isLightMode = true
    
    var sound: AVAudioPlayer!
    
    var timer = Timer()
    
    var titleLabel = UILabel()
    var descLabel = UILabel()
    var footNoteLabel = UILabel()
    var timerTextLabel = UILabel()
    
    var progressBarHostingController = UIHostingController(rootView: ProgressBarView(progressValue: 0.0, timer: "00:00", width: totalScreenWidth / 3, height: totalScreenWidth / 3, isLightMode: true))
    
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
        
        progressBarHostingController = UIHostingController(rootView: ProgressBarView(progressValue: 0.0, timer: "00:00", width: screenWidth / 3, height: screenWidth / 3, isLightMode: isLightMode))
        
        setSwiftUIView(progressBarHostingController)
        setAutoConstraints(someView: progressBarHostingController.view!, width: totalScreenWidth / 3, height: totalScreenWidth / 3, xOffset: screenWidth / 12, yOffset: screenHeight / 10, xRelative: false, yRelative: true, xLeading: true, yTop: false)
        
        setTitleLabel()
        
        setDescLabel()
        
        setFootNoteLabel()
        
        setTimerTextLabel()
        
        
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
        
        timerTextLabel.text = "Your egg will be ready in:"
        
        let hardnessSelected = sender.currentTitle!
        
        let screenWidth = UIScreen.main.bounds.width - 32
        let screenHeight = UIScreen.main.bounds.height - 32
        
        timer.invalidate()
        
        let totalTime = eggTimes[hardnessSelected]! * 60
        var time = eggTimes[hardnessSelected]! * 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { t in
            
            let min = time / 60
            let sec = time % 60
            
            time -= 1
            
            self.progressBarHostingController.view!.removeFromSuperview()
            
            self.progressBarHostingController = UIHostingController(rootView: ProgressBarView(progressValue: Float((totalTime - time)) / Float(totalTime), timer: (min > 9 ? "\(min)" : "0\(min)") + ":" + (sec > 9 ? "\(sec)" : "0\(sec)"), width: screenWidth / 3, height: screenWidth / 3, isLightMode: self.isLightMode))
            
            self.setSwiftUIView(self.progressBarHostingController)
            self.setAutoConstraints(someView: self.progressBarHostingController.view!, width: totalScreenWidth / 3, height: totalScreenWidth / 3, xOffset: screenWidth / 12, yOffset: screenHeight / 10, xRelative: false, yRelative: true, xLeading: true, yTop: false)
            
            
            if time == -1 {
                t.invalidate()
                
                self.timerTextLabel.text = "Your egg is ready!"
                
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
        
        timerTextLabel.text = "Select the type of egg you prefer"
        timerTextLabel.numberOfLines = 0
        timerTextLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        timerTextLabel.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 18 + 1)
        timerTextLabel.textAlignment = .center
        self.view.addSubview(timerTextLabel)
        setAutoConstraints(someView: timerTextLabel, width: screenWidth, height: screenHeight / 5, xOffset: 0.0, yOffset: screenHeight / 20 + totalScreenWidth / 3, xRelative: true, yRelative: true, xLeading: true, yTop: false)
    }
    
    fileprivate func setLabel(label: UILabel, xOffset: CGFloat) {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width - 32
        let screenHeight = view.safeAreaLayoutGuide.layoutFrame.height - 32
        
        label.text = "00:00"
        label.numberOfLines = 0
        label.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        label.font = UIFont(name: "AvenirNext-Bold", size: screenWidth / 5 + 1)
        label.textAlignment = .center
        self.view.addSubview(label)
        setAutoConstraints(someView: label, width: screenWidth, height: screenHeight / 8, xOffset: xOffset, yOffset: screenHeight / 6, xRelative: false, yRelative: true, xLeading: true, yTop: false)
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
    
    fileprivate func setSwiftUIView(_ child: UIHostingController<ProgressBarView>) {
            child.view.translatesAutoresizingMaskIntoConstraints = false
            child.view.frame = self.view.bounds
            // First, add the view of the child to the view of the parent
            self.view.addSubview(child.view)
            // Then, add the child to the parent
            self.addChild(child)
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
        let screenWidth = UIScreen.main.bounds.width - 32
        let screenHeight = UIScreen.main.bounds.height - 32
        
        self.isLightMode.toggle()
        overrideUserInterfaceStyle = isLightMode ? .light : .dark
        self.view.backgroundColor = isLightMode ? .white : .black
        
        titleLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        descLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        footNoteLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        timerTextLabel.textColor = isLightMode ? .darkGray : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        self.progressBarHostingController.view!.removeFromSuperview()
        
        self.progressBarHostingController = UIHostingController(rootView: ProgressBarView(progressValue: self.progressBarHostingController.rootView.progressValue, timer: self.progressBarHostingController.rootView.timer, width: self.progressBarHostingController.rootView.width, height: self.progressBarHostingController.rootView.height, isLightMode: self.isLightMode))
        
        self.setSwiftUIView(self.progressBarHostingController)
        self.setAutoConstraints(someView: self.progressBarHostingController.view!, width: totalScreenWidth / 3, height: totalScreenWidth / 3, xOffset: screenWidth / 12, yOffset: screenHeight / 10, xRelative: false, yRelative: true, xLeading: true, yTop: false)
        
        contrastModeButton.setImage(UIImage(systemName: isLightMode ? "moon.fill" : "sun.max.fill"), for: .normal)
        contrastModeButton.imageView?.tintColor = isLightMode ? .white : .black
        contrastModeButton.backgroundColor = isLightMode ? .black : .white
    }
}
