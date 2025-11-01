#!/usr/bin/env node

import { Command } from '@commander-js/extra-typings';
import chalk from 'chalk';
import fs from 'fs-extra';
import ora from 'ora';
import path from 'path';
import { fileURLToPath } from 'url';
import { createRequire } from 'module';
import {
  displayProjectBanner,
  displaySuccess,
  displayError,
  displayInfo,
  displayStep,
  isInteractive,
  selectAIAssistant,
  selectCourseField,
  selectBashScriptType
} from './utils/interactive.js';
import { executeBashScript } from './utils/bash-runner.js';
import { parseCommandTemplate } from './utils/yaml-parser.js';
import { AIConfig } from './types/index.js';

// 读取 package.json 版本号
const require = createRequire(import.meta.url);
const { version } = require('../package.json');

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// AI 平台配置 - 所有支持的平台
const AI_CONFIGS: AIConfig[] = [
  { name: 'claude', dir: '.claude', commandsDir: 'commands', displayName: 'Claude Code' },
  { name: 'cursor', dir: '.cursor', commandsDir: 'commands', displayName: 'Cursor' },
  { name: 'gemini', dir: '.gemini', commandsDir: 'commands', displayName: 'Gemini CLI' },
  { name: 'windsurf', dir: '.windsurf', commandsDir: 'workflows', displayName: 'Windsurf' },
  { name: 'roocode', dir: '.roo', commandsDir: 'commands', displayName: 'Roo Code' },
  { name: 'copilot', dir: '.github', commandsDir: 'prompts', displayName: 'GitHub Copilot' },
  { name: 'qwen', dir: '.qwen', commandsDir: 'commands', displayName: 'Qwen Code' },
  { name: 'opencode', dir: '.opencode', commandsDir: 'command', displayName: 'OpenCode' },
  { name: 'codex', dir: '.codex', commandsDir: 'prompts', displayName: 'Codex CLI' },
  { name: 'kilocode', dir: '.kilocode', commandsDir: 'workflows', displayName: 'Kilo Code' },
  { name: 'auggie', dir: '.augment', commandsDir: 'commands', displayName: 'Auggie CLI' },
  { name: 'codebuddy', dir: '.codebuddy', commandsDir: 'commands', displayName: 'CodeBuddy' },
  { name: 'q', dir: '.amazonq', commandsDir: 'prompts', displayName: 'Amazon Q Developer' }
];

const program = new Command();

// Display banner
displayProjectBanner();

program
  .name('courseify')
  .description(chalk.cyan('Courseify - AI 驱动的课程内容生成工具'))
  .version(version);

