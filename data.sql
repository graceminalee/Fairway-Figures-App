-- DROP TABLE IF EXISTS shots CASCADE;
-- DROP TABLE IF EXISTS holes CASCADE;
-- DROP TABLE IF EXISTS rounds CASCADE;
-- DROP TABLE IF EXISTS courses CASCADE;
-- DROP TABLE IF EXISTS accounts CASCADE;
-- DROP TABLE IF EXISTS users CASCADE;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    users_id SERIAL NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    username VARCHAR NOT NULL, 
    email VARCHAR NOT NULL,
    users_password VARCHAR NOT NULL,
    PRIMARY KEY (users_id),
    CONSTRAINT users_email_key UNIQUE(email),
    CONSTRAINT users_username_key UNIQUE(username)
);
-- Accounts table
CREATE TABLE IF NOT EXISTS accounts (
    account_id SERIAL NOT NULL,
    username VARCHAR NOT NULL, 
    bio TEXT DEFAULT '',
    home_location VARCHAR, -- Change in queries
    phone VARCHAR(15), 
    home_course TEXT DEFAULT '',
    profile_picture TEXT DEFAULT '',
    PRIMARY KEY (account_id),
    FOREIGN KEY(username) REFERENCES users(username) ON DELETE CASCADE--CONSTRAINT accounts_username_fkey 
);
-- Course table
CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL NOT NULL,
    course_name VARCHAR NOT NULL, 
    course_state VARCHAR, -- chagne this is queries
    course_city VARCHAR,
    PRIMARY KEY (course_id)
);
-- Rounds table
CREATE TABLE IF NOT EXISTS rounds (
    round_id SERIAL NOT NULL, 
    username VARCHAR NOT NULL, 
    course_id INT,
    date_played DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    round_status VARCHAR DEFAULT 'active',
    PRIMARY KEY(round_id), 
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (username) REFERENCES users(username)
);
-- Holes table
CREATE TABLE IF NOT EXISTS holes (
    hole_id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    round_id INTEGER NOT NULL,
    hole_number INTEGER NOT NULL,
    par INTEGER NOT NULL,
    start_yardage INTEGER NOT NULL,
    total_shots INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (round_id) REFERENCES rounds(round_id),
    UNIQUE (round_id, hole_number)
);

-- Followers table
CREATE TABLE IF NOT EXISTS followers (
    follower_username VARCHAR NOT NULL,
    followed_username VARCHAR NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_username, followed_username),
    FOREIGN KEY (follower_username) REFERENCES users(username),
    FOREIGN KEY (followed_username) REFERENCES users(username)
);

