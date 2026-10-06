-- Persona: Robert & Margaret Foster <robert.foster@example.com>
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO users (id, email, password, mfa_code, name, account_number, date_of_birth) VALUES
    ('foster', 'robert.foster@example.com', 'Demo123!', '123456', 'Robert & Margaret Foster', '8374610295', '1956-02-10');

INSERT INTO user_profiles (user_id, phone_masked, sin_masked, member_since, address_line1, address_line2, city, province, postal_code, country, trusted_contact_name, trusted_contact_relationship) VALUES
    ('foster', '+1 (250) •••-••78', '••• ••• 591', 1999, '1420 Douglas Street', NULL, 'Victoria', 'BC', 'V8W 1P6', 'Canada', 'James Foster', 'Son');

INSERT INTO user_preferences (user_id, notify_email, notify_sms, notify_push, document_delivery, language, theme, default_meeting_type) VALUES
    ('foster', 1, 1, 0, 'paper_and_digital', 'en-CA', 'light', 'phone');

INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change, day_change_pct, contribution_room, tax_status, rate_of_return, sort_order) VALUES
    ('foster', 'rrif-robert', 'RRIF', 'Robert RRIF', NULL, 32000000, 'CAD', 0, 8500, 0.03, NULL, 'Taxable', 4.2, 1),
    ('foster', 'rrif-margaret', 'RRIF', 'Margaret RRIF', NULL, 28500000, 'CAD', 0, 7200, 0.03, NULL, 'Taxable', 4, 2),
    ('foster', 'tfsa', 'TFSA', 'Joint TFSA', NULL, 9800000, 'CAD', 0, 2100, 0.02, 0, 'Tax-free', 3.5, 3),
    ('foster', 'cash', 'NON_REGISTERED', 'Cash & GICs', NULL, 14700000, 'CAD', 0, 0, 0, NULL, 'Taxable', 2.5, 4);

