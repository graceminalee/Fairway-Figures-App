const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../db');
const auth = require('../middleware/auth');




// TO SEE HASHED PASS
async function hashPasswords() {
    const passwords = {
        'exampleHashedPassword1': 'password123',
    };

    for (const [key, rawPassword] of Object.entries(passwords)) {
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(rawPassword, salt);
        console.log(`${key}: ${hashedPassword}`);
    }
}
hashPasswords();


// Sign up route
router.post('/sign-up', async (req, res) => {
    try {
        const { firstName, lastName, username, email, password } = req.body;
        
        // Convert username and email to lowercase
        const lowerUsername = username.toLowerCase();
        const lowerEmail = email.toLowerCase();
        
        // Check if user exists (using lowercase values)
        const userCheck = await pool.query(
            'SELECT * FROM users WHERE username = $1 OR email = $2',
            [lowerUsername, lowerEmail]
        );
        
        if (userCheck.rows.length > 0) {
            return res.status(400).json({ error: 'Username or email already exists' });
        }
        
        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);
        
        // Create user (using lowercase values)
        const newUser = await pool.query(
            'INSERT INTO users (first_name, last_name, username, email, users_password) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [firstName, lastName, lowerUsername, lowerEmail, hashedPassword]
        );
        
        // Create account (using lowercase username)
        await pool.query(
            'INSERT INTO accounts (username) VALUES ($1)',
            [lowerUsername]
        );
        
        // Success
        res.status(201).json({ success: 'User created successfully!' });
        
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Login route
router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;
        
        // Convert username to lowercase
        const lowerUsername = username.toLowerCase();
        
        // Check if user exists (using lowercase username)
        const user = await pool.query(
            'SELECT * FROM users WHERE username = $1',
            [lowerUsername]
        );
        
        if (user.rows.length === 0) {
            return res.status(400).json({ error: 'Invalid credentials' });
        }
        
        // Verify password
        const validPassword = await bcrypt.compare(password, user.rows[0].users_password);
        if (!validPassword) {
            return res.status(400).json({ error: 'Invalid credentials' });
        }
        
        // Generate JWT (using lowercase username)
        const token = jwt.sign(
            { id: user.rows[0].id, username: lowerUsername },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );
        
        res.json({ token });
        
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
// Get Profile Route
router.get('/profile', auth, async (req, res) => {
try {
        const user = await pool.query(
            `SELECT u.first_name, u.last_name, u.username, u.email,
                    a.bio, a.home_location, a.phone, a.home_course
            FROM users u
            JOIN accounts a ON u.username = a.username
            WHERE u.username = $1`,
            [req.user.username]
        );

    res.json(user.rows[0]);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// Get first/last name (for dashboard):
router.get('/dashboard', auth, async (req, res) => {
    try {
        const userResult = await pool.query(
            `SELECT first_name, last_name
            FROM users
            WHERE username = $1`,
            [req.user.username]
        );

        if (userResult.rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        const { first_name, last_name } = userResult.rows[0];
        res.json({ first_name, last_name });


        } catch (error) {
            res.status(500).json({ error: error.message });
        }
});


// Update Profile Route
router.put('/profile/update', auth, async (req, res) => {
    try {
        const { bio, home_location, phone, homeCourse, profilePicture } = req.body;
        // Update accounts table
        const updatedAccount = await pool.query(
            `UPDATE accounts 
            SET bio = $1, 
                home_location = $2, 
                phone = $3, 
                home_course = $4, 
                profile_picture = $5
            WHERE username = $6
            RETURNING *`,
        [bio, home_location, phone, homeCourse, profilePicture, req.user.username]
        );

        if (updatedAccount.rows.length === 0) {
        return res.status(404).json({ error: 'Account not found' });
        }

        res.json(updatedAccount.rows[0]);
    } catch (error) {
        console.error('Profile update error:', error);
        res.status(500).json({ error: 'Failed to update profile' });
    }
});


// Add course info
router.post('/add-course-info', auth, async (req, res) => {
    const { courseName, courseState, courseCity } = req.body;

    try {
        // First try to get existing course
        const courseResult = await pool.query(
            `SELECT course_id 
             FROM courses 
             WHERE LOWER(course_name) = LOWER($1) 
             AND LOWER(course_state) = LOWER($2) 
             AND LOWER(city) = LOWER($3)`,
            [courseName, courseState, courseCity]
        );

        if (courseResult.rows.length > 0) {
            // Course exists, return the existing course_id
            return res.json({
                message: 'Using existing course',
                course_id: courseResult.rows[0].course_id
            });
        }

        // Course doesn't exist, insert new course
        const newCourse = await pool.query(
            `INSERT INTO courses (course_name, course_state, city)
             VALUES ($1, $2, $3)
             RETURNING course_id`,
            [courseName, courseState, courseCity]
        );

        res.json({
            message: 'New course added successfully',
            course_id: newCourse.rows[0].course_id
        });

    } catch (error) {
        console.error('Error in add-course-info:', error);
        res.status(500).json({ 
            error: 'Failed to process course information',
            details: error.message
        });
    }
});


// Add round info
router.post('/add-round-info', auth, async (req, res) => {
    const { course_id, date_played } = req.body;

    try {
        const username = req.user.username;

        // Insert round into the database
        const insertQuery = `
            INSERT INTO rounds (username, course_id, date_played)
            VALUES ($1, $2, $3)
            RETURNING round_id, username
        `;
        const result = await pool.query(insertQuery, [username, course_id, date_played]);

        if (result.rows.length > 0) {
            res.status(201).json({
                message: 'Round added successfully!',
                round_id: result.rows[0].round_id
            });
        } else {
            return res.status(400).json({ error: 'Failed to add round' });
        }
    } catch (error) {
        console.error('Error adding round:', error);
        res.status(500).json({ error: 'Failed to add round' });
    }
});




// Add hole information
router.post('/add-hole-info', auth, async (req, res) => {
    const { course_id, round_id, hole_number, par, start_yardage, score } = req.body;

    try {
        // First check if hole already exists for this round
        const checkHoleQuery = `
            SELECT hole_id 
            FROM holes 
            WHERE round_id = $1 AND hole_number = $2`;
        
        const existingHole = await pool.query(checkHoleQuery, [round_id, hole_number]);
        
        if (existingHole.rows.length > 0) {
            return res.status(400).json({ 
                error: 'Hole already exists for this round',
                hole_id: existingHole.rows[0].hole_id 
            });
        }

        // Insert new hole data
        const insertHoleQuery = `
            INSERT INTO holes (
                course_id, 
                round_id, 
                hole_number, 
                par, 
                start_yardage,
                total_shots,
                created_at
            )
            VALUES ($1, $2, $3, $4, $5, $6, CURRENT_TIMESTAMP)
            RETURNING hole_id`;

        const holeResult = await pool.query(
            insertHoleQuery,
            [course_id, round_id, hole_number, par, start_yardage, score]
        );

        res.status(201).json({
            message: 'Hole information added successfully',
            hole_id: holeResult.rows[0].hole_id
        });

    } catch (error) {
        console.error('Error adding hole info:', error);
        res.status(500).json({ 
            error: 'Failed to add hole information',
            details: error.message 
        });
    }
});



// Submit round
router.post('/submit-round', auth, async (req, res) => {
    const { round_id } = req.body;
    
    try {
        await pool.query('BEGIN');
        
        const holesQuery = `
            SELECT h.hole_id, h.hole_number, h.par, h.total_shots
            FROM holes h
            WHERE h.round_id = $1
            ORDER BY h.hole_number`;
        
        const holesResult = await pool.query(holesQuery, [round_id]);
        
        // Update total_shots for each hole
        for (const hole of holesResult.rows) {
            await pool.query(
                'UPDATE holes SET total_shots = $1 WHERE hole_id = $2',
                [hole.total_shots, hole.hole_id]
            );
        }
        
        await pool.query('COMMIT');
        
        res.json({ message: 'Round submitted successfully' });
    } catch (error) {
        await pool.query('ROLLBACK');
        console.error('Error submitting round:', error);
        res.status(500).json({ error: 'Failed to submit round' });
    }
});



router.get('/user-rounds', auth, async (req, res) => {
    try {
        // Extract query parameters
        const { 
            course, 
            date, 
            score 
        } = req.query;

        // Base query with all the existing joins and calculations
        let query = `
            SELECT 
                r.round_id, 
                r.date_played, 
                c.course_name, 
                c.course_state AS state, 
                c.city,
                (SELECT COUNT(*) 
                FROM holes h 
                WHERE h.round_id = r.round_id) AS holes_played,
                (SELECT SUM(h.par) 
                FROM holes h 
                WHERE h.round_id = r.round_id) AS total_par,
                (SELECT SUM(h.total_shots) 
                FROM holes h 
                WHERE h.round_id = r.round_id) AS total_shots,
                (SELECT SUM(h.total_shots) - SUM(h.par)
                FROM holes h 
                WHERE h.round_id = r.round_id) AS score,
                (SELECT json_agg(
                    json_build_object(
                        'hole_number', h.hole_number,
                        'par', h.par,
                        'total_shots', h.total_shots,
                        'start_yardage', h.start_yardage
                    ) ORDER BY h.hole_number
                ) 
                FROM holes h 
                WHERE h.round_id = r.round_id) AS holes
            FROM 
                rounds r
            JOIN 
                courses c 
            ON 
                r.course_id = c.course_id
            WHERE 
                r.username = $1
                AND r.status != 'canceled'
        `;

        // Array to hold dynamic query parameters
        const queryParams = [req.user.username];
        const whereClauses = [];

        // Add course filter
        if (course) {
            whereClauses.push(`c.course_name ILIKE $${queryParams.length + 1}`);
            queryParams.push(`%${course}%`);
        }

        // Add date filter
        if (date) {
            whereClauses.push(`r.date_played::date = $${queryParams.length + 1}`);
            queryParams.push(date);
        }

        // Add score filter
        if (score !== undefined && score !== '') {
            whereClauses.push(`(SELECT SUM(h.total_shots) - SUM(h.par) FROM holes h WHERE h.round_id = r.round_id) = $${queryParams.length + 1}`);
            queryParams.push(parseInt(score));
        }

        // Combine where clauses if any exist
        if (whereClauses.length > 0) {
            query += ` AND (${whereClauses.join(' AND ')})`;
        }

        // Add ordering
        query += ` ORDER BY r.date_played ASC`;

        // Execute the query
        const roundsResult = await pool.query(query, queryParams);
        res.json(roundsResult.rows);
    } catch (error) {
        console.error('Error fetching user rounds:', error);
        res.status(500).json({ error: 'Failed to fetch rounds' });
    }
});

router.get('/par-statistics', auth, async (req, res) => {
    try {
        const query = `
            WITH ParStats AS (
                SELECT 
                    h.par,
                    AVG(h.total_shots) as average_score,
                    COUNT(*) as times_played,
                    AVG(h.total_shots - h.par) as average_over_under
                FROM holes h
                JOIN rounds r ON h.round_id = r.round_id
                WHERE r.username = $1 AND r.status != 'canceled'
                GROUP BY h.par
                ORDER BY h.par
            )
            SELECT 
                par,
                ROUND(average_score::numeric, 2) as average_score,
                times_played,
                ROUND(average_over_under::numeric, 2) as average_over_under
            FROM ParStats
        `;

        const result = await pool.query(query, [req.user.username]);
        res.json(result.rows);
    } catch (error) {
        console.error('Error fetching par statistics:', error);
        res.status(500).json({ error: 'Failed to fetch par statistics' });
    }
});


// Search Users Route , possible: LIMIT 10
router.get('/users/search', auth, async (req, res) => {
    try {
    const { query } = req.query;
    const searchResults = await pool.query(
        `SELECT username, first_name, last_name 
        FROM users 
        WHERE username ILIKE $1 
        AND username != $2 
        `,
        [`%${query}%`, req.user.username]
    );
    res.json(searchResults.rows);
    } catch (error) {
    res.status(500).json({ error: error.message });
    }
});

//  User Route
router.post('/followers/follow', auth, async (req, res) => {
    const { username: followed_username } = req.body;
    const follower_username = req.user.username;

    try {
    // Check if already following
    const existingFollow = await pool.query(
        `SELECT * FROM followers 
        WHERE follower_username = $1 AND followed_username = $2`,
        [follower_username, followed_username]
    );

    if (existingFollow.rows.length > 0) {
        return res.status(400).json({ message: 'Already following this user' });
    }

    // Insert follow relationship
    await pool.query(
        `INSERT INTO followers (follower_username, followed_username) 
        VALUES ($1, $2)`,
        [follower_username, followed_username]
    );

    res.status(201).json({ message: 'Successfully followed user' });
    } catch (error) {
    res.status(500).json({ error: error.message });
    }
});

// Unfollow a User Route
router.post('/followers/unfollow', auth, async (req, res) => {
    const { username: followed_username } = req.body;
    const follower_username = req.user.username;

    try {
    // Remove follow relationship
    await pool.query(
        `DELETE FROM followers 
        WHERE follower_username = $1 AND followed_username = $2`,
        [follower_username, followed_username]
    );

    res.json({ message: 'Successfully unfollowed user' });
    } catch (error) {
    res.status(500).json({ error: error.message });
    }
});


// Get Current User's Followers
router.get('/followers/my-followers', auth, async (req, res) => {
    try {
    const followers = await pool.query(
        `SELECT u.username, u.first_name, u.last_name
        FROM users u
        JOIN followers f ON u.username = f.follower_username
        WHERE f.followed_username = $1`,
        [req.user.username]
    );
    res.json(followers.rows);
    } catch (error) {
    res.status(500).json({ error: error.message });
    }
});


// Get Current User's Following
router.get('/followers/my-following', auth, async (req, res) => {
    try {
    const following = await pool.query(
        `SELECT u.username, u.first_name, u.last_name 
        FROM users u
        JOIN followers f ON u.username = f.followed_username
        WHERE f.follower_username = $1`,
        [req.user.username]
    );
    res.json(following.rows);
    } catch (error) {
    res.status(500).json({ error: error.message });
    }
});


// Delete/Cancel a Round Route
router.delete('/delete-round/:roundId', auth, async (req, res) => {
    const { roundId } = req.params;
    const username = req.user.username;

    try {
        // First check the round belongs to the current user
        const roundCheck = await pool.query(
            'SELECT * FROM rounds WHERE round_id = $1 AND username = $2',
            [roundId, username]
        );

        if (roundCheck.rows.length === 0) {
            return res.status(403).json({ error: 'Unauthorized to delete this round' });
        }

        // Begin a transaction
        await pool.query('BEGIN');

        // Delete associated holes first
        await pool.query(
            'DELETE FROM holes WHERE round_id = $1',
            [roundId]
        );

        
        // await pool.query(
        //     'DELETE FROM shots WHERE round_id = $1',
        //     [roundId]
        // );

        // Update round status to 'canceled'
        const result = await pool.query(
            'UPDATE rounds SET status = \'canceled\' WHERE round_id = $1 RETURNING *',
            [roundId]
        );

        // Commit
        await pool.query('COMMIT');

        res.json({ 
            message: 'Round successfully canceled', 
            round: result.rows[0] 
        });
    } catch (error) {
        // Rollback the transaction in case of error
        await pool.query('ROLLBACK');
        console.error('Error deleting round:', error);
        res.status(500).json({ error: 'Failed to delete round' });
    }
});

router.post('/equipment/add-club', auth, async (req, res) => {
    try {
        const { clubType, brand, slotNumber } = req.body;
        
        // Start a transaction
        await pool.query('BEGIN');

        // Check if this club combination exists or create it
        let clubResult = await pool.query(
            `SELECT club_id 
            FROM clubs 
            WHERE club_type = $1 AND brand = $2`,
            [clubType, brand]
        );

        let clubId;
        if (clubResult.rows.length === 0) {
            // Create new club
            const newClub = await pool.query(
                `INSERT INTO clubs (club_type, brand)
                VALUES ($1, $2)
                RETURNING club_id`,
                [clubType, brand]
            );
            clubId = newClub.rows[0].club_id;
        } else {
            clubId = clubResult.rows[0].club_id;
        }

        // Add to user's bag
        await pool.query(
            `INSERT INTO user_clubs (username, club_id, slot_number)
            VALUES ($1, $2, $3)
            ON CONFLICT (username, slot_number)
            DO UPDATE SET club_id = $2`,
            [req.user.username, clubId, slotNumber]
        );

        await pool.query('COMMIT');

        res.json({ message: "Club added successfully" });
    } catch (error) {
        await pool.query('ROLLBACK');
        res.status(500).json({ error: error.message });
    }
});

router.get('/equipment/my-clubs', auth, async (req, res) => {
    try {
        const clubs = await pool.query(
            `SELECT uc.slot_number, c.club_type, c.brand
             FROM user_clubs uc
             JOIN clubs c ON uc.club_id = c.club_id
             WHERE uc.username = $1
             ORDER BY uc.slot_number`,
            [req.user.username]
        );
        res.json(clubs.rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.get('/equipment/clubs-by-brand', auth, async (req, res) => {
    try {
        const clubs = await pool.query(
            `SELECT c.brand, array_agg(c.club_type) as clubs
             FROM user_clubs uc
             JOIN clubs c ON uc.club_id = c.club_id
             WHERE uc.username = $1
             GROUP BY c.brand
             ORDER BY c.brand`,
            [req.user.username]
        );
        res.json(clubs.rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});




module.exports = router;
