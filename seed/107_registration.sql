-- Clients who can enrol online, and the security question list (tables from migration 007).
-- New for the web edition: v1 only let the six personas "register", which signed them in as themselves.

INSERT INTO security_questions (id, text_en, text_fr, sort_order) VALUES
    ('q1', 'What was the name of your first pet?', 'Quel était le nom de votre premier animal de compagnie?', 1),
    ('q2', 'In what city were you born?', 'Dans quelle ville êtes-vous né(e)?', 2),
    ('q3', 'What was the make of your first car?', 'Quelle était la marque de votre première voiture?', 3),
    ('q4', 'What was the last name of your favourite teacher?', 'Quel était le nom de famille de votre enseignant(e) préféré(e)?', 4),
    ('q5', 'What street did you grow up on?', 'Dans quelle rue avez-vous grandi?', 5);

INSERT INTO offline_clients (account_number, name, date_of_birth, phone_masked, sin_masked, client_since, address_line1, address_line2, city, province, postal_code, country, language, advisor_id, enrolled_user_id) VALUES
    ('7391046285', 'Priya Patel', '1990-02-17', '+1 (613) •••-••24', '••• ••• 337', 2019, '150 Elgin Street', 'Suite 1200', 'Ottawa', 'ON', 'K1P 5G4', 'Canada', 'en-CA', 'adv-1', NULL),
    ('2654819370', 'Marc Tremblay', '1985-09-03', '+1 (514) •••-••61', '••• ••• 128', 2015, '3575 avenue du Parc', NULL, 'Montréal', 'QC', 'H2X 1Y4', 'Canada', 'fr-CA', 'adv-1', NULL);

-- The six personas already use online banking, so their branch records are marked as enrolled.
INSERT INTO offline_clients (account_number, name, date_of_birth, phone_masked, sin_masked, client_since, address_line1, address_line2, city, province, postal_code, country, language, advisor_id, enrolled_user_id)
SELECT u.account_number, u.name, u.date_of_birth, p.phone_masked, p.sin_masked, p.member_since, p.address_line1, p.address_line2,
       p.city, p.province, p.postal_code, p.country, pr.language, u.advisor_id, u.id
FROM users u
JOIN user_profiles p ON p.user_id = u.id
JOIN user_preferences pr ON pr.user_id = u.id;

UPDATE users SET terms_accepted_at = '2024-01-01T00:00:00Z';
