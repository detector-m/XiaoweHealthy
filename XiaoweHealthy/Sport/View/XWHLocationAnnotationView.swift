//
//  XWHLocationAnnotationView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/8.
//

import UIKit

class XWHLocationAnnotationView: MAAnnotationView {
    
    lazy var textLb = UILabel()

    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        textLb.frame = CGRect(x: 4, y: 4, width: 22, height: 22)
        
        addSubview(textLb)
        
        imageView.contentMode = .center
    
        textLb.font = XWHFont.harmonyOSSans(ofSize: 10)
        textLb.textColor = .white
        textLb.textAlignment = .center
        textLb.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLb.center = imageView.center
    }
    
}
