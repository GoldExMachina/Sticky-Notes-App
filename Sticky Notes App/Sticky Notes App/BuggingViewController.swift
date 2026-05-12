//
//  BuggingViewController.swift
//  Sticky Notes App
//
//  Created by Alexander Smith on 31/01/2025.
//

import Foundation
import UIKit

class BuggingViewController: UIViewController {
    
    private var navigationTimer: Timer?
            
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set a static image for the UIImageView
        logoImage?.image = UIImage(named: "SimpleInAppImage")
        
        // Start the timer to navigate after 5 seconds
        startNavigationTimer()
        print("Repeating ViewController viewDidLoad() ")
    

    }

    
    // MARK: - Timer Logic

    func startNavigationTimer() {
        navigationTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(navigateToSecondViewController), userInfo: nil, repeats: false)
        
        print("Repeating startNavigationTimer() ")

    }

    @objc func navigateToSecondViewController() {
        // Invalidate the timer if it's still running
        navigationTimer?.invalidate()
        
        // Perform the navigation
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Ensure your storyboard name is correct
        if let thirdVC = storyboard.instantiateViewController(withIdentifier: "StickyNoteViewController") as? StickyNoteViewController {
            thirdVC.modalPresentationStyle = .fullScreen // Full screen presentation
            self.present(thirdVC, animated: true, completion: nil)
        } else {
            print("Error: Could not instantiate SecondViewController")
        }
    }
    
    deinit {
        navigationTimer?.invalidate() // Invalidate timer when deinit
    }
    
}
