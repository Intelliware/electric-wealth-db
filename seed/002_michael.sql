-- Persona: Michael Thompson <michael.thompson@example.com>
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO users (id, email, password, mfa_code, name, account_number, date_of_birth) VALUES
    ('michael', 'michael.thompson@example.com', 'Demo123!', '123456', 'Michael Thompson', '3847291056', '1982-03-18');

INSERT INTO user_profiles (user_id, phone_masked, sin_masked, member_since, address_line1, address_line2, city, province, postal_code, country, trusted_contact_name, trusted_contact_relationship) VALUES
    ('michael', '+1 (403) •••-••89', '••• ••• 456', 2012, '742 Evergreen Terrace', NULL, 'Calgary', 'AB', 'T2P 1J9', 'Canada', 'Lisa Thompson', 'Spouse');

INSERT INTO user_preferences (user_id, notify_email, notify_sms, notify_push, document_delivery, language, theme, default_meeting_type) VALUES
    ('michael', 1, 1, 1, 'paper_and_digital', 'en-CA', 'system', 'phone');

INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change, day_change_pct, contribution_room, tax_status, rate_of_return, sort_order) VALUES
    ('michael', 'resp-elena', 'RESP', 'Elena RESP', NULL, 14200000, 'CAD', 0, 18500, 0.13, 0, 'Tax-deferred', 9.8, 1),
    ('michael', 'resp-noah', 'RESP', 'Noah RESP', NULL, 11850000, 'CAD', 0, 15200, 0.13, 0, 'Tax-deferred', 9.5, 2),
    ('michael', 'rrsp', 'RRSP', 'Retirement RRSP', NULL, 18500000, 'CAD', 0, 42000, 0.23, 310000, 'Tax-deferred', 10.2, 3),
    ('michael', 'tfsa', 'TFSA', 'Family TFSA', NULL, 6200000, 'CAD', 0, 8900, 0.14, 950000, 'Tax-free', 8.9, 4),
    ('michael', 'nonreg', 'NON_REGISTERED', 'Joint Non-Registered', NULL, 2250000, 'CAD', 0, 2100, 0.09, NULL, 'Taxable', 6.4, 5);

