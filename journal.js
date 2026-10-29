/* =========================================================
   更新日志 · 渲染 data/archive.js
   ========================================================= */

(function () {
  "use strict";

  const data = window.ARCHIVE || { categories: [], entries: [], roadmap: [], updated: "" };
  const categories = data.categories || [];
  const catMap = {};
  categories.forEach(function (cat) { catMap[cat.id] = cat; });

  const timeline = document.getElementById("timeline");
  const filterChips = document.getElementById("filterChips");
  const journalCount = document.getElementById("journalCount");
  const journalEmpty = document.getElementById("journalEmpty");
  const roadmap = document.getElementById("roadmap");

  const entries = (data.entries || [])
    .map(function (entry, index) { return Object.assign({ _order: index }, entry); })
    .sort(function (a, b) {
      if (a.date === b.date) return a._order - b._order;
      return a.date < b.date ? 1 : -1;
    });

  let activeFilter = "all";

  /* ------------------------------ utils ------------------------------ */
  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function catLabel(id) {
    return catMap[id] ? catMap[id].label : id;
  }

  function formatDate(value) {
    const parts = String(value || "").split("-");
    if (parts.length !== 3) return { day: value || "—", month: "" };
    return { day: parts[2], month: parts[0] + "." + parts[1] };
  }

  function countByCat(id) {
    return entries.filter(function (entry) { return entry.cat === id; }).length;
  }

  /* ------------------------------ stats ------------------------------ */
  (function renderStats() {
    document.getElementById("statEntries").textContent = String(entries.length).padStart(2, "0");
    document.getElementById("statCats").textContent = String(
      new Set(entries.map(function (entry) { return entry.cat; })).size
    ).padStart(2, "0");
    const latest = entries.length ? formatDate(entries[0].date) : { month: "—" };
    document.getElementById("statUpdated").textContent = latest.month || "—";
  })();

  /* ------------------------------ filters ------------------------------ */
  function renderFilters() {
    const all = [{ id: "all", label: "全部", count: entries.length }].concat(
      categories.map(function (cat) {
        return { id: cat.id, label: cat.label, count: countByCat(cat.id) };
      })
    );

    filterChips.innerHTML = all
      .map(function (item) {
        const pressed = item.id === activeFilter;
        return (
          '<button class="chip' + (pressed ? " is-active" : "") + '" type="button" ' +
          'data-filter="' + escapeHtml(item.id) + '" aria-pressed="' + (pressed ? "true" : "false") + '">' +
          '<span>' + escapeHtml(item.label) + '</span>' +
          '<b>' + String(item.count).padStart(2, "0") + '</b>' +
          "</button>"
        );
      })
      .join("");

    filterChips.querySelectorAll("[data-filter]").forEach(function (button) {
      button.addEventListener("click", function () {
        activeFilter = button.dataset.filter;
        renderFilters();
        renderTimeline();
      });
    });
  }

  /* ------------------------------ timeline ------------------------------ */
  function renderTimeline() {
    const visible = entries.filter(function (entry) {
      return activeFilter === "all" || entry.cat === activeFilter;
    });

    journalCount.textContent =
      "显示 " + String(visible.length).padStart(2, "0") + " / " +
      String(entries.length).padStart(2, "0") + " 条记录";

    journalEmpty.hidden = visible.length !== 0;
    timeline.hidden = visible.length === 0;

    timeline.innerHTML = visible
      .map(function (entry) {
        const date = formatDate(entry.date);
        const cat = catMap[entry.cat] || { label: entry.cat, en: entry.cat };
        const tags = (entry.tags || [])
          .map(function (tag) { return "<li>" + escapeHtml(tag) + "</li>"; })
          .join("");
        const cover = entry.cover
          ? '<figure class="log-cover"><img src="' + escapeHtml(entry.cover) + '" alt="' +
            escapeHtml(entry.title) + '" loading="lazy" width="720" height="540"></figure>'
          : "";
        const link = entry.link
          ? '<a class="log-link" href="' + escapeHtml(entry.link) + '">' +
            escapeHtml(entry.linkLabel || "查看详情") + ' <span aria-hidden="true">→</span></a>'
          : "";

        return (
          '<li class="log-item" data-cat="' + escapeHtml(entry.cat) + '">' +
            '<div class="log-when">' +
              '<span class="log-day">' + escapeHtml(date.day) + '</span>' +
              '<span class="log-month">' + escapeHtml(date.month) + '</span>' +
            '</div>' +
            '<div class="log-rail" aria-hidden="true"><span class="log-dot"></span></div>' +
            '<article class="log-card' + (cover ? "" : " log-card--text") + '">' +
              '<div class="log-card-top">' +
                '<span class="log-tag" data-cat="' + escapeHtml(entry.cat) + '">' +
                  escapeHtml(cat.label) + '</span>' +
                '<span class="log-no">' + escapeHtml(cat.en || "") + '</span>' +
              '</div>' +
              '<div class="log-main">' +
                '<div class="log-copy">' +
                  '<h2>' + escapeHtml(entry.title) + '</h2>' +
                  '<p>' + escapeHtml(entry.summary) + '</p>' +
                  (tags ? '<ul class="log-tags">' + tags + "</ul>" : "") +
                  link +
                '</div>' +
                cover +
              '</div>' +
            '</article>' +
          '</li>'
        );
      })
      .join("");
  }

  /* ------------------------------ roadmap ------------------------------ */
  if (roadmap) {
    roadmap.innerHTML = (data.roadmap || [])
      .map(function (item) {
        return (
          '<article class="next-card">' +
            '<span class="log-tag" data-cat="' + escapeHtml(item.cat) + '">' +
              escapeHtml(catLabel(item.cat)) + '</span>' +
            '<h3>' + escapeHtml(item.title) + '</h3>' +
            '<p>' + escapeHtml(item.desc) + '</p>' +
            '<span class="next-status">待更新</span>' +
          '</article>'
        );
      })
      .join("");
  }

  /* ------------------------------ url filter ------------------------------ */
  (function readFilter() {
    const params = new URLSearchParams(window.location.search);
    const requested = params.get("cat");
    if (requested && (requested === "all" || catMap[requested])) activeFilter = requested;
  })();

  renderFilters();
  renderTimeline();

  /* ------------------------------ github ------------------------------ */
  (function resolveGithub() {
    let url = "https://github.com/lemonteaQWQ/-";
    if (location.hostname.endsWith(".github.io")) {
      const user = location.hostname.split(".")[0];
      const repo = location.pathname.split("/").filter(Boolean)[0] || "";
      url = "https://github.com/" + user + (repo ? "/" + repo : "");
    }
    document.querySelectorAll("#githubLink").forEach(function (a) { a.href = url; });
  })();

  /* ------------------------------ scroll ui ------------------------------ */
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
      if (progressBar) progressBar.style.width = pct.toFixed(2) + "%";
      if (nav) nav.classList.toggle("is-scrolled", window.scrollY > 28);
      ticking = false;
    });
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  /* ------------------------------ reveals ------------------------------ */
  const revealEls = document.querySelectorAll(".reveal");
  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(
      function (entriesIn) {
        entriesIn.forEach(function (entry) {
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
})();
