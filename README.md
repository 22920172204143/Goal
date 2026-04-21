# Goal（小目标）

`Goal` 是一款把"现实收入记录"映射为"像素房间成长反馈"的个人财富激励应用。核心体验是：每记一笔收入，房间里的钱堆变多、小人做出搬钱庆祝动作，让用户在攒钱过程中获得即时的视觉成就感。

---

## 产品设计说明

### 一、应用定位

把每一笔现实收入映射为像素房间里可见的财富变化——钱堆随累计收入增长、小人有搬钱/庆祝动作，让用户**一眼就有赚钱攒钱的成就感**。

---

### 二、核心功能

| 功能 | 说明 |
|------|------|
| 收入记录 | 填写金额、分类（工资/副业/奖金/接单/理财/其他）、备注、日期 |
| 每日目标 | 设置每日目标金额，进度条实时显示完成比例 |
| 统计 | 今日 / 本周 / 本月 / 累计收入，连续记录天数 |
| 房间反馈 | 核心界面，收入越多房间越富（详见第三节）|
| 明细管理 | 查看、编辑、删除历史收入记录 |

---

### 三、房间反馈系统（最核心）

#### 场景素材
直接使用 [Star-Office-UI](https://github.com/ringhyacinth/Star-Office-UI) 的完整像素办公室场景——**保留原始背景图（office_bg.webp）、桌子（desk-v3.webp）、沙发、窗户等全套家具**，不要自己代码绘制房间，直接用原图铺满作为场景底图，还原像素风办公室的完整氛围。

#### 财富分层（从少到多）

```
tier 0（¥0）      → 桌面空，只有角色
tier 1（¥200+）   → 桌上出现 2 沓钱（整齐竖排）
tier 2（¥800+）   → 桌上 4 沓，右侧储物柜开始堆钱
tier 3（¥2000+）  → 桌上 6 沓 + 柜里满，地面开始出现钱袋
tier 4（¥5000+）  → 桌面全满 8 沓 + 地面钱袋/信封散落
```

**钱的展示原则**：
- 钱捆要有立体感，有光影和色差，不能是纯色 2D 矩形
- 整齐等间距排列，像真实钞票捆放在桌上
- 不同 tier 用不同颜色腰封区分（蓝→绿→金）
- 储物柜要视觉上在背景图中实际的柜子位置，不能放在空白处

#### 角色互动

| 状态 | 触发条件 | 素材 |
|------|---------|------|
| `celebrate` | 新记录后 8 秒 | `star_celebrate_32~37.png`，大幅上下弹跳 + 三颗闪光 |
| `work` | 今日收入 < 目标 60% | `star_work_0~7.png` |
| `read` | 轮转 | `star_read_16~23.png` |
| `phone` | 轮转 | `star_phone_8~15.png` |
| `idle` | 轮转 | `star_idle_0~7.png` |
| `sleep` | 23:00~06:00 | `cat_15.png` + Zzz |

**搬钱动作**：记录新收入时，角色进入 `celebrate` 状态（用专属 spritesheet），配合全屏金色光晕扩散动画，持续 8 秒后恢复正常状态。

#### 房间升级解锁
- Lv1（¥800+）：右上角出现海报、服务器机柜亮起动画
- Lv2（¥3000+）：桌边出现花盆（flower_10.png）
- Lv3（¥10000+）：小植物、宠物猫出现（cat_13/14/15.png）

---

### 四、界面设计

#### 主页（房间页）

```
┌─────────────────────────────┐
│  小目标              今日¥XX │  ← 顶部标题 + 今日金额
├─────────────────────────────┤
│                             │
│   ┌─────────────────────┐   │
│   │                     │   │
│   │   像素房间（4:3）    │   │  ← 房间占满宽度，高度约55%屏幕
│   │   office_bg全景图   │   │
│   │   桌上钱堆 + 角色   │   │
│   └─────────────────────┘   │
│                             │
│  ████████████░░░░  68%      │  ← 今日目标进度条
│  小人正在搬钱入柜。今天还差¥XX │  ← 状态文字
│                             │
│  [桌面 4沓] [柜子 6组] [Lv2] │  ← 状态芯片
│                             │
│  最近进账                    │
│  帮朋友修图 · 副业    ¥88   │
│  今日结算 · 工资      ¥168  │
└─────────────────────────────┘
```

#### 颜色方案（支持双模式）

**暗色模式（默认）**：
- 背景 `#111827`，卡片 `#26364F`，accent 绿 `#76E4AE`，金色 `#F2CD79`

**亮色模式**：
- 背景 `#FFFFFF`，卡片 `#F5F7FA`，文字 `#1A1D21`，accent 绿 `#2DB87A`，金色 `#D4A017`
- 切换入口在设置页，持久化保存

#### 整体风格
- Material 3，圆角卡片（18px），无边框投影
- 像素房间内部保持 `FilterQuality.none`（锐利像素风）
- 全局字体加粗（w700~w900），数字要大且醒目
- 底部导航：房间 / 明细 / 统计 / 设置

---

### 五、技术栈

| 层 | 方案 |
|----|------|
| 框架 | Flutter（Android 优先） |
| 状态管理 | `ChangeNotifier` + `AnimatedBuilder` |
| 持久化 | `shared_preferences` |
| 动画 | `AnimationController` 驱动帧切换 + 补间动画 |
| 素材 | `assets/star_office/`（Star-Office-UI 开源素材） |
| 包名 | `com.yourcompany.smallgoal.small_goal_app` |

---

### 六、参考资源

- **主要素材**：[Star-Office-UI](https://github.com/ringhyacinth/Star-Office-UI) — 像素办公室全套素材
- **角色行为参考**：[Pixel Agents](https://github.com/pablodelucca/pixel-agents)
- **场景布局参考**：[Lobster Lounge](https://github.com/tsconfigdotjson/lobster-lounge)

---

### 七、当前待解决问题（接管时优先处理）

1. 房间场景退回使用 `office_bg.webp` 全景背景图，不要代码绘制房间
2. 钱捆要有立体感（渐变/光影），不能是纯 2D 矩形
3. `celebrate` 状态要用 `star_celebrate_32~37.png`，动作要明显
4. 储物柜区域要落在背景图中实际的柜子位置上
5. 房间展示窗口占满屏幕宽度，高度比例 4:3
6. 支持亮色/暗色主题切换，在设置页配置

---

## 快速运行

```bash
flutter pub get
flutter run
```

仅打 Android Debug 包：

```bash
flutter build apk --debug
```

## Android Studio 一键运行注意事项

1. 打开项目根目录：`E:\AiProgram\Goal`
2. 确保已安装并启用插件：`Flutter`、`Dart`
3. Dart SDK 路径建议使用：
   - `E:\flutter\bin\cache\dart-sdk`
4. 设备建议固定：
   - AVD 名称：`goal`
   - 对应设备 ID 常见为：`emulator-5556`
5. 若出现签名冲突弹窗（different signature），可卸载旧包再装：
   - 包名：`com.yourcompany.smallgoal.small_goal_app`

## 主要目录

- `lib/controllers/`：应用状态控制
- `lib/services/`：统计与房间状态映射
- `lib/screens/`：页面结构
- `lib/widgets/star_office_room_stage.dart`：当前房间主舞台渲染
- `assets/star_office/`：复用素材与预切帧
- `docs/state_mapping.md`：收入到房间状态映射
- `docs/implementation_roadmap.md`：阶段路线
- `docs/AGENT_TAKEOVER_PROMPT.md`：给下一位 agent 的接管提示词

## 已知限制

- 当前仍有部分临时道具是"过渡实现"，需要进一步统一美术语义
- 素材版权策略尚未完成商用替换（当前目标是先把体验做顺）
- 工程根目录存在本地开发临时文件，不应提交构建缓存与截图产物