// /init - 初始化项目(支持13个AI助手)
program
  .command('init')
  .argument('[name]', '项目名称')
  .option('--here', '在当前目录初始化')
  .option('--ai <type>', '选择 AI 助手')
  .description('初始化Courseify项目(生成AI配置)')
  .action(async (name, options) => {
    // 交互式选择
    const shouldShowInteractive = isInteractive() && !options.ai;

    let selectedAI = 'claude';
    let selectedScriptType = 'sh';
    let selectedField = '编程开发';

    if (shouldShowInteractive) {
      // 显示欢迎横幅
      displayProjectBanner();

      // [1/3] 选择 AI 助手
      displayStep(1, 3, '选择 AI 助手');
      selectedAI = await selectAIAssistant(AI_CONFIGS);
      console.log('');

      // [2/3] 选择课程领域
      displayStep(2, 3, '选择课程领域');
      selectedField = await selectCourseField();
      console.log('');

      // [3/3] 选择脚本类型
      displayStep(3, 3, '选择脚本类型');
      selectedScriptType = await selectBashScriptType();
      console.log('');
    } else if (options.ai) {
      selectedAI = options.ai;
    }

    const spinner = ora('正在初始化Courseify项目...').start();

    try {
      // 确定项目路径
      let projectPath: string;
      if (options.here) {
        projectPath = process.cwd();
        name = path.basename(projectPath);
      } else {
        if (!name) {
          spinner.fail('请提供项目名称或使用 --here 参数');
          process.exit(1);
        }
        projectPath = path.join(process.cwd(), name);
        if (await fs.pathExists(projectPath)) {
          spinner.fail(`项目目录 "${name}" 已存在`);
          process.exit(1);
        }
        await fs.ensureDir(projectPath);
      }

      // 获取选中的AI配置
      const aiConfig = AI_CONFIGS.find(c => c.name === selectedAI);
      if (!aiConfig) {
        spinner.fail(`不支持的AI助手: ${selectedAI}`);
        process.exit(1);
      }

      // 创建基础项目结构
      const dirs = [
        '.courseify',
        `${aiConfig.dir}/${aiConfig.commandsDir}`
      ];

      for (const dir of dirs) {
        await fs.ensureDir(path.join(projectPath, dir));
      }

      // 创建项目配置文件
      const config = {
        name: name,
        type: 'courseify-project',
        ai: selectedAI,
        scriptType: selectedScriptType,
        defaultField: selectedField,
        created: new Date().toISOString(),
        version: '0.1.0'
      };
      await fs.writeJson(path.join(projectPath, '.courseify', 'config.json'), config, { spaces: 2 });

      // 从npm包复制模板和脚本到项目
      const packageRoot = path.resolve(__dirname, '..');

      // 根据选择的脚本类型复制对应脚本
      const scriptsSubDir = selectedScriptType === 'ps1' ? 'powershell' : 'bash';
      const scriptsSource = path.join(packageRoot, 'scripts', scriptsSubDir);
      const scriptsTarget = path.join(projectPath, 'scripts', scriptsSubDir);

      if (await fs.pathExists(scriptsSource)) {
        await fs.copy(scriptsSource, scriptsTarget);

        // 设置bash脚本执行权限
        if (selectedScriptType === 'sh') {
          const bashFiles = await fs.readdir(scriptsTarget);
          for (const file of bashFiles) {
            if (file.endsWith('.sh')) {
              const filePath = path.join(scriptsTarget, file);
              await fs.chmod(filePath, 0o755);
            }
          }
        }
      }

      // 复制templates到项目
      const templatesSource = path.join(packageRoot, 'templates');
      const templatesTarget = path.join(projectPath, 'templates');
      if (await fs.pathExists(templatesSource)) {
        await fs.copy(templatesSource, templatesTarget);
      }

      // 生成AI配置文件（直接复制模板文件）
      const commandFiles = await fs.readdir(path.join(packageRoot, 'templates', 'commands'));

      for (const file of commandFiles) {
        if (file.endsWith('.md')) {
          const sourcePath = path.join(packageRoot, 'templates', 'commands', file);
          const targetPath = path.join(projectPath, aiConfig.dir, aiConfig.commandsDir, file);
          await fs.copy(sourcePath, targetPath);
        }
      }

      // 创建README
      const readme = `# ${name}

使用 Courseify 创建的${selectedField}课程项目

## 配置

- **AI 助手**: ${aiConfig.displayName}
- **课程领域**: ${selectedField}
- **脚本类型**: ${selectedScriptType === 'sh' ? 'POSIX Shell (macOS/Linux)' : 'PowerShell (Windows)'}

## 创作流程

使用 Slash Commands 完成课程创作:

\`\`\`bash
/spec         # 1. 定义课程规格(领域/受众/时长/难度)
/objective    # 2. 设定学习目标(知识/技能/成果)
/structure    # 3. 设计课程结构(章节/课时)
/outline      # 4. 生成课程大纲(三种模式)
/content      # 5. 创作章节内容
/exercise     # 6. 生成练习题
/script       # 7. 生成视频脚本
/review       # 8. 内容质量评估
/export       # 9. 导出到多平台
\`\`\`

## 三种创作模式

### 引导模式 (Coach)
\`\`\`bash
/outline --mode coach
\`\`\`
AI 逐章引导,深度思考教学逻辑,100% 原创

### 快速模式 (Express)
\`\`\`bash
/outline --mode express
\`\`\`
AI 快速生成完整大纲,快速迭代

### 混合模式 (Hybrid)
\`\`\`bash
/outline --mode hybrid
\`\`\`
AI 生成框架,你填充内容,平衡效率与原创

## 项目结构

- \`spec.json\` - 课程规格配置
- \`objective.json\` - 学习目标
- \`structure.json\` - 课程结构
- \`outline.md\` - 课程大纲
- \`chapters/\` - 章节内容目录
- \`exercises/\` - 练习题目录
- \`scripts/${scriptsSubDir}/\` - ${selectedScriptType === 'sh' ? 'Bash' : 'PowerShell'}脚本
- \`templates/\` - AI提示词模板
- \`${aiConfig.dir}/\` - ${aiConfig.displayName}配置

## 更多命令

\`\`\`bash
/review      # 质量评估
/export      # 导出到 Notion/飞书/网易云课堂
\`\`\`

## 文档

查看 [Courseify文档](https://github.com/wordflowlab/courseify)
`;

      await fs.writeFile(path.join(projectPath, 'README.md'), readme);

      spinner.succeed(`项目 "${name}" 初始化成功!`);

      console.log('');
      displayInfo('下一步:');
      if (!options.here) {
        console.log(`  • cd ${name}`);
      }
      console.log(`  • 运行 /spec 定义课程规格`);
      console.log(`  • 运行 /objective 设定学习目标`);

    } catch (error) {
      spinner.fail('初始化项目失败');
      console.error(error);
      process.exit(1);
    }
  });

