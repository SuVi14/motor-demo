#!/usr/bin/env sh
# SessionStart hook: keeps i-have-adhd, humanizer, impeccable and last30days
# active in every session, the way the ponytail plugin keeps itself on.
# Whatever this prints is added to Claude's context at session start.
# Never blocks session start: any failure exits 0.

root="${CLAUDE_PROJECT_DIR:-$(dirname -- "$0")/../..}"
skills="$root/.claude/skills"

# Print a SKILL.md without its leading YAML frontmatter.
skill_body() {
  awk 'NR == 1 && /^---[[:space:]]*$/ { fm = 1; next }
       fm && /^---[[:space:]]*$/ { fm = 0; next }
       !fm { print }' "$1"
}

cat <<'EOF'
ALWAYS-ON SKILLS for this repository. These apply for the whole session without the user typing a slash command.

1. i-have-adhd: active now. Its full ruleset is below and shapes every response. "stop adhd mode" or "normal mode" turns it off for this session only.
2. humanizer: whenever you write prose meant for people to read (docs, READMEs, emails, messages, posts, PR descriptions), load the humanizer skill and apply it to that text before you hand it over.
3. impeccable: whenever the task touches a frontend interface (design, build, review, critique, polish), load the impeccable skill first and follow it.
4. last30days: whenever the user asks what is new, trending, or what people are saying about a topic recently, load the last30days skill and use it instead of a plain web search.

Load a skill with the Skill tool, as if the user had typed its slash command.
EOF

adhd="$skills/i-have-adhd/SKILL.md"
if [ -f "$adhd" ]; then
  printf '\n--- i-have-adhd ruleset ---\n'
  skill_body "$adhd"
fi

exit 0
