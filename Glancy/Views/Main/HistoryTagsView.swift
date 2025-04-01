import SwiftUI

struct HistoryTagsView: View {
    @State private var searchRecords: [SearchRecord] = SearchHistoryManager.shared.fetchSearchRecords()
    var onSelect: (String) -> Void  // 单击时传回选择的词
    
    @State private var showAlert = false
    @State private var recordToDelete: SearchRecord?
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], alignment: .leading, spacing: 8) {
            ForEach(searchRecords, id: \.word) { record in
                Text(record.word)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onTapGesture {
                        // 单击：直接搜索该词
                        onSelect(record.word)
                    }
                    .onLongPressGesture {
                        // 长按：弹出删除对话框
                        recordToDelete = record
                        showAlert = true
                    }
            }
        }
        .padding(.horizontal)
        .onAppear {
            reloadRecords()
        }
        // 监听搜索历史更新通知，实时刷新列表
        .onReceive(NotificationCenter.default.publisher(for: .searchHistoryUpdated)) { _ in
            reloadRecords()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("删除历史记录"),
                message: Text("是否删除 \"\(recordToDelete?.word ?? "")\" ?"),
                primaryButton: .destructive(Text("删除")) {
                    if let record = recordToDelete {
                        SearchHistoryManager.shared.deleteSearchRecord(record)
                        reloadRecords()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func reloadRecords() {
        searchRecords = SearchHistoryManager.shared.fetchSearchRecords()
    }
}
