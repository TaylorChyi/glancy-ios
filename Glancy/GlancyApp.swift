//
//  GlancyApp.swift
//  Glancy
//
//  Created by 齐天乐 on 2025/3/27.
//

import SwiftUI

import LeanCloud

@main
struct GlancyApp: App {
    init() {
        guard let path = Bundle.main.path(forResource: "LeanCloudConfig", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let appId = dict["LC_APP_ID"] as? String,
              let appKey = dict["LC_APP_KEY"] as? String else {
            fatalError("❌ 无法加载 LeanCloud 配置信息")
        }

        do {
            try LCApplication.default.set(
                id: appId,
                key: appKey,
                serverURL: "https://\(appId).lc-cn-n1-shared.com"
            )
        } catch {
            print("⚠️ LeanCloud 初始化失败：\(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
