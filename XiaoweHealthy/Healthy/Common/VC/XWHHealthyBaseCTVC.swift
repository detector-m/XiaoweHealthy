//
//  XWHHealthyBaseCTVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit

class XWHHealthyBaseCTVC: XWHCollectionViewBaseVC {
    
    lazy var dateSegment = XWHDateSegmentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateSegment.segmentValueChangedHandler = { [unowned self] dateSegmentType in
            self.dateSegmentValueChanged(dateSegmentType)
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(dateSegment)
    }
    
    override func relayoutSubViews() {
        relayoutDateSegment()
    }
    
    @objc final func relayoutDateSegment() {
        dateSegment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(120)
            make.height.equalTo(32)
        }
    }
    
    func dateSegmentValueChanged(_ segmentType: XWHHealthDateSegmentType) {
        
    }

}
