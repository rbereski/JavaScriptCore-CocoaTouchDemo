//
//  JSObject.swift
//  NativeUI
//
//  Created by Rafal Bereski on 27.04.2016.
//  Copyright © 2016 Rafał Bereski. All rights reserved.
//

import Foundation
import JavaScriptCore


@objc protocol JSObjectProtocol: JSExport {
    var setThisValue: (@convention(block)(JSValue) -> Void)? { get }
}


class JSObject: NSObject, JSObjectProtocol {
    var this: JSManagedValue?
    
    override init() {
        super.init()
    }
    
    var setThisValue: (@convention(block)(JSValue) -> Void)? {
        return { [unowned self] (value: JSValue) in
            self.this = JSManagedValue(value: value)
        }
    }
}
