//
//  ButtonWrapper.swift
//  NativeUI
//
//  Created by Rafal Bereski on 27.04.2016.
//  Copyright © 2016 Rafał Bereski. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore


@objc protocol ButtonWrapperProtocol: JSExport, JSObjectProtocol {
    var text: String { get set }
    var setFrame: (@convention(block)(CGFloat, CGFloat, CGFloat, CGFloat) -> Void)? { get }
}


class ButtonWrapper: JSObject, ButtonWrapperProtocol {
    var button: UIButton!
    
    override init() {
        super.init()
        button = UIButton(type: .System)
        button.addTarget(self, action: Selector("didTap:"), forControlEvents: .TouchUpInside)
        
        // Embedding button inside root view controller
        let app = UIApplication.sharedApplication()
        let rootVC = app.windows.first!.rootViewController!
        rootVC.view.addSubview(button)
    }
    
    
    dynamic var text: String {
        get { return button.titleLabel?.text ?? "" }
        set(value) { button.setTitle(value, forState: .Normal) }
    }
    
    
    var setFrame: (@convention(block)(CGFloat, CGFloat, CGFloat, CGFloat) -> Void)? {
        return { [unowned self] (x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) in
            self.button.frame = CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
    
    func didTap(sender: AnyObject) {
        if let onClick = this?.value.valueForProperty("onClick") {
            onClick.callWithArguments([])
        }
    }
}
