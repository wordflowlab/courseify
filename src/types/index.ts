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

// ============ 参考课程系统 ============

// 参考专栏元信息
export interface ReferenceCourse {
  name: string;
  field: string;
  level: string;
  chapter_count: number;
  description: string;
  keywords?: string[];
  path: string;
  created_at?: string;
}

// 参考课程索引
export interface ReferenceCourseIndex {
  version: string;
  updated_at: string;
  total_courses: number;
  courses: ReferenceCourse[];
}

// 专栏章节
export interface ReferenceChapter {
  number: string;
  title: string;
  filename: string;
}

// 专栏分析结果
export interface CourseAnalysis {
  course: ReferenceCourse;
  chapters: ReferenceChapter[];
  structure: {
    phases: CoursePhase[];      // 课程阶段划分
    transitions: string[];      // 关键转折点
    density: number;            // 知识点密度(0-100)
  };
  insights: {
    title_style: string;        // 标题风格
    content_balance: {          // 内容平衡
      theory: number;
      practice: number;
      exercises: number;
    };
    strengths: string[];        // 设计亮点
    suggestions: string[];      // 应用建议
  };
}

// 课程阶段
export interface CoursePhase {
  name: string;               // 阶段名称(预习篇/基础篇/进阶篇)
  chapter_range: string;      // 章节范围 "1-5"
  goal: string;               // 学习目标
  characteristics: string;    // 教学特点
}

// 智能推荐结果
export interface CourseRecommendation {
  course: ReferenceCourse;
  score: number;              // 匹配分数(0-100)
  match_reasons: string[];    // 匹配理由
  reference_value: {          // 参考价值
    structure: string;
    teaching: string;
    practice: string;
  };
}

// ============ 风格模拟系统 (Persona) ============

// 作者 Persona 元信息
export interface PersonaMetadata {
  id: string;
  name: string;
  course: string;
  field: string;
  level: string;
  style_summary: string;
  config_file: string;
}

// Persona 清单
export interface PersonaManifest {
  version: string;
  updated_at: string;
  total_personas: number;
  personas: PersonaMetadata[];
}

// 作者信息
export interface AuthorInfo {
  name: string;
  course: string;
  role: string;
  background?: string;
}

// Persona 配置
export interface AuthorPersona {
  author: AuthorInfo;
  persona: {
    identity: string;
    teaching_philosophy: string[];
    communication_style: string;
  };
  structure_patterns: {
    preferred_course_structure?: any[];
    title_style?: {
      pattern: string;
      examples: string[];
      formula?: string;
    };
  };
  content_organization?: {
    standard_flow?: any[];
    content_balance?: {
      [key: string]: number;
    };
  };
  signature_elements?: {
    must_have?: any[];
    preferred_teaching_methods?: string[];
  };
  quality_standards?: any;
  facilitation_prompts: {
    when_designing_outline: string;
    when_creating_content: string;
    when_reviewing_quality: string;
    when_stuck?: string;
  };
}

// 激活的 Persona 状态
export interface ActivePersonaStatus {
  active: boolean;
  persona?: AuthorPersona;
  persona_file?: string;
  activated_at?: string;
}
