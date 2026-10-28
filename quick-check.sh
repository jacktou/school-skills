#!/bin/bash

# Cloud Agent 审批问题快速检查脚本
# 用于诊断审批卡不显示的问题

echo "========================================"
echo "Cloud Agent 审批问题诊断工具"
echo "========================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查项计数
PASS=0
WARN=0
FAIL=0

print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "PASS")
            echo -e "${GREEN}✓${NC} $message"
            ((PASS++))
            ;;
        "WARN")
            echo -e "${YELLOW}⚠${NC} $message"
            ((WARN++))
            ;;
        "FAIL")
            echo -e "${RED}✗${NC} $message"
            ((FAIL++))
            ;;
        "INFO")
            echo -e "${BLUE}ℹ${NC} $message"
            ;;
    esac
}

section_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 1. 检查网络连接
section_header "1. 网络连接检查"

if ping -c 1 -W 2 cursor.com &> /dev/null; then
    print_status "PASS" "可以访问 cursor.com"
else
    print_status "FAIL" "无法访问 cursor.com，请检查网络连接"
fi

if ping -c 1 -W 2 github.com &> /dev/null; then
    print_status "PASS" "可以访问 github.com"
else
    print_status "WARN" "无法访问 github.com，可能影响某些功能"
fi

# 检查 DNS 解析
if nslookup cursor.com &> /dev/null; then
    print_status "PASS" "DNS 解析正常"
else
    print_status "FAIL" "DNS 解析失败，请检查 DNS 设置"
fi

# 2. 检查当前环境
section_header "2. 运行环境检查"

print_status "INFO" "当前用户: $(whoami)"
print_status "INFO" "工作目录: $(pwd)"
print_status "INFO" "系统信息: $(uname -s) $(uname -r)"

# 检查 Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    print_status "PASS" "Git 已安装: $GIT_VERSION"
else
    print_status "FAIL" "Git 未安装"
fi

# 检查 Git 仓库
if git rev-parse --git-dir &> /dev/null 2>&1; then
    print_status "PASS" "当前目录是 Git 仓库"
    REPO_URL=$(git config --get remote.origin.url)
    print_status "INFO" "仓库地址: $REPO_URL"
    CURRENT_BRANCH=$(git branch --show-current)
    print_status "INFO" "当前分支: $CURRENT_BRANCH"
else
    print_status "WARN" "当前目录不是 Git 仓库"
fi

# 3. 检查文件权限
section_header "3. 文件系统权限检查"

# 检查读权限
if [ -r "." ]; then
    print_status "PASS" "当前目录可读"
else
    print_status "FAIL" "当前目录不可读"
fi

# 检查写权限
if [ -w "." ]; then
    print_status "PASS" "当前目录可写"
else
    print_status "FAIL" "当前目录不可写，可能影响文件操作"
fi

# 检查执行权限
if [ -x "." ]; then
    print_status "PASS" "当前目录可执行"
else
    print_status "FAIL" "当前目录不可执行"
fi

# 4. 检查磁盘空间
section_header "4. 系统资源检查"

DISK_USAGE=$(df -h . | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 90 ]; then
    print_status "PASS" "磁盘使用率: ${DISK_USAGE}%"
else
    print_status "WARN" "磁盘使用率较高: ${DISK_USAGE}%"
fi

# 检查内存
if command -v free &> /dev/null; then
    MEM_INFO=$(free -h | grep Mem | awk '{print "总内存: "$2" | 已用: "$3" | 可用: "$7}')
    print_status "INFO" "$MEM_INFO"
fi

# 5. 检查必要的工具
section_header "5. 必要工具检查"

tools=("curl" "wget" "jq" "node" "npm" "docker")

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        VERSION=$($tool --version 2>&1 | head -1)
        print_status "PASS" "$tool 已安装"
    else
        print_status "WARN" "$tool 未安装（可选）"
    fi
done

# 6. 测试审批触发
section_header "6. 审批功能测试"

print_status "INFO" "准备测试审批功能..."

# 创建测试文件
TEST_FILE="test-approval-$(date +%s).txt"
print_status "INFO" "测试文件: $TEST_FILE"

