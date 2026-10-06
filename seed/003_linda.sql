-- Persona: Linda Rodriguez <linda.rodriguez@example.com>
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO users (id, email, password, mfa_code, name, account_number, date_of_birth) VALUES
    ('linda', 'linda.rodriguez@example.com', 'Demo123!', '123456', 'Linda Rodriguez', '5928374610', '1966-08-22');

INSERT INTO user_profiles (user_id, phone_masked, sin_masked, member_since, address_line1, address_line2, city, province, postal_code, country, trusted_contact_name, trusted_contact_relationship) VALUES
    ('linda', '+1 (604) •••-••17', '••• ••• 903', 2006, '1055 West Georgia Street', NULL, 'Vancouver', 'BC', 'V6B 1A1', 'Canada', 'Carlos Rodriguez', 'Spouse');

INSERT INTO user_preferences (user_id, notify_email, notify_sms, notify_push, document_delivery, language, theme, default_meeting_type) VALUES
    ('linda', 1, 0, 1, 'digital', 'en-CA', 'light', 'in_person');

INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change, day_change_pct, contribution_room, tax_status, rate_of_return, sort_order) VALUES
    ('linda', 'rrsp', 'RRSP', 'Retirement RRSP', NULL, 38500000, 'CAD', 0, 52000, 0.14, 180000, 'Tax-deferred', 7.2, 1),
    ('linda', 'tfsa', 'TFSA', 'TFSA Income', NULL, 12800000, 'CAD', 0, 8100, 0.06, 0, 'Tax-free', 5.8, 2),
    ('linda', 'lira', 'LIRA', 'Locked-In Retirement', NULL, 15200000, 'CAD', 0, 12000, 0.08, NULL, 'Tax-deferred', 6.5, 3),
    ('linda', 'cash', 'NON_REGISTERED', 'Cash Reserve', NULL, 8500000, 'CAD', 0, 0, 0, NULL, 'Taxable', 2.1, 4),
    ('linda', 'rrif', 'RRIF', 'RRIF (planned)', NULL, 5000000, 'CAD', 1, 3500, 0.07, NULL, 'Taxable', 4.5, 5);

