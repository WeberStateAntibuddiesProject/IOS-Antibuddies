//
//  Extensions.swift
//  JudgementDay
//
//  Created by Ben Oliverson on 2/23/19.
//  Copyright © 2019 Weber State. All rights reserved.
//

import UIKit
import CommonCrypto

extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func startActivityIndicator(blur: UIVisualEffectView, ai: UIActivityIndicatorView) -> Void {
        blur.frame = view.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        ai.center = blur.center
        ai.alpha = 0.0
        blur.alpha = 0.0
        view.addSubview(blur)
        view.addSubview(ai)
        
        ai.startAnimating()
        UIView.animate(withDuration: 0.3) {
            blur.alpha = 1.0
            ai.alpha = 1.0
        }
    }
    
    func stopActivityIndicator(blur: UIVisualEffectView, ai: UIActivityIndicatorView) -> Void{
        UIView.animate(withDuration: 0.25, animations: {
            blur.alpha = 0.0
            ai.alpha = 0.0
        }, completion: { finished in
            ai.stopAnimating()
            blur.removeFromSuperview()
            ai.removeFromSuperview()
        })
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension String {
    
    var boolValue: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

extension Notification.Name {
    static let practiceQuestionsDownloadedNotification = Notification.Name("practiceQuestionsDownloadedNotification")
    
    static let practiceQuestionAnswersDownloadedNotification = Notification.Name("practiceQuestionAnswersDownloadedNotification")
}

extension Array where Element : Collection,
Element.Iterator.Element : Equatable, Element.Index == Int {
    
    func indices(of x: Element.Iterator.Element) -> Int? {
        for (_, row) in self.enumerated() {
            if let j = row.firstIndex(of: x) {
                return j
            }
        }
        return nil
    }
}


