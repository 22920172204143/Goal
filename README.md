# Goal（小目标）

把每一笔现实收入映射为像素房间里可见的财富变化——**钱堆随累计收入增长、小人在记录新收入时做庆祝动作**，让用户在攒钱过程中获得即时的视觉成就感。

> 这份 README 同时也是 **Agent 交接文档**，后续 Agent 接手时请先完整阅读。

---

## 一、应用是什么

`Goal` 是一个面向个人的收入记录 + 游戏化反馈应用，基于 Flutter 开发，以 Android 为主。

**核心体验**：
- 用户手动记录每一笔收入（金额、分类、备注、日期）
- 主界面是一个像素风办公室，里面有一张桌子、一个小人
- 累计收入越多 → 桌上钱堆越多、储物柜越满、房间等级越高
- 每次新记录 → 小人进入 `celebrate` 状态，做出搬钱 / 庆祝动作，配合金色光晕

**与普通记账 App 的差异**：重点不是"记账"，而是"把看不见的钱变成看得见的房间"。

---

## 二、产品目标

| 目标 | 说明 |
|------|------|
| 即时反馈 | 一记就看到房间变化，不需要切页 |
| 成就可视化 | 一眼看出最近赚了多少 / 攒了多少 |
| 长期黏性 | 连续记录天数、目标达成、房间升级带来正反馈 |
| 低负担 | 只要记金额 + 分类就够，不强制备注 |

---

## 三、视觉风格

### 素材来源（必须保留）

