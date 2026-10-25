-- ======================================================
-- Seed Data for BookMyShow
-- Distinct Movies & Schedules Per City (Next 14 Days)
-- ======================================================

USE bookmyshow;

-- 1. Ensure trending movies exist with current metadata
INSERT INTO movies (id, title, language, genre, duration_minutes, certificate, description, poster_url, trailer_url, active)
VALUES 
(1, 'Kalki 2898 AD', 'Hindi', 'Sci-Fi / Action', 181, 'U/A',
 'In a dystopian post-apocalyptic future, immortal warriors clash to protect the divine child destined to defeat the supreme ruler.',
 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=900', '', b'1'),

(2, 'Pushpa 2: The Rule', 'Telugu, Hindi', 'Action / Thriller / Drama', 200, 'A',
 'Pushpa Raj expands his red sandalwood empire across borders while locked in an all-out war with SP Bhanwar Singh Shekhawat.',
 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=900', '', b'1'),

(3, 'Singham Again', 'Hindi', 'Action / Thriller', 160, 'U/A',
 'DCP Bajirao Singham leads the high-stakes cross-border mission with the cop universe to save his family and defeat a terror cell.',
 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=900', '', b'1'),

(4, 'Devara: Part 1', 'Telugu, Hindi', 'Action / Drama', 178, 'U/A',
 'A fearless warrior from the coastal lands rises to safeguard his people from deceit, greed and ruthless sea pirates.',
 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=900', '', b'1'),

(5, 'Stree 2', 'Hindi', 'Comedy / Horror', 147, 'U/A',
 'The town of Chanderi is gripped by terror as a headless demon known as Sarkata starts abducting modern independent women.',
 'https://images.unsplash.com/photo-1509281373149-e957c6296406?w=900', '', b'1'),

(6, 'Jailer 2', 'Tamil, Hindi', 'Action / Crime / Thriller', 172, 'U/A',
 'Superstar Rajinikanth returns as Tiger Muthuvel Pandian in this explosive blockbuster sequel, unleashing an unstoppable war against an international syndicate.',
 'https://images.unsplash.com/photo-1631540376030-acb6beacf09d?w=1600', '', b'1')

ON DUPLICATE KEY UPDATE 
    title = VALUES(title),
    language = VALUES(language),
    genre = VALUES(genre),
    duration_minutes = VALUES(duration_minutes),
    certificate = VALUES(certificate),
    description = VALUES(description),
    poster_url = VALUES(poster_url),
    trailer_url = '',
    active = VALUES(active);

-- 2. Clear old show records from testing (cascading show_seats without bookings)
DELETE FROM show_seats WHERE show_id IN (SELECT id FROM shows WHERE starts_at >= CURDATE() AND id NOT IN (SELECT show_id FROM booking WHERE show_id IS NOT NULL));
DELETE FROM shows WHERE starts_at >= CURDATE() AND id NOT IN (SELECT show_id FROM booking WHERE show_id IS NOT NULL);

-- 3. Populate Distinct Shows per City
DROP PROCEDURE IF EXISTS populate_distinct_city_shows;

DELIMITER $$
CREATE PROCEDURE populate_distinct_city_shows()
BEGIN
    DECLARE day_offset INT DEFAULT 0;
    DECLARE curr_day DATE;

    WHILE day_offset <= 14 DO
        SET curr_day = DATE_ADD(CURDATE(), INTERVAL day_offset DAY);

        -- ==================== 1. NASHIK (theatre_id = 4: PVR City Mall) ====================
        -- Featured: Jailer 2, Pushpa 2, Stree 2, Singham Again (NO Kalki, NO Devara)
        INSERT INTO shows (movie_id, theatre_id, starts_at, start_at, end_at, ticket_price, total_seats, available_seats, active, version)
        VALUES 
        (6, 4, TIMESTAMP(curr_day, '10:15:00'), TIMESTAMP(curr_day, '10:15:00'), TIMESTAMP(curr_day, '13:07:00'), 220.00, 100, 100, b'1', 0),
        (6, 4, TIMESTAMP(curr_day, '14:30:00'), TIMESTAMP(curr_day, '14:30:00'), TIMESTAMP(curr_day, '17:22:00'), 280.00, 100, 100, b'1', 0),
        (6, 4, TIMESTAMP(curr_day, '18:45:00'), TIMESTAMP(curr_day, '18:45:00'), TIMESTAMP(curr_day, '21:37:00'), 350.00, 100, 100, b'1', 0),
        (6, 4, TIMESTAMP(curr_day, '22:15:00'), TIMESTAMP(curr_day, '22:15:00'), TIMESTAMP(DATE_ADD(curr_day, INTERVAL 1 DAY), '01:07:00'), 300.00, 100, 100, b'1', 0),
        (2, 4, TIMESTAMP(curr_day, '11:00:00'), TIMESTAMP(curr_day, '11:00:00'), TIMESTAMP(curr_day, '14:20:00'), 280.00, 100, 100, b'1', 0),
        (2, 4, TIMESTAMP(curr_day, '19:30:00'), TIMESTAMP(curr_day, '19:30:00'), TIMESTAMP(curr_day, '22:50:00'), 360.00, 100, 100, b'1', 0),
        (5, 4, TIMESTAMP(curr_day, '13:00:00'), TIMESTAMP(curr_day, '13:00:00'), TIMESTAMP(curr_day, '15:27:00'), 200.00, 100, 100, b'1', 0),
        (5, 4, TIMESTAMP(curr_day, '21:00:00'), TIMESTAMP(curr_day, '21:00:00'), TIMESTAMP(curr_day, '23:27:00'), 260.00, 100, 100, b'1', 0),
        (3, 4, TIMESTAMP(curr_day, '16:00:00'), TIMESTAMP(curr_day, '16:00:00'), TIMESTAMP(curr_day, '18:40:00'), 250.00, 100, 100, b'1', 0);

        -- ==================== 2. BENGALURU (theatre_id = 3: INOX Megaplex) ====================
        -- Featured: Jailer 2, Devara: Part 1, Kalki 2898 AD, Pushpa 2 (NO Stree 2, NO Singham Again)
        INSERT INTO shows (movie_id, theatre_id, starts_at, start_at, end_at, ticket_price, total_seats, available_seats, active, version)
        VALUES 
        (6, 3, TIMESTAMP(curr_day, '09:30:00'), TIMESTAMP(curr_day, '09:30:00'), TIMESTAMP(curr_day, '12:22:00'), 250.00, 100, 100, b'1', 0),
        (6, 3, TIMESTAMP(curr_day, '13:15:00'), TIMESTAMP(curr_day, '13:15:00'), TIMESTAMP(curr_day, '16:07:00'), 320.00, 100, 100, b'1', 0),
        (6, 3, TIMESTAMP(curr_day, '17:45:00'), TIMESTAMP(curr_day, '17:45:00'), TIMESTAMP(curr_day, '20:37:00'), 400.00, 100, 100, b'1', 0),
        (6, 3, TIMESTAMP(curr_day, '21:30:00'), TIMESTAMP(curr_day, '21:30:00'), TIMESTAMP(DATE_ADD(curr_day, INTERVAL 1 DAY), '00:22:00'), 380.00, 100, 100, b'1', 0),
        (4, 3, TIMESTAMP(curr_day, '11:15:00'), TIMESTAMP(curr_day, '11:15:00'), TIMESTAMP(curr_day, '14:13:00'), 300.00, 100, 100, b'1', 0),
        (4, 3, TIMESTAMP(curr_day, '18:15:00'), TIMESTAMP(curr_day, '18:15:00'), TIMESTAMP(curr_day, '21:13:00'), 380.00, 100, 100, b'1', 0),
        (1, 3, TIMESTAMP(curr_day, '14:45:00'), TIMESTAMP(curr_day, '14:45:00'), TIMESTAMP(curr_day, '17:46:00'), 350.00, 100, 100, b'1', 0),
        (2, 3, TIMESTAMP(curr_day, '22:15:00'), TIMESTAMP(curr_day, '22:15:00'), TIMESTAMP(DATE_ADD(curr_day, INTERVAL 1 DAY), '01:35:00'), 360.00, 100, 100, b'1', 0);

        -- ==================== 3. MUMBAI (theatre_id = 2: INOX R-City) ====================
        -- Featured: Singham Again, Stree 2, Pushpa 2, Jailer 2 (NO Kalki, NO Devara)
        INSERT INTO shows (movie_id, theatre_id, starts_at, start_at, end_at, ticket_price, total_seats, available_seats, active, version)
        VALUES 
        (3, 2, TIMESTAMP(curr_day, '10:00:00'), TIMESTAMP(curr_day, '10:00:00'), TIMESTAMP(curr_day, '12:40:00'), 300.00, 100, 100, b'1', 0),
        (3, 2, TIMESTAMP(curr_day, '14:15:00'), TIMESTAMP(curr_day, '14:15:00'), TIMESTAMP(curr_day, '16:55:00'), 360.00, 100, 100, b'1', 0),
        (3, 2, TIMESTAMP(curr_day, '18:30:00'), TIMESTAMP(curr_day, '18:30:00'), TIMESTAMP(curr_day, '21:10:00'), 420.00, 100, 100, b'1', 0),
        (5, 2, TIMESTAMP(curr_day, '11:30:00'), TIMESTAMP(curr_day, '11:30:00'), TIMESTAMP(curr_day, '13:57:00'), 280.00, 100, 100, b'1', 0),
        (5, 2, TIMESTAMP(curr_day, '16:30:00'), TIMESTAMP(curr_day, '16:30:00'), TIMESTAMP(curr_day, '18:57:00'), 340.00, 100, 100, b'1', 0),
        (2, 2, TIMESTAMP(curr_day, '13:00:00'), TIMESTAMP(curr_day, '13:00:00'), TIMESTAMP(curr_day, '16:20:00'), 350.00, 100, 100, b'1', 0),
        (2, 2, TIMESTAMP(curr_day, '20:15:00'), TIMESTAMP(curr_day, '20:15:00'), TIMESTAMP(curr_day, '23:35:00'), 420.00, 100, 100, b'1', 0),
        (6, 2, TIMESTAMP(curr_day, '22:15:00'), TIMESTAMP(curr_day, '22:15:00'), TIMESTAMP(DATE_ADD(curr_day, INTERVAL 1 DAY), '01:07:00'), 380.00, 100, 100, b'1', 0);

        -- ==================== 4. DELHI (theatre_id = 1: PVR Select Citywalk) ====================
        -- Featured: Kalki 2898 AD, Singham Again, Devara: Part 1, Stree 2 (NO Jailer 2, NO Pushpa 2)
        INSERT INTO shows (movie_id, theatre_id, starts_at, start_at, end_at, ticket_price, total_seats, available_seats, active, version)
        VALUES 
        (1, 1, TIMESTAMP(curr_day, '10:30:00'), TIMESTAMP(curr_day, '10:30:00'), TIMESTAMP(curr_day, '13:31:00'), 320.00, 100, 100, b'1', 0),
        (1, 1, TIMESTAMP(curr_day, '16:45:00'), TIMESTAMP(curr_day, '16:45:00'), TIMESTAMP(curr_day, '19:46:00'), 420.00, 100, 100, b'1', 0),
        (3, 1, TIMESTAMP(curr_day, '11:45:00'), TIMESTAMP(curr_day, '11:45:00'), TIMESTAMP(curr_day, '14:25:00'), 300.00, 100, 100, b'1', 0),
        (3, 1, TIMESTAMP(curr_day, '19:00:00'), TIMESTAMP(curr_day, '19:00:00'), TIMESTAMP(curr_day, '21:40:00'), 380.00, 100, 100, b'1', 0),
        (4, 1, TIMESTAMP(curr_day, '13:30:00'), TIMESTAMP(curr_day, '13:30:00'), TIMESTAMP(curr_day, '16:28:00'), 340.00, 100, 100, b'1', 0),
        (5, 1, TIMESTAMP(curr_day, '15:15:00'), TIMESTAMP(curr_day, '15:15:00'), TIMESTAMP(curr_day, '17:42:00'), 260.00, 100, 100, b'1', 0),
        (5, 1, TIMESTAMP(curr_day, '21:30:00'), TIMESTAMP(curr_day, '21:30:00'), TIMESTAMP(curr_day, '23:57:00'), 340.00, 100, 100, b'1', 0);

        SET day_offset = day_offset + 1;
    END WHILE;
END $$
DELIMITER ;

CALL populate_distinct_city_shows();
DROP PROCEDURE IF EXISTS populate_distinct_city_shows;
