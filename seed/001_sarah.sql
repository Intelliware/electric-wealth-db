-- Persona: Sarah Chen <sarah.chen@example.com>
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO users (id, email, password, mfa_code, name, account_number, date_of_birth) VALUES
    ('sarah', 'sarah.chen@example.com', 'Demo123!', '123456', 'Sarah Chen', '4829157302', '1996-04-12');

INSERT INTO user_profiles (user_id, phone_masked, sin_masked, member_since, address_line1, address_line2, city, province, postal_code, country, trusted_contact_name, trusted_contact_relationship) VALUES
    ('sarah', '+1 (416) •••-••42', '••• ••• 821', 2020, '218 Queen Street West', NULL, 'Toronto', 'ON', 'M5V 2A1', 'Canada', 'David Chen', 'Sibling');

INSERT INTO user_preferences (user_id, notify_email, notify_sms, notify_push, document_delivery, language, theme, default_meeting_type) VALUES
    ('sarah', 1, 0, 1, 'digital', 'en-CA', 'light', 'video');

INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change, day_change_pct, contribution_room, tax_status, rate_of_return, sort_order) VALUES
    ('sarah', 'tfsa', 'TFSA', 'Growth TFSA', NULL, 3241000, 'CAD', 0, 21040, 0.65, 600000, 'Tax-free', 11.2, 1),
    ('sarah', 'rrsp', 'RRSP', 'Retirement RRSP', NULL, 1894000, 'CAD', 0, 8810, 0.47, 430000, 'Tax-deferred', 8.6, 2),
    ('sarah', 'fhsa', 'FHSA', 'First Home Savings', NULL, 648950, 'CAD', 0, -1230, -0.19, 800000, 'Tax-free', 4.1, 3),
    ('sarah', 'cash', 'NON_REGISTERED', 'Cash & Savings', NULL, 241050, 'CAD', 0, 380, 0.16, NULL, 'Taxable', 2.8, 4);

