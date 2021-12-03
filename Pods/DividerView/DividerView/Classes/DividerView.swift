//
//  DividerView.swift
//  DividerView
//
//  Created by Craig Siemens on 2016-05-27.
//
//

import UIKit

public enum DividerAxis {
    case horizontal
    case vertical
}

@IBDesignable
open class DividerView: UIView {
    
    // MARK: - Properties
    
    open var axis = DividerAxis.horizontal {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var vertical: Bool {
        get {
            return axis == .vertical
        }
        set {
            axis = (newValue ? .vertical : .horizontal)
        }
    }
    
    fileprivate var thickness: CGFloat = 1 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Methods
    
    public convenience init(axis: DividerAxis) {
        self.init(frame: .zero)
        self.axis = axis
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRequiredContentHuggingPriority()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRequiredContentHuggingPriority()
    }
    
    fileprivate func setupRequiredContentHuggingPriority() {
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
    }
    
    fileprivate func updateThicknessForWindow(_ window: UIWindow?) {
        #if !TARGET_INTERFACE_BUILDER
            let screen = window?.screen ?? UIScreen.main
            thickness = 1 / screen.scale
        #else
            thickness = 1
        #endif
    }
    
    override open func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        updateThicknessForWindow(newWindow)
    }
    
    override open var intrinsicContentSize : CGSize {
        var size = CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
        
        switch axis {
        case .horizontal:
            size.height = thickness
        case .vertical:
            size.width = thickness
        }
        
        return size
    }
}