// Helper function to execute command with template
async function executeCommandWithTemplate(
  scriptName: string,
  templateName: string,
  args: string[] = []
) {
  try {
    const result = await executeBashScript(scriptName, args);

    if (result.status === 'success' || result.status === 'info') {
      displaySuccess(`项目: ${result.project_name || ''}`);

      // Read and display command template
      const templatePath = `templates/commands/${templateName}.md`;
      if (await fs.pathExists(templatePath)) {
        const { metadata, content } = await parseCommandTemplate(templatePath);
        console.log('\n' + chalk.dim('─'.repeat(50)));
        console.log(content);
        console.log(chalk.dim('─'.repeat(50)) + '\n');

        // Display script output context for AI
        console.log(chalk.dim('## 脚本输出信息\n'));
        console.log('```json');
        console.log(JSON.stringify(result, null, 2));
        console.log('```');
      }
    } else {
      displayError(result.message || '发生未知错误');
      process.exit(1);
    }
  } catch (error) {
    displayError(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

// Help command
program
  .command('help')
  .description('显示帮助信息')
  .action(() => {
    console.log(chalk.bold('\nCourseify - AI 驱动的课程内容生成工具\n'));
    console.log(chalk.cyan('📋 项目管理:'));
    console.log('  courseify init <项目名>           创建新项目');
    console.log('');
    console.log(chalk.cyan('📚 课程创作流程:'));
    console.log('  /spec                           定义课程规格');
    console.log('  /objective                      设定学习目标');
    console.log('  /structure                      课程结构设计');
    console.log('  /outline --mode coach           大纲创作(引导模式)');
    console.log('  /outline --mode express         大纲创作(快速模式)');
    console.log('  /outline --mode hybrid          大纲创作(混合模式)');
    console.log('  /content                        章节内容创作');
    console.log('  /exercise                       生成练习题');
    console.log('  /script                         生成视频脚本');
    console.log('  /review                         质量评估');
    console.log('');
    console.log(chalk.cyan('📤 导出:'));
    console.log('  /export                         导出到多平台');
    console.log('');
  });

// Parse arguments
program.parse();
