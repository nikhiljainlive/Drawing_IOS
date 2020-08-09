//
//  Canvas.swift
//  FundooDraw
//
//  Created by Admin on 08/08/20.
//  Copyright © 2020 nikhiljain. All rights reserved.
//

import UIKit

class Canvas : UIView {
    private var lines = [Line]()
    private var strokeColor : CGColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    private var lineWidth : CGFloat = 1
    private var isContinuousLine = false
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        initCanvas()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCanvas() {
        self.backgroundColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(.round)
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color)
            context.setLineWidth(line.width)
            context.setBlendMode(.normal)
            for (index, point) in line.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isContinuousLine = false
        guard let point = touches.first?.location(in: nil) else { return }
        lines.append(Line(points : [point], color: strokeColor, width: lineWidth))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        isContinuousLine = true
        guard let point = touches.first?.location(in: nil) else { return }
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.add(point : point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isContinuousLine {
            guard let point = touches.first?.location(in: nil) else { return }
            guard var lastLine = lines.popLast() else { return }
            lastLine.add(point : point)
            lines.append(lastLine)
            setNeedsDisplay()
        }
    }
    
    func setStrokeColor(color : CGColor) {
        self.strokeColor = color
    }
    
    func setLineWidth(width : CGFloat) {
        self.lineWidth = width
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func toImage() -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
}
