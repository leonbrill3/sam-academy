#!/bin/bash
echo "🔍 S.A.M. Academy Health Check"
echo "=============================="

# JS syntax
echo -n "JS Syntax: "
sed -n '/^\/\/ =* STATE/,/<\/script>/p' /Users/sienabrill/friendship-game/index.html | sed '$d' > /tmp/sam_test.js && node --check /tmp/sam_test.js 2>&1 && echo "✅ OK" || echo "❌ ERROR"

# Sites up
echo -n "GitHub Pages: "
CODE=$(curl -s -o /dev/null -w "%{http_code}" https://leonbrill3.github.io/sam-academy/)
[ "$CODE" = "200" ] && echo "✅ UP" || echo "❌ DOWN ($CODE)"

echo -n "Render: "
CODE=$(curl -s -o /dev/null -w "%{http_code}" https://sam-academy.onrender.com)
[ "$CODE" = "200" ] && echo "✅ UP" || echo "❌ DOWN ($CODE)"

# Sync check
echo -n "Render in sync: "
curl -s https://sam-academy.onrender.com | diff - /Users/sienabrill/friendship-game/index.html > /dev/null 2>&1 && echo "✅ YES" || echo "⚠️ NO - run: git push"

# Firebase
echo -n "Firebase: "
curl -s "https://firestore.googleapis.com/v1/projects/sam-academy-ab135/databases/(default)/documents/players" 2>&1 | python3 -c "
import json,sys
data=json.load(sys.stdin)
docs=data.get('documents',[])
print(f'✅ {len(docs)} player(s)')
" 2>&1 || echo "❌ ERROR"

echo "=============================="
echo "✅ Check complete!"
