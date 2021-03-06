//
//  ColumnRangeBarChartRenderer.swift
//  Charts
//
//  Created by Riven on 2022/5/16.
//

import UIKit

class ColumnRangeBarChartRenderer: LineScatterCandleRadarRenderer {
    
    @objc open weak var dataProvider: ColumnRangeBarChartDataProvider?
    
    @objc public init(dataProvider: ColumnRangeBarChartDataProvider, animator: Animator, viewPortHandler: ViewPortHandler) {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.dataProvider = dataProvider
    }
    
    open override func drawData(context: CGContext) {
        guard let dataProvider = dataProvider, let columnRangeBarData = dataProvider.columnRangeBarData else { return }

        // If we redraw the data, remove and repopulate accessible elements to update label values and frames
        accessibleChartElements.removeAll()

        // Make the chart header the first element in the accessible elements array
        if let chart = dataProvider as? ColumnRangeBarChartView {
            let element = createAccessibleHeader(usingChart: chart,
                                                 andData: columnRangeBarData,
                                                 withDefaultDescription: "ColumnRangeBar Chart")
            accessibleChartElements.append(element)
        }

        for set in columnRangeBarData.dataSets as! [IColumnRangeBarChartDataSet] where set.isVisible
        {
            drawDataSet(context: context, dataSet: set)
        }
    }
    
