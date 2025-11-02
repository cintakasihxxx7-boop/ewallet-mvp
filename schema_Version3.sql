-- Skema DB awal untuk MVP (Postgres). Simpel, untuk starting point.
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  email VARCHAR(255),
  full_name VARCHAR(255),
  kyc_status VARCHAR(50) DEFAULT 'unverified',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE wallets (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  currency CHAR(3) DEFAULT 'IDR',
  balance BIGINT DEFAULT 0, -- store in smallest unit (e.g., cents)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Double-entry ledger: each ledger_transaction has at least two ledger_lines
CREATE TABLE ledger_transactions (
  id BIGSERIAL PRIMARY KEY,
  external_id UUID DEFAULT gen_random_uuid(), -- id untuk klien/idaempotency
  type VARCHAR(50) NOT NULL, -- topup, transfer, payment, settlement
  status VARCHAR(50) NOT NULL DEFAULT 'pending',
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE ledger_lines (
  id BIGSERIAL PRIMARY KEY,
  ledger_transaction_id BIGINT REFERENCES ledger_transactions(id) ON DELETE CASCADE,
  account VARCHAR(200) NOT NULL, -- e.g., 'wallet:user:123', 'bank:va:xxxx'
  amount BIGINT NOT NULL, -- positive small unit
  entry_type VARCHAR(10) NOT NULL, -- 'debit' or 'credit'
  metadata JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE transactions (
  id BIGSERIAL PRIMARY KEY,
  ledger_transaction_id BIGINT REFERENCES ledger_transactions(id),
  user_id BIGINT REFERENCES users(id),
  counterparty VARCHAR(255),
  amount BIGINT,
  fee BIGINT DEFAULT 0,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE kyc_records (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) UNIQUE,
  document_type VARCHAR(50),
  document_number VARCHAR(100),
  document_image_url TEXT,
  verified BOOLEAN DEFAULT false,
  verified_at TIMESTAMP WITH TIME ZONE
);