import React, { useState } from 'react';
import { getToken } from '../utils/auth';
import { useNavigate } from 'react-router-dom';
import './CourseInput.css';

const CourseInput = () => {
    const [courseName, setCourseName] = useState('');
    const [courseCity, setCourseCity] = useState('');
    const [courseState, setCourseState] = useState('');
    const [datePlayed, setDatePlayed] = useState('');
    const [message, setMessage] = useState('');
    const navigate = useNavigate();

    const handleSubmit = async (e) => {
        e.preventDefault();
        setMessage('');

        // Input validation
        if (!courseName || !courseCity || !courseState || !datePlayed) {
            setMessage('Please fill in all required fields');
            return;
        }

        try {
            // Step 1: Add or fetch course information
            const courseResponse = await fetch('http://localhost:5001/api/auth/add-course-info', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${getToken()}`
                },
                body: JSON.stringify({
                    courseName: courseName.trim(),
                    courseCity: courseCity.trim(),
                    courseState: courseState.trim()
                })
            });

            const courseData = await courseResponse.json();

            if (!courseResponse.ok) {
                console.error('Course API Error:', courseData);
                throw new Error(courseData.error || `Course API failed with status: ${courseResponse.status}`);
            }

            if (!courseData.course_id) {
                throw new Error('No course ID received from server');
            }

            // Step 2: Add round information
            const roundResponse = await fetch('http://localhost:5001/api/auth/add-round-info', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${getToken()}`
                },
                body: JSON.stringify({
                    course_id: courseData.course_id,
                    date_played: datePlayed
                })
            });

            const roundData = await roundResponse.json();

            if (!roundResponse.ok) {
                console.error('Round API Error:', roundData);
                throw new Error(roundData.error || `Round API failed with status: ${roundResponse.status}`);
            }

            if (!roundData.round_id) {
                throw new Error('No round ID received from server');
            }

            // Success - navigate to hole input page with necessary IDs
            navigate(`/hole-input?courseId=${courseData.course_id}&roundId=${roundData.round_id}`);

        } catch (error) {
            console.error('Submission Error:', error);

            // Check for specific error types
            if (error instanceof TypeError) {
                setMessage('Network error. Please check your connection.');
            } else if (error.name === 'SyntaxError') {
                setMessage('Invalid response from server.');
            } else {
                setMessage(error.message || 'An error occurred while submitting the form.');
            }
        }
    };

    return (
        <div className="course-input-container">
            <h1 className="course-input-title">Enter Course and Round Information</h1>
            <form onSubmit={handleSubmit} className="course-input-form">
                <div className="form-group">
                    <label>Course Name:</label>
                    <input
                        type="text"
                        className="input-field"
                        value={courseName}
                        onChange={(e) => setCourseName(e.target.value)}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>City:</label>
                    <input
                        type="text"
                        className="input-field"
                        value={courseCity}
                        onChange={(e) => setCourseCity(e.target.value)}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>State:</label>
                    <input
                        type="text"
                        className="input-field"
                        value={courseState}
                        onChange={(e) => setCourseState(e.target.value)}
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Date Played:</label>
                    <input
                        type="date"
                        className="input-field"
                        value={datePlayed}
                        onChange={(e) => setDatePlayed(e.target.value)}
                        required
                    />
                </div>
                <button type="submit" className="submit-button">Start Round</button>
            </form>
            {message && <p className="error-message">{message}</p>}
        </div>
    );
};



export default CourseInput;


