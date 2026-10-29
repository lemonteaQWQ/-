# 余家杰 · 数字媒体作品档案

一个纯静态的作品展示网站：六件 3ds Max 日常物件的建模档案，加上一份会继续更新的日志。网站使用原生 HTML / CSS / JavaScript，无框架、无外链字体，可直接部署在 GitHub Pages。

线上地址：<https://lemonteaQWQ.github.io/-/>

## 内容

### 六件模型

- **柜子** — 120 × 60 × 192，10 个建模部件
- **沙发** — 180 × 36.6 × 47.8，12 个建模部件
- **显示器** — 62 × 26 × 63，5 个建模部件
- **窗帘** — 380 × 300 墙面，12 个建模部件
- **键盘** — 310 × 76 × 12.6，1 个可编辑多边形（1,270 顶点）
- **鼠标** — 45 × 59.5 × 20，1 个可编辑网格（419 顶点）

首页包含 6 张渲染图、6 张剪影图、尺寸与部件清单、六步制作流程、柜子的“体块 → 细节 → 材质”三阶段对比、MaxScript 代码切片，以及全部 `.max` 源文件下载。

### 更新日志

`journal.html` 是一个独立的日志模块：

- 按时间倒序排列，每条记录包含日期、分类、标题、摘要、标签与缩略图。
- 支持按分类筛选：3D 建模 / 视频剪辑 / 平面设计 / 其他软件。
- 首页只显示最近三条，点“查看全部日志”进入完整时间线。
- 每条模型日志可以链接回首页的对应模型弹窗，例如 `index.html?model=sofa`。
- 页面底部有“接下来”区域，提前给后续模块留位置。

## 以后怎么更新

只需要改 `data/archive.js`：

1. 新记录加到 `entries` 数组最前面，日期新的在上：

   ```js
   {
     id: "my-new-entry",
     date: "2026-11-05",
     cat: "editing",
     title: "第一次剪辑练习",
     summary: "一句话说明这次做了什么。",
     tags: ["Premiere", "剪辑"],
     cover: "preview/journal/my-still.jpg",
     link: "journal.html?cat=editing",
     linkLabel: "查看剪辑记录"
   }
   ```

2. 新分类加到 `categories`，日志页会自动出现筛选按钮。
3. 新计划加到 `roadmap`，会出现在页面底部的“接下来”。
4. 新增的模型仍然可以按原来的方式加到首页卡片与 `app.js` 的 `MODELS` 里；纯文字/图片记录则只改 `entries` 就够了。

## 目录结构

```
.
├── index.html                 # 首页：六件模型 + 最新日志
├── journal.html               # 更新日志页
├── styles.css                 # 全站样式
├── journal.css                # 日志页样式
├── app.js                     # 首页交互：灯箱、键盘导航、最新日志
├── journal.js                 # 日志渲染、筛选、统计
├── data/
│   └── archive.js             # 所有日志、分类、计划的数据源
├── preview/                   # 渲染图、剪影、过程图
│   ├── all.jpg
│   ├── wardrobe.jpg / sil_wardrobe.png
│   ├── sofa.jpg / sil_sofa.png
│   ├── monitor.jpg / sil_monitor.png
│   ├── curtain.jpg / sil_curtain.png
│   ├── keyboard.jpg / sil_keyboard.png
│   ├── mouse.jpg / sil_mouse.png
│   ├── journal/               # 日志缩略图
│   └── process/               # 柜子三阶段
├── models/
│   ├── cabinet.max / sofa.max / monitor.max
│   ├── curtain.max / keyboard.max / mouse.max
│   ├── all.max
│   └── 3dsmax-models.zip
└── scripts/
    ├── build.ms               # 柜子 / 显示器 / 窗帘 + 组合场景
    ├── process.ms             # 柜子三阶段对比图
    ├── render_repo.ms         # 沙发 / 键盘 / 鼠标的自动构图渲染
    └── render_sofa_fix.ms     # 沙发重新渲染与尺寸校正
```

## 本地预览

直接双击 `index.html` 即可。日志页的数据通过普通 `<script>` 载入，不依赖 `fetch`，所以 `file://` 下也能正常显示。

若需要更接近线上环境：

```bash
python -m http.server 8080
# 打开 http://localhost:8080
```

## 部署到 GitHub Pages

1. 把本目录推送到 GitHub 仓库（源仓库为 `lemonteaQWQ/-`）。
2. 打开仓库 **Settings → Pages**。
3. **Source** 选择 `Deploy from a branch`，分支选 `main`，目录选 `/ (root)`。
4. 保存后等待约一分钟，站点地址为 `https://lemonteaQWQ.github.io/-/`。

站内 GitHub 链接会按 `*.github.io` 域名自动指向当前仓库，本地打开时默认指向源仓库。

## 交互

- 点击首页拼图或作品卡片打开灯箱，可切换 **渲染 / 剪影** 视图。
- 灯箱内使用 `←` `→` 切换六件模型，`Esc` 关闭。
- 支持 `index.html?model=sofa` 直接打开某件模型。
- 日志页可按分类筛选，也支持 `journal.html?cat=modeling` 直接进入某分类。
- 手机端三阶段对比图支持横向滑动。
- 页面底部可下载单个 `.max` 或全部模型压缩包。
- 制作流程中的 MaxScript 代码可一键复制。

## 说明

六件模型来自源仓库的 `.max` 文件：柜子、显示器、窗帘直接使用原有场景渲染；沙发、键盘、鼠标通过 `render_repo.ms` 自动构图、补灯光并渲染。沙发、键盘、鼠标原文件没有材质，预览中的织物 / 塑料材质是为展示重新分配，源文件本身未改动。

沙发预览在 2026-10-29 重新渲染，修正了自动构图对包围盒的重复计算，实际尺寸为 180 × 36.6 × 47.8。

尺寸沿用各源文件的建模单位，因此不同模型之间不一定可直接比较；页面不做单位换算。剪影通道用于检查轮廓、比例与遮挡关系。页面不依赖任何第三方库或在线字体，可离线打开。

作者：余家杰 · 学号 25120032013 · 韶关学院 教育科学学院 数字媒体技术 2025 级 02 班。
