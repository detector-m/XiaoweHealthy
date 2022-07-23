//
//  XWHPersonInfoTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit
import LEEAlert
import SKPhotoBrowser
import HXPHPicker

class XWHPersonInfoTBVC: XWHTableViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var topContentInset: CGFloat {
        66
    }
    
    override var titleText: String {
        R.string.xwhDisplayText.基本信息()
    }
    
    lazy var tbFooter = XWHTBButtonFooter(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 160)))
    
    lazy var userModel: XWHUserModel = {
        var user: XWHUserModel = XWHUserModel()
        if let cUser = XWHUserDataManager.getCurrentUser() {
            user = cUser
        }
        
        return user
    }()

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
        
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = collectionBgColor
        
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = tbFooter
        tbFooter.button.setTitle(R.string.xwhDisplayText.保存(), for: .normal)
        DispatchQueue.main.async { [unowned self] in
            self.tbFooter.relayoutSubViews(leftRightInset: 12, bottomInset: 40, height: 50)
        }
        tbFooter.clickCallback = { [unowned self] in
            self.updatePersonInfo()
        }
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
        tableView.register(cellWithClass: XWHPersonAvatarTBCell.self)

        tableView.register(cellWithClass: XWHPersonInfoTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHPersonInfoTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 153
        }
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHPersonAvatarTBCell.self, for: indexPath)
            
            cell.iconView.kf.setImage(with: userModel.avatar.url, placeholder: R.image.sport_avatar())
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: XWHPersonInfoTBCell.self, for: indexPath)
        
        cell.bottomLine.isHidden = false
        if indexPath.row == 0 { // 昵称
            cell.titleLb.text = "昵称"
            cell.subTitleLb.text = userModel.nickname
        } else if indexPath.row == 1 { // 性别
            cell.titleLb.text = "性别"
            cell.subTitleLb.text = userModel.genderType.name
        } else if indexPath.row == 2 { // 身高
            cell.titleLb.text = "身高"
            cell.subTitleLb.text = userModel.height.string + "CM"
        } else if indexPath.row == 3 { // 体重
            cell.titleLb.text = "体重"
            cell.subTitleLb.text = userModel.weight.string + "KG"
        } else if indexPath.row == 4 { // 出生年份
            cell.titleLb.text = "出生年份"
            cell.subTitleLb.text = userModel.birthday
            cell.bottomLine.isHidden = true
        }
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       if indexPath.section == 0 {
           return
       }
       rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 头像
        if indexPath.section == 0 {
            gotoAvatarActionSheet()
            return
        }
        
        if indexPath.row == 0 { // 昵称
            gotoSetNickname()
        } else if indexPath.row == 1 { // 性别
            gotoSelectGender()
        } else if indexPath.row == 2 { // 身高
            gotoSelectHeight()
        } else if indexPath.row == 3 { // 体重
            gotoSelectWeight()
        } else if indexPath.row == 4 { // 出生年份
            gotoSelectBirthday()
        }
    }
    
}

extension XWHPersonInfoTBVC: PhotoPickerControllerDelegate {
    
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
            guard let cImage = pickedImages.first else {
                return
            }
            self.uploadImage(image: cImage)
        }
    }
    
    /// Called when cancel is clicked
    /// - Parameter pickerController: Corresponding PhotoPickerController
    func pickerController(didCancel pickerController: PhotoPickerController) {
        
    }
    
}

extension XWHPersonInfoTBVC: CameraControllerDelegate {
    
    func cameraController(
        _ cameraController: CameraController,
        didFinishWithResult result: CameraController.Result,
        location: CLLocation?) {
        cameraController.dismiss(animated: true) { [unowned self] in
            switch result {
            case .image(let image):
                self.uploadImage(image: image)
                
            case .video(_):
                break
            }
        }
    }
    
}


// MARK: - UI Jump
extension XWHPersonInfoTBVC {
    
    /// 头像
    private func gotoAvatarActionSheet() {
        let aSheet = LEEAlert.actionsheet()
        let aSheetConfig = aSheet.config
        let _ = aSheetConfig.leeAddAction { [unowned self] action in
            self.configSheetAction(action)
            action.title = "拍照"
            action.clickBlock = {
                self.gotoTakePhoto()
            }
        }
        let _ = aSheetConfig.leeAddAction { [unowned self] action in
            self.configSheetAction(action)
            action.title = "相册"
            
            action.clickBlock = {
                self.gotoPickPhoto()
            }
        }
        
        if !userModel.avatar.isEmpty {
            let _ = aSheetConfig.leeAddAction { [unowned self] action in
                self.configSheetAction(action)
                action.title = "浏览大图"
                
                action.clickBlock = {
                    self.gotoShowFullAvatar()
                }
            }
        }
        
        let _ = aSheetConfig.leeAddAction { [unowned self] action in
            self.configSheetAction(action)
            
            action.type = .cancel
            action.borderColor = .clear
            action.height = 78
            action.title = "取消"
        }
        
        let _ = aSheetConfig.leeShow()
    }
    
    private func configSheetAction(_ action: LEEAction) {
        action.type = .default
        action.height = 60
        action.borderColor = UIColor(hex: 0x979797).withAlphaComponent(0.15)
        action.insets = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        action.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        action.titleColor = fontDarkColor
        action.backgroundHighlightColor = .white
    }
    
