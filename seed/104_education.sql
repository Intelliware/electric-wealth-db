-- Learning centre catalogue, glossary and each persona's progress (tables from migration 004).
-- English text and progress values come from v1 ElectricWealthAIDE; French text is new.

INSERT INTO education_content (id, title_en, title_fr, level, type, duration_min, sort_order) VALUES
    ('e1', 'Investing 101: Getting started', 'Placements 101 : premiers pas', 'beginner', 'class', 8, 1),
    ('e2', 'Understanding ETFs', 'Comprendre les FNB', 'beginner', 'class', 6, 2),
    ('e3', 'TFSA vs RRSP: which first?', 'CELI ou REER : lequel en premier?', 'beginner', 'challenge', 5, 3),
    ('e4', 'Build a diversified portfolio', 'Bâtir un portefeuille diversifié', 'intermediate', 'class', 12, 4),
    ('e5', 'Reading performance & benchmarks', 'Lire le rendement et les indices de référence', 'intermediate', 'class', 10, 5),
    ('e6', 'Tax-efficient investing', 'Investir de façon fiscalement avantageuse', 'advanced', 'class', 15, 6);

INSERT INTO glossary_terms (id, term_en, term_fr, definition_en, definition_fr, sort_order) VALUES
    ('asset-allocation', 'Asset allocation', 'Répartition de l’actif', 'How your money is split across stocks, bonds and cash to balance risk and return.', 'La façon dont votre argent est réparti entre actions, obligations et liquidités pour équilibrer le risque et le rendement.', 1),
    ('dividend', 'Dividend', 'Dividende', 'A share of a company''s profit paid to shareholders, usually quarterly.', 'Une part des bénéfices d’une société versée aux actionnaires, habituellement chaque trimestre.', 2),
    ('etf', 'ETF', 'FNB', 'Exchange-Traded Fund — a basket of securities you can buy in one trade, like a stock.', 'Fonds négocié en bourse — un panier de titres que vous achetez en une seule opération, comme une action.', 3),
    ('rrsp', 'RRSP', 'REER', 'Registered Retirement Savings Plan — contributions are tax-deductible and grow tax-deferred.', 'Régime enregistré d’épargne-retraite — les cotisations sont déductibles et la croissance est à l’abri de l’impôt jusqu’au retrait.', 4),
    ('tfsa', 'TFSA', 'CELI', 'Tax-Free Savings Account — investments grow and can be withdrawn tax-free.', 'Compte d’épargne libre d’impôt — les placements croissent et peuvent être retirés sans impôt.', 5),
    ('rate-of-return', 'Rate of return', 'Taux de rendement', 'The percentage gain or loss on an investment over a period of time.', 'Le gain ou la perte en pourcentage d’un placement sur une période donnée.', 6),
    ('rebalancing', 'Rebalancing', 'Rééquilibrage', 'Adjusting your holdings back to your target allocation as markets move.', 'Ramener vos placements à votre répartition cible à mesure que les marchés évoluent.', 7);

INSERT INTO education_progress (user_id, content_id, progress_pct, updated_at) VALUES
    ('sarah', 'e1', 100, '2024-11-30T12:00:00Z'),
    ('sarah', 'e2', 60, '2024-11-30T12:00:00Z'),
    ('michael', 'e1', 100, '2024-11-30T12:00:00Z'),
    ('michael', 'e2', 80, '2024-11-30T12:00:00Z'),
    ('michael', 'e4', 40, '2024-11-30T12:00:00Z'),
    ('linda', 'e1', 100, '2024-11-30T12:00:00Z'),
    ('linda', 'e5', 60, '2024-11-30T12:00:00Z'),
    ('david', 'e1', 100, '2024-11-30T12:00:00Z'),
    ('david', 'e4', 100, '2024-11-30T12:00:00Z'),
    ('david', 'e5', 100, '2024-11-30T12:00:00Z'),
    ('david', 'e6', 75, '2024-11-30T12:00:00Z'),
    ('emma', 'e1', 100, '2024-11-30T12:00:00Z'),
    ('emma', 'e2', 30, '2024-11-30T12:00:00Z'),
    ('foster', 'e1', 100, '2024-11-30T12:00:00Z');