    private var _shadowPoints = [CGPoint](repeating: CGPoint(), count: 4)
    private var _rangePoints = [CGPoint](repeating: CGPoint(), count: 2)
    private var _openPoints = [CGPoint](repeating: CGPoint(), count: 2)
    private var _closePoints = [CGPoint](repeating: CGPoint(), count: 2)
    private var _bodyRect = CGRect()
    private var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)
    
    @objc open func drawDataSet(context: CGContext, dataSet: IColumnRangeBarChartDataSet)
    {
        guard
            let dataProvider = dataProvider
            else { return }

        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
        
        let phaseY = animator.phaseY
        let barSpace = dataSet.barSpace
        let showCandleBar = dataSet.showCandleBar
        
//        let segmentLimits: [Double] = [20, 30, 40]
//        let segmentColors: [UIColor] = [.green, .blue, .orange, .red]
        
        var segmentLimits = dataSet.segmentLimits
        var segmentColors = dataSet.segmentColors
        
        _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
        
        context.saveGState()
        
        context.setLineWidth(dataSet.shadowWidth)

        for j in _xBounds
        {
            segmentLimits = dataSet.segmentLimits
            segmentColors = dataSet.segmentColors
            
            // get the entry
            guard let e = dataSet.entryForIndex(j) as? ColumnRangeBarChartDataEntry else { continue }
            
            let xPos = e.x
            
            let open = e.open
            let close = e.close
            let high = e.high
            let low = e.low
            
            if !e.segmentLimits.isEmpty {
                segmentLimits = e.segmentLimits
                segmentColors = e.segmentColors
            }
            
            let doesContainMultipleDataSets = (dataProvider.columnRangeBarData?.dataSets.count ?? 1) > 1
            var accessibilityMovementDescription = "neutral"
            var accessibilityRect = CGRect(x: CGFloat(xPos) + 0.5 - barSpace,
                                           y: CGFloat(low * phaseY),
                                           width: (2 * barSpace) - 1.0,
                                           height: (CGFloat(abs(high - low) * phaseY)))
            trans.rectValueToPixel(&accessibilityRect)

            if showCandleBar
            {
                // calculate the shadow
                
                _shadowPoints[0].x = CGFloat(xPos)
                _shadowPoints[1].x = CGFloat(xPos)
                _shadowPoints[2].x = CGFloat(xPos)
                _shadowPoints[3].x = CGFloat(xPos)
                
                if open > close
                {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(open * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = CGFloat(close * phaseY)
                }
                else if open < close
                {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(close * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = CGFloat(open * phaseY)
                }
                else
                {
                    _shadowPoints[0].y = CGFloat(high * phaseY)
                    _shadowPoints[1].y = CGFloat(open * phaseY)
                    _shadowPoints[2].y = CGFloat(low * phaseY)
                    _shadowPoints[3].y = _shadowPoints[1].y
                }
                
                trans.pointValuesToPixel(&_shadowPoints)
                
                // draw the shadows
                
                var shadowColor: NSUIColor! = nil
                if dataSet.shadowColorSameAsCandle
                {
                    if open > close
                    {
                        shadowColor = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
                    }
                    else if open < close
                    {
                        shadowColor = dataSet.increasingColor ?? dataSet.color(atIndex: j)
                    }
                    else
                    {
                        shadowColor = dataSet.neutralColor ?? dataSet.color(atIndex: j)
                    }
                }
                
                if shadowColor === nil
                {
                    shadowColor = dataSet.shadowColor ?? dataSet.color(atIndex: j)
                }
                
                context.setStrokeColor(shadowColor.cgColor)
                context.strokeLineSegments(between: _shadowPoints)
                
                // calculate the body
                
                _bodyRect.origin.x = CGFloat(xPos) - 0.5 + barSpace
                _bodyRect.origin.y = CGFloat(close * phaseY)
                _bodyRect.size.width = (CGFloat(xPos) + 0.5 - barSpace) - _bodyRect.origin.x
                _bodyRect.size.height = CGFloat(open * phaseY) - _bodyRect.origin.y
                
                // ??????
                // ----------
                var segmentRects: [CGRect] = []
                if !segmentLimits.isEmpty {
                    var tRect = CGRect()
                    var iLimit = segmentLimits[0]
                    var preLimit = iLimit
                    tRect.origin.x = _bodyRect.origin.x
                    tRect.origin.y = CGFloat(low * phaseY)
                    tRect.size.width = _bodyRect.size.width
                    if iLimit > low {
                        tRect.size.height = CGFloat(iLimit * phaseY) - tRect.origin.y
                    } else {
                        tRect.size.height = 0
                    }
                    segmentRects.append(tRect)
                    
                    for i in 1 ..< segmentLimits.count {
                        iLimit = segmentLimits[i]
                        tRect.origin.y = CGFloat(preLimit * phaseY)
                        if iLimit > preLimit {
                            tRect.size.height = CGFloat(iLimit * phaseY) - tRect.origin.y
                        } else {
                            tRect.size.height = 0
                        }
                        segmentRects.append(tRect)
                        preLimit = iLimit
                    }
                    
                    iLimit = segmentLimits[segmentLimits.count - 1]
                    tRect.origin.y = CGFloat(iLimit * phaseY)
                    if iLimit < high {
                        tRect.size.height = CGFloat(high * phaseY) - tRect.origin.y
                    } else {
                        tRect.size.height = 0
                    }
                    segmentRects.append(tRect)
                }
                // ----------------
                
                trans.rectValueToPixel(&_bodyRect)
                for i in 0 ..< segmentRects.count {
                    trans.rectValueToPixel(&segmentRects[i])
                }
                
                // draw body differently for increasing and decreasing entry

                if open > close
                {
                    accessibilityMovementDescription = "decreasing"

                    let color = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
                    
                    if dataSet.isDecreasingFilled
                    {
                        context.setFillColor(color.cgColor)
                        if dataSet.shouldRoundCorners {
                            let path = dataSet.roundedPath(for: _bodyRect)
                            path.addClip()
                            context.addPath(path.cgPath)
                            context.fillPath()
                            
                            if !segmentColors.isEmpty, segmentRects.count == segmentColors.count {
                                for i in 0 ..< segmentColors.count {
                                    context.setFillColor(segmentColors[i].cgColor)
                                    context.fill(segmentRects[i])
                                }
                            }
                            
                            context.resetClip()
                        } else {
                            context.fill(_bodyRect)
                        }
                    }
                    else
                    {
                        context.setStrokeColor(color.cgColor)
                        context.stroke(_bodyRect)
                    }
                }
                else if open < close
                {
                    accessibilityMovementDescription = "increasing"

                    let color = dataSet.increasingColor ?? dataSet.color(atIndex: j)
                    
                    if dataSet.isIncreasingFilled
                    {
                        context.setFillColor(color.cgColor)
                        if dataSet.shouldRoundCorners {
                            let path = dataSet.roundedPath(for: _bodyRect)
                            path.addClip()
                            context.addPath(path.cgPath)
                            context.fillPath()
                            
                            if !segmentColors.isEmpty, segmentRects.count == segmentColors.count {
                                for i in 0 ..< segmentColors.count {
                                    context.setFillColor(segmentColors[i].cgColor)
                                    context.fill(segmentRects[i])
                                }
                            }
                            
                            context.resetClip()
                        } else {
                            context.fill(_bodyRect)
                        }
                    }
                    else
                    {
                        context.setStrokeColor(color.cgColor)
                        context.stroke(_bodyRect)
                    }
                }
                else
                {
                    let color = dataSet.neutralColor ?? dataSet.color(atIndex: j)
                    
                    context.setStrokeColor(color.cgColor)
                    context.stroke(_bodyRect)
                }
            }
            else
            {
                _rangePoints[0].x = CGFloat(xPos)
                _rangePoints[0].y = CGFloat(high * phaseY)
                _rangePoints[1].x = CGFloat(xPos)
                _rangePoints[1].y = CGFloat(low * phaseY)

                _openPoints[0].x = CGFloat(xPos) - 0.5 + barSpace
                _openPoints[0].y = CGFloat(open * phaseY)
                _openPoints[1].x = CGFloat(xPos)
                _openPoints[1].y = CGFloat(open * phaseY)

                _closePoints[0].x = CGFloat(xPos) + 0.5 - barSpace
                _closePoints[0].y = CGFloat(close * phaseY)
                _closePoints[1].x = CGFloat(xPos)
                _closePoints[1].y = CGFloat(close * phaseY)
                
                trans.pointValuesToPixel(&_rangePoints)
                trans.pointValuesToPixel(&_openPoints)
                trans.pointValuesToPixel(&_closePoints)
                
                // draw the ranges
                var barColor: NSUIColor! = nil

                if open > close
                {
                    accessibilityMovementDescription = "decreasing"
                    barColor = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
                }
                else if open < close
                {
                    accessibilityMovementDescription = "increasing"
                    barColor = dataSet.increasingColor ?? dataSet.color(atIndex: j)
                }
                else
                {
                    barColor = dataSet.neutralColor ?? dataSet.color(atIndex: j)
                }
                
                context.setStrokeColor(barColor.cgColor)
                context.strokeLineSegments(between: _rangePoints)
                context.strokeLineSegments(between: _openPoints)
                context.strokeLineSegments(between: _closePoints)
            }

            let axElement = createAccessibleElement(withIndex: j,
                                                    container: dataProvider,
                                                    dataSet: dataSet)
            { (element) in
                element.accessibilityLabel = "\(doesContainMultipleDataSets ? "\(dataSet.label ?? "Dataset")" : "") " + "\(xPos) - \(accessibilityMovementDescription). low: \(low), high: \(high), opening: \(open), closing: \(close)"
                element.accessibilityFrame = accessibilityRect
            }

            accessibleChartElements.append(axElement)

        }

        // Post this notification to let VoiceOver account for the redrawn frames
        accessibilityPostLayoutChangedNotification()

        context.restoreGState()
    }
    
    open override func drawValues(context: CGContext)
    {
        guard
            let dataProvider = dataProvider,
            let columnRangeBarData = dataProvider.columnRangeBarData
            else { return }
        
        // if values are drawn
        if isDrawingValuesAllowed(dataProvider: dataProvider)
        {
            let dataSets = columnRangeBarData.dataSets
            
            let phaseY = animator.phaseY
            
            var pt = CGPoint()
            
            for i in 0 ..< dataSets.count
            {
                guard let
                    dataSet = dataSets[i] as? IBarLineScatterCandleBubbleChartDataSet,
                    shouldDrawValues(forDataSet: dataSet)
                    else { continue }
                
                let valueFont = dataSet.valueFont
                
                guard let formatter = dataSet.valueFormatter else { continue }
                
                let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
                let valueToPixelMatrix = trans.valueToPixelMatrix
                
                let iconsOffset = dataSet.iconsOffset
                
                _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
                
                let lineHeight = valueFont.lineHeight
                let yOffset: CGFloat = lineHeight + 5.0
                
                for j in _xBounds
                {
                    guard let e = dataSet.entryForIndex(j) as? ColumnRangeBarChartDataEntry else { break }
                    
                    pt.x = CGFloat(e.x)
                    pt.y = CGFloat(e.high * phaseY)
                    pt = pt.applying(valueToPixelMatrix)
                    
                    if (!viewPortHandler.isInBoundsRight(pt.x))
                    {
                        break
                    }
                    
                    if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                    {
                        continue
                    }
                    
                    if dataSet.isDrawValuesEnabled
                    {
                        ChartUtils.drawText(
                            context: context,
                            text: formatter.stringForValue(
                                e.high,
                                entry: e,
                                dataSetIndex: i,
                                viewPortHandler: viewPortHandler),
                            point: CGPoint(
                                x: pt.x,
                                y: pt.y - yOffset),
                            align: .center,
                            attributes: [NSAttributedString.Key.font: valueFont, NSAttributedString.Key.foregroundColor: dataSet.valueTextColorAt(j)])
                    }
                    
                    if let icon = e.icon, dataSet.isDrawIconsEnabled
                    {
                        ChartUtils.drawImage(context: context,
                                             image: icon,
                                             x: pt.x + iconsOffset.x,
                                             y: pt.y + iconsOffset.y,
                                             size: icon.size)
                    }
                }
            }
        }
    }
    
    open override func drawExtras(context: CGContext)
    {
    }
    
    open override func drawHighlighted(context: CGContext, indices: [Highlight])
    {
        guard
            let dataProvider = dataProvider,
            let columnRangeBarData = dataProvider.columnRangeBarData
            else { return }
        
        context.saveGState()
        
        for high in indices
        {
            guard
                let set = columnRangeBarData.getDataSetByIndex(high.dataSetIndex) as? IColumnRangeBarChartDataSet,
                set.isHighlightEnabled
                else { continue }
            
            guard let e = set.entryForXValue(high.x, closestToY: high.y) as? ColumnRangeBarChartDataEntry else { continue }
            
            if !isInBoundsX(entry: e, dataSet: set)
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
            
            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)
            
            if set.highlightLineDashLengths != nil
            {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
//            let lowValue = e.low * Double(animator.phaseY)
            let highValue = e.high * Double(animator.phaseY)
//            let y = (lowValue + highValue) / 2.0
            let y = highValue
            
            let pt = trans.pixelForValues(x: e.x, y: y)
            
            high.setDraw(pt: pt)
            
            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
        }
        
        context.restoreGState()
    }

    private func createAccessibleElement(withIndex idx: Int,
                                         container: ColumnRangeBarChartDataProvider,
                                         dataSet: IColumnRangeBarChartDataSet,
                                         modifier: (NSUIAccessibilityElement) -> ()) -> NSUIAccessibilityElement {

        let element = NSUIAccessibilityElement(accessibilityContainer: container)

        // The modifier allows changing of traits and frame depending on highlight, rotation, etc
        modifier(element)

        return element
    }
}

extension IColumnRangeBarChartDataSet {
  
    var shouldRoundCorners: Bool { !roundedCorners.isEmpty }
    
    func roundedPath(for barRect: CGRect) -> UIBezierPath {
        let cornerRadius: CGFloat = barRect.width / 2
        let bezierPath = UIBezierPath(
            roundedRect: barRect,
            byRoundingCorners: roundedCorners,
            cornerRadii: CGSize(width:cornerRadius, height: cornerRadius)
        )
        
        return bezierPath
    }
    
}
