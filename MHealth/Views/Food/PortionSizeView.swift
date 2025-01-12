//// 	 
//	PortionSizeView.swift
//	MHealth
//
//	Created By Altametrics on 12/01/25
//	

//	Hubworks: https://www.hubworks.com
//


import SwiftUI

struct PortionSizeView: View {
    var body: some View {
        VStack(alignment:.center){
            HStack{
                Text("Serving size")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold14.font)
                Text("100g")
                    .foregroundColor(Color.darkGray4)
                    .font(MFontConstant.semiBold14.font)
            }
            
            Divider()
                .frame(height: 3)
                .foregroundStyle(.mlabel)
                .padding(.top, 5)
            Text("Amount per serving")
                 

            HStack{
                Text("Calories")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold18.font)
                Text("157")
                    .foregroundColor(Color.darkGray4)
                    .font(MFontConstant.semiBold18.font)
            }
            
            Divider()
                .frame(height: 0.5)
            
            HStack{
                Text("")
                    .foregroundColor(Color.mlabel)
                    .font(MFontConstant.semiBold18.font)
                Text("157")
                    .foregroundColor(Color.darkGray4)
                    .font(MFontConstant.semiBold18.font)
            }
            
            
        }
    }
}

#Preview {
    PortionSizeView()
}
