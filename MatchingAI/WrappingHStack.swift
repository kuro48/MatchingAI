//
//  WrappingHStack.swift
//  MatchingAI
//
//  Created by Richard .T on 2025/05/31.
//

import SwiftUI

struct WrappingHStack: Layout {
    let alignment: HorizontalAlignment

    init(alignment: HorizontalAlignment = .leading) {
        self.alignment = alignment
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.width ?? 0
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.infinity)
            if currentX + subviewSize.width > containerWidth {
                currentX = 0
                currentY += lineHeight
                totalHeight = currentY + subviewSize.height
                lineHeight = 0
            }
            currentX += subviewSize.width + 8
            lineHeight = max(lineHeight, subviewSize.height)
            totalHeight = max(totalHeight, currentY + subviewSize.height)
        }
        return CGSize(width: containerWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let containerWidth = bounds.width
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0
        var lineViews: [LayoutSubviews.Element] = []

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.infinity)
            if currentX + subviewSize.width > containerWidth {
                placeLine(lineViews: lineViews, in: bounds, currentY: &currentY, lineHeight: lineHeight, containerWidth: containerWidth)
                currentX = bounds.minX
                currentY += lineHeight + 8
                lineHeight = 0
                lineViews.removeAll()
            }
            lineViews.append(subview)
            currentX += subviewSize.width + 8
            lineHeight = max(lineHeight, subviewSize.height)
        }

        placeLine(lineViews: lineViews, in: bounds, currentY: &currentY, lineHeight: lineHeight, containerWidth: containerWidth)
    }

    private func placeLine(lineViews: [LayoutSubviews.Element], in bounds: CGRect, currentY: inout CGFloat, lineHeight: CGFloat, containerWidth: CGFloat) {
        var lineTotalWidth: CGFloat = 0
        for view in lineViews {
            lineTotalWidth += view.sizeThatFits(.infinity).width + 8
        }
        lineTotalWidth -= 8

        let startX: CGFloat
        switch alignment {
        case .leading:
            startX = bounds.minX
        case .center:
            startX = bounds.minX + (containerWidth - lineTotalWidth) / 2
        case .trailing:
            startX = bounds.minX + (containerWidth - lineTotalWidth)
        default:
            startX = bounds.minX
        }

        var xOffset = startX
        for view in lineViews {
            let subviewSize = view.sizeThatFits(.infinity)
            view.place(at: CGPoint(x: xOffset, y: currentY), proposal: ProposedViewSize(subviewSize))
            xOffset += subviewSize.width + 8
        }
    }
}
