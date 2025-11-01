# Courseify 快速开始指南

## 10分钟创建你的第一门课程

**包括**: 安装 → 初始化 → 定义规格 → 训练风格 → 创作大纲 → 导出

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

### 第6步: (可选) 准备参考资料和训练风格 (2-5分钟)

#### 6.1 添加参考专栏

如果你有收集的优质专栏资料(如极客时间下载的专栏):

```bash
# 复制专栏资料到 reference-courses/
cp -r ~/Downloads/专栏/* reference-courses/

# Windows PowerShell
# Copy-Item -Path "$env:USERPROFILE\Downloads\专栏\*" -Destination "reference-courses\" -Recurse

# 扫描生成索引
bash scripts/bash/scan-references.sh

# Windows PowerShell
# powershell scripts/powershell/scan-references.ps1
```

#### 6.2 查看推荐专栏

在 Claude Code 中运行:

```
/reference
```

AI 会根据你的课程规格,推荐 Top 3 相似专栏,说明参考价值。

#### 6.3 训练作者风格 (Persona)

从你的专栏资料中训练作者的教学风格:

```
/train
```

**AI 会引导你**:
1. 列出所有可训练的专栏
2. 选择一个专栏进行训练
3. AI 自动分析该作者的:
   - 章节结构模式
   - 标题风格
   - 内容组织方式
   - 教学特色元素
4. 生成 `persona.yaml` 配置文件

**训练示例**:
```
AI: "发现以下专栏可以训练:
  1. Flutter核心技术与实战 (编程开发 | 进阶 | 43章)
  2. MySQL实战45讲 (编程开发 | 进阶 | 45章)

请选择要训练的专栏(输入编号或名称): "

你: "1"

AI: "开始分析 Flutter核心技术与实战...
     已采样 5 个章节进行分析...

     ✅ Persona 训练完成!
     - 作者: 陈航
     - 风格特点: 技术深入、原理讲解、实战结合
     - 配置已保存到: reference-courses/personas/陈航.yaml

     下一步: 使用 /mimic activate 陈航 激活该风格"
```

#### 6.4 激活作者风格

```
/mimic activate 陈航
```

AI 会以该作者的风格辅助你创作:
- `/outline` - 按该作者的风格设计大纲
- `/content` - 按该作者的方式组织内容
- `/review` - 用该作者的标准评估质量

**退出风格模拟**:
```
/mimic deactivate
```

---

### 第7步: 设计课程结构和大纲 (3分钟)

```
/structure    # 设计课程结构
/outline      # 生成课程大纲(会应用激活的 persona)
```

**如果激活了 persona**,AI 会以该作者的方式引导你:
- 建议使用该作者的章节结构模式
- 推荐该作者的标题风格
- 强调该作者重视的内容比例

### 第8步: 创作内容

```
/content      # 创作章节内容
/exercise     # 生成练习题
/script       # 生成视频脚本
```

---

## 常见问题

### Q1: 我没有专栏资料,可以跳过训练吗?

**可以!** 第6步是可选的。如果你没有专栏资料:
- 直接从第7步开始设计课程结构
- 不激活 persona,AI 会用通用方式辅助你
- 后续有资料了可以随时训练和激活

### Q2: 如何切换创作模式?

在运行 `/outline` 时,AI 会询问你选择模式:
```
请选择模式:
  1. Coach 模式 - 引导式创作
  2. Express 模式 - 快速生成
  3. Hybrid 模式 - 混合创作

输入: 1
```

### Q3: Persona 训练和风格模拟有什么区别?

- **训练 (`/train`)**: 从专栏资料中**提取**作者的教学风格,生成配置文件
- **模拟 (`/mimic`)**: **激活**已训练的作者风格,让 AI 以该风格辅助你

**流程**: 先 `/train` 训练 → 再 `/mimic activate` 激活 → 然后创作时应用

### Q4: 如何查看和分析参考专栏?

```
/reference              # 推荐相似专栏
/analyze Flutter核心技术与实战   # 深入分析某个专栏
```

AI 会分析:
- 章节划分模式 (预习篇/基础篇/进阶篇等)
- 进阶路径和难度曲线
- 教学设计特色
- 可落地的借鉴建议

### Q5: 如何导出到 Notion?

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

### Q6: 创建的文件在哪里?

```
Python编程入门/
├── spec.json                # 课程规格
├── objective.json           # 学习目标
├── structure.json           # 课程结构
├── outline.md               # 课程大纲
├── chapters/                # 章节内容
├── exercises/               # 练习题
├── exports/                 # 导出文件
├── reference-courses/       # 参考专栏资料 (本地)
│   ├── personas/            # 训练的作者风格
│   └── index.json           # 专栏索引
└── .courseify/
    └── active-persona.yaml  # 当前激活的风格
```

### Q7: 如何查看所有命令?

```bash
courseify help
```

**所有 Slash Commands**:
```
/spec        - 定义课程规格
/objective   - 设定学习目标
/structure   - 设计课程结构
/outline     - 生成课程大纲
/content     - 创作章节内容
/exercise    - 生成练习题
/script      - 生成视频脚本
/review      - 质量评估
/export      - 导出到平台

# 参考系统 (v0.2.0)
/reference   - 推荐相似专栏
/analyze     - 分析专栏结构

# 风格系统 (v0.3.0-v0.4.0)
/mimic       - 风格模拟管理
/train       - Persona 训练
```

---

## 完整工作流示例

### 方式一: 基础流程 (无参考资料)

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
# AI: "选择模式: 1.Coach 2.Express 3.Hybrid"
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

### 方式二: 完整流程 (含风格训练)

```bash
# 1. 初始化
courseify init "Web开发实战"
cd "Web开发实战"

# 2. 准备参考资料
cp -r ~/Downloads/专栏/* reference-courses/
bash scripts/bash/scan-references.sh

# 3. 定义课程规格
/spec         # 定义规格
/objective    # 设定目标

# 4. 查看推荐和训练风格
/reference    # 查看推荐的相似专栏
/analyze Vue.js实战课程  # 深入分析某个专栏
/train        # 训练作者风格
# AI 会列出可训练专栏,选择一个进行训练

# 5. 激活作者风格
/mimic activate 作者名
# AI: "✅ 已激活 作者名 的风格"

# 6. 设计课程(应用 persona)
/structure    # 设计结构
/outline      # 生成大纲(AI 会以该作者风格引导)

# 7. 创作内容
/content      # 创作内容(应用该作者的内容组织方式)
/exercise     # 生成练习题
/script       # 生成视频脚本

# 8. 质量检查
/review       # 用该作者的标准评估质量

# 9. 退出风格并导出
/mimic deactivate
/export       # 导出到平台
```

### 方式三: 快速模式 + 参考分析

```bash
# 适合: 快速创建原型,借鉴成熟专栏结构

courseify init "React进阶课程"
cd "React进阶课程"

/spec         # 定义规格
/reference    # 查看推荐专栏
/analyze React设计模式与实践  # 深入分析
# 基于分析结果,借鉴章节划分思路

/structure    # 设计结构
/outline      # 选择 Express 模式快速生成
/review       # 质量评估
/export       # 导出
```

---

## 下一步

- 📖 阅读 [完整文档](README.md)
- 🎨 了解 [三种创作模式](README.md#创作模式详解)
- 📤 了解 [导出功能](README.md#多平台导出)

---

**开始创建你的第一门课程吧!** 🚀
