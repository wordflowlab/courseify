# 参考课程库

这个目录用于存放你收集的优质专栏课程,作为创作自己课程时的参考。

## 如何添加专栏

1. 将你的专栏 Markdown 文件放入此目录:

```bash
reference-courses/
├── Flutter核心技术与实战/
│   ├── 00 开篇词.md
│   ├── 01 预习篇.md
│   └── ...
├── MySQL实战45讲/
└── ...
```

2. 运行扫描命令生成索引:

```bash
bash scripts/bash/scan-references.sh
```

3. 使用 `/reference` 命令查看推荐

## 索引文件

运行扫描后会生成:
- `index.json` - 所有专栏的索引
- 每个专栏目录下的 `meta.json` - 专栏元信息

## 注意事项

⚠️ **这些数据是你的私人资料,不会提交到 Git 仓库**

专栏数据已被添加到 `.gitignore`,仅在本地使用。