-- Clubs table
CREATE TABLE IF NOT EXISTS clubs (
   club_id SERIAL PRIMARY KEY,
   club_type VARCHAR NOT NULL,
   brand VARCHAR NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User's Club table
CREATE TABLE IF NOT EXISTS user_clubs (
   username VARCHAR NOT NULL,
   club_id INTEGER NOT NULL,
   slot_number INTEGER NOT NULL,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (username, slot_number),
   FOREIGN KEY (username) REFERENCES users(username),
   FOREIGN KEY (club_id) REFERENCES clubs(club_id),
   UNIQUE (username, slot_number)
);

-- -- Shots table
-- CREATE TABLE IF NOT EXISTS shots (
--     shot_id SERIAL NOT NULL,
--     round_id INTEGER NOT NULL,
--     hole_id INTEGER NOT NULL,
--     shot_number INTEGER NOT NULL,
--     club_used VARCHAR NOT NULL,
--     end_lie VARCHAR(3) NOT NULL, -- 'FW' (fairway), 'RO' (rough), 'BU' (bunker), 'GR' (green), 'IH' (in hole)
--     distance_in INTEGER NOT NULL,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--     PRIMARY KEY (shot_id),
--     FOREIGN KEY (round_id) REFERENCES rounds(round_id),
--     FOREIGN KEY (hole_id) REFERENCES holes(hole_id)

-- );



-- Users Data
INSERT INTO users (first_name, last_name, username, email, users_password) VALUES
('John', 'Doe', 'johndoe', 'john.doe@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), -- hashed, use password123 to login
('Jane', 'Smith', 'janesmith', 'jane.smith@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), -- hashed, use password123 to login
('Mike', 'Johnson', 'mikejohnson', 'mike.johnson@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), -- hashed, use password123 to login
('Emily', 'Johnson', 'emilyjohnson', 'emily.johnson@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), 
('Cooper', 'Fisher', 'cooperfisher', 'cooper.fisher@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), -- hashed, use password123 to login
('Cliff', 'Lande', 'clifflande', 'cliff.lande@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), -- hashed, use password123 to login
('Mike', 'Lee', 'mikelee', 'mike.lee@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), -- hashed, use password123 to login
('Sarah', 'Connor', 'sarahconnor', 'sarah.connor@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Peter', 'Parker', 'peterparker', 'peter.parker@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Bruce', 'Wayne', 'brucewayne', 'bruce.wayne@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Diana', 'Prince', 'dianaprince', 'diana.prince@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Clark', 'Kent', 'clarkkent', 'clark.kent@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Barry', 'Allen', 'barryallen', 'barry.allen@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Arthur', 'Curry', 'arthurcurry', 'arthur.curry@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Victor', 'Stone', 'victorstone', 'victor.stone@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Steve', 'Rogers', 'steverogers', 'steve.rogers@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Natasha', 'Romanoff', 'natasharomanoff', 'natasha.romanoff@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Tony', 'Stark', 'tonystark', 'tony.stark@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Bruce', 'Banner', 'brucebanner', 'bruce.banner@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Carol', 'Danvers', 'caroldanvers', 'carol.danvers@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'), 

('Emma', 'Rodriguez', 'emmarodriguez', 'emma.rodriguez@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Ryan', 'Thompson', 'ryanthompson', 'ryan.thompson@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Sophia', 'Chen', 'sophiachen', 'sophia.chen@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Daniel', 'Kim', 'danielkim', 'daniel.kim@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Olivia', 'Patel', 'oliviapatel', 'olivia.patel@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Luis', 'Garcia', 'luisgarcia', 'luis.garcia@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Zara', 'Williams', 'zarawilliams', 'zara.williams@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Ethan', 'Brown', 'ethanbrown', 'ethan.brown@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Isabella', 'Martinez', 'isabellamartinez', 'isabella.martinez@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Nathan', 'Jones', 'nathanjones', 'nathan.jones@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Ava', 'Harris', 'avaharris', 'ava.harris@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Marcus', 'Lee', 'marcuslee', 'marcus.lee@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Elena', 'Davis', 'elenadavis', 'elena.davis@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Alex', 'Miller', 'alexmiller', 'alex.miller@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Grace', 'Wilson', 'gracewilson', 'grace.wilson@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Kevin', 'Taylor', 'kevintaylor', 'kevin.taylor@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Rachel', 'Anderson', 'rachelgolf', 'rachel.anderson@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Michael', 'Thomas', 'michaelthomas', 'michael.thomas@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Lauren', 'Jackson', 'laurenjackson', 'lauren.jackson@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('David', 'White', 'davidwhite', 'david.white@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Samantha', 'Martin', 'samanthamartin', 'samantha.martin@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Jason', 'Clark', 'jasonclark', 'jason.clark@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Nicole', 'Lewis', 'nicolelewis', 'nicole.lewis@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Robert', 'Moore', 'robertmoore', 'robert.moore@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Megan', 'Walker', 'meganwalker', 'megan.walker@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm'),
('Tyler', 'Hall', 'tylerhall', 'tyler.hall@example.com', '$2a$10$7FjHZGfPgFJMpcv/28gUV.T04ctLanU6lmTSs2CmBUs5esdK1nbqm');


-- Accounts Data
INSERT INTO accounts (username, bio, home_location, phone, home_course, profile_picture) VALUES
('johndoe', 'Golf enthusiast from California', 'San Francisco, CA', '415-555-1234', 'Golden Gate Park Golf Course', 'null'),
('janesmith', 'Professional golfer and coach', 'Austin, TX', '512-555-5678', 'Austin Country Club','null'),
('mikejohnson', 'Weekend golfer loving the sport', 'Chicago, IL', '312-555-9012', 'Windy City Golf Club', 'null'),
('emilyjohnson', 'Golf enthusiast from Washington', 'Seattle, WA', '768-123-3443', 'Sahalee Golf Course', 'null'),
('cooperfisher', 'Professional golfer and sponsor', 'Austin, TX', '123-645-2134', 'Austin Country Club', 'null'),
('clifflande', 'Just for fun', 'Chicago, IL', '312-123-9012', 'Windy City Golf Club', 'null'),
('mikelee', 'Social golfer', 'Spokane, WA', '312-346-9012', 'Manito Golf Club','null'),
('sarahconnor', 'Enjoys golf during weekends', 'San Diego, CA', '619-555-7890', 'Torrey Pines Golf Course', 'null'),
('peterparker', 'Part-time photographer and golfer', 'New York, NY', '646-555-1212', 'Van Cortlandt Park Golf Course', 'null'),
('brucewayne', 'Corporate professional and golfer', 'Gotham City, NJ', '201-555-3434', 'Wayne Country Club', 'null'),
('dianaprince', 'Amazonian golfer with style', 'Themyscira', '800-555-1234', 'Themyscira Golf Course', 'null'),
('clarkkent', 'Journalist by day, golfer by weekend', 'Metropolis, NY', '555-555-1212', 'Metropolis Country Club', 'null'),
('barryallen', 'Fastest golfer alive', 'Central City', '732-555-2121', 'Flash Links', 'null'),
('arthurcurry', 'Underwater golfing pro', 'Atlantis', '404-555-4343', 'Atlantis Aqua Club', 'null'),
('victorstone', 'Tech-savvy golfer', 'Detroit, MI', '313-555-9999', 'Cyborg Golf Club', 'null'),
('steverogers', 'Golfer out of time', 'Brooklyn, NY', '718-555-1941', 'Liberty Links', 'null'),
('natasharomanoff', 'Secret agent golfer', 'Unknown', '202-555-1099', 'Widow Green', 'null'),
('tonystark', 'Billionaire golfer philanthropist', 'Malibu, CA', '310-555-1234', 'Stark Golf Course', 'null'),
('brucebanner', 'Calm golfer', 'Dayton, OH', '937-555-2233', 'Gamma Greens', 'null'),
('caroldanvers', 'Jolly man', 'Dayton, OH', '121-745-2468', 'Dayton Country Club', 'null'), 

('emmarodriguez', 'Golf enthusiast from Florida', 'Miami, FL', '305-555-1212', 'Miami Beach Golf Club', 'null'),
('ryanthompson', 'Weekend warrior golfer', 'Portland, OR', '503-555-7878', 'Riverside Golf Course', 'null'),
('sophiachen', 'Tech professional who loves golf', 'Seattle, WA', '206-555-9898', 'Newcastle Golf Club', 'null'),
('danielkim', 'Golf coach and strategy enthusiast', 'Atlanta, GA', '404-555-2323', 'East Lake Golf Club', 'null'),
('oliviapatel', 'Corporate golfer traveling the country', 'Houston, TX', '713-555-4545', 'Houston Country Club', 'null'),
('luisgarcia', 'Mountain golf lover', 'Denver, CO', '303-555-6767', 'Cherry Hills Country Club', 'null'),
('zarawilliams', 'Aspiring professional golfer', 'Phoenix, AZ', '602-555-8989', 'TPC Scottsdale', 'null'),
('ethanbrown', 'Golf equipment reviewer', 'Boston, MA', '617-555-1010', 'Old Bostonian Golf Club', 'null'),
('isabellamartinez', 'Public relations executive and golfer', 'Las Vegas, NV', '702-555-3232', 'Shadow Creek Golf Course', 'null'),
('nathanjones', 'Philosophy professor who golfs', 'Berkeley, CA', '510-555-5454', 'Tilden Park Golf Course', 'null'),
('avaharris', 'Marketing specialist and golf enthusiast', 'Charlotte, NC', '704-555-6676', 'Quail Hollow Club', 'null'),
('marcuslee', 'Data scientist on the greens', 'San Jose, CA', '408-555-7878', 'Los Gatos Golf Course', 'null'),
('elenadavis', 'Environmental lawyer and golfer', 'Portland, ME', '207-555-9090', 'Riverside Country Club', 'null'),
('alexmiller', 'Startup founder who golfs', 'Austin, TX', '512-555-2121', 'Omni Barton Creek Resort', 'null'),
('gracewilson', 'Professional photographer capturing golf', 'Nashville, TN', '615-555-3333', 'Hermitage Golf Course', 'null'),
('kevintaylor', 'Software engineer and golf strategist', 'Salt Lake City, UT', '801-555-4545', 'Mountain Dell Golf Course', 'null'),
('rachelgolf', 'Public health professional', 'Minneapolis, MN', '612-555-5656', 'Hazeltine National Golf Club', 'null'),
('michaelthomas', 'Investment banker who golfs', 'Chicago, IL', '312-555-7777', 'Olympia Fields Country Club', 'null'),
('laurenjackson', 'Real estate agent and golf lover', 'Phoenix, AZ', '480-555-8888', 'Arizona Biltmore Golf Club', 'null'),
('davidwhite', 'High school golf coach', 'San Antonio, TX', '210-555-9999', 'Silverhorn Golf Club', 'null'),
('samanthamartin', 'Yoga instructor and golfer', 'Santa Fe, NM', '505-555-1111', 'Marty Sanchez Links', 'null'),
('jasonclark', 'Restaurant owner who golfs', 'New Orleans, LA', '504-555-2222', 'English Turn Golf Club', 'null'),
('nicolelewis', 'Fitness trainer and golf enthusiast', 'Orlando, FL', '407-555-3333', 'Grand Cypress Golf Club', 'null'),
('robertmoore', 'Retired military golf lover', 'San Diego, CA', '619-555-4444', 'Torrey Pines Golf Course', 'null'),
('meganwalker', 'Art gallery curator who golfs', 'Santa Barbara, CA', '805-555-5555', 'Sandpiper Golf Club', 'null'),
('tylerhall', 'Jazz musician and weekend golfer', 'Kansas City, MO', '816-555-6666', 'Blue Hills Country Club', 'null');



-- Courses Data
INSERT INTO courses (course_name, course_state, course_city) VALUES
('Golden Gate Park Golf Course', 'CA', 'San Francisco'),
('Austin Country Club', 'TX', 'Austin'),
('Windy City Golf Club', 'IL', 'Chicago'),
('Pebble Beach Golf Links', 'CA', 'Pebble Beach'),
('Lake Shore Country Club', 'IL', 'Chicago'),
('Manito Golf Club', 'WA', 'Spokane'),
('Sahalee Country Club', 'WA', 'Redmond'),

('Miami Beach Golf Club', 'FL', 'Miami'),
('Riverside Golf Course', 'OR', 'Portland'),
('Newcastle Golf Club', 'WA', 'Newcastle'),
('East Lake Golf Club', 'GA', 'Atlanta'),
('Houston Country Club', 'TX', 'Houston'),
('Cherry Hills Country Club', 'CO', 'Denver'),
('TPC Scottsdale', 'AZ', 'Scottsdale'),
('Old Bostonian Golf Club', 'MA', 'Boston'),
('Shadow Creek Golf Course', 'NV', 'Las Vegas'),
('Tilden Park Golf Course', 'CA', 'Berkeley'),
('Quail Hollow Club', 'NC', 'Charlotte'),
('Los Gatos Golf Course', 'CA', 'Los Gatos'),
('Riverside Country Club', 'ME', 'Portland'),
('Omni Barton Creek Resort', 'TX', 'Austin'),
('Hermitage Golf Course', 'TN', 'Nashville'),
('Mountain Dell Golf Course', 'UT', 'Salt Lake City'),
('Hazeltine National Golf Club', 'MN', 'Chaska'),
('Olympia Fields Country Club', 'IL', 'Olympia Fields'),
('Arizona Biltmore Golf Club', 'AZ', 'Phoenix'),
('Silverhorn Golf Club', 'TX', 'San Antonio'),
('Marty Sanchez Links', 'NM', 'Santa Fe'),
('English Turn Golf Club', 'LA', 'New Orleans'),
('Grand Cypress Golf Club', 'FL', 'Orlando'),
('Torrey Pines Golf Course', 'CA', 'San Diego'),
('Sandpiper Golf Club', 'CA', 'Santa Barbara'),
('Blue Hills Country Club', 'MO', 'Kansas City');

-- Rounds Data
INSERT INTO rounds (username, course_id, date_played, round_status) VALUES
('janesmith', (SELECT course_id FROM courses WHERE course_name = 'Austin Country Club'), '2024-02-20', 'completed'),
('mikejohnson', (SELECT course_id FROM courses WHERE course_name = 'Windy City Golf Club'), '2024-03-10', 'completed'),
('emilyjohnson', (SELECT course_id FROM courses WHERE course_name = 'Sahalee Country Club'), '2024-04-05', 'completed'),
('cooperfisher', (SELECT course_id FROM courses WHERE course_name = 'Austin Country Club'), '2024-05-12', 'completed'),
('clifflande', (SELECT course_id FROM courses WHERE course_name = 'Windy City Golf Club'), '2024-06-15', 'completed'),
('mikelee', (SELECT course_id FROM courses WHERE course_name = 'Manito Golf Club'), '2024-07-20', 'completed');


INSERT INTO rounds (username, course_id, date_played, round_status) VALUES
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), '2024-01-15', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), '2024-08-01', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), '2024-08-15', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), '2024-08-30', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), '2024-09-10', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), '2024-09-20', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), '2024-10-01', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), '2024-10-15', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), '2024-11-01', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), '2024-11-15', 'completed'),
('johndoe', (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), '2024-11-30', 'completed');



