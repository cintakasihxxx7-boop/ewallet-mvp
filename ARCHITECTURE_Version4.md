```markdown
# Arsitektur Tinggi — eWallet MVP (Indonesia)

Komponen utama
- Mobile App (Flutter)
- API Gateway / Load Balancer (NGINX / ALB)
- Auth Service (OTP, JWT, transaction PIN)
- KYC Service (integrasi provider sandbox)
- Wallet & Ledger Service (double-entry ledger)
- Payments Service (VA creation, webhook, QRIS)
- Merchant Service
- Notification Service (FCM, SMS, Email)
- Admin Service / Dashboard
- Data Stores: Postgres (core data + ledger), Redis (cache/session)
- Message Bus: RabbitMQ (events, async tasks)
- Object Storage: S3-compatible (encrypted)
- Observability: Prometheus/Grafana, Sentry, ELK

Data flow: Top-up via VA (simplified)
1. User initiates "Top-up via VA" in mobile -> Backend Payments Service.
2. Payments Service requests VA creation from Payment Gateway (Xendit/Midtrans).
3. Create ledger_transaction (status=pending) with ledger_lines (debit: bank:va, credit: wallet:user).
4. User completes transfer to VA (outside app).
5. Payment gateway calls webhook -> Payments Service.
6. Payments Service verifies, updates ledger_transaction status=settled, updates wallet balance, emits events.
7. Notification Service sends push/SMS/email to user.

Wallet & Ledger design (principles)
- Semua pergerakan uang dicatat sebagai ledger_transactions + ledger_lines (double-entry).
- Transaksi bersifat immutable; jika perlu koreksi, buat compensating transaction.
- external_id UUID digunakan untuk idempotency dan referensi klien.
- Job rekonsiliasi mencocokkan statement PSP/bank dengan ledger -> eskalasi mismatches.

Security & compliance (highlights)
- TLS everywhere, KMS/HSM untuk keys, enkripsi at-rest.
- Transaction PIN + rate limiting, device binding optional.
- Audit logs, immutable transaction records, data retention policy.
```