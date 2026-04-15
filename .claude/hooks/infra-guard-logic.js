#!/usr/bin/env node
// infra-guard-logic.js
// PreToolUse hook logic. Called by infra-guard.sh.

const path = require('path');

let data = '';
process.stdin.on('data', chunk => { data += chunk; });
process.stdin.on('end', () => {
  let json;
  try { json = JSON.parse(data); }
  catch (e) {
    process.stderr.write('shield infra-guard: JSON parse failed\n');
    process.exit(2);
  }

  const toolName = json.tool_name || json.tool || '';
  const toolInput = json.tool_input || json.parameters || {};
  const rawFilePath = json.file_path || toolInput.file_path || '';
  const command = json.command || toolInput.command || '';

  const np = rawFilePath.split('\\').join('/').replace(/^([A-Za-z]):/, (_, d) => '/' + d.toLowerCase());
  const rp = path.posix.normalize(np);

  if (toolName === 'Write' || toolName === 'Edit') {
    if (/\.claude\/settings(.local)?\.json$/.test(rp)) {
      process.stderr.write('shield infra-guard: Blocked edit of settings file. Ask the user to change settings directly.\n');
      process.exit(2);
    }
    if (/\.claude\/hooks\//.test(rp)) {
      process.stderr.write('shield infra-guard: Blocked hooks dir edit. Ask the user directly.\n');
      process.exit(2);
    }
  }

  if (toolName === 'Bash') {
    const infraRe = /\.claude\/(settings|hooks)/;
    const writeOpRe = /(>|>>|tee\s|cp\s|mv\s|sed\s+-i|dd\s+of=|rm\s|attrib\s)/i;
    const delDirRe = /rm\s.*\.claude[\/\s]/;
    if (infraRe.test(command) && writeOpRe.test(command)) {
      process.stderr.write('shield infra-guard: Blocked indirect write. Ask the user directly.\n');
      process.exit(2);
    }
    if (delDirRe.test(command)) {
      process.stderr.write('shield infra-guard: Blocked deletion of infra dir.\n');
      process.exit(2);
    }
  }

  process.exit(0);
});
