//
//  RadioCell.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/3/7.
//

import SwiftUI

struct RadioCell: View {
    var radio: Radio
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: radio.cover_url_small)) { image in
                image
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(radio.radio_name)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(hex: "#171C26"))
                Text(radio.program_name)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .foregroundStyle(Color(hex: "#171C26"))
                    .opacity(0.7)
            }
            Spacer()
        }
    }
}

#Preview {
    RadioCell(radio: previewRadio())
}
