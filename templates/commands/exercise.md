---
description: 生成练习题
scripts:
  sh: ../../scripts/bash/exercise.sh
  ps1: ../../scripts/powershell/exercise.ps1
---

# /exercise - 练习题生成系统 📝

> **核心理念**: 为每章生成配套练习题,巩固学习成果
> **目标**: 创建多种类型的练习题,保存到 exercises/ 目录

---

## 第一步: 运行脚本获取状态 ⚠️ 必须执行

```bash
bash scripts/bash/exercise.sh
```

---

## 第二步: 选择题型和章节 ⚠️ 必须执行

```
╔══════════════════════════════════════════════════════════╗
║              练习题生成                                      ║
╚══════════════════════════════════════════════════════════╝

支持的题型:
  1. 选择题 (multiple_choice)
  2. 填空题 (fill_blank)
  3. 编程题 (coding) - 适合编程课程
  4. 案例分析 (case_study)
  5. 简答题 (essay)

请选择为哪一章生成练习题:
```

**⚠️ 等待用户选择**

---

## 第三步: 生成练习题 ⚠️ 必须执行

```
【为第1章生成练习题】

本章知识点:
  • [列出知识点]

请选择要生成的题型 (可多选,用逗号分隔):
```

**⚠️ 等待用户选择题型**

### 生成示例

```json
{
  "chapter": 1,
  "exercises": [
    {
      "id": "ex-1-1",
      "type": "multiple_choice",
      "question": "Python中哪个关键字用于定义函数?",
      "options": ["A. function", "B. def", "C. func", "D. define"],
      "answer": "B",
      "explanation": "Python使用def关键字定义函数",
      "difficulty": "easy",
      "points": 5
    }
  ]
}
```

保存到: `exercises/chapter-01.json`

---

**开始执行第一步** ⬇️
