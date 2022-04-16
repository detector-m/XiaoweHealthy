//
//  XWHMyDialVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit
import EmptyDataSet_Swift

class XWHMyDialVC: XWHDialContentBaseVC {
    
    lazy var page = 1
    lazy var pageSize = 20
    
    lazy var dials = [XWHDialModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDialsFromServer()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        collectionView.emptyDataSetView { [weak self] emptyView in
            guard let _ = self else {
                return
            }
            
            let detailText = R.string.xwhDialText.暂无表盘您可以到表盘市场添加()
            emptyView.detailLabelString(detailText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16)], toOccurrencesOf: detailText))
        }
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHDialCTCell.self)
    }
    
    func getDialsFromServer() {
        getMyDialFromServer()
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dials.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cWidth = (collectionView.width - 32 - 4) / 3
        return CGSize(width: cWidth.int, height: 154)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cDial = dials[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: XWHDialCTCell.self, for: indexPath)
        
        cell.update(cDial)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cDial = dials[indexPath.item]
        gotoDialDetail(cDial)
    }

}

// MARK: - Api
extension XWHMyDialVC {
    
    private func getMyDialFromServer() {
        XWHProgressHUD.show(title: nil)
        XWHDialVM().getMyDial(deviceSn: deviceSn, page: page, pageSize: pageSize) { [unowned self] error in
            XWHProgressHUD.hide()
            self.view.makeInsetToast(error.message)
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
            
            guard let cDials = response.data as? [XWHDialModel] else {
                self.view.makeInsetToast("数据解析错误")
                return
            }
            
            self.dials = cDials
            self.collectionView.reloadData()
            
            if cDials.isEmpty {
                self.collectionView.reloadEmptyDataSet()
            }
        }
    }
    
}


// MARK: - Jump
extension XWHMyDialVC {
    
    func gotoDialDetail(_ dial: XWHDialModel) {
        let vc = XWHDialDetailVC()
        vc.dial = dial
        vc.deviceSn = deviceSn
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
