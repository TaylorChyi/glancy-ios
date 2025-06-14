<p align="center">
  <img src="icon.jpg" alt="Glancy App Icon" width="150" style="border-radius: 50%;"/>
</p>

- [🇬🇧 English Version](../README.md)
- [🇨🇳 中文版](README_zh.md)
- [🇯🇵 日本語版](README_ja.md)

# Glancy

Glancy 是一款高级多语言词典应用，旨在为用户提供快速、准确的翻译和例句展示。凭借直观的界面和先进的语言处理能力，Glancy 帮助语言学习者、专业人士及日常用户无缝探索多种语言中的单词和短语。

## 概述

Glancy 提供：
- **多语言翻译：** 支持最多三种语言的精准翻译及上下文例句展示。
- **高级搜索：** 使用位于屏幕底部的输入栏（内嵌发送按钮）进行快速查词。
- **个性化语言设置：** 从预设列表中选择您的偏好语言，这些选择将决定主界面显示的语言按钮及查询时返回的翻译种类。
- **云端同步体验：** 通过安全的云服务，同步保存您的查询历史、收藏和设置，实现跨设备一致体验。
- **用户管理：** 提供无缝注册、登录和个人信息管理，支持匿名使用或专属账号。

## 工作原理

1. **智能查询：**
   当您搜索单词时，Glancy 会首先在云数据库中查找缓存的释义，如有命中则直接显示；否则，调用先进的语言引擎获取翻译和例句，并保存到云端。
2. **直观界面：**
   主界面展示可切换的语言按钮、清晰的查询结果区域，以及位于底部的输入栏与发送按钮。
3. **个性化体验：**
   在设置页面中定制您的语言偏好，所选语言将直接影响查询时返回的翻译结果。

## 快速开始

请从 App Store 下载 Glancy，开启全新的语言学习体验。
如有商务合作或咨询，请联系我们：[support@glancy.com](mailto:support@glancy.com)。

## 功能需求

### FR-001 单词查询
**背景** 用户希望获得所输入词语的翻译与例句。
**主流程**
1. 用户在搜索框输入词语。
2. 应用先检查 LeanCloud 缓存。
3. 若找到缓存立即返回，否则调用 DeepSeek 接口。
4. 将结果保存到 LeanCloud 并显示。
**备选流程** 网络调用失败时给出错误提示且不记录历史。
**后置条件** 查询词及时间写入搜索历史。
**例外** 当输入为空时提示用户重新输入。
#### 测试用例说明
- 缓存命中时查询 "hello" 立即返回。
- 未命中时调用 DeepSeek 并写入缓存。
- 网络错误时显示提示且不记录历史。

### FR-002 管理偏好语言
**背景** 用户希望自定义查询返回的语言种类。
**主流程**
1. 在设置页选择语言。
2. 最多可勾选三种语言。
3. 保存后偏好持久化到本地。
**备选流程** 超过三种语言的选择不生效。
**后置条件** 语言栏立即刷新。
**例外** 至少保留一种语言。
#### 测试用例说明
- 勾选两种语言，重启后仍保持。
- 尝试选择四种语言，仍仅保留三种。
- 仅剩一种语言时禁止取消。

### FR-003 账号认证
**背景** 用户可登录或退出以同步数据。
**主流程**
1. 选择密码或验证码登录方式。
2. LeanCloud 校验凭证后返回用户对象。
3. 登录成功后进入个人中心。
**备选流程** 凭证无效时提示错误并保持未登录状态。
**后置条件** 登录后搜索历史和设置同步至云端。
**例外** 网络错误时可重试。
#### 测试用例说明
- 使用正确密码登录后显示个人信息。
- 输入无效验证码提示错误。
- 离线登录时出现重试按钮。

### FR-004 搜索历史管理
**背景** 用户查看并操作最近查询过的词语。
**主流程**
1. 每次成功查询后保存 `SearchRecord`。
2. 列表展示最近十条记录。
3. 点击可重新查询，长按可删除。
**备选流程** 无。
**后置条件** 仅保留最新十条记录。
**例外** 持久化失败时忽略。
#### 测试用例说明
- 搜索后记录新增于历史列表。
- 当记录超过 10 条时自动删除最旧的一条。
- 长按条目后即被移除。

## 非功能需求

| ID | 类别 | 需求 | 指标 / 阈值 |
|----|------|------|--------------|
| NFR-S01 | 安全性 | 所有接口均使用 HTTPS，密钥存于 plist 文件。 | 静态扫描通过且无硬编码密钥 |
| NFR-P01 | 性能 | 缓存命中时响应时间不超过 500 毫秒。 | 单元测试 `GlancyTests.swift::test_performance` |
| NFR-R01 | 可靠性 | LeanCloud 操作月可用率达到 99.5%。 | Sentry 仪表盘 `glancy.reliability` |
### NFR 测试用例
- NFR-S01：运行静态扫描，确认无硬编码密钥。
- NFR-P01：测量缓存查词，耗时不超过 500 毫秒。
- NFR-R01：检查 Sentry，月成功率应达 99.5%。

## 需求追踪矩阵

| 需求 | 单元测试 | 集成 | E2E / BDD |
|------|----------|------|-----------|
| FR-001 | `GlancyTests/GlancyTests.swift::test_search_word` | – | – |
| FR-002 | `GlancyTests/GlancyTests.swift::test_language_preference` | – | – |
| FR-003 | `GlancyTests/GlancyTests.swift::test_authentication` | – | – |
| FR-004 | `GlancyTests/GlancyTests.swift::test_history` | – | – |
| NFR-P01 | `GlancyTests/GlancyTests.swift::test_performance` | N/A | `Reports/junit.xml` |

## 需求编写指南

### 功能需求

每个 FR 均应包含以下要素：

* **背景** – 简述使用场景
* **主流程** – 以编号步骤描述正常流程
* **备选流程** – 说明分支或例外情况
* **后置条件** – 成功后的系统状态
* **例外** – 错误处理方式

在 FR 下方以 Gherkin `Given/When/Then` 语法列出验收标准，覆盖正常、边界和异常场景。

### 非功能需求

以表格形式记录 NFR，包含 ID、类别、需求、指标/阈值，并在每行后用一句话解释该需求的原因。

### 需求追踪矩阵

维护映射各需求 ID 与单元、集成、端到端测试的表格。每行必须至少引用一个测试路径，新增或修改测试时同步更新。

### 测试用例说明编写要求
- 使用列表或表格描述。
- 每个需求至少包含正常、边界、异常三类用例。
- 以需求ID开头标识，例如 FR-001-T1。
- 句子使用主动语态，控制在 25 个字以内。
- 与验收标准和追踪矩阵保持一致。
