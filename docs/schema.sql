-- Smart Hisab — SQLite (Drift) schema, Stage 1
-- Rules: money is INTEGER poisha everywhere; every syncable row carries
-- id, user_id, created_at, updated_at, device_id, local_version,
-- sync_status, is_deleted, server_updated_at (Master Prompt §10).
-- Financial rows are never hard-deleted from the UI: is_deleted is a
-- tombstone (§12) and reversals are new linked rows (§14).

CREATE TABLE persons (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  mobile TEXT,
  photo_path TEXT,
  address TEXT,
  person_type TEXT NOT NULL DEFAULT 'customer', -- customer/family/somity_member/renter/staff
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER
);
CREATE INDEX idx_persons_name ON persons(name);
CREATE INDEX idx_persons_mobile ON persons(mobile);

CREATE TABLE collection_schedules (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  person_id TEXT NOT NULL REFERENCES persons(id),
  expected_poisha INTEGER NOT NULL CHECK (expected_poisha >= 0),
  schedule_type TEXT NOT NULL, -- daily/weekly/monthly/yearly/custom
  start_date TEXT NOT NULL,    -- Dhaka business date yyyy-MM-dd
  end_date TEXT,
  weekdays TEXT,               -- CSV of 1..7 for weekly/custom
  day_of_month INTEGER,
  grace_days INTEGER NOT NULL DEFAULT 0,
  allow_advance INTEGER NOT NULL DEFAULT 1,
  paused INTEGER NOT NULL DEFAULT 0,
  effective_from TEXT NOT NULL, -- changes apply forward only (§6)
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER
);
CREATE INDEX idx_sched_person ON collection_schedules(person_id);

-- One row per person per scheduled day. NEVER merged across days (§4).
CREATE TABLE collection_obligations (
  id TEXT PRIMARY KEY, -- deterministic: personId_yyyy-MM-dd (idempotent generation)
  user_id TEXT NOT NULL,
  person_id TEXT NOT NULL REFERENCES persons(id),
  schedule_id TEXT NOT NULL REFERENCES collection_schedules(id),
  date TEXT NOT NULL,
  expected_poisha INTEGER NOT NULL,
  paid_poisha INTEGER NOT NULL DEFAULT 0,
  is_holiday INTEGER NOT NULL DEFAULT 0,
  last_allocation_date TEXT,
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER,
  UNIQUE(person_id, date)
);
CREATE INDEX idx_oblig_person_date ON collection_obligations(person_id, date);
CREATE INDEX idx_oblig_date ON collection_obligations(date);

CREATE TABLE payments (
  id TEXT PRIMARY KEY, -- immutable, generated locally offline (§9)
  user_id TEXT NOT NULL,
  person_id TEXT NOT NULL REFERENCES persons(id),
  amount_poisha INTEGER NOT NULL CHECK (amount_poisha > 0),
  date TEXT NOT NULL,
  method TEXT NOT NULL DEFAULT 'cash',
  note TEXT,
  is_reversal INTEGER NOT NULL DEFAULT 0,
  reverses_payment_id TEXT,
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER
);

-- A payment touches exactly the obligations listed here — no silent spreading.
CREATE TABLE payment_allocations (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  payment_id TEXT NOT NULL REFERENCES payments(id),
  obligation_id TEXT NOT NULL REFERENCES collection_obligations(id),
  amount_poisha INTEGER NOT NULL CHECK (amount_poisha > 0),
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER
);
CREATE INDEX idx_alloc_oblig ON payment_allocations(obligation_id);

