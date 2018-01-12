//
//  ViewController.swift
//  NativeUI
//
//  Created by Rafal Bereski on 27.04.2016.
//  Copyright © 2016 Rafał Bereski. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {
    var vm: JSVirtualMachine!
    var ctx: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize JavaScriptCore
        vm = JSVirtualMachine()
        ctx = JSContext(virtualMachine: vm)
        ctx.exceptionHandler = { ctx, ex in print("\(ex!)") }
        
        // Add print function to the context
        let printFunc : @convention(block) (String) -> Void  = { text in print(text) }
        ctx.setObject(unsafeBitCast(printFunc, to: AnyObject.self), forKeyedSubscript: "print" as NSCopying & NSObjectProtocol)
        
        // Add button class to the context
        self.add(class: ButtonWrapper.self, name: "Button", context: ctx)
        
        // Create two buttons and set tap event handlers
        ctx.evaluateScript("var btn1 = new Button()")
        ctx.evaluateScript("btn1.text = 'Button 1'")
        ctx.evaluateScript("btn1.setFrame(40, 100, 280, 60)")
        ctx.evaluateScript("btn1.onClick = function() { print('Button 1 tapped.') }")
        ctx.evaluateScript("var btn2 = new Button()")
        ctx.evaluateScript("btn2.text = 'Button 2'")
        ctx.evaluateScript("btn2.setFrame(40, 200, 280, 60)")
        ctx.evaluateScript("btn2.onClick = function() { print('Button 2 tapped.') }")
    }
    
    
    func add(class cls: AnyClass, name: String, context: JSContext) {
        let constructorName = "__constructor__\(name)"
        
        let constructor: @convention(block)() -> NSObject = {
            let cls = cls as! NSObject.Type
            return cls.init()
        }
        
        context.setObject(unsafeBitCast(constructor, to: AnyObject.self),
            forKeyedSubscript: constructorName as NSCopying & NSObjectProtocol)
        
        let script = "function \(name)() " +
            "{ " +
            "   var obj = \(constructorName)(); " +
            "   obj.setThisValue(obj); " +
            "   return obj; " +
            "} "
        
        context.evaluateScript(script);
    }
}
