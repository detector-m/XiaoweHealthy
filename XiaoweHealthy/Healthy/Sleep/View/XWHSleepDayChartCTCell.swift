//
//  XWHSleepDayChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit
//import AAInfographics

class XWHSleepDayChartCTCell: XWHHealthyChartBaseCTCell {
    
//    private lazy var chartView = AAChartView()
    
//    lazy var chartView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    lazy var legendView = XWHChartLegendView()
    
    private var uiModel: XWHHealthySleepUISleepModel?
    
    private var chartView = UIView()
    private var awakeViews: [UIView] = []
    private var lightViews: [UIView] = []
    private var deepViews: [UIView] = []
    
    private lazy var leftLine = UIView()
    private lazy var rightLine = UIView()
    private lazy var topLine = UIView()
    
    private lazy var awakeLine = UIView()
    private lazy var lightLine = UIView()
    private lazy var deepLine = UIView()
    
    private lazy var bTimeLb = UILabel()
    private lazy var eTimeLb = UILabel()
    
    private lazy var awakeItems: [XWHHealthySleepUISleepItemModel] = []
    private lazy var lightItems: [XWHHealthySleepUISleepItemModel] = []
    private lazy var deepItems: [XWHHealthySleepUISleepItemModel] = []
    
    private lazy var markerView = XWHMarkerView()
//    private var leftConstraint: ConstraintMakerEditable?
    
    weak var tapedView: UIView?
    
    private lazy var sum = 0
    private lazy var chartViewWidth: CGFloat = {
        UIScreen.main.bounds.width - (18 + 12) * 2
    }()
    
    override func addSubViews() {
        super.addSubViews()
        
        isHorizontal = false
        gradientColors = [UIColor(hex: 0xE5E6FF)!, UIColor(hex: 0xffffff)!]
        
        contentView.addSubview(legendView)
        
        markerView.isHidden = true
        contentView.addSubview(markerView)
        
//        configChartView()
//        contentView.addSubview(chartView)
        
        chartView.isHidden = true
        contentView.addSubview(chartView)
            
        let lineColor = UIColor.black.withAlphaComponent(0.05)
        topLine.backgroundColor = lineColor
        leftLine.backgroundColor = lineColor
        rightLine.backgroundColor = lineColor
        awakeLine.backgroundColor = lineColor
        lightLine.backgroundColor = lineColor
        deepLine.backgroundColor = lineColor

        contentView.addSubview(topLine)
        contentView.addSubview(leftLine)
        contentView.addSubview(rightLine)
        contentView.addSubview(awakeLine)
        contentView.addSubview(lightLine)
        contentView.addSubview(deepLine)
        
        let timeColor = fontDarkColor.withAlphaComponent(0.35)
        let timeFont = XWHFont.harmonyOSSans(ofSize: 10)
        bTimeLb.font = timeFont
        bTimeLb.textColor = timeColor
        contentView.addSubview(bTimeLb)
        
        eTimeLb.font = timeFont
        eTimeLb.textColor = timeColor
        contentView.addSubview(eTimeLb)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        textLb.textColor = fontDarkColor
        textLb.textAlignment = .left
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.textAlignment = .left
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(16)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.height.equalTo(16)
        }
        
        legendView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
//        chartView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(12)
//            make.height.equalTo(72)
//        }
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(90)
            make.height.equalTo(215)
        }
        
        markerView.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.top.equalToSuperview().offset(12)
