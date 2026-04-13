# 小目标

`小目标` 是一个把现实收入映射成像素房间成长反馈的 Flutter 应用。

用户每记录一笔收入，房间里就会更“有钱”一些：

- 桌面会多一沓钱
- 储物柜会越来越满
- 小人会根据状态去干活、看书、刷手机、睡觉或搬钱
- 长期累计收入后，房间会逐步升级

## 当前实现

- Flutter + Flame 跨平台工程
- 本地收入记录增删改查
- 今日 / 本周 / 本月 / 累计统计
- 每日目标设置
- 连续记录天数
- 像素房间首页
- 纯代码驱动的小人状态和现金飞入动画

## 运行

```bash
flutter pub get
flutter run
```

Android 调试包：

```bash
flutter build apk --debug
```

如果本机 Android 环境还没配置完整，先执行：

- `flutter doctor -v`
- 补安装 Android SDK `cmdline-tools`
- `flutter doctor --android-licenses`

## 设计原则

- 首版遵循“零自绘”原则
- 不要求手绘角色、房间或逐帧动画
- 当前先使用代码像素渲染把核心玩法跑通
- 后续可替换成开源 spritesheet / tileset

## 关键目录

- `lib/controllers/`：应用状态控制
- `lib/services/`：统计和房间状态映射
- `lib/game/`：Flame 房间场景
- `lib/screens/`：页面结构
- `docs/open_source_references.md`：开源参考与素材策略
- `docs/state_mapping.md`：收入到房间的状态映射
- `docs/implementation_roadmap.md`：当前实现范围与后续路线

## 参考项目

- `Pixel Agents`：<https://github.com/pablodelucca/pixel-agents>
- `Lobster Lounge`：<https://github.com/tsconfigdotjson/lobster-lounge>
- `Universal LPC Generator`：<https://github.com/LiberatedPixelCup/Universal-LPC-Spritesheet-Character-Generator>