INSERT INTO holdings (user_id, account_id, symbol, name, quantity, market_value, currency, weight_pct) VALUES
    ('linda', 'rrsp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('linda', 'rrsp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('linda', 'rrsp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('linda', 'tfsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('linda', 'tfsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('linda', 'tfsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('linda', 'lira', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('linda', 'lira', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('linda', 'lira', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('linda', 'cash', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('linda', 'cash', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('linda', 'cash', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('linda', 'rrif', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('linda', 'rrif', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('linda', 'rrif', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20);

INSERT INTO transactions (user_id, account_id, id, date, description, detail, type, amount, currency, status) VALUES
    ('linda', 'rrsp', 'linda-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'rrsp', 'linda-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('linda', 'rrsp', 'linda-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('linda', 'rrsp', 'linda-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'rrsp', 'linda-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('linda', 'rrsp', 'linda-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('linda', 'rrsp', 'linda-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('linda', 'rrsp', 'rrsp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('linda', 'tfsa', 'linda-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'tfsa', 'linda-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('linda', 'tfsa', 'linda-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('linda', 'tfsa', 'linda-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'tfsa', 'linda-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('linda', 'tfsa', 'linda-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('linda', 'tfsa', 'linda-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('linda', 'tfsa', 'tfsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('linda', 'lira', 'linda-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'lira', 'linda-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('linda', 'lira', 'linda-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('linda', 'lira', 'linda-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'lira', 'linda-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('linda', 'lira', 'linda-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('linda', 'lira', 'linda-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('linda', 'lira', 'lira-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('linda', 'cash', 'linda-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'cash', 'linda-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('linda', 'cash', 'linda-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('linda', 'cash', 'linda-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'cash', 'linda-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('linda', 'cash', 'linda-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('linda', 'cash', 'linda-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('linda', 'cash', 'cash-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('linda', 'rrif', 'linda-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'rrif', 'linda-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('linda', 'rrif', 'linda-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('linda', 'rrif', 'linda-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('linda', 'rrif', 'linda-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('linda', 'rrif', 'linda-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('linda', 'rrif', 'linda-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('linda', 'rrif', 'rrif-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled');

INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name) VALUES
    ('linda', 'rrsp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('linda', 'tfsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('linda', 'lira', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('linda', 'cash', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('linda', 'rrif', 11.2, 'CAD', 'S&P/TSX Composite');

INSERT INTO performance_points (user_id, account_id, series, period, value) VALUES
    ('linda', 'rrsp', 'account', '2023-12', 31955000),
    ('linda', 'rrsp', 'account', '2024-03', 33495000),
    ('linda', 'rrsp', 'account', '2024-06', 35420000),
    ('linda', 'rrsp', 'account', '2024-09', 36960000),
    ('linda', 'rrsp', 'account', '2024-12', 38500000),
    ('linda', 'rrsp', 'benchmark', '2023-12', 100),
    ('linda', 'rrsp', 'benchmark', '2024-12', 108.4),
    ('linda', 'tfsa', 'account', '2023-12', 10624000),
    ('linda', 'tfsa', 'account', '2024-03', 11136000),
    ('linda', 'tfsa', 'account', '2024-06', 11776000),
    ('linda', 'tfsa', 'account', '2024-09', 12288000),
    ('linda', 'tfsa', 'account', '2024-12', 12800000),
    ('linda', 'tfsa', 'benchmark', '2023-12', 100),
    ('linda', 'tfsa', 'benchmark', '2024-12', 108.4),
    ('linda', 'lira', 'account', '2023-12', 12616000),
    ('linda', 'lira', 'account', '2024-03', 13224000),
    ('linda', 'lira', 'account', '2024-06', 13984000),
    ('linda', 'lira', 'account', '2024-09', 14592000),
    ('linda', 'lira', 'account', '2024-12', 15200000),
    ('linda', 'lira', 'benchmark', '2023-12', 100),
    ('linda', 'lira', 'benchmark', '2024-12', 108.4),
    ('linda', 'cash', 'account', '2023-12', 7055000),
    ('linda', 'cash', 'account', '2024-03', 7395000),
    ('linda', 'cash', 'account', '2024-06', 7820000),
    ('linda', 'cash', 'account', '2024-09', 8160000),
    ('linda', 'cash', 'account', '2024-12', 8500000),
    ('linda', 'cash', 'benchmark', '2023-12', 100),
    ('linda', 'cash', 'benchmark', '2024-12', 108.4),
    ('linda', 'rrif', 'account', '2023-12', 4150000),
    ('linda', 'rrif', 'account', '2024-03', 4350000),
    ('linda', 'rrif', 'account', '2024-06', 4600000),
    ('linda', 'rrif', 'account', '2024-09', 4800000),
    ('linda', 'rrif', 'account', '2024-12', 5000000),
    ('linda', 'rrif', 'benchmark', '2023-12', 100),
    ('linda', 'rrif', 'benchmark', '2024-12', 108.4);

INSERT INTO documents (user_id, id, name, category, year, account_id, account_label, size_bytes, action_required, url) VALUES
    ('linda', 'linda-d1', '2024 T5 Tax Slip', 'Tax', 2024, 'rrsp', 'Retirement RRSP', 219136, 1, 'mock://signed/linda-d1'),
    ('linda', 'linda-d2', 'Q3 2024 Statement', 'Statements', 2024, 'tfsa', 'TFSA Income', 1258291, 0, 'mock://signed/linda-d2'),
    ('linda', 'linda-d3', 'Trade Confirmation · XEQT', 'Confirmations', 2024, 'rrsp', 'Retirement RRSP', 90112, 0, 'mock://signed/linda-d3'),
    ('linda', 'linda-d4', 'Q2 2024 Statement', 'Statements', 2024, 'rrsp', 'Retirement RRSP', 1153433, 0, 'mock://signed/linda-d4'),
    ('linda', 'linda-d5', '2023 T5 Tax Slip', 'Tax', 2023, 'tfsa', 'TFSA Income', 205824, 0, 'mock://signed/linda-d5'),
    ('linda', 'linda-d6', '2023 Annual Statement', 'Statements', 2023, 'tfsa', 'TFSA Income', 2516582, 0, 'mock://signed/linda-d6'),
    ('linda', 'linda-d7', 'Client Account Agreement', 'Legal', 2023, NULL, 'All accounts', 655360, 0, 'mock://signed/linda-d7');

INSERT INTO goals (user_id, id, name, category, current_amount, target_amount, currency, target_date, progress_pct, show_on_dashboard, sort_order) VALUES
    ('linda', 'goal-retire', 'Retire at 62', 'Retirement', 63000000, 80000000, 'CAD', '2028-08-22', 78, 1, 1),
    ('linda', 'goal-health', 'Healthcare reserve', 'Safety', 8500000, 12000000, 'CAD', '2028-01-01', 71, 0, 2),
    ('linda', 'goal-travel', 'Post-retirement travel', 'Vacation', 3200000, 5000000, 'CAD', '2029-06-01', 64, 0, 3);

INSERT INTO portfolio_snapshots (user_id, currency, day_change, day_change_pct, as_of) VALUES
    ('linda', 'CAD', 72100, 0.09, '2024-12-01T14:30:00Z');

INSERT INTO asset_allocations (user_id, asset_class, pct, sort_order) VALUES
    ('linda', 'Equity', 42, 1),
    ('linda', 'Fixed Income', 48, 2),
    ('linda', 'Cash', 10, 3);

INSERT INTO alerts (user_id, id, type, title, deep_link) VALUES
    ('linda', 'al-retire', 'ACTION_REQUIRED', 'Review retirement withdrawal plan', 'electricwealth://advisor');

INSERT INTO quick_links (user_id, sort_order, label, deep_link) VALUES
    ('linda', 1, 'Book advisor', 'electricwealth://advisor');
