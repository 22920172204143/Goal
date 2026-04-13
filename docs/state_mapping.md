# 收入到像素房间的状态映射

## 核心思路

应用的核心不是把金额直接显示成一串数字，而是把收入数据转成房间里的可见变化：

- 钱变多：桌上、柜中、地面的现金堆增长
- 人物变忙：小人进入不同工作或生活状态
- 房间变富：房间等级逐步上升

这部分逻辑集中在：

- `lib/services/stats_service.dart`
- `lib/services/room_state_service.dart`
- `lib/models/room_visual_state.dart`

## 统计层

`StatsService` 负责根据收入记录生成：

- `todayIncome`
- `weekIncome`
- `monthIncome`
- `totalIncome`
- `streakDays`
- `recordCount`
- `goalProgress`
- `remainingToGoal`

## 视觉层

`RoomStateService` 把统计结果映射成：

- `moneyTier`
- `deskStackCount`
- `cabinetStackCount`
- `floorCashCount`
- `roomUpgradeLevel`
- `avatarState`
- `statusMessage`
- `animationNonce`

## 当前映射规则

### 现金堆层级

- `moneyTier`
  - `0`：几乎没有钱
  - `1`：桌上开始出现钱堆
  - `2`：桌上明显成堆
  - `3`：柜子也开始装钱
  - `4`：地面出现更明显的额外现金反馈

### 房间升级

- `totalIncome >= 800`：房间等级 1
- `totalIncome >= 3000`：房间等级 2
- `totalIncome >= 10000`：房间等级 3

### 小人状态

- 新增收入后的 8 秒内：`celebrate`
- 夜间 23:00 - 06:00：`sleep`
- 今日收入明显低于目标：`work`
- 其他时间：在 `read / phone / idle / work` 之间轮转

## 即时反馈

每次新增收入记录时：

- `AppController` 会增加 `animationNonce`
- 房间游戏层检测到 nonce 变化
- 生成现金从右上角飞向桌面或柜子的过渡动画
- 小人进入 `celebrate` 状态

## 为什么这样设计

这样做的好处：

- 业务逻辑和像素表现解耦
- 以后换真实 spritesheet 时，不用改统计层
- 以后增加更多动作时，只需要扩展 `AvatarState` 和渲染规则

## 后续扩展方向

后续可继续加的映射包括：

- 分类影响表现
  - `工资`：更偏稳定堆柜
  - `副业`：更多桌面现金
  - `奖金`：触发更强庆祝动画
- 时间段影响行为
  - 上午更偏 `work`
  - 晚上更偏 `read` 或 `phone`
- 连续记录影响房间气氛
  - 连续天数高时，灯光更亮，房间更整洁
- 目标超额达成
  - 触发额外的钱箱或闪光效果
