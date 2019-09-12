//
//  DrawingView.swift
//  ConvexHull
//
//  Created by ruckef on 9/7/19.
//  Copyright © 2019 Teem. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    enum DrawingLevel {
        case main
        case other
    }
    private var mainLayers = [CALayer]()
    private var otherLayers = [CALayer]()
    private var allLayers = [CALayer]()
    
    func drawCircle(point: CGPoint,
                    radius: CGFloat = 3,
                    color: UIColor = .white,
                    level: DrawingLevel = .main) {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(arcCenter: point,
                                  radius: radius,
                                  startAngle: 0,
                                  endAngle: CGFloat.pi * 2,
                                  clockwise: true).cgPath
        shape.fillColor = color.cgColor
        layer.addSublayer(shape)
        saveLayer(shape, level: level)
    }
    
    func drawLine(points: [CGPoint],
                  width: CGFloat = 1.5,
                  color: UIColor = .red,
                  level: DrawingLevel = .main) {
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
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = width
        layer.addSublayer(shape)
        saveLayer(shape, level: level)
    }
    
    func clear() {
        allLayers.forEach {
            $0.removeFromSuperlayer()
        }
        allLayers = []
        mainLayers = []
        otherLayers = []
    }
    
    func clear(level: DrawingLevel) {
        var layersArray: [CALayer]
        switch level {
        case .main:
            mainLayers = []
            mainLayers.forEach {
                $0.removeFromSuperlayer()
            }
            layersArray = mainLayers
        case .other:
            otherLayers.forEach {
                $0.removeFromSuperlayer()
            }
            otherLayers = []
            layersArray = otherLayers
        }
        for i in 0..<layersArray.count {
            let layer = layersArray[i]
            if let idx = allLayers.firstIndex(of: layer) {
                allLayers.remove(at: idx)
            }
        }
    }
}

extension DrawingView {
    private func saveLayer(_ layer: CALayer, level: DrawingLevel) {
        switch level {
        case .main:
            mainLayers.append(layer)
        case .other:
            otherLayers.append(layer)
        }
        allLayers.append(layer)
    }
}
