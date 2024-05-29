//
//  RadioListView.swift
//  MyRadio
//
//  Created by xiaoerlong on 2023/10/16.
//

import SwiftUI

struct RadioListView: View {
    var category_id: Int = 0
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.radios) { radio in
                    NavigationLink {
                        PlayView(viewModel: PlayViewModel(radio: radio))
                    } label: {
                        VStack {
                            AsyncImage(url: URL(string: radio.cover_url_small)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Rectangle()
                            }
                            .frame(width: 100, height: 100)
                            .background(.red)
                            .cornerRadius(5)
                            Text(radio.radio_name)
                        }
                    }
                }
            }
            .navigationTitle("Radio List")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.getRadiosList(in: category_id)
        }
    }
}

struct RadioListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CategoryViewModel()
        viewModel.radios = previewRadios()
        return RadioListView(category_id: 1, viewModel: viewModel)
    }
}
