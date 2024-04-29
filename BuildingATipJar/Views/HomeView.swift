//
//  HomeView.swift
//  BuildingATipJar
//
//  Created by Tunde Adegoroye on 20/11/2022.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showTips = false
    @State private var showThanks = false

    @EnvironmentObject private var store: TipStore
    
    
    var body: some View {
        VStack {
            
            Button("Tip Me") {
                showTips.toggle()
            }
            .tint(.blue)
            .buttonStyle(.bordered)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            
            if showTips {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        showTips.toggle()
                        
                    }
                TipsView {
                    showTips.toggle()
                }
                .environmentObject(store)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .overlay(alignment: .bottom) {
            if showThanks {
                ThanksView {
                    showThanks = false
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(), value: showTips)
        .animation(.spring(), value: showThanks)
        .onChange(of: store.action) { action in
            if action == .successful {
                showTips = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showThanks = true
                    store.reset()
                }
            }
        }
        .alert(isPresented: $store.hasError, error: store.error) {}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TipStore())
    }
}