INSERT INTO holdings (user_id, account_id, symbol, name, quantity, market_value, currency, weight_pct) VALUES
    ('sarah', 'tfsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('sarah', 'tfsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('sarah', 'tfsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('sarah', 'rrsp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('sarah', 'rrsp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('sarah', 'rrsp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('sarah', 'fhsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('sarah', 'fhsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('sarah', 'fhsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('sarah', 'cash', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('sarah', 'cash', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('sarah', 'cash', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20);

INSERT INTO transactions (user_id, account_id, id, date, description, detail, type, amount, currency, status) VALUES
    ('sarah', 'tfsa', 't1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'tfsa', 't2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('sarah', 'tfsa', 't3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('sarah', 'tfsa', 't4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'tfsa', 't5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('sarah', 'tfsa', 't6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('sarah', 'tfsa', 't7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('sarah', 'tfsa', 's1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('sarah', 'rrsp', 'sarah-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'sarah-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'sarah-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'sarah-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'sarah-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'sarah-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'sarah-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('sarah', 'rrsp', 'rrsp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('sarah', 'fhsa', 'sarah-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'sarah-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'sarah-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'sarah-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'sarah-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'sarah-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'sarah-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('sarah', 'fhsa', 'fhsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('sarah', 'cash', 'sarah-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'cash', 'sarah-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('sarah', 'cash', 'sarah-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('sarah', 'cash', 'sarah-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('sarah', 'cash', 'sarah-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('sarah', 'cash', 'sarah-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('sarah', 'cash', 'sarah-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('sarah', 'cash', 'cash-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled');

INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name) VALUES
    ('sarah', 'tfsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('sarah', 'rrsp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('sarah', 'fhsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('sarah', 'cash', 11.2, 'CAD', 'S&P/TSX Composite');

INSERT INTO performance_points (user_id, account_id, series, period, value) VALUES
    ('sarah', 'tfsa', 'account', '2023-12', 2680000),
    ('sarah', 'tfsa', 'account', '2024-03', 2810000),
    ('sarah', 'tfsa', 'account', '2024-06', 2990000),
    ('sarah', 'tfsa', 'account', '2024-09', 3120000),
    ('sarah', 'tfsa', 'account', '2024-12', 3241000),
    ('sarah', 'tfsa', 'benchmark', '2023-12', 100),
    ('sarah', 'tfsa', 'benchmark', '2024-12', 108.4),
    ('sarah', 'rrsp', 'account', '2023-12', 1572020),
    ('sarah', 'rrsp', 'account', '2024-03', 1647780),
    ('sarah', 'rrsp', 'account', '2024-06', 1742480),
    ('sarah', 'rrsp', 'account', '2024-09', 1818240),
    ('sarah', 'rrsp', 'account', '2024-12', 1894000),
    ('sarah', 'rrsp', 'benchmark', '2023-12', 100),
    ('sarah', 'rrsp', 'benchmark', '2024-12', 108.4),
    ('sarah', 'fhsa', 'account', '2023-12', 538629),
    ('sarah', 'fhsa', 'account', '2024-03', 564587),
    ('sarah', 'fhsa', 'account', '2024-06', 597034),
    ('sarah', 'fhsa', 'account', '2024-09', 622992),
    ('sarah', 'fhsa', 'account', '2024-12', 648950),
    ('sarah', 'fhsa', 'benchmark', '2023-12', 100),
    ('sarah', 'fhsa', 'benchmark', '2024-12', 108.4),
    ('sarah', 'cash', 'account', '2023-12', 200072),
    ('sarah', 'cash', 'account', '2024-03', 209714),
    ('sarah', 'cash', 'account', '2024-06', 221766),
    ('sarah', 'cash', 'account', '2024-09', 231408),
    ('sarah', 'cash', 'account', '2024-12', 241050),
    ('sarah', 'cash', 'benchmark', '2023-12', 100),
    ('sarah', 'cash', 'benchmark', '2024-12', 108.4);

INSERT INTO documents (user_id, id, name, category, year, account_id, account_label, size_bytes, action_required, url) VALUES
    ('sarah', 'd1', '2024 T5 Tax Slip', 'Tax', 2024, 'tfsa', 'Growth TFSA', 219136, 1, 'mock://signed/d1'),
    ('sarah', 'd2', 'Q3 2024 Statement', 'Statements', 2024, 'rrsp', 'Retirement RRSP', 1258291, 0, 'mock://signed/d2'),
    ('sarah', 'd3', 'Trade Confirmation · XEQT', 'Confirmations', 2024, 'tfsa', 'Growth TFSA', 90112, 0, 'mock://signed/d3'),
    ('sarah', 'd4', 'Q2 2024 Statement', 'Statements', 2024, 'tfsa', 'Growth TFSA', 1153433, 0, 'mock://signed/d4'),
    ('sarah', 'd5', '2023 T5 Tax Slip', 'Tax', 2023, 'rrsp', 'Retirement RRSP', 205824, 0, 'mock://signed/d5'),
    ('sarah', 'd6', '2023 Annual Statement', 'Statements', 2023, 'rrsp', 'Retirement RRSP', 2516582, 0, 'mock://signed/d6'),
    ('sarah', 'd7', 'Client Account Agreement', 'Legal', 2023, NULL, 'All accounts', 655360, 0, 'mock://signed/d7');

INSERT INTO goals (user_id, id, name, category, current_amount, target_amount, currency, target_date, progress_pct, show_on_dashboard, sort_order) VALUES
    ('sarah', 'goal-1', 'Home Down Payment', 'Home', 3840000, 8000000, 'CAD', '2027-06-30', 48, 1, 1),
    ('sarah', 'goal-2', 'Emergency Fund', 'Safety', 820000, 1000000, 'CAD', '2025-12-31', 82, 0, 2),
    ('sarah', 'goal-3', 'Max my TFSA', 'Retirement', 3241000, 5000000, 'CAD', '2026-03-31', 65, 0, 3);

INSERT INTO portfolio_snapshots (user_id, currency, day_change, day_change_pct, as_of) VALUES
    ('sarah', 'CAD', 42100, 0.7, '2024-12-01T14:30:00Z');

INSERT INTO asset_allocations (user_id, asset_class, pct, sort_order) VALUES
    ('sarah', 'Equity', 62.5, 1),
    ('sarah', 'Fixed Income', 25, 2),
    ('sarah', 'Cash', 12.5, 3);

INSERT INTO alerts (user_id, id, type, title, deep_link) VALUES
    ('sarah', 'al-1', 'ACTION_REQUIRED', 'Sign your 2024 tax form', 'electricwealth://documents/d1');

INSERT INTO quick_links (user_id, sort_order, label, deep_link) VALUES
    ('sarah', 1, 'Open account', 'electricwealth://accounts/new'),
    ('sarah', 2, 'Documents', 'electricwealth://documents'),
    ('sarah', 3, 'Research', 'electricwealth://market');
