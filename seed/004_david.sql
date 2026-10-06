-- Persona: David Kim <david.kim@example.com>
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO users (id, email, password, mfa_code, name, account_number, date_of_birth) VALUES
    ('david', 'david.kim@example.com', 'Demo123!', '123456', 'David Kim', '7182936450', '1976-11-05');

INSERT INTO user_profiles (user_id, phone_masked, sin_masked, member_since, address_line1, address_line2, city, province, postal_code, country, trusted_contact_name, trusted_contact_relationship) VALUES
    ('david', '+1 (905) •••-••33', '••• ••• 712', 2016, '100 City Centre Drive', NULL, 'Mississauga', 'ON', 'L5B 2C9', 'Canada', 'Jennifer Kim', 'Spouse');

INSERT INTO user_preferences (user_id, notify_email, notify_sms, notify_push, document_delivery, language, theme, default_meeting_type) VALUES
    ('david', 1, 1, 1, 'digital', 'en-CA', 'dark', 'video');

INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change, day_change_pct, contribution_room, tax_status, rate_of_return, sort_order) VALUES
    ('david', 'corp', 'NON_REGISTERED', 'Corporate Investment', NULL, 48500000, 'CAD', 0, 125000, 0.26, NULL, 'Taxable', 14.2, 1),
    ('david', 'rrsp', 'RRSP', 'Personal RRSP', NULL, 22800000, 'CAD', 0, 68000, 0.3, 0, 'Tax-deferred', 12.8, 2),
    ('david', 'tfsa', 'TFSA', 'TFSA Growth', NULL, 15200000, 'CAD', 0, 45000, 0.3, 0, 'Tax-free', 15.1, 3),
    ('david', 'rdsp', 'RDSP', 'Family RDSP', NULL, 8500000, 'CAD', 0, 5200, 0.06, 200000, 'Tax-deferred', 8.2, 4),
    ('david', 'alt', 'NON_REGISTERED', 'Alternative Investments', 'Alts', 25000000, 'CAD', 0, 0, 0, NULL, 'Taxable', 9.5, 5);

