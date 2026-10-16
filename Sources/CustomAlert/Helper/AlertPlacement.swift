import Foundation

/// Uses local, leading-to-trailing coordinates, matching SwiftUI's default
/// reserved-region query and directional padding. Bounds already exclude safe areas.
enum AlertPlacement {
    static func availableFrame(in bounds: CGRect, avoiding divisions: [CGRect]) -> CGRect {
        var available = bounds
        for division in divisions {
            let intersection = available.intersection(division)
            guard !intersection.isNull, !intersection.isEmpty else { continue }

            if division.minY <= available.minY && division.maxY >= available.maxY {
                // Book pose: prefer the trailing region, falling back to leading
                // if a split-screen window has no usable trailing region.
                if intersection.maxX < available.maxX {
                    available = CGRect(x: intersection.maxX, y: available.minY,
                                       width: available.maxX - intersection.maxX, height: available.height)
                } else if intersection.minX > available.minX {
                    available.size.width = intersection.minX - available.minX
                }
            } else if division.minX <= available.minX && division.maxX >= available.maxX {
                // Tabletop pose: keep the dialog in the upper region.
                if intersection.minY > available.minY {
                    available.size.height = intersection.minY - available.minY
                } else if intersection.maxY < available.maxY {
                    available = CGRect(x: available.minX, y: intersection.maxY,
                                       width: available.width, height: available.maxY - intersection.maxY)
                }
            }
        }
        return available
    }
}
