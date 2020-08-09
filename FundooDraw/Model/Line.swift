//
//  Line.swift
//  FundooDraw
//
//  Created by Admin on 09/08/20.
//  Copyright © 2020 nikhiljain. All rights reserved.
//

import UIKit

struct Line {
    private(set) var points = [CGPoint]()
    let color : CGColor
    let width : CGFloat
    
    mutating func add(point : CGPoint) {
        points.append(point)
    }
}
