-- Notifications for all personas (table from migration 002).
-- Generated from v1 ElectricWealthAIDE server seed data.

INSERT INTO notifications (user_id, id, title, body, type, created_at, read) VALUES
    ('sarah', 'no1', 'Sign your 2024 tax form', 'Action required before Feb 28.', 'ACTION_REQUIRED', '2024-12-01T13:30:00Z', 0),
    ('sarah', 'no2', 'Advisor meeting confirmed', 'Video call with Jordan Avery, Thu 2:30 PM.', 'SUCCESS', '2024-12-01T11:30:00Z', 0),
    ('sarah', 'no3', 'Bank of Canada holds rate', 'Rates held at 3.25%. See what it means for you.', 'INFO', '2024-12-01T08:00:00Z', 1),
    ('sarah', 'no4', 'Q3 statement ready', 'Your Retirement RRSP statement is available.', 'INFO', '2024-11-29T09:00:00Z', 1),
    ('sarah', 'no5', 'Auto-contribution processed', '$500.00 invested to Growth TFSA.', 'SUCCESS', '2024-11-28T09:00:00Z', 1),
    ('michael', 'no-m1', 'CESG grant posted', '$500 grant added to Elena RESP.', 'SUCCESS', '2024-12-01T09:00:00Z', 0),
    ('michael', 'no-m2', 'Rebalance suggestion', 'Your equity allocation is above target.', 'INFO', '2024-11-28T10:00:00Z', 1),
    ('michael', 'no-m3', 'Q3 statement ready', 'Retirement RRSP statement available.', 'INFO', '2024-11-25T09:00:00Z', 1),
    ('linda', 'no-l1', 'Retirement review due', 'Schedule a call to review your withdrawal strategy.', 'ACTION_REQUIRED', '2024-12-01T08:00:00Z', 0),
    ('linda', 'no-l2', 'Portfolio rebalanced', 'Fixed income allocation increased to 48%.', 'SUCCESS', '2024-11-30T14:00:00Z', 1),
    ('david', 'no-d1', 'Tax-loss harvesting alert', '3 positions eligible for harvesting.', 'INFO', '2024-12-01T07:00:00Z', 0),
    ('david', 'no-d2', 'Private equity update', 'Q3 fund report available.', 'INFO', '2024-11-29T12:00:00Z', 1),
    ('emma', 'no-e1', 'Round-up invested', '$12.50 auto-invested this week.', 'SUCCESS', '2024-12-01T06:00:00Z', 0),
    ('emma', 'no-e2', 'Lesson complete!', 'You finished Investing 101.', 'SUCCESS', '2024-11-30T20:00:00Z', 1),
    ('foster', 'no-f1', 'Beneficiary review due', 'Please confirm your beneficiary information.', 'ACTION_REQUIRED', '2024-12-01T09:00:00Z', 0),
    ('foster', 'no-f2', 'RRIF minimum withdrawal', '2024 minimum withdrawal completed.', 'SUCCESS', '2024-11-15T10:00:00Z', 1);
