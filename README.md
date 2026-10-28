# school-skills

## 项目说明

本仓库用于记录和解决 Cursor Cloud Agent 相关的技术问题和最佳实践。

## 内容概述

本项目包含以下内容：

1. **Cloud Agent 审批卡问题诊断** - 完整的问题分析和解决方案
2. **自动化诊断工具** - 快速检查系统环境和配置
3. **前端问题排查指南** - 针对浏览器端的详细调试方法

## 文档列表

### 主要文档

- **[README.md](README.md)** - 本文档，项目总览
- **[diagnose-approval-issue.md](diagnose-approval-issue.md)** - 详细的审批问题诊断步骤和解决方案
- **[approval-card-frontend-guide.md](approval-card-frontend-guide.md)** - 前端审批卡问题专项排查指南

### 工具脚本

- **[quick-check.sh](quick-check.sh)** - 自动化诊断脚本，快速检查环境配置

## 快速开始

### 运行诊断脚本

```bash
# 给脚本添加执行权限
chmod +x quick-check.sh

# 运行诊断
./quick-check.sh
```

诊断脚本会检查：
- 网络连接状态
- 运行环境配置
- 文件系统权限
- 系统资源
- 必要工具安装情况
- Cloud Agent 特定配置

## Cloud Agent 审批卡问题

### 问题描述

**现象**：云端 agent 在执行需要审批的操作时，没有弹出审批卡片，而是直接报错。

### 可能的原因

1. **操作超时** - 审批请求等待用户响应时超时
2. **权限配置问题** - Agent 审批流程配置不正确或用户权限不足
3. **MCP 工具认证失败** - OAuth 认证流程失败
4. **Docker Agent Safety 模式** - Safety 模式配置不当
5. **浏览器或客户端缓存** - 缓存导致审批界面无法正常显示
6. **WebSocket 连接问题** - 实时通信连接断开
7. **前端 JavaScript 错误** - 组件加载或渲染失败

### 快速解决方案

#### 1. 基础检查
```bash
# 检查网络连接
ping cursor.com

# 查看 Agent Dashboard
# 访问: https://cursor.com/agents/<your-agent-id>
```

#### 2. 浏览器端检查
- 刷新页面（F5 或 Ctrl+R）
- 清除浏览器缓存
- 使用无痕模式测试
- 打开开发者工具（F12）检查错误

#### 3. 环境检查
- 确认网络稳定
- 检查 Cursor 客户端版本
- 验证账号权限

### 详细解决步骤

请查看 [diagnose-approval-issue.md](diagnose-approval-issue.md) 获取完整的诊断和解决步骤。

## MCP 工具认证

如果问题与 MCP 工具相关：

```bash
# 重新认证 MCP（针对 Agent SDK 项目）
npx --yes "@grok/agent-sdk@0.5.0" mcp oauth
```

## Docker Agent Safety 模式

如果使用 Docker Agent，可用的 Safety 模式：

- `strict`（默认）- 所有工具调用都需要审批
- `balanced` - 危险操作需要审批
- `restricted` - 仅特定操作需要审批  
- `autonomous` - 自动执行，不需要审批（需要 `--yolo` 标志）

```bash
# 查看当前配置
docker agent doctor

# 使用不同的 safety 模式运行
docker agent run --safety balanced
```

## 前端调试技巧

打开浏览器开发者工具（F12）：

1. **Console 标签** - 查看 JavaScript 错误
2. **Network 标签** - 检查 API 请求和 WebSocket 连接
3. **Elements 标签** - 检查审批卡元素是否存在

详细的前端调试方法请查看 [approval-card-frontend-guide.md](approval-card-frontend-guide.md)。

## 常见错误类型

### MCP 认证错误 (mcp_auth_error)
- 检查 MCP 服务器配置
- 重新进行 OAuth 认证
- 确认 API 密钥正确配置

### 审批超时错误
- 缩短响应时间
- 检查客户端是否在线
- 确认通知设置正确

### 权限不足错误
- 联系管理员分配权限
- 检查团队设置
- 确认个人账号状态

## 项目结构

```
.
├── README.md                           # 项目说明（本文档）
├── diagnose-approval-issue.md          # 详细诊断指南
├── approval-card-frontend-guide.md     # 前端问题排查指南
├── quick-check.sh                      # 自动化诊断脚本
└── .git/                              # Git 版本控制目录
```

## 获取帮助

如果上述方案都无法解决问题：

### 1. 收集诊断信息
运行诊断脚本并保存结果：
```bash
./quick-check.sh > diagnostic-report.txt 2>&1
```

### 2. 查看官方资源
- **Cursor 文档**: https://docs.cursor.com
- **Cloud Agents 指南**: https://docs.cursor.com/cloud-agents
- **服务状态**: https://status.cursor.com

### 3. 联系技术支持
- **社区论坛**: https://forum.cursor.com
- **技术支持**: https://cursor.com/support
- **GitHub Issues**: 针对开源项目

提交支持请求时，请包含：
- 完整的错误消息
- 诊断脚本输出
- 操作的详细步骤
- 浏览器和系统信息
- Agent ID 和 Dashboard 链接

## 最佳实践

### 开发环境配置
1. 始终使用最新版本的 Cursor
2. 定期检查和更新 Agent SDK
3. 保持网络连接稳定
4. 合理配置 safety 模式

### 审批流程优化
1. 对于频繁操作，考虑调整 safety 模式
2. 使用 `--sandbox` 标志进行隔离测试
3. 在开发环境中使用更宽松的审批设置
4. 在生产环境中使用严格的审批流程

### 日常维护
1. 定期更新浏览器
2. 管理浏览器扩展
3. 定期清理浏览器数据
4. 优化网络环境

## 贡献指南

欢迎为本项目做出贡献！如果你：
- 发现了新的问题和解决方案
- 有更好的诊断方法
- 想要改进现有文档
- 发现了文档错误

请提交 Pull Request 或创建 Issue。

## 更新记录

- **2026-10-29** - 创建初始版本
  - 添加审批卡问题诊断文档
  - 创建自动化诊断脚本
  - 添加前端问题排查指南
  - 完善项目文档结构

## 许可证

MIT License

---

**维护者**: Cloud Agent Diagnostic Team  
**最后更新**: 2026-10-29 07:31 (UTC+8)
