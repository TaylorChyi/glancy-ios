//
//  LanguageSettingView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import SwiftUI

struct LanguageSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selected: [LanguageCode] = LanguagePreferenceManager.shared.load()

    let allLanguages = Language.allLanguages

    var body: some View {
        List {
            ForEach(allLanguages) { lang in
                HStack {
                    Text("\(lang.flag) \(lang.name)")
                    Spacer()
                    if selected.contains(lang.code) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleSelection(lang.code)
                }
            }
        }
        .navigationTitle("语言偏好设置")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") {
                    LanguagePreferenceManager.shared.save(selected)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    private func toggleSelection(_ code: LanguageCode) {
        if selected.contains(code) {
            if selected.count > 1 {
                selected.removeAll { $0 == code }
            }
        } else {
            if selected.count < 3 {
                selected.append(code)
            }
        }
    }
}
