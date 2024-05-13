//
//  RadioCardView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/4.
//

import SwiftUI

struct RadioCardView: View {
    var body: some View {
        HStack {
            Image("test_1")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            VStack(alignment: .leading, spacing: 10) {
                Text("京津冀之声")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                HStack {
                    Image(systemName: "waveform")
                    Text("正在直播：音乐爱上我")
                }
                .font(.system(size: 12))
                .foregroundStyle(Color.init(hex: "#171C26"))
                .opacity(0.7)
            }
            
            Spacer()
        }
        .padding(15)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5, x: 0, y: 5)
    }
}

#Preview {
    RadioCardView()
}
