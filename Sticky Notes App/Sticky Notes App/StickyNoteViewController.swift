//
//  StickyNoteViewController.swift
//  Sticky Notes App
//
//  Created by Alexander Smith on 04/10/2024.
//

import Foundation

import UIKit
import WidgetKit
// Search bar working and widget working + constraints

class StickyNoteViewController: UIViewController, UIColorPickerViewControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var colourwheel: UIButton!
    
    @IBOutlet weak var segementedControl10: UISegmentedControl!
    

    
    // Load the saved text for the first segment
   var currentSegmentKey: String = "segment_0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure textView is properly connected
        if textView == nil {
            print("Error: textView is nil in viewDidLoad!")
            return
        }
        
        textView.delegate = self
        
        let data = loadData(forKey: currentSegmentKey)
        textView.text = data.text ?? ""
        colorView.backgroundColor = data.color ?? .white
        textView.backgroundColor = data.color ?? .white
        
        DispatchQueue.main.async {
            // Check if self.textView is nil directly
            if self.textView != nil {
                self.textView.text = data.text ?? ""
                self.colorView.backgroundColor = data.color ?? .white
            } else {
                print("Error: textView is nil when trying to update text!")
            }
        }
        
        setupSwipeGestures()
        updateTextViewForSelectedSegment()
        
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("StickyNoteViewController will appear")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData(forKey: currentSegmentKey)
        print("StickyNoteViewController will disappear")

    }
    
    @IBAction func showColorWheel(_ sender: UIButton) {
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = colorView.backgroundColor ?? .white // Set default color
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorView.backgroundColor = viewController.selectedColor
        
        saveData(forKey: currentSegmentKey)

    }
    

    func saveData(forKey key: String) {
        
        guard self.textView != nil else {
            print("Error: textView is nil when trying to save data!")
            return
        }
        
        let text = textView.text ?? ""
        
            let color = colorView.backgroundColor ?? .white
            let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            let data: [String: Any] = ["text": text, "color": colorData]
            UserDefaults.standard.set(data, forKey: key)

        // Save to shared UserDefaults for the widget - what is the user defaults for this app group identifier accessed by suitename: and set it to the constant variable sharedDefaults!
        if let sharedDefaults = UserDefaults(suiteName: "group.com.FrostByte.StickyNotesWidget") {
            sharedDefaults.set(text, forKey: "widget_text")
            sharedDefaults.set(colorData, forKey: "widget_color")
                        
            if let text = sharedDefaults.string(forKey: "widget_text") {
 //               print("Saved text in shared defaults with (forKey: widget_text): \(text)")
            }
            if let colorData = sharedDefaults.data(forKey: "widget_color"),
               let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
//                print("Saved color in shared defaults: \(color)")
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
//        print("reloadAllTimelines widget timelines after saving data.")
    }

    func loadData(forKey key: String) -> (text: String?, color: UIColor?) {
        guard let data = UserDefaults.standard.dictionary(forKey: key),
                  let text = data["text"] as? String,
                  let colorData = data["color"] as? Data,
                  let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor
            else {
            // Default values if no data is saved
            return ("Default Note", .systemBlue) // Change the default colour here
            }
            return (text, color)
    }

    
    // TextView delegate method
    func textViewDidChange(_ textView: UITextView) {
        saveData(forKey: currentSegmentKey)  // Save on text change
    }
    

    @IBAction func segementedController(_ sender: UISegmentedControl) {
        // Save the text for the current segment
        saveData(forKey: currentSegmentKey)

        // Update the key based on the new selected segment
        currentSegmentKey = "segment_\(sender.selectedSegmentIndex)"
        
        // Load the text for the new segment
        let data = loadData(forKey: currentSegmentKey)
        textView.text = data.text ?? ""
        colorView.backgroundColor = data.color ?? .white
        
        // Refresh the widget
            WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    func setupSwipeGestures() {
            // Add swipe left gesture
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
            
            // Add swipe right gesture
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)
        }
        
        @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
            if gesture.direction == .left {
                if segementedControl10.selectedSegmentIndex < segementedControl10.numberOfSegments - 1 {
                    
                    // Save the text for the current segment
                    saveData(forKey: currentSegmentKey)
                    
                    segementedControl10.selectedSegmentIndex += 1
                    
                }
            } else if gesture.direction == .right {
                if segementedControl10.selectedSegmentIndex > 0 {
                    
                    // Save the text for the current segment
                    saveData(forKey: currentSegmentKey)
                    
                    segementedControl10.selectedSegmentIndex -= 1
                    
                }
            }
            // Update the key based on the new selected segment
            currentSegmentKey = "segment_\(segementedControl10.selectedSegmentIndex)"
            updateTextViewForSelectedSegment()
        }
        
    func updateTextViewForSelectedSegment() {

            // Load the text for the new segment
            let data = loadData(forKey: currentSegmentKey)
            textView.text = data.text ?? ""
            colorView.backgroundColor = data.color ?? .white
            
            // Refresh the widget
                WidgetCenter.shared.reloadAllTimelines()
        }
}


// Constraints help = I have a full background view under that i have a background view, under that i have a blue view a text view and a search bar and under the blue view i have a segmented control a button and a text view. How do i setup contraints propertly?
