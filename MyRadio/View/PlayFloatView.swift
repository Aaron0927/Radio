//
//  PlayFloatView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/12/27.
//

import SwiftUI

struct PlayFloatView: View {
    @State private var isPlayed = true
    var radio: Radio = previewRadio()
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: radio.cover_url_small), content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
            }, placeholder: {
                Rectangle()
            })
            .cornerRadius(10)
            
            VStack {
                Text(radio.program_name)
                Text(radio.radio_name)
            }
            Spacer()
            Button {
                isPlayed.toggle()
            } label: {
                Image(systemName: isPlayed ? "pause.fill" : "play.fill")
            }

        }
        .frame(maxWidth: .infinity, idealHeight: 50)
        .background(Color.secondary)
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    PlayFloatView(radio: previewRadio())
}
