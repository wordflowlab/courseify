# Changelog

All notable changes to Courseify will be documented in this file.

## [0.4.1] - 2025-11-01

### 🔧 Fixed - PowerShell Scripts

**跨平台支持完善** - 添加 Windows PowerShell 版本的新脚本

- 新增 `scripts/powershell/reference.ps1` - 参考课程推荐
- 新增 `scripts/powershell/analyze.ps1` - 专栏结构分析
- 新增 `scripts/powershell/mimic.ps1` - 风格模拟管理
- 新增 `scripts/powershell/train.ps1` - Persona 训练

这些脚本与 Bash 版本功能完全一致,确保 Windows 用户也能使用 v0.2.0-v0.4.0 的所有新功能。

---

## [0.3.0] - 2025-11-01

### ✨ Added - Author Persona System (风格模拟系统)

**学习大师的教学方法** - AI 模拟优秀专栏作者的风格辅助创作

- **`/mimic` 命令** - 风格模拟管理
  - `/mimic list` - 列出所有可模拟的作者
  - `/mimic activate <作者名>` - 激活某个作者的风格
  - `/mimic deactivate` - 退出风格模拟
  - `/mimic status` - 查看当前激活状态

- **3个精选作者 Persona**
  - **陈航** (Flutter核心技术与实战)
    - 风格特点: 技术深入、原理讲解、实战结合
    - 结构模式: 预习篇+基础篇+进阶篇+实战篇
    - 内容组织: Why → What → How → Think
  - **林晓斌** (MySQL实战45讲)
    - 风格特点: 问题驱动、深入浅出、生产案例
    - 标题风格: 问题导向式
    - 教学模式: 问题场景 → 原理剖析 → 解决方案 → 思考题
  - **倪朋飞** (Linux性能优化实战)
    - 风格特点: 实战为主、工具演示、性能分析
    - 教学模式: 问题场景 → 工具使用 → 实战演示 → 优化对比
    - 内容重点: 工具40% + 实战30% + 原理20% + 总结10%

- **智能风格应用**
  - `/outline` - 激活 persona 后,按该作者的风格设计大纲
  - `/content` - 按该作者的内容组织方式创作
  - `/review` - 用该作者的质量标准评估

- **Persona 配置系统**
  - YAML 格式的作者风格配置
  - 包含教学理念、结构模式、标志性元素
  - facilitation_prompts: 不同场景的AI指导提示词
  - 支持用户自定义添加新的 persona

### 🔧 Technical

- 新增目录: `reference-courses/personas/`
- 新增脚本: `scripts/bash/mimic.sh`
- 新增命令: `templates/commands/mimic.md`
- 新增类型定义: `PersonaMetadata`, `AuthorPersona`, `ActivePersonaStatus`
- 修改命令模板:
  - `outline-express.md` - 添加 persona 检查
  - `outline-coach.md` - 添加 persona 检查
  - `outline-hybrid.md` - 添加 persona 检查
  - `content.md` - 添加 persona 检查
  - `review.md` - 添加 persona 检查

### 📚 Documentation

- 新增 `docs/MIMIC_GUIDE.md` - 完整使用指南
  - 功能介绍和工作原理
  - 3个作者的详细风格说明
  - 使用场景和最佳实践
  - 常见问题解答
- 更新 `README.md` - 新功能介绍
- 更新 `src/types/index.ts` - Persona 系统类型定义

### 🎯 核心价值

- 📚 从行业标杆学习课程设计方法
- 🎭 AI 以大师的方式引导你思考
- 🚀 快速提升课程设计质量
- ✍️ 学习方法而非照搬内容

---

## [0.2.0] - 2025-11-01

### ✨ Added - Reference Course System

**智能参考系统** - 学习和借鉴优质专栏的设计方法

- **`/reference` 命令** - 智能推荐相似专栏
  - 基于课程规格自动匹配 Top 3 相关专栏
  - 多维度评分:领域匹配、关键词匹配、难度接近
  - 清晰说明每个专栏的参考价值

- **`/analyze <专栏名>` 命令** - 深入分析专栏结构
  - 自动识别章节划分模式
  - 分析进阶路径和难度曲线
  - 提取教学设计特色
  - 给出可落地的借鉴建议

- **集成参考能力**
  - `/outline` - 设计大纲时可查看推荐专栏
  - `/review` - 增加质量对标功能

- **专栏管理工具**
  - `scan-references.sh` - 扫描专栏生成索引
  - 自动识别领域和难度
  - 生成索引和元信息文件

### 🔧 Technical

- 新增类型定义: `ReferenceCourse`, `CourseAnalysis`, `CourseRecommendation`
- 数据隔离: `reference-courses/` 加入 `.gitignore`

### 📚 Documentation

- 新增 `REFERENCE_GUIDE.md` - 完整使用指南
- 新增 `reference-courses/README.md`
- 更新 `README.md` - 新功能介绍

---

## [0.1.0] - 2025-11-01

### Added
- 🎉 Initial release
- ✅ Core CLI implementation with `init` command
- ✅ 9 Bash scripts for complete workflow
- ✅ 13 AI assistant platform support
- ✅ Three creation modes (coach/express/hybrid)
- ✅ Complete course creation workflow:
  - `/spec` - Course specification
  - `/objective` - Learning objectives
  - `/structure` - Course structure
  - `/outline` - Course outline generation
  - `/content` - Chapter content creation
  - `/exercise` - Exercise generation
  - `/script` - Video script generation
  - `/review` - Quality assessment
  - `/export` - Multi-platform export
- ✅ Markdown template system
- ✅ TypeScript type definitions
- ✅ Cross-platform support (Bash + PowerShell)
- ✅ Support for 8 course fields:
  - Programming
  - Design
  - Business
  - Language
  - Data Analysis
  - Academic
  - Professional Skills
  - Soft Skills
- ✅ Multi-platform export support:
  - Notion
  - Feishu (Lark)
  - NetEase Cloud Classroom
  - Excel
  - HTML

### Documentation
- ✅ Complete README.md
- ✅ Architecture documentation
- ✅ Usage examples
- ✅ Roadmap

## [Unreleased]

### Planned for v0.2.0
- Enhanced AI teaching suggestions
- Case library and template library
- Interactive exercise generation improvements
- Video script optimization
- More detailed quality metrics

### Planned for v0.3.0
- Direct API integration with Notion/Feishu
- Batch import for NetEase Cloud Classroom
- Bilibili course description generation
- YouTube subtitle generation

### Planned for v0.4.0
- Automatic course difficulty analysis
- Teaching effectiveness prediction
- Personalized learning path generation
- Multi-language course support
