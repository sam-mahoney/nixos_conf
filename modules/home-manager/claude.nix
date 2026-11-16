{ inputs, ... }:

{
  home.file.".claude/skills/socratic-tutor".source = "${inputs.agent-skills}/socratic-tutor";
}
