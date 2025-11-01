/**
 * Interactive UI utilities for CLI
 */

import chalk from 'chalk';
import inquirer from 'inquirer';
import { AIConfig } from '../types/index.js';

/**
 * Display project banner
 */
export function displayProjectBanner(): void {
  console.log('');
  console.log(chalk.bold.cyan('╔══════════════════════════════════════════════════════════╗'));
  console.log(chalk.bold.cyan('║') + '                   ' + chalk.bold.yellow('COURSEIFY') + '                        ' + chalk.bold.cyan('║'));
  console.log(chalk.bold.cyan('║') + '           ' + chalk.gray('AI 驱动的课程内容生成工具') + '              ' + chalk.bold.cyan('║'));
  console.log(chalk.bold.cyan('╚══════════════════════════════════════════════════════════╝'));
  console.log('');
}

/**
 * Display success message
 */
export function displaySuccess(message: string): void {
  console.log(chalk.green('✅ ' + message));
}

/**
 * Display error message
 */
export function displayError(message: string): void {
  console.log(chalk.red('❌ ' + message));
}

/**
 * Display info message
 */
export function displayInfo(message: string): void {
  console.log(chalk.blue('ℹ️  ' + message));
}

/**
 * Display step indicator
 */
export function displayStep(current: number, total: number, title: string): void {
  console.log(chalk.bold.cyan(`[${current}/${total}] ${title}`));
  console.log('');
}

/**
 * Check if running in interactive mode
 */
export function isInteractive(): boolean {
  return process.stdin.isTTY === true && process.stdout.isTTY === true;
}

/**
 * Select AI assistant interactively
 */
export async function selectAIAssistant(configs: AIConfig[]): Promise<string> {
  const choices = configs.map((config, index) => ({
    name: `${index + 1}. ${config.displayName}`,
    value: config.name,
    short: config.displayName
  }));

  const answer = await inquirer.prompt([
    {
      type: 'list',
      name: 'ai',
      message: '选择 AI 助手:',
      choices: choices,
      default: 'claude'
    }
  ]);

  return answer.ai;
}

/**
 * Select course field interactively
 */
export async function selectCourseField(): Promise<string> {
  const answer = await inquirer.prompt([
    {
      type: 'list',
      name: 'field',
      message: '选择课程领域:',
      choices: [
        { name: '1. 💻 编程开发 - 编程语言/框架/工具', value: '编程开发' },
        { name: '2. 🎨 设计创意 - UI/UX/平面/视频', value: '设计创意' },
        { name: '3. 💼 商业管理 - 运营/营销/管理', value: '商业管理' },
        { name: '4. 🌍 语言学习 - 英语/日语等', value: '语言学习' },
        { name: '5. 📊 数据分析 - 数据科学/分析/BI', value: '数据分析' },
        { name: '6. 🎓 学术课程 - 学科知识', value: '学术课程' },
        { name: '7. 🛠️ 职业技能 - 职场技能/工具', value: '职业技能' },
        { name: '8. 🧠 软技能 - 沟通/思维/时间管理', value: '软技能' }
      ],
      default: '编程开发'
    }
  ]);

  return answer.field;
}

/**
 * Select bash script type (sh or ps1)
 */
export async function selectBashScriptType(): Promise<string> {
  const answer = await inquirer.prompt([
    {
      type: 'list',
      name: 'scriptType',
      message: '选择脚本类型:',
      choices: [
        { name: '1. Bash (macOS/Linux) - 推荐', value: 'sh' },
        { name: '2. PowerShell (Windows)', value: 'ps1' }
      ],
      default: 'sh'
    }
  ]);

  return answer.scriptType;
}
