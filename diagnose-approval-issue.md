# Cloud Agent 审批问题诊断工具

## 当前运行信息
- **Agent ID**: bc-9528fc4a-1045-416c-9345-94ea1fb212b5
- **状态**: 运行中
- **仓库**: github.com/jacktou/school-skills
- **模型**: claude-4.5-sonnet-thinking
- **Dashboard**: https://cursor.com/agents/bc-9528fc4a-1045-416c-9345-94ea1fb212b5

## 审批卡不显示的常见原因

### 1. 前端界面问题
**症状**：审批请求已发送，但前端没有正确渲染审批卡

**可能的原因**：
- 浏览器兼容性问题
- JavaScript 错误阻塞了界面渲染
- CSS 加载失败导致审批卡不可见
- WebSocket 连接断开

**排查方法**：
```javascript
// 打开浏览器开发者工具 (F12)
// 检查 Console 标签页是否有错误
// 检查 Network 标签页，查看 WebSocket 连接状态
```

**解决方案**：
1. 刷新页面 (F5 或 Ctrl+R)
2. 清除浏览器缓存后重新加载
3. 使用无痕模式打开
4. 尝试不同的浏览器（Chrome、Edge、Firefox）
5. 检查是否有浏览器扩展干扰

### 2. 审批请求超时
**症状**：等待用户审批时超时，直接返回错误

**可能的原因**：
- 网络延迟过高
- 服务器响应超时
- 审批等待时间超过系统限制

**排查方法**：
```bash
# 检查网络连接
ping cursor.com

# 检查网络延迟
curl -w "@curl-format.txt" -o /dev/null -s https://cursor.com
```

**解决方案**：
1. 检查网络连接是否稳定
2. 如果使用 VPN，尝试切换节点或关闭 VPN
3. 重启路由器
4. 联系网络管理员检查防火墙设置

### 3. 权限配置问题
**症状**：某些操作被直接拒绝，没有审批选项

**可能的原因**：
- 用户账号权限不足
- 团队设置限制了审批流程
- MCP 工具权限配置错误

**排查步骤**：

#### 检查个人权限
1. 访问 Cursor Settings: https://cursor.com/settings
2. 检查账号类型（Free / Pro / Business）
3. 确认订阅状态正常

#### 检查团队权限（如果使用团队账号）
1. 访问 Team Settings
2. 检查 Cloud Agents 设置
3. 确认 MCP 工具权限已启用
4. 检查是否有操作限制

#### 检查 MCP 工具权限
如果错误与特定 MCP 工具相关：
1. 访问 Cursor Dashboard → MCP Settings
2. 检查相关工具的认证状态
3. 重新授权 OAuth（如果需要）

### 4. 操作类型不支持审批
**症状**：某些操作不会触发审批卡，而是直接执行或拒绝

**说明**：
并非所有操作都需要审批。以下操作通常会触发审批：

**需要审批的操作**：
- 文件的创建、修改、删除
- Shell 命令执行
- Git 操作（push、commit、创建 PR）
- 访问外部 API
- MCP 工具调用（取决于配置）

**不需要审批的操作**：
- 文件读取
- 代码搜索
- 查看文档
- 获取系统信息

### 5. 系统级别错误
**症状**：后端系统错误导致审批流程中断

**可能的错误类型**：
```
- 500 Internal Server Error
- 502 Bad Gateway
- 503 Service Unavailable
- 504 Gateway Timeout
```

**解决方案**：
1. 等待几分钟后重试
2. 检查 Cursor 状态页面：https://status.cursor.com
3. 如果问题持续，提交支持工单

## 具体操作指南

### 如何捕获错误详情

#### 方法 1：查看 Dashboard 事件日志
1. 访问你的 Agent Dashboard：
   https://cursor.com/agents/bc-9528fc4a-1045-416c-9345-94ea1fb212b5
2. 查看 "Events" 标签页
3. 记录所有 error 级别的事件
4. 截图保存

#### 方法 2：使用浏览器开发者工具
1. 在 Cursor 页面打开开发者工具（F12）
2. 切换到 "Console" 标签
3. 尝试重现问题
4. 记录所有红色错误信息
5. 切换到 "Network" 标签
6. 查看失败的请求（红色显示）
7. 点击查看详细的请求和响应信息

