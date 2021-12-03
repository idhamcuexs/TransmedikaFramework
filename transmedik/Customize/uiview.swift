//
//  uiview.swift
//  Pasien
//
//  Created by Idham Kurniawan on 22/03/21.
//  Copyright © 2021 Netkrom. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import Lottie
extension UIViewController  {
   
    func setmoney(harga : Int) -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: NSNumber(value: harga)) {
            let outputs = formattedTipAmount.replacingOccurrences(of: "$", with: "")
            let outputs1 = "Rp. \(outputs.replacingOccurrences(of: "IDR", with: ""))"
           return String(outputs1)
        }
        return ""
    }

    
    func loading(_ UIViewController : UIViewController){
        let vc = UIStoryboard(name: "Loading", bundle: AppSettings.bundleframework).instantiateViewController(withIdentifier: "lodingViewController") as? lodingViewController
        present(vc!, animated: false, completion: nil)
        
    }
    
    func closeloading(_ UIViewController : UIViewController){
        dismiss(animated: false, completion: nil)
    }
    
  

}


open class Loading: UIView {
    
    static var view = UIView()
    //    static var lblProgress = UILabel()
    
    // MARK: - MyHud Show and Dismiss
    
    open class func show() {
        
        if let vc = UIApplication.topViewController() {
            /// Create UIView for loading
            view = UIView(frame: CGRect(x: 50, y: 50, width: 80, height: 80))
            view.center = vc.view.center
            view.backgroundColor = UIColor.clear
            view.alpha = 0.9
            view.layer.cornerRadius = 10
            
            /// Set view to full screen, aspectFill
//            let animationView = LOTAnimationView(name: "loading_rainbow")
            let animationView = LOTAnimationView(name: "loading_rainbow", bundle: AppSettings.bundleframework!)
            animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            animationView.contentMode = .scaleAspectFill
            animationView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
            animationView.loopAnimation = true
            animationView.play{ (finished) in }
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animationView)
            
//            lblProgress = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            //lblProgress.text = "0%"
//            lblProgress.font = UIFont(name: "Helvetica-Regular", size: 16)
//            lblProgress.textAlignment = .center
//            lblProgress.textColor = #colorLiteral(red: 0.2543821383, green: 0.2543821383, blue: 0.2543821383, alpha: 1)
//            view.addSubview(lblProgress)
//            lblProgress.isHidden = true
            vc.view.addSubview(view)
            UIApplication.shared.keyWindow!.isUserInteractionEnabled = false
            
        }
    }
    
    open class func setValue(progress:Int){
//        lblProgress.isHidden = false
//        lblProgress.text = "\(progress)%"
        if progress == 100 {
            self.dismiss()
        }
    }
    
    open class func dismiss() {
        
        /// Remove loading UIView
        let vc = UIApplication.topViewController()
        vc?.view.isUserInteractionEnabled = true
        view.removeFromSuperview()
        UIApplication.shared.keyWindow!.isUserInteractionEnabled = true
    }
}

extension UIApplication {
    
    // MARK: - Get current view controller
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UIViewController{
    
    func keluar(view : PresentPage){
        if view == .navigation{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    func openVC(_ view : UIViewController ,_ present : PresentPage){
        if present == .navigation{
            self.navigationController?.pushViewController(view, animated: true)
        }else{
            self.present(view, animated: true, completion: nil)
        }
    }
}

extension Double {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}


extension UIView {
    
    /**
     Set x Position
     
     :param: x CGFloat
     by DaRk-_-D0G
     */
    func setX(x: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position
     
     :param: y CGFloat
     by DaRk-_-D0G
     */
    func setY(y: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width
     
     :param: width CGFloat
     by DaRk-_-D0G
     */
    func setWidth(width: CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height
     
     :param: height CGFloat
     by DaRk-_-D0G
     */
    func setHeight(height: CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
//    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
    
    func hideKeyboardTappedAround() {
        /// Dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func addDashedBorderRed() {
        let color = UIColor.red.cgColor
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = 2
        caShapeLayer.lineDashPattern = [2,3]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    func addDashedBorderGray() {
        let color = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1).cgColor
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = 2
        caShapeLayer.lineDashPattern = [2,3]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    
    func dropShadow(shadowColor: UIColor,
                    fillColor: UIColor ,
                    opacity: Float,
                    offset: CGSize,
                    radius: CGFloat)  {
        
//        self.layer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
//        self.layer.fillColor = fillColor.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
//        self.layer.shadowPath = shadowLayer.path
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    func dropShadowOnTop(shadowColor: UIColor,
                    fillColor: UIColor ,
                    opacity: Float,
                    offset: CGSize,
                    radius: CGFloat)  {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: -1, y: -1, width: self.bounds.width, height: self.layer.shadowRadius)).cgPath
        
    }
    
    func addDashedBorder() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        DispatchQueue.main.async {
            self.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
            gradientLayer.frame = self.bounds
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
}
