# Cursor Cloud Agent 审批卡前端问题排查指南

## 问题现象

**用户报告**：云端 Agent 审批时，审批卡没有弹出，而是直接报错。

**可能的表现形式**：
1. 操作被直接拒绝，显示错误消息
2. 操作自动执行，没有审批提示
3. 页面加载不完整或卡住
4. 控制台出现 JavaScript 错误

## 前端技术问题分析

### 1. WebSocket 连接问题

审批卡的实时显示依赖 WebSocket 连接。如果连接断开或不稳定，审批请求可能无法送达前端。

#### 检查方法：
1. 打开浏览器开发者工具（F12）
2. 切换到 **Network** 标签
3. 筛选 **WS**（WebSocket）连接
4. 观察连接状态

**正常状态**：
- 应该看到一个或多个 WebSocket 连接
- 状态显示为 "101 Switching Protocols"
- 持续保持连接（绿色指示）

**异常状态**：
- 没有 WebSocket 连接
- 连接状态为红色（断开）
- 频繁重连
- 连接失败错误

#### 解决方案：

**方案 A：网络问题**
```javascript
// 检查 WebSocket 连接错误
// 在控制台中查看类似以下的错误：
// WebSocket connection to 'wss://cursor.com/...' failed: Error in connection establishment
```
解决：
- 检查防火墙设置，确保允许 WebSocket 连接
- 如果使用代理，确保代理支持 WebSocket
- 尝试关闭 VPN 后重试

**方案 B：CORS 或 CSP 策略**
检查控制台是否有类似错误：
```
Refused to connect to 'wss://...' because it violates the following Content Security Policy directive
```
解决：
- 这通常是浏览器安全策略问题
- 检查浏览器扩展是否干扰（尝试禁用所有扩展）
- 使用无痕模式测试

### 2. JavaScript 错误导致审批卡无法渲染

前端 JavaScript 错误可能阻止审批卡组件的加载和显示。

#### 检查方法：
1. 打开开发者工具 Console 标签
2. 查看是否有红色错误消息
3. 特别注意以下类型的错误：

**常见错误类型**：

```javascript
// 1. 组件加载失败
Uncaught Error: Loading chunk failed

// 2. React 组件错误
Error: Minified React error #

// 3. 未定义的变量或函数
Uncaught ReferenceError: ApprovalCard is not defined

// 4. 类型错误
Uncaught TypeError: Cannot read property 'show' of undefined

// 5. 异步加载问题
Uncaught (in promise) ChunkLoadError
```

#### 解决方案：

**方案 A：清除缓存**
```
Chrome/Edge:
Ctrl+Shift+Delete → 清除缓存的图像和文件 → 清除数据

Firefox:
Ctrl+Shift+Delete → 缓存 → 立即清除

Safari:
开发 → 清空缓存
```

**方案 B：强制刷新**
- Windows/Linux: `Ctrl + F5` 或 `Ctrl + Shift + R`
- Mac: `Cmd + Shift + R`

**方案 C：禁用浏览器扩展**
1. 尝试无痕/隐私模式（扩展通常默认禁用）
2. 如果无痕模式正常，逐个启用扩展找出问题扩展

### 3. CSS 加载失败导致审批卡不可见

审批卡可能已经渲染，但由于 CSS 未加载而不可见。

#### 检查方法：

1. 在 Network 标签中查看 CSS 文件的加载状态
2. 筛选 **CSS** 类型
3. 查看是否有加载失败（红色）的 CSS 文件

#### 检查元素是否存在但不可见：

```javascript
// 在 Console 中执行，检查审批相关元素是否存在
document.querySelectorAll('[class*="approval"]').length > 0
// 如果返回 > 0，说明元素存在但可能被隐藏

// 查找可能的审批弹窗元素
document.querySelectorAll('[role="dialog"]')
document.querySelectorAll('[class*="modal"]')
document.querySelectorAll('[class*="dialog"]')
```

#### 解决方案：

如果元素存在但不可见，尝试：

```javascript
// 强制显示所有可能的审批元素
document.querySelectorAll('[class*="approval"], [role="dialog"]').forEach(el => {
    el.style.display = 'block';
    el.style.visibility = 'visible';
    el.style.opacity = '1';
    el.style.zIndex = '99999';
});
```

**注意**：这只是临时调试方法，根本原因仍需修复。

