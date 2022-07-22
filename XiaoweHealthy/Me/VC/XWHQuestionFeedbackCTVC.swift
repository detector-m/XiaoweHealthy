//
//  XWHQuestionFeedbackCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit

class XWHQuestionFeedbackCTVC: XWHCollectionViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var topContentInset: CGFloat {
        66
    }
    
    override var titleText: String {
        "意见反馈"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)
        
//        let leftItem = getNavItem(text: titleText, font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
//        navigationItem.leftBarButtonItem = leftItem
        
        navigationItem.title = titleText
        
//        setNavHidden(false, animated: true, async: false)
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.title = ""
        
//        setNavHidden(true, animated: true, async: false)
    }
    
    override func addSubViews() {
        super.addSubViews()

        setLargeTitleMode()

        largeTitleView.titleLb.text = titleText
        
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
    
    override func relayoutSubViews() {
        collectionView.snp.remakeConstraints { make in
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
        collectionView.register(cellWithClass: XWHQuestionTagCTCell.self)
        collectionView.register(cellWithClass: XWHQuestionTextViewCTCell.self)
        
        collectionView.register(cellWithClass: XWHQuestionSubmitCTCell.self)
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension XWHQuestionFeedbackCTVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return 1
        }
    }
    
    // - UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.width, height: 86)
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.width, height: 227)
        } else if indexPath.section == 2 {
            return CGSize(width: 73, height: 73)
        } else {
            return CGSize(width: collectionView.width, height: 202)
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
//        let row = indexPath.row
        
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionTagCTCell.self, for: indexPath)
            
            return cell
        } else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionTextViewCTCell.self, for: indexPath)
            
            return cell
        } else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionTextViewCTCell.self, for: indexPath)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionSubmitCTCell.self, for: indexPath)
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