-- johndoe's holes: 
-- Round 1: Pebble Beach Golf Links
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 1, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 2, 3, 190, 3),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 3, 4, 390, 5),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 4, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 5, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 6, 5, 510, 6),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 7, 3, 170, 3),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 8, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 9, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 10, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 11, 4, 380, 5),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 12, 3, 200, 3),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 13, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 14, 5, 520, 5),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 15, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 16, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 17, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Golden Gate Park Golf Course'), 7, 18, 5, 540, 5);

-- Round 8: Pebble Beach Golf Links
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 1, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 2, 3, 190, 3),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 3, 4, 390, 5),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 4, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 5, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 6, 5, 510, 6),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 7, 3, 170, 3),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 8, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 9, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 10, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 11, 4, 380, 5),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 12, 3, 200, 3),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 13, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 14, 5, 520, 5),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 15, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 16, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 17, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 8, 18, 5, 540, 5);


-- Round 9: TPC Scottsdale
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 1, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 2, 3, 190, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 3, 4, 390, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 4, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 5, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 6, 5, 510, 6),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 7, 3, 170, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 8, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 9, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 10, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 11, 4, 380, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 12, 3, 200, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 13, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 14, 5, 520, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 15, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 16, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 17, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 9, 18, 5, 540, 5);


-- Round 10: Shadow Creek
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 1, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 2, 3, 190, 3),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 3, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 4, 4, 370, 5),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 5, 3, 180, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 6, 5, 510, 5),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 7, 3, 170, 3),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 8, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 9, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 10, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 11, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 12, 3, 200, 3),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 13, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 14, 5, 520, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 15, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 16, 3, 180, 4),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 17, 4, 400, 5),
((SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 10, 18, 5, 540, 6);

-- Round 11: Quail Hollow Club (course_id 18, round 11)
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 1, 4, 420, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 2, 3, 210, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 3, 5, 490, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 4, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 5, 3, 180, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 6, 4, 410, 5),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 7, 5, 540, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 8, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 9, 4, 380, 5),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 10, 4, 450, 5),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 11, 3, 170, 2),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 12, 5, 530, 6),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 13, 4, 420, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 14, 4, 440, 3),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 15, 3, 190, 4),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 16, 5, 510, 6),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 17, 4, 380, 3),
((SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 11, 18, 4, 430, 5);

-- Round 12: Cherry Hills Country Club (course_id 13, round 12)
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 1, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 2, 3, 200, 3),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 3, 5, 470, 5),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 4, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 5, 3, 190, 3),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 6, 4, 420, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 7, 5, 520, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 8, 4, 380, 3),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 9, 4, 370, 5),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 10, 4, 440, 5),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 11, 3, 160, 3),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 12, 5, 510, 6),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 13, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 14, 4, 430, 3),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 15, 3, 180, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 16, 5, 500, 5),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 17, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 12, 18, 4, 420, 5);