//            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(chartView)
        }
        
        topLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(chartView)
            make.left.right.equalTo(chartView)
        }
        leftLine.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(chartView)
            make.width.equalTo(0.5)
        }
        
        rightLine.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(chartView)
            make.width.equalTo(0.5)
        }
        
        awakeLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(chartView).offset(72)
            make.left.right.equalTo(chartView)
        }
        
        lightLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(chartView).offset(72 * 2)
            make.left.right.equalTo(chartView)
        }
        
        deepLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(chartView).offset(72 * 3)
            make.left.right.equalTo(chartView)
        }
        
        bTimeLb.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.left.equalTo(chartView)
            make.height.equalTo(14)
            make.width.lessThanOrEqualTo(120)
        }
        eTimeLb.snp.makeConstraints { make in
            make.top.height.width.equalTo(bTimeLb)
            make.right.equalTo(chartView)
        }
    }
    
    private func configChartView() {
        
    }
    
    func update(legendTitles: [String], legendColors: [UIColor], sleepUIModel: XWHHealthySleepUISleepModel?) {
        uiModel = sleepUIModel
        
        textLb.text = XWHUIDisplayHandler.getSleepDurationString(sleepUIModel?.totalSleepDuration ?? 0)
        let dateStr = sleepUIModel?.riseTime.date(withFormat: XWHDate.standardTimeAllFormat)?.localizedString(withFormat: XWHDate.monthDayFormat) ?? ""
        detailLb.text = "\(dateStr) \(R.string.xwhHealthyText.睡眠总时长())"
        
        updateChart(sleepUIModel)
        
        legendView.update(titles: legendTitles, colors: legendColors)
    }
    
    private func updateChart(_ sleepUIModel: XWHHealthySleepUISleepModel?) {
        awakeViews.forEach({ $0.removeFromSuperview() })
        deepViews.forEach({ $0.removeFromSuperview() })
        lightViews.forEach({ $0.removeFromSuperview() })
        
        awakeViews.removeAll()
        deepViews.removeAll()
        lightViews.removeAll()
        
        awakeItems.removeAll()
        lightItems.removeAll()
        deepItems.removeAll()
        
        guard let sleepUIModel = sleepUIModel else {
            return
        }
        
        bTimeLb.text = sleepUIModel.bedTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
        eTimeLb.text = sleepUIModel.riseTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
        
        sum = 0
        for iItem in sleepUIModel.items {
            iItem.sleepOffset = sum
            sum += iItem.duration
            
            if iItem.sleepStatus == 0 {
                deepItems.append(iItem)
            } else if iItem.sleepStatus == 1 {
                lightItems.append(iItem)
            } else {
                awakeItems.append(iItem)
            }
        }
        
        if sum == 0 {
            sum = 1
        }
        for (i, iItem) in awakeItems.enumerated() {
            let cView = getSleepStateView(item: iItem, tag: i, color: XWHHealthySleepState.awake.color, action: #selector(clickAwakeView(_:)), top: 90)
            
            contentView.addSubview(cView)
            awakeViews.append(cView)
        }
        
        for (i, iItem) in lightItems.enumerated() {
            let cView = getSleepStateView(item: iItem, tag: i, color: XWHHealthySleepState.light.color, action: #selector(clickLightView(_:)), top: 90 + 72)
            
            contentView.addSubview(cView)
            lightViews.append(cView)
        }
        
        for (i, iItem) in deepItems.enumerated() {
            let cView = getSleepStateView(item: iItem, tag: i, color: XWHHealthySleepState.deep.color, action: #selector(clickDeepView(_:)), top: 90 + 72 * 2)
            
            contentView.addSubview(cView)
            deepViews.append(cView)
        }

        // AAChartView
//        updateAAChartView(sleepUIModel: sleepUIModel)
    }
    
    @objc private func clickAwakeView(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        let iItem = awakeItems[tag]
        
        showMarker(iItem, sender.view!)
    }
    
    @objc private func clickLightView(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        let iItem = lightItems[tag]
        
        showMarker(iItem, sender.view!)
    }
    
    @objc private func clickDeepView(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        let iItem = deepItems[tag]
        
        showMarker(iItem, sender.view!)
    }
    
    private func getSleepStateView(item: XWHHealthySleepUISleepItemModel, tag: Int, color: UIColor, action: Selector, top: CGFloat) -> UIView {
        let cView = UIView()
        cView.tag = tag
        cView.backgroundColor = color
        let tapGes = UITapGestureRecognizer()
        tapGes.addTarget(self, action: action)
        cView.addGestureRecognizer(tapGes)
        
        let offsetRate = item.sleepOffset.cgFloat / sum.cgFloat
        let widthRate = item.duration.cgFloat / sum.cgFloat
        
        cView.frame = CGRect(x: offsetRate * chartViewWidth + 12, y: top, width: widthRate * chartViewWidth, height: 72)
        
        return cView
    }
    
    private func showMarker(_ item: XWHHealthySleepUISleepItemModel, _ inView: UIView) {
        if tapedView == inView {
            tapedView = nil
            markerView.isHidden = true
            
            return
        }
        
        tapedView = inView
        
        let valueStr = XWHUIDisplayHandler.getSleepDurationString(item.duration)
        let sState = XWHHealthySleepState(item.sleepStatus)
        let bTimeStr = item.startTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
        let eTimeStr = item.endTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""

        let tipStr = sState.name + " " + bTimeStr + "-" + eTimeStr
        
        markerView.textLb.text = valueStr
        markerView.detailLb.text = tipStr
        markerView.isHidden = false
        
        let viewCenterX = inView.center.x
        let markerWidthHalf = markerView.width / 2
        
        let cMin = viewCenterX - markerWidthHalf
        let cMax = viewCenterX + markerWidthHalf
        
        var cValue: CGFloat = 0
        var lineOffset: CGFloat = 0
        if cMin <= 0 {
            cValue = 0
            lineOffset = cMin
        } else if cMax >= self.width {
            cValue = self.width - markerWidthHalf * 2
            lineOffset = cMax - self.width
        } else {
            cValue = cMin
        }
        
        markerView.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(cValue)
        }
        markerView.lineView.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(lineOffset)
        }
    }
    
}


