//
//  GameScene.swift
//  Ninja
//
//  Created by Migu on 2018/2/23.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import CoreGraphics

let π = CGFloat(Double.pi)

public extension CGFloat {
  public func degreesToRadians() -> CGFloat {
    return π * self / 180.0
  }

  public func radiansToDegrees() -> CGFloat {
    return self * 180.0 / π
  }

  public func clamped(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
    let min = v1 < v2 ? v1 : v2
    let max = v1 > v2 ? v1 : v2
    return self < min ? min : (self > max ? max : self)
  }

  public mutating func clamp(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
    self = clamped(v1, v2)
    return self
  }

  public func sign() -> CGFloat {
    return (self >= 0.0) ? 1.0 : -1.0
  }

  public static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }

  public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }

  public static func randomSign() -> CGFloat {
    return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
  }
}

public func shortestAngleBetween(_ angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
    if (angle >= π) {
        angle = angle - twoπ
    }
    if (angle <= -π) {
        angle = angle + twoπ
    }
    return angle
}
