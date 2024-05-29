//
//  CardView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2024/1/14.
//

import SwiftUI

struct CardView: View {
    var radio: Radio
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: radio.cover_url_small)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } placeholder: {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.red)
            }

            
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(radio.radio_name)
                        .font(.title3)
                    HStack {
                        Image(systemName: "pause")
                            .frame(width: 15)
                        Text("正在直播:\(radio.program_name)")
                    }
                    .font(.callout)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    HStack {
                        Image(systemName: "headphones")
                            .frame(width: 15)
                        Text("收听人数:\(radio.radio_play_count)")
                        Text("内容由喜马拉雅APP提供")
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                Spacer()
                Divider()
            }
            Spacer()
        }
        .frame(height: 80)
        .padding(.vertical, 5)
    }
}

#Preview {
    CardView(radio: previewRadio())
}