INSERT INTO holdings (user_id, account_id, symbol, name, quantity, market_value, currency, weight_pct) VALUES
    ('foster', 'rrif-robert', 'XEQT.TO', 'iShares All-Equity ETF', 120, 417840, 'CAD', 45),
    ('foster', 'rrif-robert', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 1136800, 'CAD', 35),
    ('foster', 'rrif-robert', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 402000, 'CAD', 20),
    ('foster', 'rrif-margaret', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('foster', 'rrif-margaret', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('foster', 'rrif-margaret', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('foster', 'tfsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('foster', 'tfsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('foster', 'tfsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('foster', 'cash', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('foster', 'cash', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('foster', 'cash', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20);

INSERT INTO transactions (user_id, account_id, id, date, description, detail, type, amount, currency, status) VALUES
    ('foster', 'rrif-robert', 'foster-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'foster-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'foster-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'foster-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'foster-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'foster-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'foster-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('foster', 'rrif-robert', 'rrif-robert-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('foster', 'rrif-margaret', 'foster-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'foster-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'foster-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'foster-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'foster-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'foster-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'foster-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('foster', 'rrif-margaret', 'rrif-margaret-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('foster', 'tfsa', 'foster-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'tfsa', 'foster-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('foster', 'tfsa', 'foster-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('foster', 'tfsa', 'foster-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'tfsa', 'foster-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('foster', 'tfsa', 'foster-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('foster', 'tfsa', 'foster-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('foster', 'tfsa', 'tfsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('foster', 'cash', 'foster-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'cash', 'foster-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('foster', 'cash', 'foster-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('foster', 'cash', 'foster-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('foster', 'cash', 'foster-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('foster', 'cash', 'foster-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('foster', 'cash', 'foster-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('foster', 'cash', 'cash-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled');

INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name) VALUES
    ('foster', 'rrif-robert', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('foster', 'rrif-margaret', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('foster', 'tfsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('foster', 'cash', 11.2, 'CAD', 'S&P/TSX Composite');

INSERT INTO performance_points (user_id, account_id, series, period, value) VALUES
    ('foster', 'rrif-robert', 'account', '2023-12', 26560000),
    ('foster', 'rrif-robert', 'account', '2024-03', 27840000),
    ('foster', 'rrif-robert', 'account', '2024-06', 29440000),
    ('foster', 'rrif-robert', 'account', '2024-09', 30720000),
    ('foster', 'rrif-robert', 'account', '2024-12', 32000000),
    ('foster', 'rrif-robert', 'benchmark', '2023-12', 100),
    ('foster', 'rrif-robert', 'benchmark', '2024-12', 108.4),
    ('foster', 'rrif-margaret', 'account', '2023-12', 23655000),
    ('foster', 'rrif-margaret', 'account', '2024-03', 24795000),
    ('foster', 'rrif-margaret', 'account', '2024-06', 26220000),
    ('foster', 'rrif-margaret', 'account', '2024-09', 27360000),
    ('foster', 'rrif-margaret', 'account', '2024-12', 28500000),
    ('foster', 'rrif-margaret', 'benchmark', '2023-12', 100),
    ('foster', 'rrif-margaret', 'benchmark', '2024-12', 108.4),
    ('foster', 'tfsa', 'account', '2023-12', 8134000),
    ('foster', 'tfsa', 'account', '2024-03', 8526000),
    ('foster', 'tfsa', 'account', '2024-06', 9016000),
    ('foster', 'tfsa', 'account', '2024-09', 9408000),
    ('foster', 'tfsa', 'account', '2024-12', 9800000),
    ('foster', 'tfsa', 'benchmark', '2023-12', 100),
    ('foster', 'tfsa', 'benchmark', '2024-12', 108.4),
    ('foster', 'cash', 'account', '2023-12', 12201000),
    ('foster', 'cash', 'account', '2024-03', 12789000),
    ('foster', 'cash', 'account', '2024-06', 13524000),
    ('foster', 'cash', 'account', '2024-09', 14112000),
    ('foster', 'cash', 'account', '2024-12', 14700000),
    ('foster', 'cash', 'benchmark', '2023-12', 100),
    ('foster', 'cash', 'benchmark', '2024-12', 108.4);

INSERT INTO documents (user_id, id, name, category, year, account_id, account_label, size_bytes, action_required, url) VALUES
    ('foster', 'foster-d1', '2024 T5 Tax Slip', 'Tax', 2024, 'rrif-robert', 'Robert RRIF', 219136, 1, 'mock://signed/foster-d1'),
    ('foster', 'foster-d2', 'Q3 2024 Statement', 'Statements', 2024, 'rrif-margaret', 'Margaret RRIF', 1258291, 0, 'mock://signed/foster-d2'),
    ('foster', 'foster-d3', 'Trade Confirmation · XEQT', 'Confirmations', 2024, 'rrif-robert', 'Robert RRIF', 90112, 0, 'mock://signed/foster-d3'),
    ('foster', 'foster-d4', 'Q2 2024 Statement', 'Statements', 2024, 'rrif-robert', 'Robert RRIF', 1153433, 0, 'mock://signed/foster-d4'),
    ('foster', 'foster-d5', '2023 T5 Tax Slip', 'Tax', 2023, 'rrif-margaret', 'Margaret RRIF', 205824, 0, 'mock://signed/foster-d5'),
    ('foster', 'foster-d6', '2023 Annual Statement', 'Statements', 2023, 'rrif-margaret', 'Margaret RRIF', 2516582, 0, 'mock://signed/foster-d6'),
    ('foster', 'foster-d7', 'Client Account Agreement', 'Legal', 2023, NULL, 'All accounts', 655360, 0, 'mock://signed/foster-d7');

INSERT INTO goals (user_id, id, name, category, current_amount, target_amount, currency, target_date, progress_pct, show_on_dashboard, sort_order) VALUES
    ('foster', 'goal-income', 'Monthly income target', 'Retirement', 5520000, 6000000, 'CAD', '2025-01-01', 92, 1, 1),
    ('foster', 'goal-legacy', 'Legacy for children', 'Retirement', 75000000, 85000000, 'CAD', '2030-01-01', 88, 0, 2),
    ('foster', 'goal-health', 'Long-term care reserve', 'Safety', 12000000, 15000000, 'CAD', '2028-01-01', 80, 0, 3);

INSERT INTO portfolio_snapshots (user_id, currency, day_change, day_change_pct, as_of) VALUES
    ('foster', 'CAD', 17800, 0.02, '2024-12-01T14:30:00Z');

INSERT INTO asset_allocations (user_id, asset_class, pct, sort_order) VALUES
    ('foster', 'Fixed Income', 55, 1),
    ('foster', 'Equity', 25, 2),
    ('foster', 'Cash', 20, 3);

INSERT INTO alerts (user_id, id, type, title, deep_link) VALUES
    ('foster', 'al-beneficiary', 'ACTION_REQUIRED', 'Review beneficiary designations', 'electricwealth://profile');

INSERT INTO quick_links (user_id, sort_order, label, deep_link) VALUES
    ('foster', 1, 'Call advisor', 'electricwealth://advisor');
