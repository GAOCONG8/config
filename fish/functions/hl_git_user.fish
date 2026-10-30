function hl_git_user
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "❌ Not inside a git repository"
        return 1
    end

    git config --local user.name "gaocong"
    git config --local user.email "cong.gao@hollyland.com"
    echo "✅ Git user set to: gaocong <cong.gao@hollyland.com>"
end
