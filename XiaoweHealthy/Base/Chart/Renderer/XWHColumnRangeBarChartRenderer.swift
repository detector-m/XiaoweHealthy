//
//  XWHColumnRangeBarChartRenderer.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/14.
//

import UIKit
import Charts

class XWHColumnRangeBarChartRenderer: CandleStickChartRenderer {
    
}

//class XWHColumnRangeBarChartRenderer: CandleStickChartRenderer {
//    
//    internal var _xBounds = XBounds() // Reusable XBounds object
//    
//    private var _shadowPoints = [CGPoint](repeating: CGPoint(), count: 4)
//    private var _rangePoints = [CGPoint](repeating: CGPoint(), count: 2)
//    private var _openPoints = [CGPoint](repeating: CGPoint(), count: 2)
//    private var _closePoints = [CGPoint](repeating: CGPoint(), count: 2)
//    private var _bodyRect = CGRect()
//    private var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)
//    
//    override func drawDataSet(context: CGContext, dataSet: ICandleChartDataSet) {
//        guard
//            let dataProvider = dataProvider
//            else { return }
//
//        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
//        
//        let phaseY = animator.phaseY
//        let barSpace = dataSet.barSpace
//        let showCandleBar = dataSet.showCandleBar
//        
//        _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
//        
//        context.saveGState()
//        
//        context.setLineWidth(dataSet.shadowWidth)
//
//        for j in _xBounds
//        {
//            // get the entry
//            guard let e = dataSet.entryForIndex(j) as? CandleChartDataEntry else { continue }
//            
//            let xPos = e.x
//            
//            let open = e.open
//            let close = e.close
//            let high = e.high
//            let low = e.low
//            
//            let doesContainMultipleDataSets = (dataProvider.candleData?.dataSets.count ?? 1) > 1
//            var accessibilityMovementDescription = "neutral"
//            var accessibilityRect = CGRect(x: CGFloat(xPos) + 0.5 - barSpace,
//                                           y: CGFloat(low * phaseY),
//                                           width: (2 * barSpace) - 1.0,
//                                           height: (CGFloat(abs(high - low) * phaseY)))
//            trans.rectValueToPixel(&accessibilityRect)
//
//            if showCandleBar
//            {
//                // calculate the shadow
//                
//                _shadowPoints[0].x = CGFloat(xPos)
//                _shadowPoints[1].x = CGFloat(xPos)
//                _shadowPoints[2].x = CGFloat(xPos)
//                _shadowPoints[3].x = CGFloat(xPos)
//                
//                if open > close
//                {
//                    _shadowPoints[0].y = CGFloat(high * phaseY)
//                    _shadowPoints[1].y = CGFloat(open * phaseY)
//                    _shadowPoints[2].y = CGFloat(low * phaseY)
//                    _shadowPoints[3].y = CGFloat(close * phaseY)
//                }
//                else if open < close
//                {
//                    _shadowPoints[0].y = CGFloat(high * phaseY)
//                    _shadowPoints[1].y = CGFloat(close * phaseY)
//                    _shadowPoints[2].y = CGFloat(low * phaseY)
//                    _shadowPoints[3].y = CGFloat(open * phaseY)
//                }
//                else
//                {
//                    _shadowPoints[0].y = CGFloat(high * phaseY)
//                    _shadowPoints[1].y = CGFloat(open * phaseY)
//                    _shadowPoints[2].y = CGFloat(low * phaseY)
//                    _shadowPoints[3].y = _shadowPoints[1].y
//                }
//                
//                trans.pointValuesToPixel(&_shadowPoints)
//                
//                // draw the shadows
//                
//                var shadowColor: NSUIColor! = nil
//                if dataSet.shadowColorSameAsCandle
//                {
//                    if open > close
//                    {
//                        shadowColor = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
//                    }
//                    else if open < close
//                    {
//                        shadowColor = dataSet.increasingColor ?? dataSet.color(atIndex: j)
//                    }
//                    else
//                    {
//                        shadowColor = dataSet.neutralColor ?? dataSet.color(atIndex: j)
//                    }
//                }
//                
//                if shadowColor === nil
//                {
//                    shadowColor = dataSet.shadowColor ?? dataSet.color(atIndex: j)
//                }
//                
//                context.setStrokeColor(shadowColor.cgColor)
//                context.strokeLineSegments(between: _shadowPoints)
//                
//                // calculate the body
//                
//                _bodyRect.origin.x = CGFloat(xPos) - 0.5 + barSpace
//                _bodyRect.origin.y = CGFloat(close * phaseY)
//                _bodyRect.size.width = (CGFloat(xPos) + 0.5 - barSpace) - _bodyRect.origin.x
//                _bodyRect.size.height = CGFloat(open * phaseY) - _bodyRect.origin.y
//                
//                trans.rectValueToPixel(&_bodyRect)
//                
//                // draw body differently for increasing and decreasing entry
//
//                if open > close
//                {
//                    accessibilityMovementDescription = "decreasing"
//
//                    let color = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
//                    
//                    if dataSet.isDecreasingFilled
//                    {
//                        context.setFillColor(color.cgColor)
//                        context.fill(_bodyRect)
//                    }
//                    else
//                    {
//                        context.setStrokeColor(color.cgColor)
//                        context.stroke(_bodyRect)
//                    }
//                }
//                else if open < close
//                {
//                    accessibilityMovementDescription = "increasing"
//
//                    let color = dataSet.increasingColor ?? dataSet.color(atIndex: j)
//                    
//                    if dataSet.isIncreasingFilled
//                    {
//                        context.setFillColor(color.cgColor)
//                        context.fill(_bodyRect)
//                    }
//                    else
//                    {
//                        context.setStrokeColor(color.cgColor)
//                        context.stroke(_bodyRect)
//                    }
//                }
//                else
//                {
//                    let color = dataSet.neutralColor ?? dataSet.color(atIndex: j)
//                    
//                    context.setStrokeColor(color.cgColor)
//                    context.stroke(_bodyRect)
//                }
//            }
//            else
//            {
//                _rangePoints[0].x = CGFloat(xPos)
//                _rangePoints[0].y = CGFloat(high * phaseY)
//                _rangePoints[1].x = CGFloat(xPos)
//                _rangePoints[1].y = CGFloat(low * phaseY)
//
//                _openPoints[0].x = CGFloat(xPos) - 0.5 + barSpace
//                _openPoints[0].y = CGFloat(open * phaseY)
//                _openPoints[1].x = CGFloat(xPos)
//                _openPoints[1].y = CGFloat(open * phaseY)
//
//                _closePoints[0].x = CGFloat(xPos) + 0.5 - barSpace
//                _closePoints[0].y = CGFloat(close * phaseY)
//                _closePoints[1].x = CGFloat(xPos)
//                _closePoints[1].y = CGFloat(close * phaseY)
//                
//                trans.pointValuesToPixel(&_rangePoints)
//                trans.pointValuesToPixel(&_openPoints)
//                trans.pointValuesToPixel(&_closePoints)
//                
//                // draw the ranges
//                var barColor: NSUIColor! = nil
//
//                if open > close
//                {
//                    accessibilityMovementDescription = "decreasing"
//                    barColor = dataSet.decreasingColor ?? dataSet.color(atIndex: j)
//                }
//                else if open < close
//                {
//                    accessibilityMovementDescription = "increasing"
//                    barColor = dataSet.increasingColor ?? dataSet.color(atIndex: j)
//                }
//                else
//                {
//                    barColor = dataSet.neutralColor ?? dataSet.color(atIndex: j)
//                }
//                
//                context.setStrokeColor(barColor.cgColor)
//                context.strokeLineSegments(between: _rangePoints)
//                context.strokeLineSegments(between: _openPoints)
//                context.strokeLineSegments(between: _closePoints)
//            }
//
//            let axElement = createAccessibleElement(withIndex: j,
//                                                    container: dataProvider,
//                                                    dataSet: dataSet)
//            { (element) in
//                element.accessibilityLabel = "\(doesContainMultipleDataSets ? "\(dataSet.label ?? "Dataset")" : "") " + "\(xPos) - \(accessibilityMovementDescription). low: \(low), high: \(high), opening: \(open), closing: \(close)"
//                element.accessibilityFrame = accessibilityRect
//            }
//
//            let chartViewBase = dataProvider as? ChartViewBase
//            var cAccessibleChartElements = chartViewBase?.accessibilityChildren()
//            cAccessibleChartElements?.append(axElement)
////             accessibleChartElements.append(axElement)
//
//        }
//
//        // Post this notification to let VoiceOver account for the redrawn frames
//        accessibilityPostLayoutChangedNotification()
//
//        context.restoreGState()
//    }
//    
//    private func createAccessibleElement(withIndex idx: Int,
//                                         container: CandleChartDataProvider,
//                                         dataSet: ICandleChartDataSet,
//                                         modifier: (NSUIAccessibilityElement) -> ()) -> NSUIAccessibilityElement {
//
//        let element = NSUIAccessibilityElement(accessibilityContainer: container)
//
//        // The modifier allows changing of traits and frame depending on highlight, rotation, etc
//        modifier(element)
//
//        return element
//    }
//
//}
//
//internal func accessibilityPostLayoutChangedNotification(withElement element: Any? = nil)
//{
//    UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: element)
//}
