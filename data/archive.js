/* =========================================================
   作品档案 · 内容数据
   ---------------------------------------------------------
   以后更新网站，只需要改这个文件：
   1. 新记录加到 entries 数组最前面（日期新的在上）。
   2. 新分类加到 categories，日志页会自动出现筛选按钮。
   3. 新模块可以继续往 roadmap 里加计划。
   ========================================================= */

window.ARCHIVE = {
  updated: "2026-10-29",

  categories: [
    {
      id: "modeling",
      label: "3D 建模",
      en: "MODELING",
      note: "3ds Max 物件、场景与渲染"
    },
    {
      id: "editing",
      label: "视频剪辑",
      en: "EDITING",
      note: "Premiere / After Effects"
    },
    {
      id: "design",
      label: "平面设计",
      en: "GRAPHIC",
      note: "Photoshop 海报与路径练习"
    },
    {
      id: "other",
      label: "其他软件",
      en: "OTHER",
      note: "Blender / C4D / 后续工具"
    }
  ],

  entries: [
    {
      id: "sofa-rerender",
      date: "2026-10-29",
      cat: "modeling",
      title: "沙发重新渲染：修正构图与尺寸",
      summary:
        "重新渲染沙发，替换掉原来的黑图；修正自动构图把包围盒重复计算的问题，尺寸从错误的 343.6 改为实际的 180 × 36.6 × 47.8。",
      tags: ["3ds Max", "渲染修正", "沙发"],
      cover: "preview/sofa.jpg",
      link: "index.html?model=sofa",
      linkLabel: "查看沙发模型"
    },
    {
      id: "six-objects-online",
      date: "2026-10-29",
      cat: "modeling",
      title: "六件日常物件 · 建模档案上线",
      summary:
        "柜子、沙发、显示器、窗帘、键盘、鼠标六件模型整理成可浏览的档案，包含渲染、剪影、尺寸、部件清单与制作过程，并部署到 GitHub Pages。",
      tags: ["3ds Max", "作品集", "GitHub Pages"],
      cover: "preview/all.jpg",
      link: "index.html#works",
      linkLabel: "浏览六件模型"
    },
    {
      id: "sakura-stamp",
      date: "2026-10-29",
      cat: "design",
      title: "樱花邮票 · 路径与图形练习",
      summary:
        "用木纹桌面、邮票齿孔、樱花线稿与圆形路径邮戳完成的一张海报，练习钢笔路径、路径文字与图层合成。",
      tags: ["Photoshop", "路径", "海报"],
      cover: "preview/journal/sakura-stamp.jpg",
      link: "",
      linkLabel: ""
    },
    {
      id: "first-three-models",
      date: "2026-10-27",
      cat: "modeling",
      title: "柜子 / 显示器 / 窗帘：完成建模",
      summary:
        "第一批三件模型完成：柜子用体块叠加出门板与把手，显示器从圆形底盘逐层向上，窗帘用正弦波做出布褶与窗框。",
      tags: ["3ds Max", "Editable Poly", "建模"],
      cover: "preview/process/wardrobe_03_final.jpg",
      link: "index.html?model=cabinet",
      linkLabel: "查看柜子模型"
    },
    {
      id: "render-three-models",
      date: "2026-10-27",
      cat: "modeling",
      title: "沙发 / 键盘 / 鼠标：补材质与渲染",
      summary:
        "为三个没有材质的源文件补上织物与塑料质感，自动构图、三点布光，输出 800 × 600 的渲染图与剪影图。",
      tags: ["3ds Max", "材质", "布光"],
      cover: "preview/keyboard.jpg",
      link: "index.html?model=keyboard",
      linkLabel: "查看键盘模型"
    },
    {
      id: "project-start",
      date: "2026-10-27",
      cat: "modeling",
      title: "项目启动：六件物件清单与脚本流程",
      summary:
        "确定柜子、沙发、显示器、窗帘、键盘、鼠标六件日常物件，建立统一的建模脚本、尺寸记录与渲染流程。",
      tags: ["3ds Max", "MaxScript", "流程"],
      cover: "",
      link: "index.html#process",
      linkLabel: "看制作过程"
    }
  ],

  roadmap: [
    {
      cat: "editing",
      title: "视频剪辑模块",
      desc: "课程短片、节奏剪辑与调色记录，完成后按同样的日志方式归档。"
    },
    {
      cat: "modeling",
      title: "更多模型与场景",
      desc: "继续补充单体物件、组合场景与不同材质方案。"
    },
    {
      cat: "design",
      title: "平面设计归档",
      desc: "海报、路径练习与版式作业，逐步并入作品档案。"
    },
    {
      cat: "other",
      title: "其他软件尝试",
      desc: "Blender、C4D 等工具的练习，也会作为独立分类出现。"
    }
  ]
};
