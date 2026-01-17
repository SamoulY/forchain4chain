# forchain - 去中心化社交平台

forchain 是一个基于区块链的去中心化社交平台，部署在 Monad 测试网上。用户可以在平台上发帖、回复、转发和点赞，并获得 BAIT 代币奖励。

## 🌟 功能特性

### 🏗️ 智能合约
- **BAIT 代币合约**: 用于奖励用户的 ERC20 代币
- **Identity 身份合约**: 管理用户显示名称和唯一身份标识
- **Post 社交合约**: 处理发帖、回复、转发和点赞功能

### 💻 前端功能
- **钱包连接**: 支持 MetaMask 钱包连接
- **用户身份管理**: 设置和显示个性化用户名
- **社交互动**: 发帖、回复、转发、点赞
- **代币奖励**: 每次互动获得 1 BAIT 奖励
- **帖子搜索**: 在已加载的帖子中搜索内容
- **响应式设计**: 适配桌面端和移动端

### 🎨 界面设计
- 类似 Twitter 的三栏布局
- 深色主题，现代化设计
- 左侧：用户信息、发帖按钮、导航菜单
- 中间：发帖框和时间线
- 右侧：搜索功能、身份信息、余额显示

## 🚀 快速开始

### 前置要求
1. 安装 [MetaMask](https://metamask.io/) 浏览器扩展
2. 在 MetaMask 中添加 Monad 测试网网络
3. 获取测试网 MON 代币用于支付 Gas 费

### 部署地址
- **BAIT 合约**: `0xDE0CdE4306350DA70e8BA37ecBd525783fb7a93a`
- **Identity 合约**: `0x5601Af53965340746abA4f29b5E37F7c6c72387f`
- **Post 合约**: `0x76eCfa6cB85321728F474977760aD556FDaE5E47`

### 使用步骤
1. 打开 `index.html` 文件（可通过本地服务器运行）
2. 点击"连接钱包"按钮
3. 切换到 Monad 测试网
4. 在右侧边栏设置你的显示名称
5. 开始发帖、回复、转发和点赞

## 📁 项目结构
orchain/
├── index.html # 主前端文件
├── README.md # 项目说明文档
├── bait.sol # BAIT 代币合约
├── identity.sol # 身份合约
├── post.sol # 社交合约
└── contract-addresses.txt # 合约地址记录

## 🔧 技术栈

### 前端
- **HTML5/CSS3**: 页面结构和样式
- **JavaScript (ES6+)**: 交互逻辑
- **ethers.js v5.7.2**: 与区块链交互
- **Responsive Design**: 移动端适配

### 区块链
- **Solidity 0.8.19**: 智能合约开发
- **Monad Testnet**: 部署网络
- **ERC20**: 代币标准

## 💰 奖励机制

每次成功操作都会获得 1 BAIT 奖励：
- ✅ 发帖: +1 BAIT
- ✅ 回复: +1 BAIT
- ✅ 转发: +1 BAIT
- ❤️ 点赞: 无奖励（仅社交互动）

## 📱 响应式设计

### 桌面端 (≥1000px)
- 完整三栏布局
- 左侧边栏显示完整信息

### 平板端 (500px-1000px)
- 隐藏右侧边栏
- 左侧边栏简化

### 移动端 (<500px)
- 单栏布局
- 导航菜单移至底部
- 优化触控体验

## 🔍 搜索功能

搜索框位于右侧边栏顶部，支持：
- 按帖子内容搜索
- 按作者地址搜索
- 实时过滤显示结果

## ⚙️ 合约配置

前端会自动检查 BAIT 合约配置状态：
- ✅ **配置正确**: BAIT 合约已正确设置 Post 合约地址
- ⚠️ **需要配置**: 需要合约所有者设置 Post 合约地址
- ❌ **配置失败**: 无法读取合约配置

如果你是合约所有者，可以在前端直接修复配置。

## 🛠️ 开发说明

### 本地运行
1. 克隆仓库
2. 使用 VS Code Live Server 或任何静态文件服务器运行
3. 确保已安装 MetaMask 并连接到 Monad 测试网

### 合约交互
前端使用以下 ABI 与合约交互：
- **BAIT ABI**: 代币余额、铸造、配置
- **Identity ABI**: 设置和获取用户身份
- **Post ABI**: 社交功能、帖子查询

### 网络配置
```javascript
MONAD_TESTNET: {
  chainId: "0x279F", // 10143 十进制
  chainName: "Monad Testnet",
  rpcUrls: ["https://testnet-rpc.monad.xyz"],
  nativeCurrency: {
    name: "MON",
    symbol: "MON",
    decimals: 18
  }
}
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进项目！

待开发功能

用户个人资料页面
关注/取消关注功能
私信功能
图片上传（IPFS 集成）
帖子分类和标签
高级搜索功能
多语言支持
📄 许可证

本项目采用 MIT 许可证 - 查看 LICENSE 文件了解详情。

##📞 联系

如有问题或建议，请通过以下方式联系：

GitHub Issues: 提交问题
邮箱: voicechit@gmail.com

##🙏 致谢

Monad 测试网: 提供区块链基础设施
Monad Blitz
