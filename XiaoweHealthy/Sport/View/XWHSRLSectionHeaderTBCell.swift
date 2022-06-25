//
//  XWHSRLSectionHeaderTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import UIKit

class XWHSRLSectionHeaderTBCell: XWHExpandBaseTBCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        
        set {
            var newFrame = newValue
            newFrame.origin.x = 16
            newFrame.size.width -= 32
            
            super.frame = newFrame
        }
    }

    override func addSubViews() {
        super.addSubViews()
    }
    
    override func relayoutSubViews() {
        super.relayoutSubViews()
    }

}
