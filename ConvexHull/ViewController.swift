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
        drawingView.addCircle(point: location)
        points.append(location)
    }
    
    @IBAction private func clearDidClick(_ sender: UIBarButtonItem) {
        clear()
    }
    
    @IBAction private func convexHullDidClick(_ sender: UIBarButtonItem) {
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
    
    private func clear() {
        points = []
        drawingView.clear()
    }
}