### 4. React 组件状态管理问题

审批卡可能因为前端状态管理问题而无法显示。

#### 常见场景：

**场景 A：审批状态未正确更新**
- Agent 发送了审批请求
- 后端记录了请求
- 但前端 React 状态未更新

**场景 B：事件监听器丢失**
- 页面加载时注册了事件监听器
- 但某些操作导致监听器被移除
- 审批事件到达时没有处理器响应

#### 检查方法：

如果你有 React DevTools 扩展：

1. 打开 React DevTools
2. 查找审批相关的组件
3. 检查组件的 props 和 state

### 5. API 请求失败

审批卡的显示可能依赖某些 API 请求，如果这些请求失败，审批卡可能无法显示。

#### 检查方法：

1. Network 标签，筛选 **Fetch/XHR**
2. 查找与 `approval`、`review` 相关的请求
3. 检查请求状态码

**正常状态码**：
- 200 OK
- 201 Created
- 204 No Content

**异常状态码**：
- 400 Bad Request - 请求格式错误
- 401 Unauthorized - 未授权
- 403 Forbidden - 禁止访问
- 404 Not Found - 资源不存在
- 429 Too Many Requests - 请求过于频繁
- 500 Internal Server Error - 服务器错误
- 502 Bad Gateway - 网关错误
- 503 Service Unavailable - 服务不可用

#### 解决方案：

**401/403 错误**：
- 重新登录 Cursor 账号
- 检查 Token 是否过期
- 确认账号权限

**429 错误**：
- 等待一段时间后重试
- 降低操作频率

**500/502/503 错误**：
- 这是服务器端问题
- 查看 https://status.cursor.com 确认服务状态
- 等待后重试或联系支持

## 实际操作步骤

### 完整的排查流程

#### 步骤 1：打开开发者工具
```
Windows/Linux: F12 或 Ctrl+Shift+I
Mac: Cmd+Option+I
```

#### 步骤 2：重现问题
1. 清空 Console（点击垃圾桶图标）
2. 切换到 Network 标签，启用记录
3. 执行会触发审批的操作
4. 观察是否弹出审批卡

#### 步骤 3：检查 Console 错误
切换到 Console 标签，查看是否有错误：

**没有错误**：
- 问题可能在网络层或后端
- 继续检查 Network 标签

**有错误**：
- 记录完整的错误消息
- 注意错误的文件名和行号
- 截图保存

#### 步骤 4：检查 Network 请求

**检查 WebSocket**：
1. 筛选 WS
2. 确认有活跃的 WebSocket 连接
3. 点击连接查看消息流

**检查 XHR/Fetch**：
1. 查找审批相关的 API 请求
2. 检查响应状态码
3. 查看请求和响应内容

#### 步骤 5：检查元素
切换到 Elements 标签：

```javascript
// 在 Console 中执行
console.log('=== 审批元素检查 ===');
console.log('审批相关元素:', document.querySelectorAll('[class*="approval"]'));
console.log('对话框元素:', document.querySelectorAll('[role="dialog"]'));
console.log('模态框元素:', document.querySelectorAll('[class*="modal"]'));
```

### 快速修复技巧

#### 技巧 1：强制重新连接
```javascript
// 刷新 WebSocket 连接（如果可以访问到连接对象）
// 注意：这只是示例，实际对象名可能不同
if (window.wsConnection) {
    window.wsConnection.close();
    window.wsConnection.connect();
}
```

#### 技巧 2：清空本地存储
```javascript
// 清空可能损坏的本地数据
localStorage.clear();
sessionStorage.clear();
// 然后刷新页面
location.reload();
```

#### 技巧 3：注入调试代码
```javascript
// 监控所有 fetch 请求
const originalFetch = window.fetch;
window.fetch = function(...args) {
    console.log('Fetch called:', args);
    return originalFetch.apply(this, args)
        .then(response => {
            console.log('Fetch response:', response);
            return response;
        })
        .catch(error => {
            console.error('Fetch error:', error);
            throw error;
        });
};
```

## 浏览器特定问题

### Chrome/Edge

**已知问题**：
- 某些企业版本可能有额外的安全策略
- 第三方 Cookie 阻止可能影响功能

**解决**：
1. 检查 `chrome://settings/cookies`
2. 确保 cursor.com 不在阻止列表
3. 允许第三方 Cookie（仅用于 cursor.com）

