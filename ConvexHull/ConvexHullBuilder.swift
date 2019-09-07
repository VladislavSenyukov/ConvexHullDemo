//
//  ConvexHullBuilder.swift
//  ConvexHull
//
//  Created by ruckef on 9/7/19.
//  Copyright © 2019 Teem. All rights reserved.
//

import CoreGraphics

struct ConvexHullBuilder {
    enum Orientation {
        case clockwise
        case counterclockwise
        case colinear
    }
    
    static func build(from points: [CGPoint]) -> [CGPoint] {
        if points.count < 3 {
            return []
        }
        var output = [CGPoint]()
        var leftmostIdx = 0
        for i in 1..<points.count {
            if points[i].x < points[leftmostIdx].x {
                leftmostIdx = i
            }
        }
        var p = leftmostIdx
        var q = 0
        repeat {
            output.append(points[p])
            q = (p + 1) % points.count
            for i in 0..<points.count {
                if ConvexHullBuilder.makeOrientation(p: points[p],
                                                     q: points[i],
                                                     r: points[q]) == .counterclockwise {
                    q = i
                }
            }
            p = q
        } while p != leftmostIdx
        return output
    }
    
    private static func makeOrientation(p: CGPoint, q: CGPoint, r: CGPoint) -> Orientation {
        let slope =
            (q.y - p.y) * (r.x - q.x) -
                (q.x - p.x) * (r.y - q.y)
        if slope == 0 {
            return .colinear
        }
        return slope > 0 ? .clockwise : .counterclockwise
    }
}