    /// 去拍照
    private func gotoTakePhoto() {
        let config = CameraConfiguration()
        config.position = .front
        config.sessionPreset = .hd1280x720
        config.appearanceStyle = .varied
        config.shouldAutorotate = false
        config.takePhotoMode = .click
        config.photoEditor.state = .cropping
        config.photoEditor.fixedCropState = true
        config.photoEditor.cropping.fixedRatio = true
        config.photoEditor.cropping.aspectRatioType = .ratio_1x1
        config.photoEditor.cropping.maskType = .blackColor
        config.photoFilters = []
        config.videoFilters = []
        config.photoEditor.toolView.toolOptions.removeAll(where: { $0.type != .cropSize })
        
        let camerController = CameraController(config: config, type: .photo)
        camerController.autoDismiss = false
        camerController.cameraDelegate = self
        camerController.modalPresentationStyle = .fullScreen
        
        present(camerController, animated: true, completion: nil)
    }
    
    /// 去相册
    private func gotoPickPhoto() {
        // 设置与微信主题一致的配置
        let config = PhotoTools.getWXPickerConfig()
        config.photoList.allowAddCamera = false
        config.allowSelectedTogether = false
        config.selectMode = .single
        config.maximumSelectedCount = 1
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
    private func gotoShowFullAvatar() {
        if userModel.avatar.isEmpty {
            return
        }
        
        let photo = SKPhoto.photoWithImageURL(userModel.avatar)
        let pb = SKPhotoBrowser(photos: [photo])
        present(pb, animated: true)
    }
    
    /// 设置昵称
    private func gotoSetNickname() {
        XWHEditNicknamePopupView.show(nickname: userModel.nickname) { [weak self] cNickname in
            guard let self = self else {
                return
            }
            
            self.userModel.nickname = cNickname
            self.tableView.reloadData()
        }
    }
    
    /// 选择性别
    private func gotoSelectGender() {
//        let vc = XWHGenderSelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.gender = cUserModel.gender
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickGenderPopupView.showPickGender(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.gender = cUserModel.gender
            self.tableView.reloadData()
        }
    }
    
    /// 选择身高
    private func gotoSelectHeight() {
//        let vc = XWHHeightSelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.height = cUserModel.height
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickHeightPopupView.showPickHeight(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.height = cUserModel.height
            self.tableView.reloadData()
        }
    }
    
    /// 选择体重
    private func gotoSelectWeight() {
//        let vc = XWHWeightSelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.weight = cUserModel.weight
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickWeightPopupView.showPickWeight(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.weight = cUserModel.weight
            self.tableView.reloadData()
        }
    }
    
    /// 选择出生
    private func gotoSelectBirthday() {
//        let vc = XWHBirthdaySelectVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.birthday = cUserModel.birthday
//            self?.tableView.reloadData()
//        }
//
//        navigationController?.pushViewController(vc, animated: true)
        
        XWHPickBirthdayPopupView.showPickBirthday(userModel: userModel) { [weak self] cUserModel in
            guard let self = self else {
                return
            }
            
            self.userModel.birthday = cUserModel.birthday
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - UI Jump & Api
extension XWHPersonInfoTBVC {
    
    /// 更新用户信息
    private func updatePersonInfo() {
        XWHUserVM().update(userModel: userModel)
        XWHUserDataManager.saveUser(&userModel)
    }
    
    /// 上传图片
    private func uploadImage(image: UIImage) {
        XWHProgressHUD.show(title: "上传图片中...")
        getOssStsToken { [weak self] cModel in
            guard let self = self else {
                return
            }
            
//            DispatchQueue.main.async {
                guard let cModel = cModel else {
                    XWHProgressHUD.hide()
                    self.view.makeInsetToast("上传图片失败")
                    return
                }

                guard let ossClient = AliyunUploadManager.createCredential(with: cModel) else {
                    XWHProgressHUD.hide()
                    self.view.makeInsetToast("上传图片成功")
                    return
                }
                AliyunUploadManager.uploadImages([image], client: ossClient, bucketName: "xiaowe-ycyoss", documentPath: "avatars") { json in
                    DispatchQueue.main.async {
                        XWHProgressHUD.hide()

                        guard let cAvatar = json.first else {
                            self.view.makeInsetToast("上传图片成功")
                            return
                        }
                        self.userModel.avatar = cAvatar
                        self.view.makeInsetToast("上传图片成功")
                        self.tableView.reloadData()
                    }
                } failure: { eString in
                    log.error("上传头像图片失败 error = \(eString)")

                    DispatchQueue.main.async {
                        XWHProgressHUD.hide()

                        XWHProgressHUD.hide()

                        self.view.makeInsetToast("上传图片失败")
                    }
                }
//            }
        }
    }
    
    /// 获取图片零时token
    private func getOssStsToken(completion: @escaping (AliyunCredentialModel?) -> Void) {
        AppImageUploadManager.getOssStsToken { [weak self] error in
            log.error("上传图片失败 \(error)")
            guard let _ = self else {
                return
            }
            
            completion(nil)
        } successHandler: { [weak self] response in
            guard let _ = self else {
                return
            }
            
            guard let credentialModel = response.data as? AliyunCredentialModel else {
                log.error("上传图片失败, 获取的 AliyunCredentialModel 为空")
                completion(nil)
                return
            }
            
            completion(credentialModel)
        }
    }
    
}
