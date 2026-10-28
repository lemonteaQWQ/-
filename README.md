# 六件物件 · 3ds Max 建模档案

一个纯静态的作品展示网站，用来呈现 GitHub 仓库 [`lemonteaQWQ/-`](https://github.com/lemonteaQWQ/-) 里的六件 3ds Max 模型，以及从体块到渲染的制作过程：

- **柜子** — 120 × 60 × 192，10 个建模部件
- **沙发** — 343.6 × 58.5 × 70，12 个建模部件
- **显示器** — 62 × 26 × 63，5 个建模部件
- **窗帘** — 380 × 300 墙面，12 个建模部件
- **键盘** — 310 × 76 × 12.6，1 个可编辑多边形（1,270 顶点）
- **鼠标** — 45 × 59.5 × 20，1 个可编辑网格（419 顶点）

页面包含 6 张渲染图、6 张剪影图、尺寸与部件清单、六步制作流程、柜子的“体块 → 细节 → 材质”三阶段对比、MaxScript 代码切片，以及全部 `.max` 源文件下载。

## 目录结构

```
.
├── index.html                 # 页面结构
├── styles.css                 # 全部样式（无框架、无外链字体）
├── app.js                     # 灯箱、键盘导航、滚动动效
├── preview/                   # 6 张渲染图（JPG）与 6 张剪影（PNG）
│   ├── all.jpg                # 柜子 + 显示器 + 窗帘的组合场景
│   ├── wardrobe.jpg / sil_wardrobe.png
│   ├── sofa.jpg / sil_sofa.png
│   ├── monitor.jpg / sil_monitor.png
│   ├── curtain.jpg / sil_curtain.png
│   ├── keyboard.jpg / sil_keyboard.png
│   ├── mouse.jpg / sil_mouse.png
│   └── process/               # 柜子三阶段：体块 / 细节 / 材质
│       ├── wardrobe_01_block.jpg
│       ├── wardrobe_02_detail.jpg
│       └── wardrobe_03_final.jpg
├── models/                    # 从仓库复制并改为 ASCII 文件名的 .max
│   ├── cabinet.max
│   ├── sofa.max
│   ├── monitor.max
│   ├── curtain.max
│   ├── keyboard.max
│   ├── mouse.max
│   ├── all.max                # 三件模型的组合场景
│   └── 3dsmax-models.zip
└── scripts/
    ├── build.ms               # 柜子 / 显示器 / 窗帘 + 组合场景
    ├── process.ms             # 柜子三阶段对比图
    └── render_repo.ms         # 沙发 / 键盘 / 鼠标的自动构图渲染
```

## 本地预览

直接双击 `index.html` 即可。若需要更接近线上环境：

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
- 手机端三阶段对比图支持横向滑动。
- 页面底部可下载单个 `.max` 或全部模型压缩包。
- 制作流程中的 MaxScript 代码可一键复制。

## 说明

六件模型来自源仓库的 `.max` 文件：柜子、显示器、窗帘直接使用原有场景渲染；沙发、键盘、鼠标通过 `render_repo.ms` 自动构图、补灯光并渲染。沙发、键盘、鼠标原文件没有材质，预览中的织物 / 塑料材质是为展示重新分配，源文件本身未改动。

尺寸沿用各源文件的建模单位，因此不同模型之间不一定可直接比较；页面不做单位换算。剪影通道用于检查轮廓、比例与遮挡关系。页面不依赖任何第三方库或在线字体，可离线打开。
