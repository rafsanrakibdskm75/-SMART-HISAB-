# দুই Device-এ একই Data — কোনটা থাকবে? (Sync Conflict Rules)

Owner-er proshno: dui device-e eki record save holo, value alada —
ek device-e 9:50-e ৳190, arektay 10:50-e ৳200. Konta enter hobe?
Abar value same hole-i ba ki hobe?

## Niyom (v1.0.2 theke thikbhabe kaj kore)
1. **Notun entry (notun ID) hole conflict-i nei** — dui device-er dui entry-i
   thakbe. Jemon dui device theke alada alada ledger entry/payment: dutui
   hisabe jog hobe, ektao muchbe na.
2. **Eki record edit hole — seshe edit kora-ta jite (Last-Write-Wins).**
   Tulona hoy *edit-er time* diye, sync-er time diye na.
   - 9:50-e ৳190 vs 10:50-e ৳200 → **৳200 thakbe** (10:50 seshe edit).
   - Ke age sync korlo tate kichu jay ashe na.
3. **Value same, time alada** — jeta seshe edit setai jite, kintu value
   jehetu eki, **folafol ek: ৳200-i thakbe, duibar hobe na** (prottek
   record-er nirdishto operation ID thake, duplicate save hoy na).
4. **Time ekdom same hole** — beshi version (beshi bar edit) jite;
   tao same hole server-er copy jite, jate dui device ek folafol pay.
5. **Delete vs Edit** — time same hole delete (tombstone) jite; kintu
   delete-er pore abar notun edit hole sei edit-i jite (record fire ashe).

## v1.0.1-e pawa 3 ta bug (ei proshno khujte giye dhora pore)
- Record-e **sync-er time** stamp hoto, edit-er time na — tai "je seshe
  sync korto se jit-to", edit joto agei hok. Ekhon edit time save hoy
  (SyncOp.enqueuedAtMs).
- Sync controller **age push kore pore pull** korto — mane nijer value
  diye server overwrite kore dito, conflict check-i hoto na. Ekhon age
  pull → planSync diye winner ber kora → sudhu winner push hoy, loser-er
  pending kaj queue theke muchhe jay.
- Push sesheo pending queue **khali hoto na** (opId format mismatch —
  'entity:id:v1' vs 'id_v1'), tai prottek sync-e sob abar uthto.
- Settings (app_settings) record pull-er list-ei chilo na — ekhon ache.
- Pull-er watermark client-er edit time diye hoto; ekhon server-er
  timestamp diye, tai deri kore sync kora purono edit kokhono haray na.

## Ekta sotorkota
Tulona device-er ghori (clock) diye hoy. Ekta phone-er time bhul thakle
sei device-er edit bhul time-e ganona hobe. Dui phone-ei automatic
date/time on rakha bhalo.

Proof: `tool/verify_stage8.dart` — 19 check (uporer sob case), sob pass.

## Same time + same name (owner-er porer proshno, verify_stage9 — 15 check)
- **Notun data, eki name, eki somoy** (jemon du device-e "Rahim" name
  customer khola): nam kono identity na — prottek entry-r alada ID hoy,
  tai **duitai thakbe, ektau bad jabe na**. Nam+mobile ek holeo eki obostha:
  app icchakrito name diye merge kore na (dui asol customer-er nam ek
  hotei pare; nam diye taka merge kora bipodjonok). Asol duplicate hole
  malik nije ekta delete (soft delete) korben.
- **Eki record, ekdom eki millisecond, value alada**: je device **age
  sync korbe tar copy jite**; porer device-er edit ta bad (superseded)
  hoye jay, se prothomjoner value peye jay. Dui device-i seshe ek value.
- **Eki record, eki somoy, eki value**: ek copy-i thake.
- **Eki somoye ek device delete, arekta edit**: delete (tombstone) jite.
- **Din sheshe day close**: taka-r entry (alada ID) sob device-er sob
  thake; diner mot hisab entry theke abar ganona hoy, tai mot = dui
  device mile (jemon 190 + 200 = ৳390) — closing snapshot jetai jituk.

## Possible-duplicate warning (v1.0.3, 2026-11-13)
- Dui device-e eki nam-e eki somoye notun person khulle sync duitai rakhe
  (verify_stage9) — kintu tokhon Baki/collection dui record-e vag hoye jay,
  chokhe pore na. Tai Person list-e ekhon warning ache, merge NA:
- `findPossibleDuplicates` (lib/domain/person.dart): eki normalized nam
  (space/case miliye) + eki normalized mobile (+880/880/017 ek kore) hole
  **strong** group; eki nam kintu mobile alada/na thakle **possible** group.
  Deleted person bad; eki mobile kintu alada nam group hoy na (family-r
  shared phone hote pare).
- Person list-e amber banner (koyta group, koyta-te mobile-o ek) + prottek
  sondehojonok row-te ⚠ chinno. Malik jachai kore asol duplicate-ta
  soft-delete korben — app nije theke kichu merge/delete kore na.
- Proof: `tool/verify_stage10.dart` — 23 check, sob pass (mobile format,
  Bangla nam, deleted bad, dui jora group soho).
