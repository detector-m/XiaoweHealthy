//
//  XWHAddBrandDeviceVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import UIKit
import Kingfisher

class XWHAddBrandDeviceVC: XWHDeviceBaseVC, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    fileprivate lazy var flowLayout = UICollectionViewFlowLayout()
    fileprivate lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    fileprivate lazy var dataSource = [XWHDeviceProductModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDeviceList()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.添加设备()
        detailLb.text = nil
        detailLb.isHidden = true
        
        let itemWidth = (UIScreen.main.bounds.width - 12 * 3) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 46)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = bgColor
        
        collectionView.register(cellWithClass: XWHAddBrandDeviceCTCell.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: XWHBaseCTCell.self)
        view.addSubview(collectionView)
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(94)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return 3
//        }
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productModel = dataSource[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withClass: XWHAddBrandDeviceCTCell.self, for: indexPath)
        
//        cell.imageView.image = R.image.devicePlaceholder()
        cell.imageView.kf.setImage(with: URL(string: productModel.cover))
        
        let tColor = UIColor(hex: 0x2A2A2A)!
        let txt1 = productModel.brand
        let txt2 = productModel.mode
        let attr = "\(txt1) \(txt2)".colored(with: tColor).applying(attributes: [.font: XWHFont.skSans(ofSize: 13, weight: .bold)], toOccurrencesOf: txt1).applying(attributes: [.font: XWHFont.skSans(ofSize: 13, weight: .regular)], toOccurrencesOf: txt2)
        
        cell.textLb.attributedText = attr
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: XWHBaseCTCell.self, for: indexPath)
            
            header.addRelayoutTextLb(inset: UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28))
            header.textLb.text = R.string.xwhDeviceText.创维智能手表()
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productModel = dataSource[indexPath.item]

        gotoSearchDevice(productModel: productModel)
    }

}

// MARK: - Api
extension XWHAddBrandDeviceVC {
    
    fileprivate func getDeviceList() {
        XWHProgressHUD.show()
//        view.makeToastActivity(.center)
        XWHDeviceVM().list { [unowned self] error in
            XWHProgressHUD.hide()
//            self.view.hideToastActivity()
            self.view.makeInsetToast(error.message)
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hide()
//            self.view.hideToastActivity()
            
            if let cDevice = response.data as? [XWHDeviceProductModel] {
                self.dataSource = cDevice
                self.reloadUIData()
            } else {
                self.view.makeInsetToast("产品信息有误")
            }
        }
    }
    
}

// MARK: - UI
extension XWHAddBrandDeviceVC {
    
    fileprivate func reloadUIData() {
        collectionView.reloadData()
    }
    
}

// MARK: - UI Jump
extension XWHAddBrandDeviceVC {
    
    fileprivate func gotoSearchDevice(productModel: XWHDeviceProductModel) {
        let watchModel = XWHDevWatchModel()
        watchModel.category = .watch
        let typeStr = productModel.brand + " " + productModel.mode
        watchModel.type = XWHDeviceType(rawValue: typeStr) ?? .none
        
        if watchModel.type == .none {
            view.makeInsetToast("产品的型号不对")
            return
        }
        
        let vc = XWHSearchDeviceVC()
        vc.watchModel = watchModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
