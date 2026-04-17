# Goal（小目标）

`Goal` 是一个把“现实收入”映射为“像素房间成长反馈”的 Flutter 应用。  
每记一笔收入，房间会变得更富、更精致，小角色也会有不同状态反馈。

## 当前状态（可直接交接）

- Flutter 工程可运行（Android 优先）
- 已实现收入记录、统计、目标、连续打卡等核心数据闭环
- 首页房间已从纯代码原型升级为“素材复用 + 状态驱动”版本
- 已接入参考项目风格素材（`assets/star_office/`）
- 已修复安卓端偶发“spritesheet 错帧 / 乱码条纹”问题（改为单帧资源切换）
- 当前推荐接管方向：房间财富反馈精修、角色互动细化、商用替换素材规划

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

- 当前仍有部分临时道具是“过渡实现”，需要进一步统一美术语义
- 素材版权策略尚未完成商用替换（当前目标是先把体验做顺）
- 工程根目录存在本地开发临时文件，不应提交构建缓存与截图产物

## 参考项目

- `Star-Office-UI`：<https://github.com/ringhyacinth/Star-Office-UI>
- `Pixel Agents`：<https://github.com/pablodelucca/pixel-agents>
- `Lobster Lounge`：<https://github.com/tsconfigdotjson/lobster-lounge>
