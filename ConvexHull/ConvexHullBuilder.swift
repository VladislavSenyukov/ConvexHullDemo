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
    struct Triplet {
        let p: CGPoint
        let q: CGPoint
        let r: CGPoint
    }
    struct IterationResult {
        let triplet: Triplet
        let isSoughtFor: Bool
    }
    struct HullSegment {
        let a: CGPoint
        let b: CGPoint
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
                if ConvexHullBuilder.findOrientation(p: points[p],
                                                     q: points[i],
                                                     r: points[q]) == .counterclockwise {
                    q = i
                }
            }
            p = q
        } while p != leftmostIdx
        return output
    }
    
    static func build(from points: [CGPoint],
                      foundOrientationCallback: (IterationResult) -> Bool,
                      foundHullSegmentCallback: (HullSegment) -> Bool )  -> [CGPoint] {
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
                let orientation = ConvexHullBuilder.findOrientation(p: points[p],
                                                                    q: points[i],
                                                                    r: points[q])
                let isSoughtFor = orientation == .counterclockwise
                if isSoughtFor {
                    q = i
                }
                let triplet = Triplet(p: points[p], q: points[i], r: points[q])
                let result = IterationResult(triplet: triplet, isSoughtFor: isSoughtFor)
                let isCancelled = foundOrientationCallback(result)
                if isCancelled {
                    return []
                }
            }
            let segment = HullSegment(a: points[p], b: points[q])
            let isCancelled = foundHullSegmentCallback(segment)
            if isCancelled {
                return []
            }
            p = q
        } while p != leftmostIdx
        return output
    }
    
    private static func findOrientation(p: CGPoint, q: CGPoint, r: CGPoint) -> Orientation {
        let slope =
            (q.y - p.y) * (r.x - q.x) -
                (q.x - p.x) * (r.y - q.y)
        if slope == 0 {
            return .colinear
        }
        return slope > 0 ? .clockwise : .counterclockwise
    }
}
