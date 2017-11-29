//
//  Binding.swift
//  GenericsAndBind
//
//  Created by Hajji on 21/11/2017.
//  Copyright © 2017 dev. All rights reserved.
//
//  This is based on the concept presented by Srdan Rasic
//  Simple Binding Method to avoid using complex libraries such as
//  RXSwift and ReactCoaCoa
import Foundation

class Bind<T> {
    
    typealias Listener = (T) -> ()
    var listener:Listener?
    
    func bind(_ listener:Listener?) {
        self.listener = listener
    }
    
    func fire(_ listener:Listener?) {
        self.listener = listener
        // Dispatch asynchronously on main Queue
        // This is in hopes to fire the listener on main thread
        // Somehow update on view will not be dragged down by other process
        DispatchQueue.main.async {
            listener?(self.value)
        }
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}

