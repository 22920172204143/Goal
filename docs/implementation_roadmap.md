# 当前实现范围与后续路线

## 已完成

### 技术骨架

- Flutter 跨平台工程已创建
- 已接入 `Flame`
- 已配置本地持久化 `shared_preferences`
- 已接入 `intl` 做日期与金额格式化

### 首版业务能力

- 收入记录新增
- 收入记录编辑
- 收入记录删除
- 本地保存收入记录
- 每日目标设置
- 今日/本周/本月/累计统计
- 连续记录天数计算

### 房间表现

- 像素风单房间首页
- 代码绘制的床、桌子、柜子、书架、地板、窗户
- 代码绘制的小人状态
- 现金堆数量随累计收入变化
- 新增收入时的现金飞入动画
- 目标达成时的灯光反馈

### 页面结构

- 房间页
- 明细页
- 统计页
- 设置页

## 当前验证结果

- `flutter analyze` 通过
- `flutter test` 通过
- Android 构建代码侧无静态错误

## 当前 Android 构建阻塞

本地 Android 打包验证遇到的是环境侧问题，不是业务代码错误：

- 首次 Gradle 依赖下载较慢
- 本机 Flutter Doctor 提示 Android cmdline-tools 缺失
- Android licenses 尚未确认

建议本机补齐后再做一次完整 APK 构建：

1. 安装 Android SDK `cmdline-tools;latest`
2. 执行 `flutter doctor --android-licenses`
3. 再运行 `flutter build apk --debug`

当前项目已将 Gradle wrapper 切到 `8.5-bin`，以避免之前损坏的 `8.3-all` 分发包继续影响构建。

## 下一阶段建议

### 阶段 A：接入真实开源像素素材

- 选一套人物 spritesheet
- 选一套房间 tileset
- 将 `small_goal_room_game.dart` 中的代码绘制逐步替换为素材渲染

### 阶段 B：丰富行为系统

- 增加 `moveMoney`
- 增加 `cleanRoom`
- 增加 `studyLate`
- 根据分类做差异化反馈

### 阶段 C：强化产品感

- 增加月度目标
- 增加房间解锁
- 增加现金保险柜
- 增加每周总结

## 开发顺序建议

如果继续实现，建议按这个顺序推进：

1. 先稳定 Android 构建环境
2. 接入一套统一授权的开源角色素材
3. 把人物从纯代码渲染替换成 sprite animation
4. 再替换家具和房间 tileset
5. 最后做成长和更多反馈动画
