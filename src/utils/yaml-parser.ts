/**
 * YAML frontmatter parser for command templates
 */

import fs from 'fs-extra';
import yaml from 'js-yaml';
import { CommandMetadata } from '../types/index.js';

/**
 * Parse command template with YAML frontmatter
 */
export async function parseCommandTemplate(
  templatePath: string
): Promise<{ metadata: CommandMetadata; content: string }> {
  const fileContent = await fs.readFile(templatePath, 'utf-8');

  // Check for YAML frontmatter (---...---)
  const frontmatterRegex = /^---\s*\n([\s\S]*?)\n---\s*\n([\s\S]*)$/;
  const match = fileContent.match(frontmatterRegex);

  if (match) {
    const yamlContent = match[1];
    const markdownContent = match[2];

    try {
      const metadata = yaml.load(yamlContent) as CommandMetadata;
      return {
        metadata,
        content: markdownContent.trim()
      };
    } catch (error) {
      throw new Error(`Failed to parse YAML frontmatter: ${error}`);
    }
  }

  // No frontmatter, return empty metadata
  return {
    metadata: { description: '' },
    content: fileContent.trim()
  };
}
