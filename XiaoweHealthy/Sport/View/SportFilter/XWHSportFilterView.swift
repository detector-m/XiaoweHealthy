//
//  XWHSportFilterView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import Foundation

class XWHPopupSportFilter {
    
    class func show(pickItems: [String], sIndex: Int, action: ((XWHAlertContentView.ActionType, Int) -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow!
        let popupPick = XWHPopupSportFilterView(frame: window.bounds)
        window.addSubview(popupPick)

        popupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned popupPick] cType in
            if let contentView = popupPick.contentView as? XWHPopupSportFilterContentView {
                action?(cType, contentView.sIndex)
            }
        }
    }
    
}


class XWHPopupSportFilterView: RLPopupBaseView {

    private lazy var _contentView = XWHPopupSportFilterContentView()
    
    override var contentView: RLPopupContentBaseView {
        _contentView
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentView.layer.masksToBounds = true
        
        overlayView.addTarget(self, action: #selector(backgroundViewClicked), for: .touchUpInside)
    }
    
    func show(pickItems: [String], sIndex: Int, action: ((RLPopupContentBaseView.ActionType) -> Void)? = nil) {
        clickCallback = action
        _contentView.pickItems = pickItems
        _contentView.sIndex = sIndex
        _contentView.clickCallback = { [weak self] actionType in
            self?.clickCallback?(actionType)
            
            self?.hideAnimation()
        }
        
        _contentView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(232 + 44 + safeAreaInsets.top + 24)
        }
        
        _contentView.relayoutSubViews(topInset: safeAreaInsets.top)
        
        layoutIfNeeded()
        contentCenterY = _contentView.center.y
        
        showAnimation()
    }
    
    @objc func backgroundViewClicked() {
        clickCallback?(.cancel)
    }
    
}

class XWHPopupSportFilterContentView: RLPopupContentBaseView, UITableViewDelegate & UITableViewDataSource {
    
    lazy var titleBtn = UIButton()

    lazy var tableView = UITableView()
    
    private(set) lazy var closeImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowUp.rawValue, size: 16, color: fontDarkColor)
    
    lazy var pickItems = [String]()
    lazy var sIndex: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(titleBtn)
        configTitleBtn()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        addSubview(tableView)
        
        tableView.register(cellWithClass: XWHSportFilterTBCell.self)
        
        confirmBtn.isHidden = true
        cancelBtn.isHidden = true
    }
    
    private func configTitleBtn() {
        titleBtn.frame = CGRect(x: 0, y: 0, width: 160, height: 44)
        titleBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .medium)
        titleBtn.setTitleColor(fontDarkColor, for: .normal)
        titleBtn.set(image: closeImage, title: R.string.xwhSportText.所有运动(), titlePosition: .left, additionalSpacing: 5, state: .normal)
        titleBtn.addTarget(self, action: #selector(clickTitleBtn), for: .touchUpInside)
    }
    
    @objc private func clickTitleBtn() {
        clickCancelBtn()
    }
    
    override func relayoutSubViews() {
        
    }
    
    func relayoutSubViews(topInset: CGFloat) {
        titleBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(topInset)
            make.width.equalTo(160)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(topInset + 44 + 12)
            make.height.equalTo(232)
        }
    }

    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHSportFilterTBCell.self)
        cell.titleLb.text = pickItems[indexPath.row]
        if sIndex == indexPath.row {
            cell.titleLb.textColor = btnBgColor
        } else {
            cell.titleLb.textColor = fontDarkColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sIndex = indexPath.row
        
        clickCallback?(.confirm)
    }
    
}

class XWHSportFilterTBCell: XWHBaseTBCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        iconView.isHidden = true
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.8)
        titleLb.textAlignment = .center
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
}
