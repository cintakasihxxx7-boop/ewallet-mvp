# eWallet (OVO-like) — Project Starter (MVP: Indonesia)

Tujuan
- Membuat MVP e-wallet untuk pasar Indonesia (Android & iOS) dalam 3 bulan.
- Fokus pada core wallet, top-up via Virtual Account (VA), P2P transfer, dan pembayaran merchant lewat QRIS.

Keputusan teknis rekomendasi
- Mobile: Flutter (single codebase for Android + iOS)
- Backend: Node.js + TypeScript (NestJS)
- Database: PostgreSQL (double-entry ledger)
- Queue/Event: RabbitMQ (atau Kafka untuk scale)
- Cache: Redis
- Storage: S3-compatible (encrypted) untuk dokumen KYC & receipts
- CI/CD: GitHub Actions
- IaC: Terraform
- Monitoring: Prometheus + Grafana, Sentry, ELK/OpenSearch

Scope MVP (3 bulan)
- OTP-based signup/login + transaction PIN
- Basic e-KYC integration (sandbox)
- Wallet & immutable double-entry ledger
- Top-up via VA (bank virtual account) + webhook settlement
- P2P transfer (user to user)
- QRIS payment (scan & pay) for merchants
- Admin dashboard (view-only) + basic reconciliation
- Notifications: Push (FCM), email, SMS (gateway)
- Logging, metrics, basic incident runbook

Quick start (next steps)
1. Konfirmasi stack (Flutter + NestJS) — sudah konfirmasi.
2. Pilih vendor pembayaran & e-KYC (contoh: Xendit, Midtrans, Verihubs).
3. Siapkan akun sandbox untuk payment gateway & e-KYC.
4. Jika Anda ingin saya push langsung, aktifkan akses GitHub/integrasi atau tambahkan saya sebagai collaborator.

Catatan hukum/regulator
- Konsultasi wajib dengan konsultan hukum/regulator (Bank Indonesia, AML/KYC, PDP).
- Untuk MVP, pertimbangkan model operator yang bermitra dengan bank berizin untuk mengurangi beban perizinan awal.
