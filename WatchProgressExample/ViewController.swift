//
//  ViewController.swift
//  WatchProgressExample
//
//  Created by Simon on 12/26/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var watchProgressView: WatchProgressView!
    @IBOutlet weak var moveSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpProgress()
    }
    
    func setUpProgress() {
        self.watchProgressView.value = moveSlider.value
        self.watchProgressView.trackThickness = 30
        self.watchProgressView.progressThickness = 30
        self.watchProgressView.progressThicknessFraction = 30
        self.watchProgressView.trackStartTint = UIColor(hexString: "F0F0F0")
        self.watchProgressView.trackEndTint = UIColor(hexString: "E0E0E0")
        self.watchProgressView.progressStartTint = UIColor(hexString: "A3C3F9")
        self.watchProgressView.progressEndTint = UIColor(hexString: "C8ACFF")
        self.watchProgressView.trackStartAngle = 140
        self.watchProgressView.trackEndAngle = 400
        self.watchProgressView.showPercent = true
        self.watchProgressView.percentTint = .black
        self.watchProgressView.percentSize = 48
        self.watchProgressView.percentBold = true

    }

    @IBAction func moveProgress(_ sender: Any) {
        if let slider = sender as? UISlider {
            self.watchProgressView.value = slider.value
        }
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


