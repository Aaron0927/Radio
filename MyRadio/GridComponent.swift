//
//  GridComponent.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/8/20.
//

import SwiftUI

struct GridComponent: View {
    private var symbols = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private var gridItemLayout = [
        GridItem.init(.flexible(), spacing: 0, alignment: .center),
        GridItem.init(.flexible(), spacing: 0, alignment: .center),
        GridItem.init(.flexible(), spacing: 0, alignment: .center),
    ]
    
    var width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    ForEach((0...28), id: \.self) {item in
                        HStack{
                            VStack(alignment:.leading, spacing: 10){
                                Text("广东")
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .font(.headline)
                                Text("东莞综合广播FM100")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(.body)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 20, leading: 5, bottom: 5, trailing: 5))
                            .foregroundColor(.white)
                        }
                        .frame(width:((self.width - 20 * 2.0) / 3.0),height:100)
                        .background {
                            Color(hex: "#242324")
                        }
                        .padding(0)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color(hex: "#3e3e40"), lineWidth: 1)
                        )
                    }
                    .shadow(color: Color(hex: "#3e3e40"), radius: 3)
                }
            }
        }
        .background {
            Color(hex: "#3e3e40")
        }
    }
}

struct GridComponent_Previews: PreviewProvider {
    static var previews: some View {
        GridComponent()
    }
}
