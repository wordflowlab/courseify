// AI 平台配置
export interface AIConfig {
  name: string;           // 'claude', 'cursor', ...
  dir: string;            // '.claude', '.cursor', ...
  commandsDir: string;    // 'commands' / 'workflows' / 'prompts'
  displayName: string;    // 显示名称
}

// 课程规格
export interface CourseSpec {
  course_name: string;
  field: '编程开发' | '设计创意' | '商业管理' | '语言学习' | '数据分析' | '学术课程' | '职业技能' | '软技能' | string;
  level: '入门' | '进阶' | '高级';
  duration: string;       // "10小时"
  audience: string;       // "职场新人(0-3年)"
  format: 'video' | 'text' | 'audio' | 'mixed';
  platforms: string[];    // ["网易云课堂", "B站"]
  language: '中文' | '英文' | '双语' | string;
  created_at: string;
  updated_at: string;
}

// 学习目标
export interface LearningObjective {
  knowledge: string[];    // 知识点列表
  skills: string[];       // 技能列表
  outcomes: string[];     // 学习成果
}

// 课程结构
export interface CourseStructure {
  total_duration: string;
  chapters: Chapter[];
}

export interface Chapter {
  chapter_number: number;
  title: string;
  duration: string;
  description?: string;
  lessons: Lesson[];
}

export interface Lesson {
  lesson_number: number;
  title: string;
  duration: string;
  type: 'theory' | 'practice' | 'case' | 'quiz';
  objectives?: string[];
  content_file?: string;
}

// 创作模式
export type CreationMode = 'coach' | 'express' | 'hybrid';

// 命令模板元数据
export interface CommandMetadata {
  description: string;
  'argument-hint'?: string;
  'allowed-tools'?: string[];
  scripts?: {
    sh?: string;
    ps1?: string;
  };
  mode?: CreationMode;
}

// Bash 脚本执行结果
export interface BashResult {
  status: 'success' | 'error' | 'info';
  message?: string;
  [key: string]: any;
}

// 练习题类型
export interface Exercise {
  id: string;
  type: 'multiple_choice' | 'fill_blank' | 'coding' | 'case_study' | 'essay';
  question: string;
  options?: string[];     // 选择题选项
  answer?: string | string[];
  explanation?: string;
  difficulty?: 'easy' | 'medium' | 'hard';
  points?: number;
}

// 视频脚本
export interface VideoScript {
  lesson_title: string;
  total_duration: string;
  segments: ScriptSegment[];
}

export interface ScriptSegment {
  timestamp: string;      // "00:00-02:30"
  camera: string;         // "正面特写" / "屏幕录制"
  narration: string;      // 讲述文本
  demo?: string;          // 演示内容
  notes?: string;         // 讲师备注
}

// 质量评分
export interface ContentQualityScore {
  clarity: number;          // 清晰度 (0-100)
  structure: number;        // 结构性
  engagement: number;       // 吸引力
  practicality: number;     // 实用性
  completeness: number;     // 完整性
  total: number;
  feedback: {
    strengths: string[];
    improvements: string[];
    suggestions: string[];
  };
}

// 导出格式
export interface ExportConfig {
  platform: 'notion' | 'feishu' | 'netease' | 'excel' | 'html' | 'all';
  include_exercises?: boolean;
  include_scripts?: boolean;
  language?: string;
}
