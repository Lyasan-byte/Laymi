//
//  FlowLayout.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = rows(proposal: proposal, subviews: subviews)
        return CGSize(
            width: proposal.width ?? rows.map(\.width).max() ?? 0,
            height: rows.last.map { $0.y + $0.height } ?? 0
        )
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = rows(proposal: ProposedViewSize(width: bounds.width, height: bounds.height), subviews: subviews)
        
        for row in rows {
            for item in row.items {
                subviews[item.index].place(
                    at: CGPoint(x: bounds.minX + item.x, y: bounds.minY + row.y),
                    proposal: ProposedViewSize(item.size)
                )
            }
        }
    }
    
    private func rows(proposal: ProposedViewSize, subviews: Subviews) -> [FlowRow] {
        let maxWidth = proposal.width ?? .infinity
        var rows: [FlowRow] = []
        var currentRow = FlowRow()
        
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let nextWidth = currentRow.width + (currentRow.items.isEmpty ? 0 : spacing) + size.width
            
            if nextWidth > maxWidth, !currentRow.items.isEmpty {
                rows.append(currentRow)
                currentRow = FlowRow(y: currentRow.y + currentRow.height + spacing)
            }
            
            let x = currentRow.items.isEmpty ? 0 : currentRow.width + spacing
            currentRow.items.append(FlowItem(index: index, x: x, size: size))
            currentRow.width = x + size.width
            currentRow.height = max(currentRow.height, size.height)
        }
        
        rows.append(currentRow)
        return rows
    }
}

private struct FlowRow {
    var items: [FlowItem] = []
    var width: CGFloat = 0
    var height: CGFloat = 0
    var y: CGFloat = 0
}

private struct FlowItem {
    let index: Int
    let x: CGFloat
    let size: CGSize
}
