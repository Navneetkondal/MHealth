//// 	 
//	Extension + Image.swift
//	MHealth
//
//	Created By Navneet on 29/12/24
//


import Foundation
import SwiftUI

extension Image {
    @MainActor func getUIImage() -> UIImage? {
        return ImageRenderer(content: self).uiImage
    }
    
    init(isSytemImg: Bool = false, img: MImageStringEnum, bundle: Bundle = .main) {
        if isSytemImg{
            self.init(systemName: img.rawValue)
        }else{
            self.init(img.rawValue, bundle: bundle)
        }
    }
    
    init(systemImg: MImageStringEnum) {
        self.init(systemName:  systemImg.rawValue)
    }
}