INSERT INTO holdings (user_id, account_id, symbol, name, quantity, market_value, currency, weight_pct) VALUES
    ('david', 'corp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('david', 'corp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('david', 'corp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('david', 'rrsp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('david', 'rrsp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('david', 'rrsp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('david', 'tfsa', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('david', 'tfsa', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('david', 'tfsa', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('david', 'rdsp', 'XEQT.TO', 'iShares All-Equity ETF', 120, 278560, 'CAD', 45),
    ('david', 'rdsp', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 757867, 'CAD', 35),
    ('david', 'rdsp', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 268000, 'CAD', 20),
    ('david', 'alt', 'XEQT.TO', 'iShares All-Equity ETF', 120, 139280, 'CAD', 45),
    ('david', 'alt', 'VFV.TO', 'Vanguard S&P 500 ETF', 80, 378933, 'CAD', 35),
    ('david', 'alt', 'ZAG.TO', 'BMO Aggregate Bond ETF', 200, 134000, 'CAD', 20);

INSERT INTO transactions (user_id, account_id, id, date, description, detail, type, amount, currency, status) VALUES
    ('david', 'corp', 'david-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'corp', 'david-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('david', 'corp', 'david-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('david', 'corp', 'david-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'corp', 'david-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('david', 'corp', 'david-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('david', 'corp', 'david-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('david', 'corp', 'corp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('david', 'rrsp', 'david-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'rrsp', 'david-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('david', 'rrsp', 'david-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('david', 'rrsp', 'david-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'rrsp', 'david-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('david', 'rrsp', 'david-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('david', 'rrsp', 'david-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('david', 'rrsp', 'rrsp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('david', 'tfsa', 'david-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'tfsa', 'david-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('david', 'tfsa', 'david-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('david', 'tfsa', 'david-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'tfsa', 'david-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('david', 'tfsa', 'david-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('david', 'tfsa', 'david-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('david', 'tfsa', 'tfsa-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('david', 'rdsp', 'david-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'rdsp', 'david-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('david', 'rdsp', 'david-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('david', 'rdsp', 'david-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'rdsp', 'david-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('david', 'rdsp', 'david-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('david', 'rdsp', 'david-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('david', 'rdsp', 'rdsp-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled'),
    ('david', 'alt', 'david-t1', '2024-12-01T00:00:00Z', 'Contribution', 'From chequing ••4821', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'alt', 'david-t2', '2024-11-28T00:00:00Z', 'XEQT · Buy 12 units', 'All-Equity ETF', 'buy', -38412, 'CAD', 'posted'),
    ('david', 'alt', 'david-t3', '2024-11-15T00:00:00Z', 'Dividend · VFV', 'S&P 500 Index ETF', 'dividend', 4210, 'CAD', 'posted'),
    ('david', 'alt', 'david-t4', '2024-11-01T00:00:00Z', 'Contribution', 'Auto-invest', 'contribution', 50000, 'CAD', 'posted'),
    ('david', 'alt', 'david-t5', '2024-10-30T00:00:00Z', 'Management fee', '0.25% annual', 'fee', -1840, 'CAD', 'posted'),
    ('david', 'alt', 'david-t6', '2024-10-22T00:00:00Z', 'ZAG · Buy 8 units', 'Aggregate Bond ETF', 'buy', -11280, 'CAD', 'posted'),
    ('david', 'alt', 'david-t7', '2024-10-15T00:00:00Z', 'Dividend · XEQT', 'Quarterly distribution', 'dividend', 3160, 'CAD', 'posted'),
    ('david', 'alt', 'alt-s1', '2024-12-15T00:00:00Z', 'Auto contribution', 'Recurring monthly', 'scheduled', 50000, 'CAD', 'scheduled');

INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name) VALUES
    ('david', 'corp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('david', 'rrsp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('david', 'tfsa', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('david', 'rdsp', 11.2, 'CAD', 'S&P/TSX Composite'),
    ('david', 'alt', 11.2, 'CAD', 'S&P/TSX Composite');

INSERT INTO performance_points (user_id, account_id, series, period, value) VALUES
    ('david', 'corp', 'account', '2023-12', 40255000),
    ('david', 'corp', 'account', '2024-03', 42195000),
    ('david', 'corp', 'account', '2024-06', 44620000),
    ('david', 'corp', 'account', '2024-09', 46560000),
    ('david', 'corp', 'account', '2024-12', 48500000),
    ('david', 'corp', 'benchmark', '2023-12', 100),
    ('david', 'corp', 'benchmark', '2024-12', 108.4),
    ('david', 'rrsp', 'account', '2023-12', 18924000),
    ('david', 'rrsp', 'account', '2024-03', 19836000),
    ('david', 'rrsp', 'account', '2024-06', 20976000),
    ('david', 'rrsp', 'account', '2024-09', 21888000),
    ('david', 'rrsp', 'account', '2024-12', 22800000),
    ('david', 'rrsp', 'benchmark', '2023-12', 100),
    ('david', 'rrsp', 'benchmark', '2024-12', 108.4),
    ('david', 'tfsa', 'account', '2023-12', 12616000),
    ('david', 'tfsa', 'account', '2024-03', 13224000),
    ('david', 'tfsa', 'account', '2024-06', 13984000),
    ('david', 'tfsa', 'account', '2024-09', 14592000),
    ('david', 'tfsa', 'account', '2024-12', 15200000),
    ('david', 'tfsa', 'benchmark', '2023-12', 100),
    ('david', 'tfsa', 'benchmark', '2024-12', 108.4),
    ('david', 'rdsp', 'account', '2023-12', 7055000),
    ('david', 'rdsp', 'account', '2024-03', 7395000),
    ('david', 'rdsp', 'account', '2024-06', 7820000),
    ('david', 'rdsp', 'account', '2024-09', 8160000),
    ('david', 'rdsp', 'account', '2024-12', 8500000),
    ('david', 'rdsp', 'benchmark', '2023-12', 100),
    ('david', 'rdsp', 'benchmark', '2024-12', 108.4),
    ('david', 'alt', 'account', '2023-12', 20750000),
    ('david', 'alt', 'account', '2024-03', 21750000),
    ('david', 'alt', 'account', '2024-06', 23000000),
    ('david', 'alt', 'account', '2024-09', 24000000),
    ('david', 'alt', 'account', '2024-12', 25000000),
    ('david', 'alt', 'benchmark', '2023-12', 100),
    ('david', 'alt', 'benchmark', '2024-12', 108.4);

INSERT INTO documents (user_id, id, name, category, year, account_id, account_label, size_bytes, action_required, url) VALUES
    ('david', 'david-d1', '2024 T5 Tax Slip', 'Tax', 2024, 'corp', 'Corporate Investment', 219136, 1, 'mock://signed/david-d1'),
    ('david', 'david-d2', 'Q3 2024 Statement', 'Statements', 2024, 'rrsp', 'Personal RRSP', 1258291, 0, 'mock://signed/david-d2'),
    ('david', 'david-d3', 'Trade Confirmation · XEQT', 'Confirmations', 2024, 'corp', 'Corporate Investment', 90112, 0, 'mock://signed/david-d3'),
    ('david', 'david-d4', 'Q2 2024 Statement', 'Statements', 2024, 'corp', 'Corporate Investment', 1153433, 0, 'mock://signed/david-d4'),
    ('david', 'david-d5', '2023 T5 Tax Slip', 'Tax', 2023, 'rrsp', 'Personal RRSP', 205824, 0, 'mock://signed/david-d5'),
    ('david', 'david-d6', '2023 Annual Statement', 'Statements', 2023, 'rrsp', 'Personal RRSP', 2516582, 0, 'mock://signed/david-d6'),
    ('david', 'david-d7', 'Client Account Agreement', 'Legal', 2023, NULL, 'All accounts', 655360, 0, 'mock://signed/david-d7');

INSERT INTO goals (user_id, id, name, category, current_amount, target_amount, currency, target_date, progress_pct, show_on_dashboard, sort_order) VALUES
    ('david', 'goal-succession', 'Business succession', 'Retirement', 42000000, 120000000, 'CAD', '2035-01-01', 35, 1, 1),
    ('david', 'goal-estate', 'Estate planning fund', 'Safety', 15000000, 25000000, 'CAD', '2030-12-31', 60, 0, 2),
    ('david', 'goal-growth', 'Wealth growth target', 'Retirement', 120000000, 150000000, 'CAD', '2040-11-05', 80, 0, 3);

INSERT INTO portfolio_snapshots (user_id, currency, day_change, day_change_pct, as_of) VALUES
    ('david', 'CAD', 243200, 0.2, '2024-12-01T14:30:00Z');

INSERT INTO asset_allocations (user_id, asset_class, pct, sort_order) VALUES
    ('david', 'Equity', 72, 1),
    ('david', 'Fixed Income', 15, 2),
    ('david', 'Alternatives', 8, 3),
    ('david', 'Cash', 5, 4);

INSERT INTO alerts (user_id, id, type, title, deep_link) VALUES
    ('david', 'al-tax', 'INFO', 'Year-end tax-loss harvesting opportunity', 'electricwealth://market');

INSERT INTO quick_links (user_id, sort_order, label, deep_link) VALUES
    ('david', 1, 'Advanced analytics', 'electricwealth://accounts/corp'),
    ('david', 2, 'Private markets', 'electricwealth://market/baskets');
