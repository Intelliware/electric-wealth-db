-- Persona: Emma Wilson <emma.wilson@example.com>
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO users (id, email, password, mfa_code, name, account_number, date_of_birth) VALUES
    ('emma', 'emma.wilson@example.com', 'Demo123!', '123456', 'Emma Wilson', '6293847150', '2000-06-14');

INSERT INTO user_profiles (user_id, phone_masked, sin_masked, member_since, address_line1, address_line2, city, province, postal_code, country, trusted_contact_name, trusted_contact_relationship) VALUES
    ('emma', '+1 (902) •••-••56', '••• ••• 284', 2022, '5678 Spring Garden Road', NULL, 'Halifax', 'NS', 'B3H 4R2', 'Canada', NULL, NULL);

INSERT INTO user_preferences (user_id, notify_email, notify_sms, notify_push, document_delivery, language, theme, default_meeting_type) VALUES
    ('emma', 0, 0, 1, 'digital', 'en-CA', 'system', 'video');

INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change, day_change_pct, contribution_room, tax_status, rate_of_return, sort_order) VALUES
    ('emma', 'tfsa', 'TFSA', 'Starter TFSA', NULL, 2850000, 'CAD', 0, 1200, 0.04, 4150000, 'Tax-free', 6.2, 1),
    ('emma', 'rrsp', 'RRSP', 'RRSP', NULL, 850000, 'CAD', 0, 400, 0.05, 910000, 'Tax-deferred', 5.1, 2),
    ('emma', 'cash', 'NON_REGISTERED', 'Emergency Savings', NULL, 620000, 'CAD', 0, 0, 0, NULL, 'Taxable', 1.8, 3),
    ('emma', 'fhsa', 'FHSA', 'First Home FHSA', NULL, 0, 'CAD', 0, 0, 0, 800000, 'Tax-free', 0, 4);

