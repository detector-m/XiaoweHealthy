//
//  XWHCollectionViewBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHCollectionViewBaseVC: XWHBaseVC {
    
    lazy var flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerViews()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = bgColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
                
        view.addSubview(collectionView)
    }
    
    override func setLargeTitleMode() {
        isUseLargeTitleMode = true
        
        // 大标题方式2
        setLargeTitleModeSecond()
    }
    
    /// 设置第二种方式
    final func setLargeTitleModeSecond() {
        collectionView.addSubview(largeTitleView)
        setTopInsetForLargeTitle(in: collectionView)
    }
    
    override func relayoutSubViews() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func relayoutLargeTitle() {
        relayoutLargeTitleSecond()
    }
    
    /// 常用布局
    final func relayoutCommon() {
        // 大标题方式2
        collectionView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitleSecond()
        relayoutLargeTitleContentView()
    }
    
    final func relayoutLargeTitleSecond() {
        largeTitleView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(largeTitleWidth)
            make.top.equalToSuperview().inset(-largeTitleHeight)
            make.height.equalTo(largeTitleHeight)
        }
    }
    
    func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(28)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(28)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    @objc func registerViews() {
        
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
@objc extension XWHCollectionViewBaseVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    // - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return UICollectionReusableView()
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