-- The single financial truth. Balances are recalculated from these rows (§14).
CREATE TABLE ledger_entries (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  date TEXT NOT NULL, -- Dhaka business date
  direction TEXT NOT NULL, -- in / out
  amount_poisha INTEGER NOT NULL CHECK (amount_poisha > 0),
  module TEXT NOT NULL, -- dailyHisab/income/expense/baki/collection/bkash/nagad/rocket/upay/bank/cash/recharge/personal/familyTransfer/tokriVara/somity
  person_id TEXT REFERENCES persons(id),
  account_id TEXT,
  category TEXT, note TEXT,
  is_reversal INTEGER NOT NULL DEFAULT 0,
  reverses_entry_id TEXT,
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER
);
CREATE INDEX idx_ledger_date ON ledger_entries(date);
CREATE INDEX idx_ledger_person ON ledger_entries(person_id);
CREATE INDEX idx_ledger_module_date ON ledger_entries(module, date);

CREATE TABLE accounts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  kind TEXT NOT NULL, -- cash/bkash/nagad/rocket/upay/bank
  label TEXT NOT NULL, number TEXT,
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL,
  device_id TEXT, local_version INTEGER NOT NULL DEFAULT 1,
  sync_status TEXT NOT NULL DEFAULT 'pendingUpload',
  is_deleted INTEGER NOT NULL DEFAULT 0, server_updated_at INTEGER
);

CREATE TABLE daily_summaries (
  date TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  opening_poisha INTEGER NOT NULL,
  total_in_poisha INTEGER NOT NULL,
  total_out_poisha INTEGER NOT NULL,
  collection_poisha INTEGER NOT NULL,
  closing_poisha INTEGER NOT NULL,
  is_closed INTEGER NOT NULL DEFAULT 0,
  closed_by TEXT, closed_at INTEGER,
  updated_at INTEGER NOT NULL
);

CREATE TABLE audit_log (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  entity TEXT NOT NULL, entity_id TEXT NOT NULL,
  action TEXT NOT NULL, -- create/update/reopen/reverse/conflict_resolved
  actor TEXT, reason TEXT,
  created_at INTEGER NOT NULL
);

CREATE TABLE sync_queue (
  op_id TEXT PRIMARY KEY, -- recordId_v<localVersion> — idempotent (§12)
  record_id TEXT NOT NULL, entity TEXT NOT NULL,
  local_version INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'pendingUpload',
  attempts INTEGER NOT NULL DEFAULT 0, last_error TEXT,
  created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL
);
CREATE INDEX idx_sync_status ON sync_queue(status);

CREATE TABLE backups (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  kind TEXT NOT NULL, -- firebase_snapshot/local_file/export
  path_or_ref TEXT, record_count INTEGER,
  integrity_ok INTEGER, created_at INTEGER NOT NULL
);

-- ================= Stage 4 additions (schema v2) =================
-- Module state that is not money. Money itself stays in ledger_entries.

CREATE TABLE IF NOT EXISTS operator_balances (
  operator      TEXT PRIMARY KEY,
  balance_poisha INTEGER NOT NULL DEFAULT 0,
  updated_at    TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tokri_rentals (
  id                TEXT PRIMARY KEY,
  user_id           TEXT NOT NULL,
  person_id         TEXT NOT NULL,
  tokri_count       INTEGER NOT NULL,
  daily_rate_poisha INTEGER NOT NULL,
  created_at        TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tokri_attendance (
  user_id       TEXT NOT NULL,
  rental_id     TEXT NOT NULL,
  business_date TEXT NOT NULL,
  status        TEXT NOT NULL CHECK (status IN ('present','absent','leave')),
  PRIMARY KEY (rental_id, business_date)
);

CREATE TABLE IF NOT EXISTS somity_members (
  user_id   TEXT NOT NULL,
  person_id TEXT NOT NULL,
  PRIMARY KEY (user_id, person_id)
);

-- ================= Stage 6 additions (schema v3) =================
CREATE TABLE IF NOT EXISTS app_settings (
  user_id TEXT PRIMARY KEY,
  json    TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- v1.1.0: face enrollments (device-local only; never synced or backed up)
CREATE TABLE IF NOT EXISTS face_enrollments (
  person_id TEXT PRIMARY KEY,
  json TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