INSERT INTO holdings (user_id, account_id, symbol, name, quantity, market_value, currency, weight_pct) VALUES
    ('emma', 'tfsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('emma', 'tfsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('emma', 'tfsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('emma', 'rrsp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('emma', 'rrsp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('emma', 'rrsp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('emma', 'cash', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('emma', 'cash', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('emma', 'cash', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('emma', 'fhsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('emma', 'fhsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('emma', 'fhsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20);

INSERT INTO transactions (user_id, account_id, id, date, description, detail, type, amount, currency, status) VALUES
    ('emma', 'tfsa', 'emma-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'tfsa', 'emma-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('emma', 'tfsa', 'emma-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('emma', 'tfsa', 'emma-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'tfsa', 'emma-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('emma', 'tfsa', 'emma-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('emma', 'tfsa', 'emma-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('emma', 'tfsa', 'tfsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('emma', 'rrsp', 'emma-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'rrsp', 'emma-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('emma', 'rrsp', 'emma-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('emma', 'rrsp', 'emma-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'rrsp', 'emma-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('emma', 'rrsp', 'emma-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('emma', 'rrsp', 'emma-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('emma', 'rrsp', 'rrsp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('emma', 'cash', 'emma-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'cash', 'emma-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('emma', 'cash', 'emma-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('emma', 'cash', 'emma-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'cash', 'emma-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('emma', 'cash', 'emma-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('emma', 'cash', 'emma-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('emma', 'cash', 'cash-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('emma', 'fhsa', 'emma-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'fhsa', 'emma-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('emma', 'fhsa', 'emma-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('emma', 'fhsa', 'emma-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('emma', 'fhsa', 'emma-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('emma', 'fhsa', 'emma-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('emma', 'fhsa', 'emma-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('emma', 'fhsa', 'fhsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled');

INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name) VALUES
    ('emma', 'tfsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('emma', 'rrsp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('emma', 'cash', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('emma', 'fhsa', 11.2, 'CAD', 'S&P/TSX Composite');

INSERT INTO performance_points (user_id, account_id, series, period, value) VALUES
    ('emma', 'tfsa', 'account', '2023-12', 2365500),
    ('emma', 'tfsa', 'account', '2024-03', 2479500),
    ('emma', 'tfsa', 'account', '2024-06', 2622000),
    ('emma', 'tfsa', 'account', '2024-09', 2736000),
    ('emma', 'tfsa', 'account', '2024-12', 2850000),
    ('emma', 'tfsa', 'benchmark', '2023-12', 100),
    ('emma', 'tfsa', 'benchmark', '2024-12', 108.4),
    ('emma', 'rrsp', 'account', '2023-12', 705500),
    ('emma', 'rrsp', 'account', '2024-03', 739500),
    ('emma', 'rrsp', 'account', '2024-06', 782000),
    ('emma', 'rrsp', 'account', '2024-09', 816000),
    ('emma', 'rrsp', 'account', '2024-12', 850000),
    ('emma', 'rrsp', 'benchmark', '2023-12', 100),
    ('emma', 'rrsp', 'benchmark', '2024-12', 108.4),
    ('emma', 'cash', 'account', '2023-12', 514600),
    ('emma', 'cash', 'account', '2024-03', 539400),
    ('emma', 'cash', 'account', '2024-06', 570400),
    ('emma', 'cash', 'account', '2024-09', 595200),
    ('emma', 'cash', 'account', '2024-12', 620000),
    ('emma', 'cash', 'benchmark', '2023-12', 100),
    ('emma', 'cash', 'benchmark', '2024-12', 108.4),
    ('emma', 'fhsa', 'account', '2023-12', 0),
    ('emma', 'fhsa', 'account', '2024-03', 0),
    ('emma', 'fhsa', 'account', '2024-06', 0),
    ('emma', 'fhsa', 'account', '2024-09', 0),
    ('emma', 'fhsa', 'account', '2024-12', 0),
    ('emma', 'fhsa', 'benchmark', '2023-12', 100),
    ('emma', 'fhsa', 'benchmark', '2024-12', 108.4);

INSERT INTO documents (user_id, id, name, category, year, account_id, account_label, size_bytes, action_required, url) VALUES
    ('emma', 'emma-d1', '2024 T5 Tax Slip', 'Tax', 2024, 'tfsa', 'Starter TFSA', 219136, 1, 'mock://signed/emma-d1'),
    ('emma', 'emma-d2', 'Q3 2024 Statement', 'Statements', 2024, 'rrsp', 'RRSP', 1258291, 0, 'mock://signed/emma-d2'),
    ('emma', 'emma-d3', 'Trade Confirmation · XEQT', 'Confirmations', 2024, 'tfsa', 'Starter TFSA', 90112, 0, 'mock://signed/emma-d3'),
    ('emma', 'emma-d4', 'Q2 2024 Statement', 'Statements', 2024, 'tfsa', 'Starter TFSA', 1153433, 0, 'mock://signed/emma-d4'),
    ('emma', 'emma-d5', '2023 T5 Tax Slip', 'Tax', 2023, 'rrsp', 'RRSP', 205824, 0, 'mock://signed/emma-d5'),
    ('emma', 'emma-d6', '2023 Annual Statement', 'Statements', 2023, 'rrsp', 'RRSP', 2516582, 0, 'mock://signed/emma-d6'),
    ('emma', 'emma-d7', 'Client Account Agreement', 'Legal', 2023, NULL, 'All accounts', 655360, 0, 'mock://signed/emma-d7');

INSERT INTO goals (user_id, id, name, category, current_amount, target_amount, currency, target_date, progress_pct, show_on_dashboard, sort_order) VALUES
    ('emma', 'goal-debt', 'Pay off student loans', 'Safety', 1470000, 3500000, 'CAD', '2027-06-01', 42, 1, 1),
    ('emma', 'goal-emergency', 'Emergency fund', 'Safety', 620000, 900000, 'CAD', '2025-12-31', 69, 0, 2),
    ('emma', 'goal-invest', 'First $10K invested', 'Retirement', 370000, 1000000, 'CAD', '2026-01-01', 37, 0, 3);

INSERT INTO portfolio_snapshots (user_id, currency, day_change, day_change_pct, as_of) VALUES
    ('emma', 'CAD', 1600, 0.05, '2024-12-01T14:30:00Z');

INSERT INTO asset_allocations (user_id, asset_class, pct, sort_order) VALUES
    ('emma', 'Equity', 55, 1),
    ('emma', 'Fixed Income', 15, 2),
    ('emma', 'Cash', 30, 3);

INSERT INTO alerts (user_id, id, type, title, deep_link) VALUES
    ('emma', 'al-learn', 'INFO', 'New beginner lesson available', 'electricwealth://learn');

INSERT INTO quick_links (user_id, sort_order, label, deep_link) VALUES
    ('emma', 1, 'Start investing', 'electricwealth://accounts/new'),
    ('emma', 2, 'Learn basics', 'electricwealth://learn');
