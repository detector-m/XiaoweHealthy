//
//  XWHMyDialVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHMyDialVC: XWHDialContentBaseVC {
    
    lazy var page = 1
    lazy var pageSize = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDialsFromServer()
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHDialCTCell.self)
    }
    
    func getDialsFromServer() {
        getMyDialFromServer()
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cWidth = (collectionView.width - 32 - 4) / 3
        return CGSize(width: cWidth.int, height: 154)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: XWHDialCTCell.self, for: indexPath)
        
        cell.imageView.image = R.image.devicePlaceholder()
        cell.textLb.text = "index \(indexPath.item)"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gotoDialDetail()
    }

}

// MARK: - Api
extension XWHMyDialVC {
    
    private func getMyDialFromServer() {
        XWHProgressHUD.show(title: nil)
        XWHDialVM().getMyDial(deviceSn: "1923190012204123456", page: page, pageSize: pageSize) { [unowned self] error in
            XWHProgressHUD.hide()
            self.view.makeInsetToast(error.message)
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
        }
    }
    
}


// MARK: - Jump
extension XWHMyDialVC {
    
    func gotoDialDetail() {
        let vc = XWHDialDetailVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
