/* =========================================================
   室内一角 · gallery interactions
   ========================================================= */

(function () {
  "use strict";

  /* ------------------------------ data ------------------------------ */
  const MODELS = {
    all: {
      eyebrow: "COMPOSITE SCENE — 00",
      title: "室内一角",
      en: "All Scenes / Interior Study",
      img: "preview/all.png",
      sil: "preview/sil_all.png",
      desc:
        "三个独立场景在同一个镜头里重新排布：衣柜靠左、显示器居中、窗帘靠右。共用地面、三点灯光与一台目标摄像机，用来检查比例、朝向与遮挡关系是否成立。",
      specs: [
        ["画幅", "800 × 600 px"],
        ["模型", "3 件"],
        ["建模部件", "27 个"],
        ["场景对象", "45 个"],
        ["渲染器", "Default Scanline"]
      ],
      parts: ["双门衣柜", "桌面显示器", "窗与窗帘", "地面", "三点灯光", "目标摄像机"],
      file: "models/all.max"
    },
    wardrobe: {
      eyebrow: "MODEL 01 — WARDROBE",
      title: "双门衣柜",
      en: "Wardrobe",
      img: "preview/wardrobe.png",
      sil: "preview/sil_wardrobe.png",
      desc:
        "以 120 × 60 × 192 cm 的柜体为基准，先用三个体块确定比例，再补上 1 cm 中缝、圆柱把手与门板压线。五种木色材质拉开层次，避免大面单调。",
      specs: [
        ["外包尺寸", "120 × 60 × 192 cm"],
        ["建模部件", "10 个"],
        ["材质", "5 种"],
        ["场景对象", "16 个"],
        ["源文件", "wardrobe.max"]
      ],
      parts: ["柜体", "顶板", "踢脚", "左门", "右门", "1 cm 中缝", "圆柱把手 ×2", "门板线条 ×2"],
      file: "models/wardrobe.max"
    },
    monitor: {
      eyebrow: "MODEL 02 — MONITOR",
      title: "桌面显示器",
      en: "Monitor",
      img: "preview/monitor.png",
      sil: "preview/sil_monitor.png",
      desc:
        "从 26 cm 的圆形底盘开始，颈柱、边框、屏幕与背板逐层叠合。屏幕与背板转为 Editable Mesh，深灰塑料搭配低饱和蓝屏，保持桌面设备的冷静感。",
      specs: [
        ["外包尺寸", "62 × 26 × 63 cm"],
        ["建模部件", "5 个"],
        ["材质", "4 种"],
        ["场景对象", "11 个"],
        ["源文件", "monitor.max"]
      ],
      parts: ["圆形底盘", "颈柱", "屏幕边框", "屏幕面板 ×1", "背板"],
      file: "models/monitor.max"
    },
    curtain: {
      eyebrow: "MODEL 03 — CURTAIN",
      title: "窗与窗帘",
      en: "Curtain",
      img: "preview/curtain.png",
      sil: "preview/sil_curtain.png",
      desc:
        "380 × 300 cm 的墙面上开出 164 × 160 cm 的窗，窗框、竖梃与玻璃依次嵌入。帘布以正弦波做 4.2 cm 的褶皱，左右各 96 cm 宽，最后加上木质帘杆与球形端头。",
      specs: [
        ["墙面尺寸", "380 × 300 cm"],
        ["窗洞尺寸", "164 × 160 cm"],
        ["建模部件", "12 个"],
        ["材质", "6 种"],
        ["场景对象", "18 个"],
        ["源文件", "curtain.max"]
      ],
      parts: ["墙面", "窗框 ×4", "竖梃", "玻璃", "帘杆", "球形端头 ×2", "帘布 ×2"],
      file: "models/curtain.max"
    }
  };

  const ORDER = ["all", "wardrobe", "monitor", "curtain"];

  /* ------------------------------ refs ------------------------------ */
  const modal = document.getElementById("modal");
  const modalImg = document.getElementById("modalImg");
  const modalTitle = document.getElementById("modalTitle");
  const modalEyebrow = document.getElementById("modalEyebrow");
  const modalEn = document.getElementById("modalEn");
  const modalDesc = document.getElementById("modalDesc");
  const modalSpecs = document.getElementById("modalSpecs");
  const modalParts = document.getElementById("modalParts");
  const modalDownload = document.getElementById("modalDownload");
  const modalCount = document.getElementById("modalCount");
  const modalFile = document.getElementById("modalFile");
  const modalSil = document.getElementById("modalSil");
  const viewButtons = document.querySelectorAll("[data-view]");
  const prevBtn = document.getElementById("prevBtn");
  const nextBtn = document.getElementById("nextBtn");
  const closeBtn = modal.querySelector(".modal-close");

  let currentKey = null;
  let currentView = "render";
  let lastFocused = null;

  /* ------------------------------ github link ------------------------------ */
  (function resolveGithub() {
    let url = "https://github.com/";
    if (location.hostname.endsWith(".github.io")) {
      const user = location.hostname.split(".")[0];
      const repo = location.pathname.split("/").filter(Boolean)[0] || "";
      url = "https://github.com/" + user + (repo ? "/" + repo : "");
    }
    document.querySelectorAll("#githubLink, #githubLinkFoot").forEach(function (a) {
      a.href = url;
    });
  })();

  /* ------------------------------ populate ------------------------------ */
  function render(key) {
    const model = MODELS[key];
    if (!model) return;
    currentKey = key;
    currentView = "render";

    modalEyebrow.textContent = model.eyebrow;
    modalTitle.textContent = model.title;
    modalEn.textContent = model.en;
    modalDesc.textContent = model.desc;
    modalImg.alt = model.title + "的渲染图";

    modalSpecs.innerHTML = model.specs
      .map(function (row) {
        return "<div><dt>" + row[0] + "</dt><dd>" + row[1] + "</dd></div>";
      })
      .join("");

    modalParts.innerHTML = model.parts
      .map(function (part) {
        return "<li>" + part + "</li>";
      })
      .join("");

    modalDownload.href = model.file;
    modalDownload.setAttribute("download", model.file.split("/").pop());
    modalFile.textContent = model.file.split("/").pop();

    const index = ORDER.indexOf(key);
    modalCount.textContent =
      String(index + 1).padStart(2, "0") + " / " + String(ORDER.length).padStart(2, "0");

    setView("render");
    modal.querySelector(".modal-info").scrollTop = 0;
  }

  function setView(view) {
    const model = MODELS[currentKey];
    if (!model) return;
    currentView = view;
    modalImg.src = view === "sil" ? model.sil : model.img;
    modalImg.classList.toggle("is-sil", view === "sil");
    modalImg.alt = model.title + (view === "sil" ? "的剪影图" : "的渲染图");

    viewButtons.forEach(function (btn) {
      btn.classList.toggle("is-active", btn.dataset.view === view);
      btn.setAttribute("aria-pressed", btn.dataset.view === view ? "true" : "false");
    });

    modalSil.textContent = view === "sil" ? "看渲染" : "看剪影";
  }

  /* ------------------------------ open / close ------------------------------ */
  function openModal(key, trigger) {
    if (!MODELS[key]) return;
    lastFocused = trigger || document.activeElement;
    render(key);
    modal.classList.add("is-open");
    modal.setAttribute("aria-hidden", "false");
    document.body.classList.add("is-locked");
    window.setTimeout(function () {
      closeBtn.focus();
    }, 50);
  }

  function closeModal() {
    if (!modal.classList.contains("is-open")) return;
    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    document.body.classList.remove("is-locked");
    if (lastFocused && typeof lastFocused.focus === "function") {
      lastFocused.focus();
    }
  }

  function step(direction) {
    if (!currentKey) return;
    const index = ORDER.indexOf(currentKey);
    const next = (index + direction + ORDER.length) % ORDER.length;
    render(ORDER[next]);
  }

  /* ------------------------------ card events ------------------------------ */
  document.querySelectorAll("[data-model]").forEach(function (card) {
    card.setAttribute("aria-haspopup", "dialog");
    card.addEventListener("click", function (event) {
      if (event.target.closest("a")) return;
      openModal(card.dataset.model, card);
    });
    card.addEventListener("keydown", function (event) {
      if (event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        openModal(card.dataset.model, card);
      }
    });
  });

  /* ------------------------------ modal events ------------------------------ */
  modal.querySelectorAll("[data-close]").forEach(function (el) {
    el.addEventListener("click", closeModal);
  });

  viewButtons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      setView(btn.dataset.view);
    });
  });

  modalSil.addEventListener("click", function () {
    setView(currentView === "sil" ? "render" : "sil");
  });

  prevBtn.addEventListener("click", function () { step(-1); });
  nextBtn.addEventListener("click", function () { step(1); });

  document.addEventListener("keydown", function (event) {
    if (!modal.classList.contains("is-open")) return;

    if (event.key === "Escape") {
      event.preventDefault();
      closeModal();
      return;
    }
    if (event.key === "ArrowLeft") {
      event.preventDefault();
      step(-1);
      return;
    }
    if (event.key === "ArrowRight") {
      event.preventDefault();
      step(1);
      return;
    }
    if (event.key === "Tab") {
      const focusable = modal.querySelectorAll(
        'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])'
      );
      if (!focusable.length) return;
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    }
  });

  /* ------------------------------ scroll UI ------------------------------ */
  const progressBar = document.getElementById("progressBar");
  const nav = document.getElementById("nav");
  let ticking = false;

  function onScroll() {
    if (ticking) return;
    ticking = true;
    window.requestAnimationFrame(function () {
      const doc = document.documentElement;
      const max = doc.scrollHeight - window.innerHeight;
      const pct = max > 0 ? (window.scrollY / max) * 100 : 0;
      progressBar.style.width = pct.toFixed(2) + "%";
      nav.classList.toggle("is-scrolled", window.scrollY > 28);
      ticking = false;
    });
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  /* ------------------------------ reveals ------------------------------ */
  const revealEls = document.querySelectorAll(".reveal");
  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-in");
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: "0px 0px -6% 0px" }
    );
    revealEls.forEach(function (el) { observer.observe(el); });
  } else {
    revealEls.forEach(function (el) { el.classList.add("is-in"); });
  }

  /* ------------------------------ copy code ------------------------------ */
  const copyBtn = document.querySelector("[data-copy]");
  if (copyBtn) {
    copyBtn.addEventListener("click", function () {
      const code = document.getElementById("codeSnippet").innerText;
      const done = function () {
        copyBtn.textContent = "已复制 ✓";
        window.setTimeout(function () { copyBtn.textContent = "复制代码"; }, 1600);
      };

      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(code).then(done).catch(fallback);
      } else {
        fallback();
      }

      function fallback() {
        const area = document.createElement("textarea");
        area.value = code;
        area.setAttribute("readonly", "");
        area.style.position = "fixed";
        area.style.opacity = "0";
        document.body.appendChild(area);
        area.select();
        try { document.execCommand("copy"); done(); } catch (e) { /* noop */ }
        document.body.removeChild(area);
      }
    });
  }
})();