-- Round for Torrey Pines Golf Course (course_id 31, round 13)
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 1, 4, 410, 5),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 2, 3, 210, 3),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 3, 5, 480, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 4, 4, 400, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 5, 3, 170, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 6, 4, 430, 5),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 7, 5, 530, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 8, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 9, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 10, 4, 450, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 11, 3, 180, 3),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 12, 5, 520, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 13, 4, 410, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 14, 4, 440, 5),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 15, 3, 200, 3),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 16, 5, 510, 5),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 17, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 13, 18, 4, 430, 3);

-- Round 14: East Lake Golf Club (course_id 11, round 14)
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 1, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 2, 3, 190, 2),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 3, 5, 460, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 4, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 5, 3, 160, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 6, 4, 410, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 7, 5, 510, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 8, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 9, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 10, 4, 430, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 11, 3, 170, 2),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 12, 5, 500, 5),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 13, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 14, 4, 420, 4),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 15, 3, 190, 2),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 16, 5, 490, 5),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 17, 4, 360, 3),
((SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 14, 18, 4, 410, 4);



-- Round 15: East Lake Golf Club (course_id 11, round 14)
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 1, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 2, 3, 190, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 3, 5, 460, 5),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 4, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 5, 3, 160, 5),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 6, 4, 410, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 7, 5, 510, 5),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 8, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 9, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 10, 4, 430, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 11, 3, 170, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 12, 5, 500, 5),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 13, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 14, 4, 420, 5),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 15, 3, 190, 2),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 16, 5, 490, 5),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 17, 4, 360, 3),
((SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 15, 18, 4, 410, 3);

-- Round 16: 
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 1, 4, 390, 3),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 2, 3, 190, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 3, 5, 460, 5),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 4, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 5, 3, 160, 5),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 6, 4, 410, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 7, 5, 510, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 8, 4, 370, 5),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 9, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 10, 4, 430, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 11, 3, 170, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 12, 5, 500, 5),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 13, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 14, 4, 420, 5),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 15, 3, 190, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 16, 5, 490, 5),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 17, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 16, 18, 4, 410, 4);

-- Round 17: 
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 1, 4, 390, 3),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 2, 3, 190, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 3, 5, 460, 5),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 4, 4, 380, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 5, 3, 160, 5),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 6, 4, 410, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 7, 5, 510, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 8, 4, 370, 5),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 9, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 10, 4, 430, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 11, 3, 170, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 12, 5, 500, 5),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 13, 4, 390, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 14, 4, 420, 5),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 15, 3, 190, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 16, 5, 490, 5),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 17, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 17, 18, 4, 410, 4);

-- Insert holes for round_id 2 (janesmith's round)
INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots)
VALUES
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 1, 4, 350, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 2, 3, 175, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 3, 5, 520, 6),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 4, 4, 360, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 5, 3, 170, 2),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 6, 4, 400, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 7, 5, 530, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 8, 3, 185, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 9, 4, 375, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 10, 4, 385, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 11, 5, 510, 6),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 12, 3, 195, 3),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 13, 4, 365, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 14, 4, 380, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 15, 5, 525, 5),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 16, 4, 370, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 17, 3, 180, 4),
((SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 2, 18, 5, 535, 6);



-- INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots, created_at)
-- VALUES 
-- (49, 75, 1, 4, 350, 4, CURRENT_TIMESTAMP),
-- (49, 75, 2, 3, 200, 3, CURRENT_TIMESTAMP),
-- (49, 75, 3, 5, 450, 5, CURRENT_TIMESTAMP),
-- (49, 75, 4, 4, 370, 4, CURRENT_TIMESTAMP),
-- (49, 75, 5, 3, 160, 3, CURRENT_TIMESTAMP),
-- (49, 75, 6, 4, 390, 4, CURRENT_TIMESTAMP),
-- (49, 75, 7, 5, 510, 5, CURRENT_TIMESTAMP),
-- (49, 75, 8, 3, 180, 3, CURRENT_TIMESTAMP),
-- (49, 75, 9, 4, 380, 4, CURRENT_TIMESTAMP),
-- (49, 75, 10, 4, 370, 4, CURRENT_TIMESTAMP),
-- (49, 75, 11, 5, 440, 5, CURRENT_TIMESTAMP),
-- (49, 75, 12, 3, 210, 3, CURRENT_TIMESTAMP),
-- (49, 75, 13, 4, 360, 4, CURRENT_TIMESTAMP),
-- (49, 75, 14, 4, 380, 4, CURRENT_TIMESTAMP),
-- (49, 75, 15, 5, 490, 5, CURRENT_TIMESTAMP),
-- (49, 75, 16, 4, 360, 4, CURRENT_TIMESTAMP),
-- (49, 75, 17, 3, 190, 3, CURRENT_TIMESTAMP),
-- (49, 75, 18, 5, 520, 5, CURRENT_TIMESTAMP);



