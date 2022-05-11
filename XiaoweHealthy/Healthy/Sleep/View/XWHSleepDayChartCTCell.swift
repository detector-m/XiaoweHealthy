//
//  XWHSleepDayChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit
import AAInfographics

class XWHSleepDayChartCTCell: XWHHealthyChartBaseCTCell {
    
    lazy var aaChartView = AAChartView()
    
    lazy var legendView = XWHChartLegendView()
    
    override func addSubViews() {
        super.addSubViews()
        
        isHorizontal = false
        gradientColors = [UIColor(hex: 0xE5E6FF)!, UIColor(hex: 0xffffff)!]
        
        contentView.addSubview(legendView)
        
        aaChartView.scrollEnabled = false
        aaChartView.delegate = self
        aaChartView.aa_adaptiveScreenRotation()
        aaChartView.isClearBackgroundColor = true
        aaChartView.translatesAutoresizingMaskIntoConstraints = false
        aaChartView.scrollView.contentInsetAdjustmentBehavior = .never
        contentView.addSubview(aaChartView)
        
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
        
        aaChartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(90)
            make.height.equalTo(230)
        }
    }
    
    func update(legendTitles: [String], legendColors: [UIColor], sleepUIModel: XWHHealthySleepUISleepModel?) {
        textLb.text = XWHUIDisplayHandler.getSleepDurationString(sleepUIModel?.totalSleepDuration ?? 0)
        let dateStr = sleepUIModel?.riseTime.date(withFormat: XWHDate.standardTimeAllFormat)?.localizedString(withFormat: XWHDate.monthDayFormat) ?? ""
        detailLb.text = "\(dateStr) \(R.string.xwhHealthyText.睡眠总时长())"
        
        updateChart(sleepUIModel)
        
        legendView.update(titles: legendTitles, colors: legendColors)
    }
    
    private func updateChart(_ sleepUIModel: XWHHealthySleepUISleepModel?) {
        guard let sleepUIModel = sleepUIModel else {
            return
        }

        let aaChartModel = AAChartModel()
        aaChartModel.chartType(.columnrange).animationDuration(0).legendEnabled(false).xAxisVisible(true).yAxisVisible(true)
        aaChartModel.categories(["", "", ""]).dataLabelsEnabled(false)
        aaChartModel.yAxisMin(0).yAxisMax(sleepUIModel.totalSleepDuration.cgFloat)
        aaChartModel.xAxisTickInterval = 1
        aaChartModel.xAxisLabelsEnabled = false
        aaChartModel.xAxisGridLineWidth(1)
        aaChartModel.yAxisGridLineWidth(0)
        aaChartModel.stacking(.normal)
        // x 轴是否垂直翻转
        aaChartModel.inverted(true)
        aaChartModel.backgroundColor(AAColor.clear)
        aaChartModel.series(XWHHealthyChartDataHandler.getSleepDayChartData(sleepUIModel))
        
        let aaOptions = aaChartModel.aa_toAAOptions()
        aaOptions.plotOptions?.columnrange?.pointPadding(0).pointPlacement(0).groupPadding(0)
        aaOptions.xAxis?.min(0).lineWidth(0)
//        aaOptions.yAxis?
        aaOptions.chart?.spacingLeft(16).spacingRight(16).spacingBottom(2)
        
        var yAxisLb = [String](repeating: "", count: sleepUIModel.totalSleepDuration + 1)
        yAxisLb[0] = sleepUIModel.bedTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
        yAxisLb[sleepUIModel.totalSleepDuration] = sleepUIModel.riseTime.date(withFormat: XWHDate.standardTimeAllFormat)?.string(withFormat: XWHDate.hourMinuteFormat) ?? ""
        
        let aaStyle = AAStyle()
        aaStyle.color(fontDarkColor.withAlphaComponent(0.35).alphaHexString).fontSize(10).fontWeight(AAChartFontWeightType.regular)
        let aaLable = AALabels()
        aaLable.step(1).style(aaStyle)
        
        aaOptions.yAxis?.tickInterval(1).labels(aaLable).categories(yAxisLb)
        
        aaChartView.aa_drawChartWithChartOptions(aaOptions)
    }
    
}

extension XWHSleepDayChartCTCell: AAChartViewDelegate {
    
    func aaChartViewDidFinishLoad (_ aaChartView: AAChartView) {
//        log.debug("🚀🚀🚀AAChartView did finished load")
    }
    
    func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        
    }

    
}
