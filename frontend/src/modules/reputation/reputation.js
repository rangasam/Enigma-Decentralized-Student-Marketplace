import { connect, writeContracts, readContracts, mountNetworkSelector, net } from "../../shared/app.js";
mountNetworkSelector("net");
const out = (m) => (document.getElementById("out").textContent = m);
const val = (id) => document.getElementById(id).value.trim();
let signer, wc;
document.getElementById("connect").onclick = async () => {
  try { ({ signer } = await connect()); wc = writeContracts(signer);
    document.getElementById("who").textContent = "Connected: " + (await signer.getAddress()) + " · " + net().label;
  } catch (e) { out(String(e.message || e)); }
};
document.getElementById("rate").onclick = async () => {
  try { if (!wc) throw new Error("Connect a wallet first.");
    const tx = await wc.reputation.rateUser(Number(val("id")), Number(val("stars"))); await tx.wait();
    out("✅ rating submitted");
  } catch (e) { out(String(e.message || e)); }
};
document.getElementById("avg").onclick = async () => {
  try {
    const rc = readContracts();
    let seller = val("seller");
    if (!seller) seller = (await rc.marketplace.getListing(Number(val("id")))).seller;
    const [total, count] = await rc.reputation.getAverageRating(seller);
    out(Number(count) ? `Seller avg: ${(Number(total)/Number(count)).toFixed(2)} ★ (${count} ratings)` : "No ratings yet");
  } catch (e) { out(String(e.message || e)); }
};
