//
//  XWHDeviceFaceView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

class XWHDeviceFaceView: XWHBaseView {

    lazy var bgImageView = UIImageView()
    lazy var imageView = UIImageView()
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(bgImageView)
        addSubview(imageView)
    }
    
    override func relayoutSubViews() {
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