INSERT INTO holdings (user_id, account_id, symbol, name, quantity, market_value, currency, weight_pct) VALUES
    ('michael', 'resp-elena', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('michael', 'resp-elena', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('michael', 'resp-elena', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('michael', 'resp-noah', 'XEQT.TO', 'iShares All-Equity ETF', 120, 139280, 'CAD', 45),
    ('michael', 'resp-noah', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 378933, 'CAD', 35),
    ('michael', 'resp-noah', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 134000, 'CAD', 20),
    ('michael', 'rrsp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('michael', 'rrsp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('michael', 'rrsp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('michael', 'tfsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('michael', 'tfsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('michael', 'tfsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('michael', 'nonreg', 'XEQT.TO', 'iShares All-Equity ETF', 120, 139280, 'CAD', 45),
    ('michael', 'nonreg', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 378933, 'CAD', 35),
    ('michael', 'nonreg', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 134000, 'CAD', 20);

INSERT INTO transactions (user_id, account_id, id, date, description, detail, type, amount, currency, status) VALUES
    ('michael', 'resp-elena', 'michael-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'michael-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'michael-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'michael-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'michael-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'michael-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'michael-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('michael', 'resp-elena', 'resp-elena-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('michael', 'resp-noah', 'michael-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'michael-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'michael-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'michael-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'michael-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'michael-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'michael-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('michael', 'resp-noah', 'resp-noah-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('michael', 'rrsp', 'michael-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'rrsp', 'michael-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('michael', 'rrsp', 'michael-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('michael', 'rrsp', 'michael-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'rrsp', 'michael-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('michael', 'rrsp', 'michael-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('michael', 'rrsp', 'michael-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('michael', 'rrsp', 'rrsp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('michael', 'tfsa', 'michael-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'tfsa', 'michael-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('michael', 'tfsa', 'michael-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('michael', 'tfsa', 'michael-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'tfsa', 'michael-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('michael', 'tfsa', 'michael-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('michael', 'tfsa', 'michael-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('michael', 'tfsa', 'tfsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('michael', 'nonreg', 'michael-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'nonreg', 'michael-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('michael', 'nonreg', 'michael-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('michael', 'nonreg', 'michael-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('michael', 'nonreg', 'michael-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('michael', 'nonreg', 'michael-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('michael', 'nonreg', 'michael-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('michael', 'nonreg', 'nonreg-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled');

INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name) VALUES
    ('michael', 'resp-elena', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('michael', 'resp-noah', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('michael', 'rrsp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('michael', 'tfsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('michael', 'nonreg', 11.2, 'CAD', 'S&P/TSX Composite');

INSERT INTO performance_points (user_id, account_id, series, period, value) VALUES
    ('michael', 'resp-elena', 'account', '2023-12', 11786000),
    ('michael', 'resp-elena', 'account', '2024-03', 12354000),
    ('michael', 'resp-elena', 'account', '2024-06', 13064000),
    ('michael', 'resp-elena', 'account', '2024-09', 13632000),
    ('michael', 'resp-elena', 'account', '2024-12', 14200000),
    ('michael', 'resp-elena', 'benchmark', '2023-12', 100),
    ('michael', 'resp-elena', 'benchmark', '2024-12', 108.4),
    ('michael', 'resp-noah', 'account', '2023-12', 9835500),
    ('michael', 'resp-noah', 'account', '2024-03', 10309500),
    ('michael', 'resp-noah', 'account', '2024-06', 10902000),
    ('michael', 'resp-noah', 'account', '2024-09', 11376000),
    ('michael', 'resp-noah', 'account', '2024-12', 11850000),
    ('michael', 'resp-noah', 'benchmark', '2023-12', 100),
    ('michael', 'resp-noah', 'benchmark', '2024-12', 108.4),
    ('michael', 'rrsp', 'account', '2023-12', 15355000),
    ('michael', 'rrsp', 'account', '2024-03', 16095000),
    ('michael', 'rrsp', 'account', '2024-06', 17020000),
    ('michael', 'rrsp', 'account', '2024-09', 17760000),
    ('michael', 'rrsp', 'account', '2024-12', 18500000),
    ('michael', 'rrsp', 'benchmark', '2023-12', 100),
    ('michael', 'rrsp', 'benchmark', '2024-12', 108.4),
    ('michael', 'tfsa', 'account', '2023-12', 5146000),
    ('michael', 'tfsa', 'account', '2024-03', 5394000),
    ('michael', 'tfsa', 'account', '2024-06', 5704000),
    ('michael', 'tfsa', 'account', '2024-09', 5952000),
    ('michael', 'tfsa', 'account', '2024-12', 6200000),
    ('michael', 'tfsa', 'benchmark', '2023-12', 100),
    ('michael', 'tfsa', 'benchmark', '2024-12', 108.4),
    ('michael', 'nonreg', 'account', '2023-12', 1867500),
    ('michael', 'nonreg', 'account', '2024-03', 1957500),
    ('michael', 'nonreg', 'account', '2024-06', 2070000),
    ('michael', 'nonreg', 'account', '2024-09', 2160000),
    ('michael', 'nonreg', 'account', '2024-12', 2250000),
    ('michael', 'nonreg', 'benchmark', '2023-12', 100),
    ('michael', 'nonreg', 'benchmark', '2024-12', 108.4);

INSERT INTO documents (user_id, id, name, category, year, account_id, account_label, size_bytes, action_required, url) VALUES
    ('michael', 'michael-d1', '2024 T5 Tax Slip', 'Tax', 2024, 'resp-elena', 'Elena RESP', 219136, 1, 'mock://signed/michael-d1'),
    ('michael', 'michael-d2', 'Q3 2024 Statement', 'Statements', 2024, 'resp-noah', 'Noah RESP', 1258291, 0, 'mock://signed/michael-d2'),
    ('michael', 'michael-d3', 'Trade Confirmation · XEQT', 'Confirmations', 2024, 'resp-elena', 'Elena RESP', 90112, 0, 'mock://signed/michael-d3'),
    ('michael', 'michael-d4', 'Q2 2024 Statement', 'Statements', 2024, 'resp-elena', 'Elena RESP', 1153433, 0, 'mock://signed/michael-d4'),
    ('michael', 'michael-d5', '2023 T5 Tax Slip', 'Tax', 2023, 'resp-noah', 'Noah RESP', 205824, 0, 'mock://signed/michael-d5'),
    ('michael', 'michael-d6', '2023 Annual Statement', 'Statements', 2023, 'resp-noah', 'Noah RESP', 2516582, 0, 'mock://signed/michael-d6'),
    ('michael', 'michael-d7', 'Client Account Agreement', 'Legal', 2023, NULL, 'All accounts', 655360, 0, 'mock://signed/michael-d7');

INSERT INTO goals (user_id, id, name, category, current_amount, target_amount, currency, target_date, progress_pct, show_on_dashboard, sort_order) VALUES
    ('michael', 'goal-resp', 'University for Elena', 'Education', 14200000, 20000000, 'CAD', '2032-09-01', 72, 1, 1),
    ('michael', 'goal-retire', 'Retire at 60', 'Retirement', 24700000, 45000000, 'CAD', '2042-03-18', 54, 1, 2),
    ('michael', 'goal-vacation', 'Family vacation fund', 'Vacation', 850000, 1500000, 'CAD', '2026-07-01', 57, 0, 3);

INSERT INTO portfolio_snapshots (user_id, currency, day_change, day_change_pct, as_of) VALUES
    ('michael', 'CAD', 86700, 0.16, '2024-12-01T14:30:00Z');

INSERT INTO asset_allocations (user_id, asset_class, pct, sort_order) VALUES
    ('michael', 'Equity', 58, 1),
    ('michael', 'Fixed Income', 32, 2),
    ('michael', 'Cash', 10, 3);

INSERT INTO alerts (user_id, id, type, title, deep_link) VALUES
    ('michael', 'al-resp', 'INFO', 'CESG grant posted to Elena RESP', 'electricwealth://accounts/resp-elena');

INSERT INTO quick_links (user_id, sort_order, label, deep_link) VALUES
    ('michael', 1, 'RESP contributions', 'electricwealth://accounts/resp-elena'),
    ('michael', 2, 'Tax documents', 'electricwealth://documents');