#### 方法 3：检查浏览器控制台的网络请求
```javascript
// 在 Console 中执行，监控审批相关的 API 调用
window.addEventListener('fetch', (event) => {
  if (event.request.url.includes('approval') || event.request.url.includes('review')) {
    console.log('Approval API called:', event.request.url);
  }
});
```

### 测试审批流程

创建一个简单的测试文件来触发审批：

```bash
# 在 agent 中执行这些命令应该会触发审批卡

# 1. 创建文件（应该触发审批）
echo "test" > test-approval.txt

# 2. 修改文件（应该触发审批）
echo "modified" >> test-approval.txt

# 3. 删除文件（应该触发审批）
rm test-approval.txt

# 4. Git 操作（应该触发审批）
git status
```

观察每个操作是否：
- ✅ 正确显示审批卡
- ❌ 直接报错
- ⚠️ 自动执行（没有审批）

### 记录问题详情

如果问题持续存在，请记录以下信息：

```
问题报告模板：
====================
1. 问题描述：
   - 症状：审批卡不显示 / 直接报错
   - 错误消息：[复制完整错误信息]

2. 复现步骤：
   - 步骤 1：
   - 步骤 2：
   - 步骤 3：

3. 环境信息：
   - 操作系统：
   - 浏览器：[名称 + 版本]
   - Cursor 版本：
   - Agent ID：bc-9528fc4a-1045-416c-9345-94ea1fb212b5

4. 已尝试的解决方案：
   - [ ] 刷新页面
   - [ ] 清除缓存
   - [ ] 更换浏览器
   - [ ] 检查网络
   - [ ] 其他：

5. 截图/录屏：
   - [附加截图或录屏链接]

6. 控制台错误日志：
   - [复制浏览器控制台的错误信息]
====================
```

## 应急解决方案

如果审批卡确实无法显示，可以尝试以下替代方案：

### 方案 1：使用命令行工具
对于某些操作，可以直接在命令行中执行并确认：

```bash
# 使用 --help 查看命令选项
cursor --help

# 查看可用的命令行参数
cursor agent --help
```

### 方案 2：调整 Agent 配置
如果使用 Docker Agent，可以调整 safety 模式：

```yaml
# agent.yaml
agents:
  my-agent:
    model: claude-4.5-sonnet
    instruction: "..."
    # 使用更宽松的模式（仅用于开发环境）
```

运行时使用：
```bash
# 平衡模式（推荐）
docker agent run --safety balanced

# 受限模式
docker agent run --safety restricted
```

### 方案 3：联系技术支持
如果以上方案都无效：

1. **访问 Cursor 社区**：https://forum.cursor.com
2. **提交支持工单**：https://cursor.com/support
3. **加入 Discord**：获取实时帮助

提交工单时，请包含：
- Agent ID: bc-9528fc4a-1045-416c-9345-94ea1fb212b5
- Dashboard 链接
- 完整的错误信息
- 问题复现步骤

## 预防措施

为了避免将来出现类似问题：

### 1. 保持软件更新
- 定期更新 Cursor 客户端
- 保持浏览器为最新版本
- 及时更新系统和驱动

### 2. 优化网络环境
- 使用稳定的网络连接
- 避免使用不稳定的 VPN
- 配置合理的防火墙规则

### 3. 正确的权限配置
- 确保账号权限充足
- 定期检查团队设置
- 及时续费订阅

### 4. 监控和日志
- 定期检查 Dashboard 事件日志
- 关注系统通知
- 保存重要操作的记录

## 后续跟进

解决问题后，建议：

1. **记录解决方案**：在项目中记录解决的方法，方便以后参考
2. **更新文档**：将新发现的问题和解决方案添加到文档中
3. **分享经验**：如果是常见问题，可以在社区中分享解决方案
4. **反馈改进**：向 Cursor 团队反馈问题，帮助改进产品

---

**更新时间**: 2026-10-29 07:31 UTC+8
**文档版本**: 1.0
