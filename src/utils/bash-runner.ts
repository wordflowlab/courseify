/**
 * Bash/PowerShell script execution utilities
 */

import { spawn } from 'child_process';
import path from 'path';
import fs from 'fs-extra';
import { BashResult } from '../types/index.js';

/**
 * Find the courseify project root directory by looking for .courseify/config.json
 */
function findProjectRoot(): string {
  let current = process.cwd();

  // Windows root detection (C:\ etc.)
  const isWindowsRoot = (p: string) => {
    return /^[a-zA-Z]:\\?$/.test(p);
  };

  while (current !== '/' && !isWindowsRoot(current)) {
    const configPath = path.join(current, '.courseify', 'config.json');
    if (fs.existsSync(configPath)) {
      return current;
    }
    const parent = path.dirname(current);
    if (parent === current) break; // Reached root
    current = parent;
  }

  // Fallback to current directory
  return process.cwd();
}

/**
 * Get script configuration from project config
 */
function getScriptConfig(projectRoot: string): { scriptType: string; scriptDir: string } {
  const configPath = path.join(projectRoot, '.courseify', 'config.json');

  if (fs.existsSync(configPath)) {
    try {
      const config = fs.readJsonSync(configPath);
      const scriptType = config.scriptType || 'sh';
      const scriptDir = scriptType === 'ps1' ? 'powershell' : 'bash';
      return { scriptType, scriptDir };
    } catch (error) {
      // Fall back to bash if config is invalid
    }
  }

  // Default to bash
  return { scriptType: 'sh', scriptDir: 'bash' };
}

/**
 * Execute a bash/powershell script and return parsed JSON result
 */
export async function executeBashScript(
  scriptName: string,
  args: string[] = []
): Promise<BashResult> {
  return new Promise((resolve, reject) => {
    const projectRoot = findProjectRoot();
    const { scriptType, scriptDir } = getScriptConfig(projectRoot);

    // Determine script path and command
    const scriptExt = scriptType === 'ps1' ? '.ps1' : '.sh';
    const scriptPath = path.join(
      projectRoot,
      'scripts',
      scriptDir,
      `${scriptName}${scriptExt}`
    );

    // Check if script exists
    if (!fs.existsSync(scriptPath)) {
      reject(new Error(`Script not found: ${scriptPath}`));
      return;
    }

    // Determine command and arguments
    let command: string;
    let commandArgs: string[];

    if (scriptType === 'ps1') {
      // PowerShell
      command = 'powershell.exe';
      commandArgs = [
        '-ExecutionPolicy', 'Bypass',
        '-NoProfile',
        '-File', scriptPath,
        ...args
      ];
    } else {
      // Bash
      command = 'bash';
      commandArgs = [scriptPath, ...args];
    }

    const child = spawn(command, commandArgs, {
      cwd: process.cwd(),
      env: process.env
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (data) => {
      stdout += data.toString();
    });

    child.stderr.on('data', (data) => {
      stderr += data.toString();
    });

    child.on('close', (code) => {
      if (code !== 0) {
        reject(new Error(`Script exited with code ${code}: ${stderr}`));
        return;
      }

      try {
        // Parse JSON output from script
        const result = JSON.parse(stdout.trim());
        resolve(result);
      } catch (error) {
        reject(new Error(`Failed to parse script output: ${stdout}`));
      }
    });

    child.on('error', (error) => {
      reject(error);
    });
  });
}

/**
 * Execute a bash/powershell script with real-time output
 */
export async function executeBashScriptWithOutput(
  scriptName: string,
  args: string[] = []
): Promise<void> {
  return new Promise((resolve, reject) => {
    const projectRoot = findProjectRoot();
    const { scriptType, scriptDir } = getScriptConfig(projectRoot);

    // Determine script path and command
    const scriptExt = scriptType === 'ps1' ? '.ps1' : '.sh';
    const scriptPath = path.join(
      projectRoot,
      'scripts',
      scriptDir,
      `${scriptName}${scriptExt}`
    );

    // Check if script exists
    if (!fs.existsSync(scriptPath)) {
      reject(new Error(`Script not found: ${scriptPath}`));
      return;
    }

    // Determine command and arguments
    let command: string;
    let commandArgs: string[];

    if (scriptType === 'ps1') {
      // PowerShell
      command = 'powershell.exe';
      commandArgs = [
        '-ExecutionPolicy', 'Bypass',
        '-NoProfile',
        '-File', scriptPath,
        ...args
      ];
    } else {
      // Bash
      command = 'bash';
      commandArgs = [scriptPath, ...args];
    }

    const child = spawn(command, commandArgs, {
      cwd: process.cwd(),
      env: process.env,
      stdio: 'inherit' // Show output in real-time
    });

    child.on('close', (code) => {
      if (code !== 0) {
        reject(new Error(`Script exited with code ${code}`));
        return;
      }
      resolve();
    });

    child.on('error', (error) => {
      reject(error);
    });
  });
}