-- INSERT INTO holes (course_id, round_id, hole_number, par, start_yardage, total_shots, created_at)
-- VALUES 
-- (55, 83, 1, 4, 350, 4, CURRENT_TIMESTAMP),
-- (55, 83, 2, 3, 190, 3, CURRENT_TIMESTAMP),
-- (55, 83, 3, 5, 460, 5, CURRENT_TIMESTAMP),
-- (55, 83, 4, 4, 380, 4, CURRENT_TIMESTAMP),
-- (55, 83, 5, 3, 160, 3, CURRENT_TIMESTAMP),
-- (55, 83, 6, 4, 400, 4, CURRENT_TIMESTAMP),
-- (55, 83, 7, 5, 500, 5, CURRENT_TIMESTAMP),
-- (55, 83, 8, 3, 180, 3, CURRENT_TIMESTAMP),
-- (55, 83, 9, 4, 370, 4, CURRENT_TIMESTAMP),
-- (55, 83, 10, 4, 380, 4, CURRENT_TIMESTAMP),
-- (55, 83, 11, 5, 450, 5, CURRENT_TIMESTAMP),
-- (55, 83, 12, 3, 220, 3, CURRENT_TIMESTAMP),
-- (55, 83, 13, 4, 370, 4, CURRENT_TIMESTAMP),
-- (55, 83, 14, 4, 380, 4, CURRENT_TIMESTAMP),
-- (55, 83, 15, 5, 490, 5, CURRENT_TIMESTAMP),
-- (55, 83, 16, 4, 360, 4, CURRENT_TIMESTAMP),
-- (55, 83, 17, 3, 190, 3, CURRENT_TIMESTAMP),
-- (55, 83, 18, 5, 520, 5, CURRENT_TIMESTAMP);


