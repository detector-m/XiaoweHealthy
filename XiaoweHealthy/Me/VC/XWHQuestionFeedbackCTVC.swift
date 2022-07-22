//
//  XWHQuestionFeedbackCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/22.
//

import UIKit
import HXPHPicker
import SKPhotoBrowser

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
    
    private lazy var imageUrls = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUrls = ["https://img0.baidu.com/it/u=1880899726,3824907986&fm=253&fmt=auto&app=138&f=JPEG?w=750&h=500", "https://img0.baidu.com/it/u=3798217922,3880088897&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1658595600&t=20e62f15b577273597305d00cf94b4b2", "https://img2.baidu.com/it/u=1792249350,650626052&fm=253&app=120&size=w931&n=0&f=JPEG&fmt=auto?sec=1658595600&t=dcadebca8a30f1ae7811954b0d85f338"]
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
        
        collectionView.register(cellWithClass: XWHQuestionImageCTCell.self)
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
            return imageUrls.count + 1
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
        let row = indexPath.row
        
        if section == 0 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionTagCTCell.self, for: indexPath)
            
            return cell
        } else if section == 1 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionTextViewCTCell.self, for: indexPath)
            
            return cell
        } else if section == 2 {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionImageCTCell.self, for: indexPath)
            
            if row == imageUrls.count {
                cell.update(imageUrl: "")
            } else {
                cell.update(imageUrl: imageUrls[row])
            }
            cell.clickCallback = { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.imageUrls.remove(at: row)
                self.collectionView.reloadData()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withClass: XWHQuestionSubmitCTCell.self, for: indexPath)
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section != 2 {
            return
        }
        
        if row == imageUrls.count {
            if imageUrls.count == 3 {
                view.makeInsetToast("最多只能上传3张")
                return
            }
            gotoPickPhoto()
        } else {
            gotoShowImages(row)
        }
    }
    
}

extension XWHQuestionFeedbackCTVC: PhotoPickerControllerDelegate {
    
    /// Called after the selection is complete
    /// - Parameters:
    ///   - pickerController: corresponding PhotoPickerController
    ///   - result: Selected result
    ///     result.photoAssets  Selected asset array
    ///     result.isOriginal   Whether to select the original image
    func pickerController(_ pickerController: PhotoPickerController,
                            didFinishSelection result: PickerResult) {
//        result.getImage { (image, photoAsset, index) in
//
//        } completionHandler: { (images) in
//            print(images)
//        }
        result.getImage { [unowned self] pickedImages in
//            self.pickedImage = pickedImages.first
//            self.tableView.reloadData()
        }
    }
    
    /// Called when cancel is clicked
    /// - Parameter pickerController: Corresponding PhotoPickerController
    func pickerController(didCancel pickerController: PhotoPickerController) {
        
    }
    
}

extension XWHQuestionFeedbackCTVC {
    
    /// 去相册
    private func gotoPickPhoto() {
        // 设置与微信主题一致的配置
        let config = PhotoTools.getWXPickerConfig()
        config.photoList.allowAddCamera = false
        config.allowSelectedTogether = false
        config.selectMode = .single
        config.maximumSelectedCount = 3 - imageUrls.count
        config.selectOptions = [.photo]
        config.photoList.cancelType = .text
        config.editorOptions = [.photo]
        config.photoSelectionTapAction = .openEditor
        
        config.photoEditor.state = .cropping
        config.photoEditor.fixedCropState = true
        config.photoEditor.cropping.fixedRatio = true
        config.photoEditor.cropping.aspectRatioType = .ratio_1x1
        config.photoEditor.cropping.maskType = .blackColor
        config.photoEditor.toolView.toolOptions.removeAll(where: { $0.type != .cropSize })

        
        let pickerController = PhotoPickerController(picker: config)
        pickerController.pickerDelegate = self
        // 是否选中原图
        pickerController.isOriginal = true
        present(pickerController, animated: true, completion: nil)
    }
    
    /// 浏览大图
    private func gotoShowImages(_ at: Int) {
        SKPhotoBrowserOptions.displayAction = false
        
        var photos: [SKPhoto] = []
        for iImageUrl in imageUrls {
            let photo = SKPhoto.photoWithImageURL(iImageUrl)
            photos.append(photo)
        }
        
        let pb = SKPhotoBrowser(photos: photos)
        pb.currentPageIndex = at
        present(pb, animated: true)
    }
    
}
