-- Advisor, client assignments, past meetings and message threads (tables from migration 005).
-- Messages come from v1 ElectricWealthAIDE. Message ids are prefixed with the user id to keep them unique across users.

INSERT INTO advisors (id, name, designation, available) VALUES
    ('adv-1', 'Jordan Avery', 'CFP', 1);

UPDATE users SET advisor_id = 'adv-1';

-- Sarah's video call from her 'Advisor meeting confirmed' notification, now in the past.
INSERT INTO appointments (id, user_id, advisor_id, meeting_type, date, time, status, notes, created_at) VALUES
    ('appt-sarah-1', 'sarah', 'adv-1', 'video', '2024-12-05', '14:30', 'completed', 'FHSA allocation for the house goal', '2024-12-01T11:30:00Z');

INSERT INTO advisor_messages (id, user_id, advisor_id, sender, text, sent_at) VALUES
    ('sarah-m1', 'sarah', 'adv-1', 'advisor', 'Hi Sarah — great to connect. I took a look at your allocation ahead of our chat.', '2024-12-01T13:00:00Z'),
    ('sarah-m2', 'sarah', 'adv-1', 'client', 'Thanks Jordan! I''m wondering if I should shift more into my FHSA for the house goal.', '2024-12-01T13:02:00Z'),
    ('sarah-m3', 'sarah', 'adv-1', 'advisor', 'Good question. Given your Jun 2027 timeline, a higher cash/bond mix in the FHSA makes sense. Let''s review options.', '2024-12-01T13:05:00Z'),
    ('michael-mm1', 'michael', 'adv-1', 'advisor', 'Hi Michael — I reviewed your RESP contributions ahead of year-end.', '2024-12-01T10:00:00Z'),
    ('michael-mm2', 'michael', 'adv-1', 'client', 'Should we max both RESPs before contributing more to RRSP?', '2024-12-01T10:05:00Z'),
    ('michael-mm3', 'michael', 'adv-1', 'advisor', 'Good plan. Let us prioritize CESG-eligible RESP room first.', '2024-12-01T10:08:00Z'),
    ('linda-lm1', 'linda', 'adv-1', 'advisor', 'Linda, your portfolio is positioned conservatively for a 62 retirement.', '2024-11-29T15:00:00Z'),
    ('linda-lm2', 'linda', 'adv-1', 'client', 'Should I delay retirement to 65 given recent market volatility?', '2024-11-29T15:10:00Z'),
    ('david-dm1', 'david', 'adv-1', 'advisor', 'David, I have the year-end tax optimization report ready.', '2024-12-01T08:00:00Z'),
    ('david-dm2', 'david', 'adv-1', 'client', 'Please include the corporate account in the analysis.', '2024-12-01T08:05:00Z'),
    ('emma-em1', 'emma', 'adv-1', 'advisor', 'Welcome Emma! Start with your TFSA — great first step.', '2024-11-28T12:00:00Z'),
    ('foster-fm1', 'foster', 'adv-1', 'advisor', 'Robert, your monthly withdrawal plan is on track.', '2024-11-30T11:00:00Z'),
    ('foster-fm2', 'foster', 'adv-1', 'client', 'Can we increase the TFSA withdrawal slightly for the cruise?', '2024-11-30T11:15:00Z');