**直接使用 [Star-Office-UI](https://github.com/ringhyacinth/Star-Office-UI) 的开源像素素材**，已拷贝到 `assets/star_office/`。

关键素材（**不要删，不要代码重绘替换**）：

| 文件 | 用途 |
|------|------|
| `office_bg.webp` | 整张办公室全景背景图（房间舞台底图） |
| `desk-v3.webp` | 桌子（左区） |
| `sofa-idle-v3.png` | 沙发（中区，阅读/玩手机状态位置） |
| `serverroom_0~5.png` | 服务器机柜帧动画（右区，Lv1 后出现） |
| `poster_0/4/8/12.png` | 墙面海报（按房间等级切换） |
| `flower_2/5/10/15.png` | 桌边花盆（按房间等级切换） |
| `cat_13/14/15.png` | 宠物猫（房间等级 1 后出现） |
| `star_idle_0~7.png` | 角色闲逛动画 |
| `star_work_0~7.png` | 角色工作动画 |
| `star_read_16~23.png` | 角色阅读动画 |
| `star_phone_8~15.png` | 角色刷手机动画 |
| `star_celebrate_32~37.png` | **角色庆祝动画（新记录后播放）** |
| `coffee_0~7.png` | 咖啡机帧动画（可放桌边） |

### 关键视觉原则

1. **整张办公室全景作为底图**，不要只显示一个房间；左中右三区（桌子 / 沙发 / 服务器机柜）同时可见
2. **不要代码绘制墙壁、地板、窗户**——所有场景元素来自素材图
3. **钱堆是代码绘制的小部件**（`_MoneyBundle`），覆盖在桌面、柜子、地板的正确像素坐标上
4. **安卓端曾出现 spritesheet 错帧 / 乱码条纹**，解决方案是用**预切单帧 PNG 切换**，不要用 SpriteSheet 组件

---

## 四、界面设计

### 主页（房间页）

```
┌──────────────────────────────┐
│  小目标                       │  ← 标题
│  把现实收入堆进你的像素房间里  │  ← 副标题
│                              │
│ [今日 ¥XX]   [连续 N 天]      │  ← 指标卡
│                              │
│ ┌──────────────────────────┐ │
│ │                          │ │
│ │    像素办公室全景 16:9    │ │  ← 房间舞台
│ │  (office_bg + 角色 + 钱)  │ │
│ │                          │ │
│ └──────────────────────────┘ │
│  ████████░░░░  进度条         │  ← 今日目标
│  小人正在搬钱入柜。还差 ¥XX   │  ← 状态文字
│ [桌面 4沓] [柜子 6组] [Lv2]   │  ← 状态芯片
│                              │
│  最近进账                     │
│  帮朋友修图 · 副业      ¥88  │
│  今日结算 · 工资       ¥168  │
└──────────────────────────────┘
                         [+ 记收入]  ← FAB
```

### 四个 Tab

- **房间**：主界面，游戏化反馈
- **明细**：全部收入记录，可编辑 / 删除
- **统计**：今日 / 周 / 月 / 累计
- **设置**：每日目标、策略说明、参考项目

### 颜色方案

**暗色模式（默认）**：
- 背景 `#111827`，卡片 `#26364F`
- accent 绿 `#76E4AE`，金色 `#F2CD79`

**亮色模式（待接入，issue 列表中）**：
- 背景 `#FFFFFF`，卡片 `#F5F7FA`，文字 `#1A1D21`
- accent 绿 `#2DB87A`，金色 `#D4A017`

---

## 五、数据层（**禁止改动**）

### 状态模型

- `lib/models/income_record.dart`：单笔收入记录
- `lib/models/app_stats.dart`：派生统计数据（今日/周/月/累计/连续天数/进度）
- `lib/models/app_settings.dart`：用户设置（目标、货币、策略）
- `lib/models/room_visual_state.dart`：房间视觉状态（钱堆数、房间等级、角色状态、庆祝动画 nonce）

### 收入 → 房间状态的映射（`lib/services/room_state_service.dart`）

#### 钱堆层级（`moneyTier`）
| 累计收入 | tier |
|---------|------|
| ≥ ¥5000 | 4 |
| ≥ ¥2000 | 3 |
| ≥ ¥800  | 2 |
| ≥ ¥200  | 1 |
| 其他    | 0 |

#### 桌面 / 柜子 / 地面钱堆数量
| 累计收入 | deskStack | cabinetStack | floorCash |
|---------|-----------|--------------|-----------|
| ≥ ¥8000 | 8 | 9 | 5 |
| ≥ ¥5000 | 8 | 9 | 3 |
| ≥ ¥3000 | 6 | 6 | 1 |
| ≥ ¥2500 | 6 | 3 | 1 |
| ≥ ¥2000 | 6 | 3 | 0 |
| ≥ ¥1200 | 4 | 3 | 0 |
| ≥ ¥800  | 4 | 0 | 0 |
| ≥ ¥200  | 2 | 0 | 0 |
| > ¥0    | 1 | 0 | 0 |
| 其他    | 0 | 0 | 0 |

#### 房间等级（`roomUpgradeLevel`）
| 累计收入 | 等级 | 解锁内容 |
|---------|------|---------|
| ≥ ¥10000 | 3 | 小植物、顶级宠物 |
| ≥ ¥3000  | 2 | 桌边花盆 |
| ≥ ¥800   | 1 | 墙面海报 + 服务器机柜动画 + 基础宠物 |
| 其他     | 0 | 基础房间 |

#### 角色状态（`AvatarState`）
- `celebrate`：新记录后 8 秒内（`lastCelebrationAt` 触发）
- `sleep`：当前时间 23:00 ~ 06:00
- `work`：今日收入 < 目标 60%
- 其他：`read / phone / idle / work` 按分钟轮转

### 即时反馈

`AppController.addIncome()` 会：
1. 插入新记录，排序保存
2. 更新 `_lastCelebrationAt = now`
3. 递增 `_animationNonce`
4. 触发 `notifyListeners()`
5. 房间舞台检测到 `animationNonce` 变化 → 角色进入 `celebrate` 状态 8 秒

---

## 六、代码结构

```
lib/
├── main.dart                          入口
├── app/
│   ├── app.dart                       MaterialApp + AppController 持有
│   └── theme.dart                     暗色主题定义
├── controllers/
│   └── app_controller.dart            唯一状态中心（ChangeNotifier）
├── models/                            数据模型（禁止改动字段含义）
│   ├── income_record.dart
│   ├── app_stats.dart
│   ├── app_settings.dart
│   └── room_visual_state.dart
├── services/                          纯函数映射层
│   ├── stats_service.dart             记录 → 统计
│   └── room_state_service.dart        统计 → 视觉状态
├── repositories/
│   └── local_app_repository.dart      shared_preferences 持久化
├── screens/                           页面
│   ├── home_shell.dart                底部导航
│   ├── room_page.dart                 房间页
│   ├── records_page.dart              明细页
│   ├── stats_page.dart                统计页
│   └── settings_page.dart             设置页
├── widgets/
│   ├── star_office_room_stage.dart    ★ 房间主舞台（视觉重点）
│   ├── income_editor_sheet.dart       记录编辑 BottomSheet
│   └── metric_card.dart               指标卡
└── utils/
    └── formatters.dart                金额 / 日期格式化

assets/star_office/                    Star-Office-UI 素材（不要删）
docs/
├── state_mapping.md                   收入→房间映射详解
├── implementation_roadmap.md          路线图
├── open_source_references.md          开源参考
└── AGENT_TAKEOVER_PROMPT.md           下一位 agent 的提示词
```

---

## 七、技术栈

| 层 | 方案 |
|----|------|
| 框架 | Flutter 3.x（Android 优先） |
| 状态管理 | `ChangeNotifier` + `AnimatedBuilder` |
| 持久化 | `shared_preferences`（仅两个 key：`income_records`、`app_settings`） |
| 动画 | `AnimationController` 驱动 tick 做单帧切换 |
| 图片质量 | `FilterQuality.none`（保持像素锐利） |
| 包名 | `com.yourcompany.smallgoal.small_goal_app` |

---

## 八、运行 / 构建

### 开发运行

```bash
flutter pub get
flutter run -d emulator-5556
```

模拟器 AVD 名：`goal`，设备 ID：`emulator-5556`

### 打包 Debug APK

```bash
flutter build apk --debug
# 产物：build/app/outputs/flutter-apk/app-debug.apk
```

需要 **JDK 17**（Android Gradle Plugin 要求），Java 11 会编译失败。

### 每次改动后必做

```bash
flutter analyze   # 必须无问题
```

---

## 九、当前待解决问题（按优先级）

> **接管后按顺序处理这些**，不要再次做大范围重构。

1. **亮色 / 暗色双主题切换**
   - 在 `AppSettings` 加 `isDarkMode` 字段（默认 `true`），需要在 `fromJson` 兼容缺失
   - 在 `theme.dart` 加一份 `buildSmallGoalLightTheme()`
   - 在 `app.dart` 用 `ThemeMode` + `themeMode: settings.isDarkMode ? dark : light`
   - 在设置页加 Switch 入口
   - 注意：`metric_card.dart`、`room_page.dart`、`settings_page.dart` 里有硬编码 `Colors.white70` / `Color(0xFF223147)`，亮色下要改成 `Theme.of(context).colorScheme.onSurfaceVariant` 之类

2. **钱堆视觉立体感**
   - 当前 `_MoneyBundle` 是纯 2D 矩形，要有渐变 / 光影 / 多层钞票叠放的深度感
   - 可以用多个 `Container` 垂直偏移叠放模拟厚度
   - 不同 tier 颜色腰封要更明显（蓝 → 绿 → 金渐进）

3. **房间展示比例**
   - 当前 `aspectRatio: 16/9`，可改为 `4/3` 或 `5/4` 让房间更高、更显眼
   - 同时检查各元素像素坐标是否需要微调

4. **庆祝动作更明显**
   - `star_celebrate_32~37.png` 已在用，但可以再加：
     - 钱从右上角飞向桌面的过场动画
     - 角色旁边出现一个小钱袋 `_MoneyBag`
     - 全屏金色光晕扩散

5. **素材商用替换（中长期）**
   - Star-Office-UI 是 MIT License 但最终发布前需要评估
   - 备选：LPC（Liberated Pixel Cup）素材、Kenney.nl 免费素材

---

## 十、约束（**必须遵守**）

从 `docs/AGENT_TAKEOVER_PROMPT.md` 迁移：

- **不要改包名、统计口径、已有持久化字段**
- **不要提交构建缓存、IDE 临时文件、本地截图**
- **每轮改动后至少跑一次 `flutter analyze`**
- **大改前先给出 3~5 条最小改动计划，得到用户确认后再实施**
- **不要重做基础架构**（数据层已稳定）
- **不要代码绘制替换原始场景素材**（保留 `office_bg.webp` 等）

---

## 十一、参考项目

- **主要素材（已接入）**：[Star-Office-UI](https://github.com/ringhyacinth/Star-Office-UI) — 像素办公室全套素材
- **角色行为参考**：[Pixel Agents](https://github.com/pablodelucca/pixel-agents)
- **场景布局参考**：[Lobster Lounge](https://github.com/tsconfigdotjson/lobster-lounge)
- **人物生成器（未来扩展）**：[Universal LPC Generator](https://github.com/LiberatedPixelCup/Universal-LPC-Spritesheet-Character-Generator)

---

## 十二、每轮交付清单

提交前附带：
- **变更点**：改了什么
- **影响范围**：哪些文件 / 哪些功能
- **验证方式**：至少一条设备 / 模拟器验证步骤
- **flutter analyze 结果**：必须 `No issues found!`

如果需要打包安装，产物规则：
- APK 放到旧服务器 `liq@172.16.246.15:/mnt/liq/work/temp/goal.apk`
- 用户从那里下载到手机安装

---

**接管后请先阅读 `lib/widgets/star_office_room_stage.dart` 和本 README 第九节，再开始迭代。**
