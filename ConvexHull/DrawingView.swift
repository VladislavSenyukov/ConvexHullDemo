//
//  DrawingView.swift
//  ConvexHull
//
//  Created by ruckef on 9/7/19.
//  Copyright © 2019 Teem. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    var circleColor = UIColor.white
    var circleRadius = CGFloat(3)
    var lineColor = UIColor.red
    var lineWidth = CGFloat(1.5)
    private var allCustomLayers = [CALayer]()
    
    func addCircle(point: CGPoint) {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(arcCenter: point,
                                  radius: circleRadius,
                                  startAngle: 0,
                                  endAngle: CGFloat.pi * 2,
                                  clockwise: true).cgPath
        shape.fillColor = circleColor.cgColor
        layer.addSublayer(shape)
        allCustomLayers.append(shape)
    }
    
    func drawLine(points: [CGPoint]) {
        let line = UIBezierPath()
        for i in 0..<points.count {
            let point = points[i]
            if i == 0 {
                line.move(to: point)
            } else {
                line.addLine(to: point)
            }
        }
        line.close()
        let shape = CAShapeLayer()
        shape.path = line.cgPath
        shape.strokeColor = lineColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = lineWidth
        layer.addSublayer(shape)
        allCustomLayers.append(shape)
    }
    
    func clear() {
        allCustomLayers.forEach {
            $0.removeFromSuperlayer()
        }
        allCustomLayers = []
    }
}