//extension XWHSleepDayChartCTCell: AAChartViewDelegate {
//
//    private func configAAChartView() {
//        chartView.scrollEnabled = false
//        chartView.delegate = self
//        chartView.aa_adaptiveScreenRotation()
//        chartView.isClearBackgroundColor = true
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        chartView.scrollView.contentInsetAdjustmentBehavior = .never
//    }
//
//    private func updateAAChartView(sleepUIModel: XWHHealthySleepUISleepModel) {
//        let aaChartModel = AAChartModel()
//        aaChartModel.chartType(.columnrange).animationDuration(0).legendEnabled(false).xAxisVisible(true).yAxisVisible(true)
//        aaChartModel.categories(["", "", ""]).dataLabelsEnabled(false)
//        aaChartModel.yAxisMin(0).yAxisMax(sleepUIModel.totalSleepDuration.cgFloat)
//        aaChartModel.xAxisTickInterval = 1
//        aaChartModel.xAxisLabelsEnabled = false
//        aaChartModel.xAxisGridLineWidth(1)
//        aaChartModel.yAxisGridLineWidth(0)
//        aaChartModel.stacking(.normal)
//        // x 轴是否垂直翻转
//        aaChartModel.inverted(true)
//        aaChartModel.backgroundColor(AAColor.clear)
//        aaChartModel.series(XWHHealthyChartDataHandler.getSleepDayChartData(sleepUIModel))
//
//        let aaOptions = aaChartModel.aa_toAAOptions()
//        aaOptions.plotOptions?.columnrange?.pointPadding(0).pointPlacement(0).groupPadding(0)
//        aaOptions.xAxis?.min(0).lineWidth(0)
////        aaOptions.yAxis?
//        aaOptions.chart?.spacingLeft(16).spacingRight(16).spacingBottom(2)
//
//        var yAxisLb = [String](repeating: "", count: sleepUIModel.totalSleepDuration + 1)
//        yAxisLb[0] = sleepUIModel.bedTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
//        yAxisLb[sleepUIModel.totalSleepDuration] = sleepUIModel.riseTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
//
//        let aaStyle = AAStyle()
//        aaStyle.color(fontDarkColor.withAlphaComponent(0.35).alphaHexString).fontSize(10).fontWeight(AAChartFontWeightType.regular)
//        let aaLable = AALabels()
//        aaLable.step(1).style(aaStyle)
//
//        aaOptions.yAxis?.tickInterval(1).labels(aaLable).categories(yAxisLb)
//
//        chartView.aa_drawChartWithChartOptions(aaOptions)
//    }
//
//    func aaChartViewDidFinishLoad (_ aaChartView: AAChartView) {
////        log.debug("🚀🚀🚀AAChartView did finished load")
//    }
//
//    func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
//
//    }
//
//}