### Firefox

**已知问题**：
- 增强型跟踪保护可能阻止某些请求
- 严格模式可能影响 WebSocket

**解决**：
1. 点击地址栏左侧的盾牌图标
2. 临时禁用保护测试
3. 如果解决问题，添加 cursor.com 为例外

### Safari

**已知问题**：
- 跨站跟踪预防可能影响功能
- 更严格的 CORS 策略

**解决**：
1. 开发 → 停用跨站跟踪预防（仅用于测试）
2. 偏好设置 → 隐私 → 取消勾选"阻止所有 Cookie"

## 收集诊断信息

如果需要向技术支持报告问题，请收集以下信息：

### 1. 基本信息
```
- 浏览器: [名称和版本]
- 操作系统: [名称和版本]
- Cursor 账号: [邮箱]
- Agent ID: bc-9528fc4a-1045-416c-9345-94ea1fb212b5
- 发生时间: [UTC+8 时区时间]
```

### 2. 错误信息
- Console 中的所有错误（截图）
- Network 中失败的请求（截图）
- 错误消息的完整文本

### 3. 网络信息
```javascript
// 在 Console 中执行并保存结果
console.log('User Agent:', navigator.userAgent);
console.log('Online:', navigator.onLine);
console.log('Language:', navigator.language);
console.log('Cookies Enabled:', navigator.cookieEnabled);
```

### 4. 重现步骤
详细记录：
1. 操作前的状态
2. 执行的具体操作
3. 预期的结果
4. 实际的结果

### 5. 录屏
如果可能，录制操作过程，包括：
- 打开开发者工具
- 执行操作
- 显示错误

## 临时解决方案

如果审批卡确实无法使用，可以尝试以下替代方案：

### 方案 1：使用其他浏览器
如果在 Chrome 中有问题，尝试：
- Firefox
- Edge
- Safari
- Brave

### 方案 2：使用 Cursor 桌面客户端
如果有桌面客户端可用：
1. 下载并安装 Cursor Desktop
2. 登录相同账号
3. 在桌面客户端中使用 Cloud Agent

### 方案 3：调整 Agent 配置
如果控制权限允许，暂时调整配置：
- 对非关键操作使用较低的审批级别
- 仅对敏感操作保留严格审批

**注意**：这只是临时方案，不应长期使用。

## 预防措施

### 日常维护
1. **定期更新浏览器**
   - 保持浏览器为最新版本
   - 启用自动更新

2. **管理浏览器扩展**
   - 定期审查安装的扩展
   - 移除不必要的扩展
   - 确保扩展来自可信来源

3. **清理浏览器数据**
   - 定期清除缓存（每月）
   - 清理过期的 Cookie
   - 但保留登录状态

4. **网络环境优化**
   - 使用稳定的网络连接
   - 避免使用不稳定的 VPN
   - 企业环境确保防火墙规则正确

### 最佳实践

1. **在开始重要工作前**：
   - 测试审批功能是否正常
   - 执行一个简单的需要审批的操作
   - 确认审批卡可以正常显示

2. **遇到问题时**：
   - 首先尝试刷新页面
   - 检查网络连接
   - 查看开发者工具
   - 记录错误信息

3. **报告问题时**：
   - 提供详细的重现步骤
   - 附上截图或录屏
   - 包含系统和浏览器信息
   - 说明已尝试的解决方案

## 相关资源

### 官方文档
- Cursor 文档: https://docs.cursor.com
- Cloud Agents 指南: https://docs.cursor.com/cloud-agents

### 支持渠道
- 技术支持: https://cursor.com/support
- 社区论坛: https://forum.cursor.com
- GitHub Issues: [如果是开源项目]

### 状态页面
- Cursor 服务状态: https://status.cursor.com
- 查看实时服务状态和历史事件

### 开发者资源
- Chrome DevTools: https://developer.chrome.com/docs/devtools/
- Firefox Developer Tools: https://firefox-source-docs.mozilla.org/devtools-user/
- WebSocket 调试: https://javascript.info/websocket

---

**文档版本**: 1.0  
**最后更新**: 2026-10-29 07:31 (UTC+8)  
**维护者**: Cloud Agent Diagnostic Team  
**Agent ID**: bc-9528fc4a-1045-416c-9345-94ea1fb212b5
