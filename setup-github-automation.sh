#!/bin/bash

# One-time setup for GitHub automation
# This enables git to push without password prompts

echo "🔐 PropRanked GitHub Automation Setup"
echo "===================================="
echo ""

# Check if GitHub repo exists
REPO_PATH=~/propranked
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "❌ GitHub repo not found at ~/propranked"
    echo "Please clone your repo first: git clone git@github.com:YOUR_USERNAME/propranked.git"
    exit 1
fi

echo "✓ Found GitHub repo at $REPO_PATH"
echo ""

# Option 1: Check for SSH key (preferred method)
echo "Checking for SSH keys..."
if [ -f ~/.ssh/id_rsa ] || [ -f ~/.ssh/id_ed25519 ]; then
    echo "✓ SSH key detected"
    
    cd "$REPO_PATH"
    
    # Switch to SSH remote if not already
    REMOTE=$(git config --get remote.origin.url)
    if [[ "$REMOTE" == https* ]]; then
        echo "Converting HTTPS remote to SSH..."
        NEW_URL=$(echo "$REMOTE" | sed 's|https://github.com/|git@github.com:|')
        git remote set-url origin "$NEW_URL"
        echo "✓ Updated to SSH: $NEW_URL"
    else
        echo "✓ Already using SSH: $REMOTE"
    fi
    
    echo ""
    echo "✅ GitHub automation ready!"
    echo "Git will now use SSH keys for authentication (no password needed)"
    exit 0
fi

# Option 2: GitHub Personal Access Token
echo "⚠️  No SSH key found"
echo ""
echo "To enable automated GitHub pushes, choose one option:"
echo ""
echo "Option A (Recommended): Set up SSH key"
echo "  1. Run: ssh-keygen -t ed25519 -C 'your@email.com'"
echo "  2. Add public key to GitHub: https://github.com/settings/keys"
echo ""
echo "Option B: Use Personal Access Token"
echo "  1. Create token: https://github.com/settings/tokens"
echo "  2. Grant 'repo' permission"
echo "  3. Run: gh auth login"
echo ""
echo "For automated scripts, SSH is recommended (no token storage needed)"

