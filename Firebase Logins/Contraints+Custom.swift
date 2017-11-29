//
//  Contraints+Custom.swift
//  Firebase Logins
//
//  Created by dev on 24/11/2017.
//  Copyright © 2017 Hajji Reyes. All rights reserved.
//

import UIKit

enum Anchor {
    case Top, Bottom, Lead, Trail, Width, Height, XAnchor, YAnchor
}

extension UIView {
  
    func addConstraints(_ to:Anchor, from:UIView, constant:CGFloat? = nil) {
        let constant = constant ?? 0
        switch to {
        case .Top:
            self.topAnchor.constraint(equalTo: from.topAnchor, constant: constant).isActive = true
            break
        case .Bottom:
            self.bottomAnchor.constraint(equalTo: from.bottomAnchor, constant: constant).isActive = true
            break
        case .Lead:
            self.leadingAnchor.constraint(equalTo: from.leadingAnchor, constant: constant).isActive = true
            break
        case .Trail:
            self.trailingAnchor.constraint(equalTo: from.trailingAnchor, constant: constant).isActive = true
            break
        case .Width:
            self.widthAnchor.constraint(equalToConstant: constant).isActive = true
            break
        case .Height:
            self.heightAnchor.constraint(equalToConstant: constant).isActive = true
            break
        case .XAnchor:
            self.centerXAnchor.constraint(equalTo: from.centerXAnchor).isActive = true
            break
        case .YAnchor:
            self.centerYAnchor.constraint(equalTo: from.centerYAnchor).isActive = true
            break
        }
    }
    
}
