//
//  ViewController.swift
//  ConvexHull
//
//  Created by ruckef on 9/7/19.
//  Copyright © 2019 Teem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var drawingView: DrawingView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var convexHullButton: UIBarButtonItem!
    private var points = [CGPoint]()
    private var shouldClearDrawings = false
}

extension ViewController {
    @IBAction private func viewDidClick(_ sender: UITapGestureRecognizer) {
        if shouldClearDrawings {
            clear()
            shouldClearDrawings = false
        }
        let location = sender.location(in: drawingView)
        drawingView.drawCircle(point: location)
        points.append(location)
    }
    
    @IBAction private func convexHullDidClick(_ sender: UIBarButtonItem) {
        if animationSwitch.isOn {
            let isAnimating = convexHullButton.tag == 0
            changeConvexHullButton(isAnimating)
            if isAnimating {
                shouldClearDrawings = true
                drawingView.clear(level: .other)
            } else {
                animateConvexHull()
            }
        } else {
            changeConvexHullButton(true)
            drawConvexHull()
        }
    }
    
    private func drawConvexHull() {
        spinner.startAnimating()
        drawingView.isUserInteractionEnabled = false
        shouldClearDrawings = true
        DispatchQueue.global().async {
            let convexHullPoints = ConvexHullBuilder.build(from: self.points)
            DispatchQueue.main.async {
                self.drawingView.drawLine(points: convexHullPoints)
                self.spinner.stopAnimating()
                self.drawingView.isUserInteractionEnabled = true
            }
        }
    }
    
    private func animateConvexHull() {
        drawingView.isUserInteractionEnabled = false
        shouldClearDrawings = true
        DispatchQueue.global().async {
            let convexHullPoints = ConvexHullBuilder.build(from: self.points, foundOrientationCallback: { iterationResult in
                DispatchQueue.main.async {
                    let level = DrawingView.DrawingLevel.other
                    self.drawingView.clear(level: level)
                    let triplet = iterationResult.triplet
                    let linePoint = [triplet.p, triplet.q, triplet.r]
                    let lineColor: UIColor = iterationResult.isSoughtFor ? .blue : .gray
                    self.drawingView.drawCircle(point: triplet.p, radius: 4, color: .red, level: level)
                    self.drawingView.drawCircle(point: triplet.r, radius: 4, color: .red, level: level)
                    self.drawingView.drawCircle(point: triplet.q, radius: 4, color: .yellow, level: level)
                    self.drawingView.drawLine(points: linePoint, color: lineColor, level: level)
                }
                Thread.sleep(forTimeInterval: 2)
                return self.convexHullButton.tag == 1
            }, foundHullSegmentCallback: { hullSegment in
                DispatchQueue.main.async {
                    self.drawingView.clear(level: .other)
                    self.drawingView.drawCircle(point: hullSegment.a, radius: 4, color: .green)
                    self.drawingView.drawCircle(point: hullSegment.b, radius: 4, color: .green)
                    self.drawingView.drawLine(points: [hullSegment.a, hullSegment.b], width: 2, color: .green)
                }
                Thread.sleep(forTimeInterval: 2)
                return self.convexHullButton.tag == 1
            })
            DispatchQueue.main.async {
                self.drawingView.drawLine(points: convexHullPoints)
                self.drawingView.isUserInteractionEnabled = true
            }
        }
    }
    
    private func clear() {
        points = []
        drawingView.clear()
    }
    
    private func changeConvexHullButton(_ enabled: Bool) {
        let buttonTitle = enabled ? "Convex Hull" : "Cancel"
        convexHullButton.title = buttonTitle
        convexHullButton.tag = enabled ? 1 : 0
    }
}
