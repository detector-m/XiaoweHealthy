//
//  XWHHealthCardEditTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/10.
//

import UIKit


/// 编辑健康卡片控制器
class XWHHealthCardEditTBVC: XWHTableViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var titleText: String {
        R.string.xwhHealthyText.编辑卡片()
    }
    
    private let cardMsg = XWHHealthCardManager()
    
    private var cards: [XWHHealthCardModel] = []
    
    private var showCards: [XWHHealthCardModel] {
        cards.filter({ !$0.isHidden })
    }
    private var hideCards: [XWHHealthCardModel] {
        cards.filter({ $0.isHidden })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = XWHDataUserManager.getCurrentUser()?.mobile ?? ""
        cards = cardMsg.loadCards(userId: userId)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)

        navigationItem.title = titleText
        
//        setNavHidden(false, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    @objc private func clickNavLeftItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.title = nil
        
//        setNavHidden(true, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        
        setLargeTitleMode()
        
        tableView.backgroundColor = view.backgroundColor
        tableView.backgroundColor = tableView.backgroundColor
        tableView.separatorStyle = .none
        
        tableView.dragInteractionEnabled = true

        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        largeTitleView.titleLb.text = titleText
    }
    
    override func relayoutSubViews() {
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitle()
        relayoutLargeTitleContentView()
    }
    
    override func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(12)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(12)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHHealthCardEditTBCell.self)
        tableView.register(headerFooterViewClassWith: XWHHealthCardEditTBHeader.self)
        
        tableView.register(cellWithClass: XWHHealthCardEditEmptyTBCell.self)
    }

}


// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHHealthCardEditTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cards.isEmpty {
            return 0
        }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == 0 {
            count = showCards.count
        } else {
            count = hideCards.count
        }
        
        if count == 0 {
            return 1
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if showCards.isEmpty {
                return 100
            }
        } else {
            if hideCards.isEmpty {
                return 100
            }
        }
        return 64 + 13
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let s = indexPath.section
        let r = indexPath.row
        
        if s == 0 {
            if showCards.isEmpty {
                let cell = tableView.dequeueReusableCell(withClass: XWHHealthCardEditEmptyTBCell.self, for: indexPath)
                cell.update(isHidden: false)
                return cell
            }
        } else {
            if hideCards.isEmpty {
                let cell = tableView.dequeueReusableCell(withClass: XWHHealthCardEditEmptyTBCell.self, for: indexPath)
                cell.update(isHidden: true)
                return cell
            }
        }
        
        var iCard: XWHHealthCardModel
        let cell = tableView.dequeueReusableCell(withClass: XWHHealthCardEditTBCell.self, for: indexPath)
        
        if s == 0 {
            iCard = showCards[r]
            cell.subIconView.image = R.image.cardHiddenIcon()
        } else {
            iCard = hideCards[r]
            cell.subIconView.image = R.image.cardShowIcon()
        }
        
        switch iCard.cardType {
        case .heart:
            cell.iconView.image = R.image.heartIcon()
            cell.titleLb.text = R.string.xwhHealthyText.心率()
            
        case .sleep:
            cell.iconView.image = R.image.sleepIcon()
            cell.titleLb.text = R.string.xwhHealthyText.睡眠()
            
        case .bloodOxygen:
//            cell.iconView.image = R.image.sleepIcon()
            cell.iconView.backgroundColor = UIColor(hex: 0x6CD267)
            cell.iconView.image = R.image.deviceOxygen()
            cell.titleLb.text = R.string.xwhHealthyText.血氧饱和度()
            
        case .mentalStress:
            cell.iconView.image = R.image.stressIcon()
            cell.titleLb.text = R.string.xwhHealthyText.压力()
            
        case .mood:
            cell.iconView.image = R.image.moodIcon()
            cell.titleLb.text = R.string.xwhHealthyText.情绪()
            
        default:
            cell.iconView.image = nil
            cell.titleLb.text = nil
        }
        
        return cell
    }
    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withClass: XWHHealthCardEditTBHeader.self)
        
        var hText: NSAttributedString
        if section == 0 {
            let t1 = R.string.xwhHealthyText.显示()
            let t2 = R.string.xwhHealthyText.长按拖动卡片以调整顺序()
            let text = t1 + t2
            
            hText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)], toOccurrencesOf: t1).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12, weight: .regular), .foregroundColor: fontDarkColor.withAlphaComponent(0.35)], toOccurrencesOf: t2)
        } else {
            let text = R.string.xwhHealthyText.隐藏的卡片()
            hText = text.colored(with: fontDarkColor.withAlphaComponent(0.35)).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)], toOccurrencesOf: text)
        }
        
        header.titleLb.attributedText = hText
        
        return header
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cView = UIView()
        cView.backgroundColor = collectionBgColor

        return cView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cShowCards = showCards
        var cHideCards = hideCards
        if indexPath.section == 0 {
            if showCards.isEmpty {
                return
            }
            let iCard = showCards[indexPath.row]
            iCard.isHidden = true
            
            cShowCards.removeFirst(where: { $0 === iCard })
            cHideCards.append(iCard)
        } else {
            if hideCards.isEmpty {
                return
            }
            
            let iCard = hideCards[indexPath.row]
            iCard.isHidden = false
            
            cHideCards.removeFirst(where: { $0 === iCard })
            cShowCards.append(iCard)
        }
        
        cards = cShowCards + cHideCards
        let userId = XWHDataUserManager.getCurrentUser()?.mobile ?? ""
        cardMsg.saveCards(userId: userId, cards: cards)
//        cards = cardMsg.loadCards(userId: userId)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        }
        
        return true
    }
    
    // 实现委托(delegate)方法以实际重新排列基础数据源。
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: sourceIndexPath)
//        cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        if sourceIndexPath.section != 0 || destinationIndexPath.section != 0 {
            return
        }
        objc_sync_enter(self)
        let iCard = showCards[sourceIndexPath.row]

        var cShowCards = showCards
        cShowCards.remove(at: sourceIndexPath.row)
        cShowCards.insert(iCard, at: destinationIndexPath.row)
        
        cards = cShowCards + hideCards
        
        let userId = XWHDataUserManager.getCurrentUser()?.mobile ?? ""
        cardMsg.saveCards(userId: userId, cards: cards)
        
        tableView.reloadData()
        
        objc_sync_exit(self)
    }
    
}

// MARK: - UITableViewDragDelegate & UITableViewDropDelegate
extension XWHHealthCardEditTBVC: UITableViewDragDelegate & UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section == 1 {
            return []
        }
        
        let cItem = UIDragItem(itemProvider: NSItemProvider(object: UIImage()))
        return [cItem]
    }
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

        let preView = UIDragPreviewParameters()
        preView.backgroundColor = .clear
        
        return preView
    }
    
//    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
//
//    }
    
//    func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }

    // MARK: - UITableViewDropDelegate
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        if let indexPath = coordinator.items.first?.sourceIndexPath {
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let preView = UIDragPreviewParameters()

        preView.backgroundColor = .clear
        return preView
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        let dropProposal: UITableViewDropProposal

        if destinationIndexPath?.section == 0 {
            dropProposal = UITableViewDropProposal(operation: .move, intent: UITableViewDropProposal.Intent.insertAtDestinationIndexPath)
        } else {
            dropProposal = UITableViewDropProposal(operation: .forbidden, intent: UITableViewDropProposal.Intent.insertAtDestinationIndexPath)
        }

        return dropProposal
    }
    
}
