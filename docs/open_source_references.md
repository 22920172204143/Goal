# 开源参考与素材策略

`小目标` 首版遵循“零自绘”原则，不要求手工绘制角色、房间、家具或逐帧动画。

当前项目里已经落地的是：

- 使用 `Flutter + Flame` 完成房间场景和动画驱动
- 使用纯代码渲染实现基础像素房间、小人状态和现金飞入效果
- 保留后续接入现成开源 spritesheet / tileset 的结构

## 已选参考项目

### `pablodelucca/pixel-agents`

链接：<https://github.com/pablodelucca/pixel-agents>

本项目主要借鉴：

- agent 状态到像素角色动作的映射思路
- 主场景承载业务信息的方式
- “看得见工作状态”的产品表达

在 `小目标` 中的对应落地：

- 收入状态映射为 `work / read / phone / idle / sleep / celebrate`
- 房间首页作为应用主页面
- 记录收入后，小人和现金堆会即时发生变化

### `tsconfigdotjson/lobster-lounge`

链接：<https://github.com/tsconfigdotjson/lobster-lounge>

本项目主要借鉴：

- 像素空间承载 UI 的方式
- 情绪化房间氛围
- 角色存在于主画面中的“陪伴感”

在 `小目标` 中的对应落地：

- 房间页上方保留业务指标，下方保留像素房间主视图
- 不做传统表格首页，而是用房间承载反馈

## 后续可接入的开源人物素材

### `Universal LPC Spritesheet Character Generator`

链接：<https://github.com/LiberatedPixelCup/Universal-LPC-Spritesheet-Character-Generator>

建议用途：

- 替换当前纯代码人物，接入真实像素人物 spritesheet
- 优先选用站立、行走、阅读、工作、休息等基础动作

注意事项：

- 不同部件素材 license 可能不同
- 接入前需要整理 attribution 清单
- 若要上线商用，优先选择授权最清晰的组合

## 后续可接入的开源室内素材

建议筛选原则：

- 只选 `CC0` 或明确允许免费/商用的 tileset
- 统一尺寸体系，例如全部 16x16 或全部 32x32
- 首版只接一套风格，避免混搭

建议素材类型：

- 地板和墙面
- 床、桌子、椅子、柜子、书架
- 纸币堆、钱箱、保险柜

## 首版为什么先用纯代码像素渲染

虽然目标是复用开源像素资源，但首版优先用代码渲染有几个好处：

- 不依赖素材下载成功与否
- 先把产品闭环跑通
- 先验证“收入 -> 房间反馈”的玩法是否成立
- 后续替换为 spritesheet/tileset 时，不用重写业务状态层

## 后续素材替换接口

当前项目代码结构已经为后续替换素材留好方向：

- `lib/game/small_goal_room_game.dart`
  - 当前用代码绘制房间和角色
  - 后续可替换为 Flame `SpriteAnimationComponent`
- `lib/services/room_state_service.dart`
  - 负责把收入和统计映射成视觉状态
  - 不依赖具体素材形式
- `lib/models/room_visual_state.dart`
  - 提供人物状态、钱堆数量、房间等级等数据
  - 可供任何像素资源实现复用
