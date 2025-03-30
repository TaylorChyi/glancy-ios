//
//  SettingsView.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/28.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var preferences = LanguagePreference.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("选择语言倾向（最多3个）")) {
                    ForEach(Language.allLanguages) { lang in
                        HStack {
                            Text(lang.name)
                            Spacer()
                            if preferences.isSelected(lang) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            preferences.toggle(lang)
                        }
                    }
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        preferences.save()
                        dismiss()
                    }
                }
            }
        }
    }
}
