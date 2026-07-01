import { writeContracts, readContracts, mountNetworkSelector } from "../../shared/app.js";
import { mountSidebarWallet } from "../../shared/wallet.js";

mountNetworkSelector("net");

const purchasesOut = (m, type = "") => {
  const el = document.getElementById("purchases-out");
  el.textContent = m; el.className = "status-box" + (type ? " " + type : "");
};
const avgOut = (m, type = "") => {
  const el = document.getElementById("avg-out");
  el.textContent = m; el.className = "status-box" + (type ? " " + type : "");
};

let wc;
let currentUserAddress = null;

// ── Wallet ────────────────────────────────────────────────────────────────
mountSidebarWallet("wallet-section", ({ wc: w, address: a }) => {
  wc = w;
  currentUserAddress = a;
  loadMyPurchases();
  loadMyReputation();
});

// ── Refresh ───────────────────────────────────────────────────────────────
document.getElementById("refresh-rep").onclick = () => {
  loadMyPurchases();
  loadMyReputation();
};

// ── LEFT: completed purchases — rate inline ───────────────────────────────
async function loadMyPurchases() {
  const wrap = document.getElementById("purchases-list-wrap");
  if (!currentUserAddress) {
    wrap.innerHTML = `<div class="escrow-empty">Connect your wallet to view your purchases.</div>`;
    return;
  }
  wrap.innerHTML = `<div class="escrow-empty">Loading…</div>`;
  try {
    const rc = readContracts();
    const total = Number(await rc.marketplace.totalListings());
    const sold = [];
    for (let i = 0; i < total; i++) {
      const listing = await rc.marketplace.getListing(i);
      if (
        Number(listing.status) === 2 &&
        listing.buyer.toLowerCase() === currentUserAddress.toLowerCase()
      ) {
        const rated = await rc.reputation.buyerRatedSeller(i);
        sold.push({ id: i, listing, rated });
      }
    }
    if (sold.length === 0) {
      wrap.innerHTML = `<div class="escrow-empty">No completed purchases yet.<br/>Buy and confirm delivery on the Escrow page first.</div>`;
      return;
    }
    wrap.innerHTML = `<div class="escrow-pending-list">${sold.map(buildPurchaseItem).join("")}</div>`;

    // Wire star pickers
    wrap.querySelectorAll(".star-input[data-val]").forEach(group => {
      const spans = group.querySelectorAll("span");
      spans.forEach(span => {
        span.onmouseover = () => highlightInline(spans, Number(span.dataset.val));
        span.onmouseout  = () => highlightInline(spans, Number(group.dataset.val || 0));
        span.onclick     = () => {
          group.dataset.val = span.dataset.val;
          highlightInline(spans, Number(span.dataset.val));
        };
      });
    });

    // Wire submit buttons
    wrap.querySelectorAll("[data-rate-id]").forEach(btn => {
      btn.addEventListener("click", () => {
        const id = Number(btn.getAttribute("data-rate-id"));
        const card = btn.closest(".escrow-pending-item");
        const stars = Number(card.querySelector(".star-input[data-val]")?.dataset.val || 0);
        handleRate(btn, id, stars);
      });
    });
  } catch (e) {
    wrap.innerHTML = `<div class="escrow-empty" style="color:var(--danger)">${e.message || e}</div>`;
  }
}

function highlightInline(spans, n) {
  spans.forEach(s => s.classList.toggle("active", Number(s.dataset.val) <= n));
}

function buildPurchaseItem({ id, listing, rated }) {
  const sellerShort = listing.seller.slice(0, 6) + "…" + listing.seller.slice(-4);
  if (rated) {
    return `<div class="escrow-pending-item">
      <div class="escrow-pending-item-title">${listing.title}</div>
      <div class="escrow-pending-item-meta">
        <span>Seller: ${sellerShort}</span>
        <span>Listing #${id}</span>
      </div>
      <div class="escrow-pending-item-meta">
        <span style="color:var(--ok)">✅ Already rated</span>
      </div>
    </div>`;
  }
  return `<div class="escrow-pending-item">
    <div class="escrow-pending-item-title">${listing.title}</div>
    <div class="escrow-pending-item-meta">
      <span>Seller: ${sellerShort}</span>
      <span>Listing #${id}</span>
    </div>
    <div class="star-input" data-val="0" style="margin:10px 0;">
      <span data-val="1">★</span>
      <span data-val="2">★</span>
      <span data-val="3">★</span>
      <span data-val="4">★</span>
      <span data-val="5">★</span>
    </div>
    <div class="escrow-pending-item-actions">
      <button data-rate-id="${id}">Submit Rating</button>
    </div>
  </div>`;
}

async function handleRate(btn, id, stars) {
  if (!wc) { purchasesOut("Connect your wallet first.", "err"); return; }
  if (!stars || stars < 1 || stars > 5) { purchasesOut("Select a star rating first.", "err"); return; }
  try {
    btn.textContent = "Submitting…";
    btn.disabled = true;
    purchasesOut(`Submitting rating for listing #${id}…`, "pending");
    const tx = await wc.reputation.rateUser(id, stars);
    await tx.wait();
    purchasesOut("✅ Rating submitted!", "ok");
    loadMyPurchases();
    loadMyReputation();
  } catch (e) {
    purchasesOut(String(e.message || e), "err");
    btn.textContent = "Submit Rating";
    btn.disabled = false;
  }
}

// ── RIGHT: your score ──────────────────────────────────────────────────────
async function loadMyReputation() {
  const scoreWrap = document.getElementById("my-rep-result");
  if (!currentUserAddress) {
    scoreWrap.style.display = "none";
    return;
  }
  try {
    const rc = readContracts();
    const [total, count] = await rc.reputation.getAverageRating(currentUserAddress);
    const n = Number(count);
    if (n === 0) {
      scoreWrap.style.display = "none";
      avgOut("You have no ratings yet.", "");
    } else {
      const avg = (Number(total) / n).toFixed(2);
      const filled = Math.round(Number(total) / n);
      document.getElementById("rep-score-num").textContent = avg;
      document.getElementById("rep-stars").textContent = "★".repeat(filled) + "☆".repeat(5 - filled);
      document.getElementById("rep-count").textContent = `${n} rating${n === 1 ? "" : "s"} received`;
      scoreWrap.style.display = "block";
      avgOut("", "");
    }
  } catch (e) {
    avgOut(String(e.message || e), "err");
  }
}
