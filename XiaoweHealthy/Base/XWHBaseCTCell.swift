//
//  XWHBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/27.
//

import UIKit

class XWHBaseCTCell: UICollectionViewCell {
    
    lazy var imageView = UIImageView()
    lazy var textLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        
    }
    
    func relayoutSubViews() {
        
    }
    
    final func addImageTextView() {
        contentView.addSubview(imageView)
        contentView.addSubview(textLb)
    }
    
    final func addRelayoutTextLb(inset: UIEdgeInsets) {
        textLb.textColor = UIColor(hex: 0x000000, transparency: 0.45)
        textLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        
        contentView.addSubview(textLb)
        
        relayoutTextLb(inset: inset)
    }
    
    private func relayoutTextLb(inset: UIEdgeInsets) {
        textLb.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(inset)
        }
    }
    
}