-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- ((SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 1, 4, 380, 4, CURRENT_TIMESTAMP),
-- (327, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 2, 3, 190, 3, CURRENT_TIMESTAMP),
-- (328, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 3, 4, 390, 5, CURRENT_TIMESTAMP),
-- (329, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 4, 4, 370, 4, CURRENT_TIMESTAMP),
-- (330, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 5, 3, 180, 2, CURRENT_TIMESTAMP),
-- (331, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 6, 5, 510, 6, CURRENT_TIMESTAMP),
-- (332, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 7, 3, 170, 3, CURRENT_TIMESTAMP),
-- (333, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 8, 4, 400, 5, CURRENT_TIMESTAMP),
-- (334, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 9, 4, 380, 4, CURRENT_TIMESTAMP),
-- (335, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 10, 4, 390, 4, CURRENT_TIMESTAMP),
-- (336, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 11, 4, 380, 5, CURRENT_TIMESTAMP),
-- (337, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 12, 3, 200, 3, CURRENT_TIMESTAMP),
-- (338, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 13, 4, 370, 4, CURRENT_TIMESTAMP),
-- (339, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 14, 5, 520, 5, CURRENT_TIMESTAMP),
-- (340, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 15, 4, 380, 4, CURRENT_TIMESTAMP),
-- (341, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 16, 3, 180, 4, CURRENT_TIMESTAMP),
-- (342, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 17, 4, 400, 4, CURRENT_TIMESTAMP),
-- (343, (SELECT course_id FROM courses WHERE course_name = 'Pebble Beach Golf Links'), 94, 18, 5, 540, 5, CURRENT_TIMESTAMP);


-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (344, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 1, 4, 360, 5, CURRENT_TIMESTAMP),
-- (345, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 2, 4, 380, 4, CURRENT_TIMESTAMP),
-- (346, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 3, 5, 500, 6, CURRENT_TIMESTAMP),
-- (347, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 4, 3, 185, 3, CURRENT_TIMESTAMP),
-- (348, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 5, 4, 370, 4, CURRENT_TIMESTAMP),
-- (349, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 6, 4, 390, 5, CURRENT_TIMESTAMP),
-- (350, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 7, 3, 175, 2, CURRENT_TIMESTAMP),
-- (351, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 8, 4, 400, 4, CURRENT_TIMESTAMP),
-- (352, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 9, 5, 510, 5, CURRENT_TIMESTAMP),
-- (353, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 10, 4, 385, 4, CURRENT_TIMESTAMP),
-- (354, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 11, 4, 380, 4, CURRENT_TIMESTAMP),
-- (355, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 12, 3, 190, 4, CURRENT_TIMESTAMP),
-- (356, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 13, 5, 520, 5, CURRENT_TIMESTAMP),
-- (357, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 14, 4, 390, 4, CURRENT_TIMESTAMP),
-- (358, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 15, 4, 375, 5, CURRENT_TIMESTAMP),
-- (359, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 16, 3, 180, 3, CURRENT_TIMESTAMP),
-- (360, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 17, 4, 400, 4, CURRENT_TIMESTAMP),
-- (361, (SELECT course_id FROM courses WHERE course_name = 'TPC Scottsdale'), 95, 18, 5, 530, 6, CURRENT_TIMESTAMP);


-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (362, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 1, 4, 370, 4, CURRENT_TIMESTAMP),
-- (363, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 2, 3, 170, 2, CURRENT_TIMESTAMP),
-- (364, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 3, 4, 390, 4, CURRENT_TIMESTAMP),
-- (365, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 4, 5, 510, 5, CURRENT_TIMESTAMP),
-- (366, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 5, 4, 380, 4, CURRENT_TIMESTAMP),
-- (367, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 6, 3, 185, 4, CURRENT_TIMESTAMP),
-- (368, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 7, 4, 395, 5, CURRENT_TIMESTAMP),
-- (369, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 8, 5, 525, 5, CURRENT_TIMESTAMP),
-- (370, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 9, 4, 385, 4, CURRENT_TIMESTAMP),
-- (371, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 10, 4, 375, 3, CURRENT_TIMESTAMP),
-- (372, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 11, 3, 175, 3, CURRENT_TIMESTAMP),
-- (373, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 12, 4, 390, 4, CURRENT_TIMESTAMP),
-- (374, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 13, 5, 515, 6, CURRENT_TIMESTAMP),
-- (375, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 14, 4, 380, 4, CURRENT_TIMESTAMP),
-- (376, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 15, 3, 190, 3, CURRENT_TIMESTAMP),
-- (377, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 16, 4, 395, 5, CURRENT_TIMESTAMP),
-- (378, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 17, 4, 385, 4, CURRENT_TIMESTAMP),
-- (379, (SELECT course_id FROM courses WHERE course_name = 'Shadow Creek Golf Course'), 96, 18, 5, 535, 5, CURRENT_TIMESTAMP);

-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (380, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 1, 4, 380, 4, CURRENT_TIMESTAMP),
-- (381, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 2, 4, 390, 5, CURRENT_TIMESTAMP),
-- (382, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 3, 3, 170, 3, CURRENT_TIMESTAMP),
-- (383, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 4, 4, 385, 4, CURRENT_TIMESTAMP),
-- (384, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 5, 5, 520, 6, CURRENT_TIMESTAMP),
-- (385, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 6, 3, 175, 2, CURRENT_TIMESTAMP),
-- (386, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 7, 4, 395, 4, CURRENT_TIMESTAMP),
-- (387, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 8, 4, 380, 5, CURRENT_TIMESTAMP),
-- (388, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 9, 5, 530, 5, CURRENT_TIMESTAMP),
-- (389, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 10, 4, 375, 4, CURRENT_TIMESTAMP),
-- (390, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 11, 4, 385, 4, CURRENT_TIMESTAMP),
-- (391, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 12, 3, 180, 4, CURRENT_TIMESTAMP),
-- (392, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 13, 4, 390, 4, CURRENT_TIMESTAMP),
-- (393, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 14, 5, 515, 5, CURRENT_TIMESTAMP),
-- (394, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 15, 4, 380, 4, CURRENT_TIMESTAMP),
-- (395, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 16, 3, 185, 3, CURRENT_TIMESTAMP),
-- (396, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 17, 4, 395, 5, CURRENT_TIMESTAMP),
-- (397, (SELECT course_id FROM courses WHERE course_name = 'Quail Hollow Club'), 97, 18, 5, 525, 5, CURRENT_TIMESTAMP);



-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (398, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 1, 4, 375, 5, CURRENT_TIMESTAMP),
-- (399, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 2, 3, 180, 3, CURRENT_TIMESTAMP),
-- (400, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 3, 4, 385, 4, CURRENT_TIMESTAMP),
-- (401, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 4, 4, 390, 4, CURRENT_TIMESTAMP),
-- (402, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 5, 5, 525, 6, CURRENT_TIMESTAMP),
-- (403, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 6, 3, 175, 2, CURRENT_TIMESTAMP),
-- (404, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 7, 4, 380, 4, CURRENT_TIMESTAMP),
-- (405, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 8, 4, 395, 5, CURRENT_TIMESTAMP),
-- (406, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 9, 5, 530, 5, CURRENT_TIMESTAMP),
-- (407, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 10, 4, 370, 4, CURRENT_TIMESTAMP),
-- (408, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 11, 3, 185, 3, CURRENT_TIMESTAMP),
-- (409, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 12, 4, 390, 5, CURRENT_TIMESTAMP),
-- (410, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 13, 5, 520, 5, CURRENT_TIMESTAMP),
-- (411, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 14, 4, 385, 4, CURRENT_TIMESTAMP),
-- (412, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 15, 3, 170, 3, CURRENT_TIMESTAMP),
-- (413, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 16, 4, 395, 4, CURRENT_TIMESTAMP),
-- (414, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 17, 4, 380, 5, CURRENT_TIMESTAMP),
-- (415, (SELECT course_id FROM courses WHERE course_name = 'Cherry Hills Country Club'), 98, 18, 5, 535, 6, CURRENT_TIMESTAMP);

-- -- Round 6 (Torrey Pines) - round_id 99
-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (416, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 1, 4, 380, 4, CURRENT_TIMESTAMP),
-- (417, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 2, 4, 385, 5, CURRENT_TIMESTAMP),
-- (418, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 3, 3, 180, 3, CURRENT_TIMESTAMP),
-- (419, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 4, 4, 390, 4, CURRENT_TIMESTAMP),
-- (420, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 5, 5, 530, 6, CURRENT_TIMESTAMP),
-- (421, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 6, 4, 375, 4, CURRENT_TIMESTAMP),
-- (422, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 7, 3, 175, 2, CURRENT_TIMESTAMP),
-- (423, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 8, 4, 395, 5, CURRENT_TIMESTAMP),
-- (424, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 9, 5, 520, 5, CURRENT_TIMESTAMP),
-- (425, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 10, 4, 385, 4, CURRENT_TIMESTAMP),
-- (426, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 11, 3, 190, 4, CURRENT_TIMESTAMP),
-- (427, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 12, 4, 380, 4, CURRENT_TIMESTAMP),
-- (428, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 13, 5, 525, 5, CURRENT_TIMESTAMP),
-- (429, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 14, 4, 370, 3, CURRENT_TIMESTAMP),
-- (430, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 15, 4, 385, 5, CURRENT_TIMESTAMP),
-- (431, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 16, 3, 185, 3, CURRENT_TIMESTAMP),
-- (432, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 17, 4, 390, 4, CURRENT_TIMESTAMP),
-- (433, (SELECT course_id FROM courses WHERE course_name = 'Torrey Pines Golf Course'), 99, 18, 5, 535, 6, CURRENT_TIMESTAMP);


-- -- Round 7 (East Lake) - round_id 100
-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (434, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 1, 4, 375, 4, CURRENT_TIMESTAMP),
-- (435, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 2, 3, 170, 2, CURRENT_TIMESTAMP),
-- (436, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 3, 4, 385, 5, CURRENT_TIMESTAMP),
-- (437, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 4, 4, 390, 4, CURRENT_TIMESTAMP),
-- (438, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 5, 5, 520, 5, CURRENT_TIMESTAMP),
-- (439, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 6, 3, 175, 3, CURRENT_TIMESTAMP),
-- (440, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 7, 4, 380, 4, CURRENT_TIMESTAMP),
-- (441, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 8, 4, 395, 5, CURRENT_TIMESTAMP),
-- (442, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 9, 5, 530, 6, CURRENT_TIMESTAMP),
-- (443, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 10, 4, 370, 4, CURRENT_TIMESTAMP),
-- (444, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 11, 3, 185, 3, CURRENT_TIMESTAMP),
-- (445, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 12, 4, 390, 4, CURRENT_TIMESTAMP),
-- (446, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 13, 5, 525, 5, CURRENT_TIMESTAMP),
-- (447, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 14, 4, 380, 4, CURRENT_TIMESTAMP),
-- (448, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 15, 3, 180, 4, CURRENT_TIMESTAMP),
-- (449, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 16, 4, 385, 4, CURRENT_TIMESTAMP),
-- (450, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 17, 4, 390, 5, CURRENT_TIMESTAMP),
-- (451, (SELECT course_id FROM courses WHERE course_name = 'East Lake Golf Club'), 100, 18, 5, 535, 5, CURRENT_TIMESTAMP);

-- -- Round 8 (Houston Country Club) - round_id 101
-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (452, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 1, 4, 380, 5, CURRENT_TIMESTAMP),
-- (453, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 2, 3, 175, 3, CURRENT_TIMESTAMP),
-- (454, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 3, 4, 390, 4, CURRENT_TIMESTAMP),
-- (455, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 4, 5, 525, 5, CURRENT_TIMESTAMP),
-- (456, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 5, 4, 375, 4, CURRENT_TIMESTAMP),
-- (457, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 6, 3, 180, 2, CURRENT_TIMESTAMP),
-- (458, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 7, 4, 385, 4, CURRENT_TIMESTAMP),
-- (459, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 8, 4, 395, 5, CURRENT_TIMESTAMP),
-- (460, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 9, 5, 530, 6, CURRENT_TIMESTAMP),
-- (461, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 10, 4, 370, 4, CURRENT_TIMESTAMP),
-- (462, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 11, 3, 170, 3, CURRENT_TIMESTAMP),
-- (463, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 12, 4, 380, 4, CURRENT_TIMESTAMP),
-- (464, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 13, 5, 520, 5, CURRENT_TIMESTAMP),
-- (465, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 14, 4, 385, 5, CURRENT_TIMESTAMP),
-- (466, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 15, 3, 175, 3, CURRENT_TIMESTAMP),
-- (467, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 16, 4, 390, 4, CURRENT_TIMESTAMP),
-- (468, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 17, 4, 380, 4, CURRENT_TIMESTAMP),
-- (469, (SELECT course_id FROM courses WHERE course_name = 'Houston Country Club'), 101, 18, 5, 535, 5, CURRENT_TIMESTAMP);

-- -- Round 9 (Hazeltine) - round_id 102
-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (470, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 1, 4, 375, 4, CURRENT_TIMESTAMP),
-- (471, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 2, 4, 385, 5, CURRENT_TIMESTAMP),
-- (472, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 3, 3, 180, 3, CURRENT_TIMESTAMP),
-- (473, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 4, 4, 390, 4, CURRENT_TIMESTAMP),
-- (474, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 5, 5, 525, 6, CURRENT_TIMESTAMP),
-- (475, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 6, 4, 380, 4, CURRENT_TIMESTAMP),
-- (476, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 7, 3, 175, 2, CURRENT_TIMESTAMP),
-- (477, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 8, 4, 395, 5, CURRENT_TIMESTAMP),
-- (478, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 9, 5, 530, 5, CURRENT_TIMESTAMP),
-- (479, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 10, 4, 370, 4, CURRENT_TIMESTAMP),
-- (480, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 11, 3, 185, 4, CURRENT_TIMESTAMP),
-- (481, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 12, 4, 380, 4, CURRENT_TIMESTAMP),
-- (482, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 13, 5, 520, 5, CURRENT_TIMESTAMP),
-- (483, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 14, 4, 385, 5, CURRENT_TIMESTAMP),
-- (484, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 15, 3, 170, 3, CURRENT_TIMESTAMP),
-- (485, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 16, 4, 390, 4, CURRENT_TIMESTAMP),
-- (486, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 17, 4, 375, 4, CURRENT_TIMESTAMP),
-- (487, (SELECT course_id FROM courses WHERE course_name = 'Hazeltine National Golf Club'), 102, 18, 5, 535, 6, CURRENT_TIMESTAMP);


-- -- Round 10 (Old Bostonian) - round_id 103
-- INSERT INTO holes (hole_id, course_id, round_id, hole_number, par, start_yardage, total_shots, created_at) VALUES
-- (488, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 1, 4, 380, 5, CURRENT_TIMESTAMP),
-- (489, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 2, 3, 175, 3, CURRENT_TIMESTAMP),
-- (490, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 3, 4, 385, 4, CURRENT_TIMESTAMP),
-- (491, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 4, 4, 390, 5, CURRENT_TIMESTAMP),
-- (492, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 5, 5, 525, 5, CURRENT_TIMESTAMP),
-- (493, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 6, 3, 180, 2, CURRENT_TIMESTAMP),
-- (494, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 7, 4, 375, 4, CURRENT_TIMESTAMP),
-- (495, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 8, 4, 395, 4, CURRENT_TIMESTAMP),
-- (496, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 9, 5, 530, 6, CURRENT_TIMESTAMP),
-- (497, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 10, 4, 370, 4, CURRENT_TIMESTAMP),
-- (498, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 11, 3, 185, 3, CURRENT_TIMESTAMP),
-- (499, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 12, 4, 380, 4, CURRENT_TIMESTAMP),
-- (500, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 13, 5, 520, 5, CURRENT_TIMESTAMP),
-- (501, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 14, 4, 385, 5, CURRENT_TIMESTAMP),
-- (502, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 15, 3, 175, 3, CURRENT_TIMESTAMP),
-- (503, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 16, 4, 390, 4, CURRENT_TIMESTAMP),
-- (504, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 17, 4, 380, 5, CURRENT_TIMESTAMP),
-- (505, (SELECT course_id FROM courses WHERE course_name = 'Old Bostonian Golf Club'), 103, 18, 5, 535, 6, CURRENT_TIMESTAMP);

-- Create Followers
INSERT INTO followers (follower_username, followed_username) VALUES
('johndoe', 'janesmith'),
('mikejohnson', 'johndoe'),
('janesmith', 'mikejohnson'),
('emilyjohnson', 'johndoe'),
('cooperfisher', 'janesmith'),
('clifflande', 'mikejohnson'),
('mikelee', 'cooperfisher'),
('johndoe', 'emilyjohnson'),
('janesmith', 'clifflande'),
('mikejohnson', 'cooperfisher'),
('emilyjohnson', 'mikelee'),
('cooperfisher', 'emilyjohnson'),
('clifflande', 'johndoe'),
('mikelee', 'janesmith'),

('tonystark', 'brucewayne'),
('brucewayne', 'clarkkent'),
('clarkkent', 'dianaprince'),
('steverogers', 'tonystark'),
('natasharomanoff', 'steverogers'),
('brucebanner', 'tonystark'),
('peterparker', 'tonystark'),
('caroldanvers', 'steverogers'),
('brucewayne', 'dianaprince'),
('barryallen', 'clarkkent'),
('dianaprince', 'steverogers'),
('arthurcurry', 'brucewayne'),
('victorstone', 'barryallen'),

('emmarodriguez', 'tonystark'),
('ryanthompson', 'brucewayne'),
('sophiachen', 'dianaprince'),
('danielkim', 'steverogers'),
('oliviapatel', 'natasharomanoff'),
('luisgarcia', 'peterparker'),

('zarawilliams', 'emmarodriguez'),
('ethanbrown', 'ryanthompson'),
('isabellamartinez', 'sophiachen'),
('nathanjones', 'danielkim'),
('avaharris', 'oliviapatel'),
('marcuslee', 'luisgarcia'),
('elenadavis', 'zarawilliams'),
('alexmiller', 'ethanbrown'),
('gracewilson', 'isabellamartinez'),
('kevintaylor', 'nathanjones'),
('rachelgolf', 'avaharris'),
('michaelthomas', 'marcuslee'),


('laurenjackson', 'rachelgolf'),
('davidwhite', 'michaelthomas'),
('samanthamartin', 'laurenjackson'),
('jasonclark', 'davidwhite'),
('nicolelewis', 'samanthamartin'),
('robertmoore', 'jasonclark'),
('meganwalker', 'nicolelewis'),
('tylerhall', 'robertmoore'),

-- Cross-group connections
('tonystark', 'rachelgolf'),
('brucewayne', 'michaelthomas'),
('steverogers', 'laurenjackson'),
('dianaprince', 'davidwhite'),
('peterparker', 'samanthamartin'),
('clarkkent', 'jasonclark'),

-- Additional mutual followings
('rachelgolf', 'tonystark'),
('michaelthomas', 'brucewayne'),
('laurenjackson', 'steverogers'),
('davidwhite', 'dianaprince'),
('samanthamartin', 'peterparker'),
('jasonclark', 'clarkkent'),

-- More community connections
('meganwalker', 'emmarodriguez'),
('tylerhall', 'ryanthompson'),
('robertmoore', 'sophiachen'),
('nicolelewis', 'danielkim'),
('samanthamartin', 'oliviapatel'),
('jasonclark', 'luisgarcia'),
('davidwhite', 'zarawilliams'),
('laurenjackson', 'ethanbrown');




-- Clubs
INSERT INTO clubs (club_type, brand) VALUES
-- TaylorMade
('Driver', 'TaylorMade'),
('3 Wood', 'TaylorMade'),
('5 Wood', 'TaylorMade'),
('3H', 'TaylorMade'),
('4 Iron', 'TaylorMade'),
('5 Iron', 'TaylorMade'),
('6 Iron', 'TaylorMade'),
('7 Iron', 'TaylorMade'),
('8 Iron', 'TaylorMade'),
('9 Iron', 'TaylorMade'),
('PW', 'TaylorMade'),
('Putter', 'TaylorMade'),

-- Callaway
('Driver', 'Callaway'),
('3 Wood', 'Callaway'),
('4H', 'Callaway'),
('4 Iron', 'Callaway'),
('5 Iron', 'Callaway'),
('6 Iron', 'Callaway'),
('7 Iron', 'Callaway'),
('8 Iron', 'Callaway'),
('9 Iron', 'Callaway'),
('PW', 'Callaway'),

-- Ping
('Driver', 'Ping'),
('3 Wood', 'Ping'),
('3H', 'Ping'),
('Putter', 'Ping'),

-- Titleist
('Driver', 'Titleist'),
('5 Wood', 'Titleist'),
('4H', 'Titleist'),
('GW', 'Titleist'),
('SW', 'Titleist'),
('LW', 'Titleist'),

-- Cobra
('Driver', 'Cobra'),
('5H', 'Cobra'),

-- Mizuno
('5 Iron', 'Mizuno'),
('6 Iron', 'Mizuno'),
('7 Iron', 'Mizuno'),
('8 Iron', 'Mizuno'),
('9 Iron', 'Mizuno'),
('PW', 'Mizuno'),

-- Cleveland
('GW', 'Cleveland'),
('SW', 'Cleveland'),
('LW', 'Cleveland'),

-- Other Putters
('Putter', 'Scotty Cameron'),
('Putter', 'Odyssey'),
('Putter', 'Wilson');

-- User clubs 
INSERT INTO user_clubs (username, club_id, slot_number) VALUES
('johndoe', (SELECT club_id FROM clubs WHERE club_type = 'Driver' AND brand = 'TaylorMade'), 1),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '3 Wood' AND brand = 'TaylorMade'), 2),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '5 Wood' AND brand = 'TaylorMade'), 3),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '4 Iron' AND brand = 'TaylorMade'), 4),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '5 Iron' AND brand = 'TaylorMade'), 5),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '6 Iron' AND brand = 'TaylorMade'), 6),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '7 Iron' AND brand = 'TaylorMade'), 7),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '8 Iron' AND brand = 'TaylorMade'), 8),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = '9 Iron' AND brand = 'TaylorMade'), 9),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = 'PW' AND brand = 'TaylorMade'), 10),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = 'GW' AND brand = 'Titleist'), 11),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = 'SW' AND brand = 'Titleist'), 12),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = 'LW' AND brand = 'Titleist'), 13),
('johndoe', (SELECT club_id FROM clubs WHERE club_type = 'Putter' AND brand = 'Scotty Cameron'), 14);

-- Jane Smith's Bag (Hybrid Setup)
INSERT INTO user_clubs (username, club_id, slot_number) VALUES
('janesmith', (SELECT club_id FROM clubs WHERE club_type = 'Driver' AND brand = 'Callaway'), 1),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '3 Wood' AND brand = 'Callaway'), 2),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '3H' AND brand = 'TaylorMade'), 3),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '4H' AND brand = 'Callaway'), 4),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '5 Iron' AND brand = 'Mizuno'), 5),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '6 Iron' AND brand = 'Mizuno'), 6),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '7 Iron' AND brand = 'Mizuno'), 7),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '8 Iron' AND brand = 'Mizuno'), 8),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = '9 Iron' AND brand = 'Mizuno'), 9),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = 'PW' AND brand = 'Mizuno'), 10),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = 'GW' AND brand = 'Cleveland'), 11),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = 'SW' AND brand = 'Cleveland'), 12),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = 'LW' AND brand = 'Cleveland'), 13),
('janesmith', (SELECT club_id FROM clubs WHERE club_type = 'Putter' AND brand = 'Odyssey'), 14);
