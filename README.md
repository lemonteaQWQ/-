# 室内一角 · 3ds Max 建模作品集

一个纯静态的作品展示网站，用来呈现三件室内物件的建模成果与完整制作过程：

- **双门衣柜** — 120 × 60 × 192 cm，10 个建模部件
- **桌面显示器** — 62 × 26 × 63 cm，5 个建模部件
- **窗与窗帘** — 380 × 300 cm 墙面，12 个建模部件
- **组合场景** — 三件模型合并为 `all.max`

页面包含渲染图、剪影校验图、体块 → 细节 → 材质三阶段对比、尺寸与部件清单、六步制作流程、MaxScript 代码切片以及 `.max` 源文件下载。

## 目录结构

```
.
├── index.html                 # 页面结构
├── styles.css                 # 全部样式（无框架、无外链字体）
├── app.js                     # 灯箱、键盘导航、滚动动效
├── preview/                   # 渲染图与剪影图（800 × 600）
│   ├── all.png / sil_all.png
│   ├── wardrobe.png / sil_wardrobe.png
│   ├── monitor.png / sil_monitor.png
│   ├── curtain.png / sil_curtain.png
│   └── process/               # 衣柜三阶段：体块 / 细节 / 材质
│       ├── wardrobe_01_block.png
│       ├── wardrobe_02_detail.png
│       └── wardrobe_03_final.png
├── models/                    # 3ds Max 源文件与打包下载
│   ├── all.max
│   ├── wardrobe.max
│   ├── monitor.max
│   ├── curtain.max
│   └── 3dsmax-models.zip
└── scripts/
    ├── build.ms               # 生成全部场景的 MaxScript
    └── process.ms             # 生成衣柜三阶段对比图
```

## 本地预览

直接双击 `index.html` 即可。若需要更接近线上环境：

```bash
python -m http.server 8080
# 打开 http://localhost:8080
```

## 部署到 GitHub Pages

1. 把本目录推送到 GitHub 仓库。
2. 打开仓库 **Settings → Pages**。
3. **Source** 选择 `Deploy from a branch`，分支选 `main`，目录选 `/ (root)`。
4. 保存后等待约一分钟，站点地址为 `https://<用户名>.github.io/<仓库名>/`。

站内 GitHub 链接会自动识别 `*.github.io` 域名并指向当前仓库，无需手动修改。

## 交互

- 点击任意作品卡片打开灯箱，可切换 **渲染 / 剪影** 视图。
- 灯箱内使用 `←` `→` 切换模型，`Esc` 关闭。
- 手机端三阶段对比图支持横向滑动。
- 页面底部可下载单个 `.max` 或全部模型压缩包。
- 制作流程中的 MaxScript 代码可一键复制。

## 说明

模型由 3ds Max 基础几何体与 Editable Mesh 搭建，使用 Default Scanline Renderer 渲染。剪影通道用于检查轮廓、比例与遮挡关系；三阶段图保持同一相机与布光，仅改变几何与材质。页面不依赖任何第三方库或在线字体，可离线打开。
