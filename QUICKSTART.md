# Courseify 快速开始指南

## 5分钟创建你的第一门课程

### 第1步: 安装 (30秒)

```bash
# 全局安装
npm install -g ai-courseify

# 或本地开发
git clone https://github.com/wordflowlab/courseify.git
cd courseify
npm install
npm run build
```

### 第2步: 初始化项目 (1分钟)

```bash
courseify init "Python编程入门"
```

**交互式选择**:
1. 选择 AI 助手: `1` (Claude Code) - 回车
2. 选择课程领域: `1` (💻 编程开发) - 回车
3. 选择脚本类型: `1` (Bash) - 回车

**输出**:
```
✅ 项目 "Python编程入门" 初始化成功!

下一步:
  • cd Python编程入门
  • 运行 /spec 定义课程规格
```

### 第3步: 进入项目目录

```bash
cd Python编程入门
```

### 第4步: 定义课程规格 (2分钟)

在 Claude Code 中运行:

```
/spec
```

**AI 会引导你填写 9 个步骤**:

1. **确认领域**: 输入 `1` (继续使用"编程开发")
2. **难度等级**: 输入 `1` (🌱 入门级)
3. **课程时长**: 输入 `15小时`
4. **目标受众**: 输入 `1` (🎓 学生)
5. **课程格式**: 输入 `4` (🔀 混合形式)
6. **目标平台**: 输入 `2,5` (网易云课堂+B站)
7. **课程语言**: 输入 `1` (中文)
8. **确认保存**: 输入 `1` (✅ 确认保存)

**AI 会使用 Write 工具保存 `spec.json`**

### 第5步: 设定学习目标 (1分钟)

```
/objective
```

**AI 会引导你填写**:
- 知识点: 例如 "Python 基础语法"、"变量和数据类型" 等
- 技能: 例如 "编写简单的 Python 程序"
- 学习成果: 例如 "能够独立完成 xxx"

### 第6步: 开始使用!

```
/structure    # 设计课程结构
/outline      # 生成课程大纲
/content      # 创作章节内容
/exercise     # 生成练习题
```

---

## 常见问题

### Q1: 如何切换创作模式?

在运行 `/outline` 时,AI 会询问你选择模式:
```
请选择模式:
  1. 引导模式 (Coach) - 逐章引导
  2. 快速模式 (Express) - 快速生成
  3. 混合模式 (Hybrid) - AI生成框架

输入: 1
```

### Q2: 如何导出到 Notion?

```
/export
```
AI 会询问:
```
选择导出平台:
  1. Notion Database
  2. 飞书文档
  3. 网易云课堂
  ...

输入: 1
```

### Q3: 创建的文件在哪里?

```
Python编程入门/
├── spec.json           # 课程规格
├── objective.json      # 学习目标
├── structure.json      # 课程结构
├── outline.md          # 课程大纲
├── chapters/           # 章节内容
├── exercises/          # 练习题
└── exports/            # 导出文件
```

### Q4: 如何查看所有命令?

```bash
courseify help
```

---

## 完整工作流示例

```bash
# 1. 初始化
courseify init "Web开发实战"
cd "Web开发实战"

# 2. 在 Claude Code 中使用 slash commands
/spec         # 定义规格
/objective    # 设定目标
/structure    # 设计结构

# 3. 创作大纲(选择引导模式)
/outline
# AI: "选择模式: 1.引导 2.快速 3.混合"
# 你: "1"
# AI 会逐章引导你设计...

# 4. 创作内容
/content      # 逐章创作
/exercise     # 生成练习题
/script       # 生成视频脚本

# 5. 质量检查和导出
/review       # 质量评估
/export       # 导出到平台
```

---

## 下一步

- 📖 阅读 [完整文档](README.md)
- 🎨 了解 [三种创作模式](README.md#创作模式详解)
- 📤 了解 [导出功能](README.md#多平台导出)

---

**开始创建你的第一门课程吧!** 🚀