# 注意：在实际的 Cloud Agent 环境中，这些操作应该会触发审批
# 这里只是检查操作是否能够执行

echo "测试内容" > "$TEST_FILE" 2>&1
if [ $? -eq 0 ]; then
    print_status "PASS" "可以创建文件"
    
    # 测试修改
    echo "修改内容" >> "$TEST_FILE" 2>&1
    if [ $? -eq 0 ]; then
        print_status "PASS" "可以修改文件"
    else
        print_status "FAIL" "无法修改文件"
    fi
    
    # 清理测试文件
    rm -f "$TEST_FILE" 2>&1
    if [ $? -eq 0 ]; then
        print_status "PASS" "可以删除文件"
    else
        print_status "WARN" "无法删除测试文件: $TEST_FILE"
    fi
else
    print_status "FAIL" "无法创建文件，可能存在权限问题"
fi

# 7. 检查环境变量
section_header "7. 环境变量检查"

# 检查可能相关的环境变量
ENV_VARS=("HOME" "PATH" "USER" "SHELL" "LANG")

for var in "${ENV_VARS[@]}"; do
    if [ -n "${!var}" ]; then
        print_status "INFO" "$var=${!var}"
    else
        print_status "WARN" "$var 未设置"
    fi
done

# 8. Agent 特定检查
section_header "8. Cloud Agent 特定检查"

print_status "INFO" "Agent ID: bc-9528fc4a-1045-416c-9345-94ea1fb212b5"
print_status "INFO" "Dashboard: https://cursor.com/agents/bc-9528fc4a-1045-416c-9345-94ea1fb212b5"

# 检查是否在 Cloud Agent 环境中运行
if [ -n "$CURSOR_CLOUD_AGENT" ]; then
    print_status "PASS" "在 Cloud Agent 环境中运行"
else
    print_status "INFO" "可能不在 Cloud Agent 环境中运行（本地测试）"
fi

# 检查 Cursor 相关目录
CURSOR_DIRS=(
    "/cursor/stores"
    "/tmp/cursor"
    "$HOME/.cursor"
)

for dir in "${CURSOR_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_status "PASS" "Cursor 目录存在: $dir"
    else
        print_status "INFO" "Cursor 目录不存在: $dir（可能正常）"
    fi
done

# 9. 总结报告
section_header "9. 诊断总结"

TOTAL=$((PASS + WARN + FAIL))
echo ""
echo -e "总检查项: ${BLUE}$TOTAL${NC}"
echo -e "通过: ${GREEN}$PASS${NC}"
echo -e "警告: ${YELLOW}$WARN${NC}"
echo -e "失败: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ] && [ $WARN -eq 0 ]; then
    echo -e "${GREEN}✓ 所有检查都通过了！${NC}"
    echo "如果审批卡仍然不显示，问题可能在前端界面或服务器端。"
    echo "建议："
    echo "  1. 刷新浏览器页面"
    echo "  2. 清除浏览器缓存"
    echo "  3. 检查浏览器控制台的错误信息"
    echo "  4. 尝试使用无痕模式"
elif [ $FAIL -gt 0 ]; then
    echo -e "${RED}✗ 发现 $FAIL 个严重问题！${NC}"
    echo "建议优先解决标记为 ✗ 的问题。"
else
    echo -e "${YELLOW}⚠ 发现 $WARN 个警告！${NC}"
    echo "这些警告可能不影响核心功能，但建议检查。"
fi

echo ""
echo "详细诊断步骤和解决方案，请查看："
echo "  - README.md"
echo "  - diagnose-approval-issue.md"
echo ""
echo "如需帮助，请访问："
echo "  - Dashboard: https://cursor.com/agents/bc-9528fc4a-1045-416c-9345-94ea1fb212b5"
echo "  - Support: https://cursor.com/support"
echo "  - Forum: https://forum.cursor.com"
echo ""
echo "========================================"
echo "诊断完成"
echo "========================================"

# 返回适当的退出码
if [ $FAIL -gt 0 ]; then
    exit 1
elif [ $WARN -gt 0 ]; then
    exit 2
else
    exit 0
fi
