import React, { useState, useEffect } from 'react';
import { getToken } from '../utils/auth';
import ScoreGraph from './ScoreGraph';
import './StatsPage.css';

const StatsPage = () => {
    const [rounds, setRounds] = useState([]);
    const [parStats, setParStats] = useState([]);
    const [uniqueCourses, setUniqueCourses] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    
    // Search state
    const [searchFilters, setSearchFilters] = useState({
        course: '',
        date: '',
        score: ''
    });

    // Fetch overall par statistics
    const fetchParStats = async () => {
        try {
            const response = await fetch('http://localhost:5001/api/auth/par-statistics', {
                headers: {
                    'Authorization': `Bearer ${getToken()}`,
                },
            });

            if (!response.ok) {
                throw new Error('Failed to fetch par statistics');
            }

            const data = await response.json();
            setParStats(data);
        } catch (err) {
            console.error('Error fetching par statistics:', err);
        }
    };

    // Fetch rounds with optional filters
    const fetchRounds = async (filters = {}) => {
        setLoading(true);
        setError(null);

        try {
            // Construct query parameters
            const queryParams = new URLSearchParams();
            
            // Add filters to query parameters
            Object.entries(filters).forEach(([key, value]) => {
                if (value) {
                    queryParams.append(key, value);
                }
            });

            const url = `http://localhost:5001/api/auth/user-rounds${
                queryParams.toString() ? `?${queryParams.toString()}` : ''
            }`;

            const response = await fetch(url, {
                headers: {
                    'Authorization': `Bearer ${getToken()}`,
                },
            });

            if (!response.ok) {
                throw new Error('Failed to fetch rounds');
            }

            const data = await response.json();
            setRounds(data);

            // If this is the first fetch (no filters), populate unique courses
            if (Object.keys(filters).length === 0) {
                const courses = [...new Set(data.map(round => round.course_name))];
                setUniqueCourses(courses);
            }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    // Initial fetch on component mount
    useEffect(() => {
        fetchRounds();
        fetchParStats();
    }, []);

    // Handle filter changes
    const handleFilterChange = (e) => {
        const { name, value } = e.target;
        const newFilters = {
            ...searchFilters,
            [name]: value
        };
        
        // Update search filters
        setSearchFilters(newFilters);

        // Fetch rounds with new filters
        fetchRounds(newFilters);
    };

    // Delete round
    const handleDeleteRound = async (roundId) => {
        const confirmDelete = window.confirm('Are you sure you want to delete this round? This action cannot be undone.');
        
        if (!confirmDelete) return;

        try {
            const response = await fetch(`http://localhost:5001/api/auth/delete-round/${roundId}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${getToken()}`,
                },
            });

            if (!response.ok) {
                throw new Error('Failed to delete round');
            }

            // Refresh rounds and par statistics after deletion
            fetchRounds(searchFilters);
            fetchParStats();
        } catch (err) {
            console.error('Error deleting round:', err);
            alert('Failed to delete round. Please try again.');
        }
    };

    return (
        <div className="stats-page">
            <h1 className="stats-title">Round Statistics</h1>
            
            {/* Overall Par Statistics */}
            <div className="overall-stats-section">
                <h2>Overall Par Statistics</h2>
                <div className="par-stats-grid">
                    {parStats.map((stat) => (
                        <div key={stat.par} className="par-stat-card">
                            <h3>Par {stat.par}</h3>
                            <p>Average Score: {stat.average_score}</p>
                            <p>Times Played: {stat.times_played}</p>
                            <p>Average Over/Under: {stat.average_over_under > 0 ? 
                                `+${stat.average_over_under}` : 
                                stat.average_over_under}
                            </p>
                        </div>
                    ))}
                </div>
            </div>
            
            {/* Faceted Search Container */}
            <div className="faceted-search-container">
                {/* Course Dropdown */}
                <div className="filter-group">
                    <label htmlFor="course-select">Course:</label>
                    <select
                        id="course-select"
                        name="course"
                        value={searchFilters.course}
                        onChange={handleFilterChange}
                        className="filter-select"
                    >
                        <option value="">All Courses</option>
                        {uniqueCourses.map((course, index) => (
                            <option key={index} value={course}>{course}</option>
                        ))}
                    </select>
                </div>

                {/* Date Filter */}
                <div className="filter-group">
                    <label htmlFor="date-search">Date:</label>
                    <input 
                        type="date" 
                        id="date-search"
                        name="date"
                        value={searchFilters.date}
                        onChange={handleFilterChange}
                        className="filter-input"
                    />
                </div>

                {/* Score Filter */}
                <div className="filter-group">
                    <label htmlFor="score-search">Score(relative to par ex: -1, 0, 1):</label>
                    <input 
                        type="number" 
                        id="score-search"
                        name="score"
                        value={searchFilters.score}
                        onChange={handleFilterChange}
                        placeholder="Enter score"
                        className="filter-input"
                    />
                </div>
            </div>

            {/* Loading and Error States */}
            {loading && <div className="loading">Loading rounds...</div>}
            {error && <div className="error">Error: {error}</div>}

            {/* Graph */}
            {!loading && !error && <ScoreGraph rounds={rounds} />}

            {/* Rounds */}
            {!loading && !error && rounds.length === 0 ? (
                <div className="no-rounds">No rounds found matching your search criteria.</div>
            ) : (
                rounds.map((round, index) => (
                    <div className="round-box" key={index}>
                        <div className="round-header">
                            <h2>{round.course_name}</h2>
                            <button 
                                className="delete-round-btn" 
                                onClick={() => handleDeleteRound(round.round_id)}
                            >
                                Delete Round
                            </button>
                        </div>
                        <p>{round.city}, {round.state}</p>
                        <p>Played on: {new Date(round.date_played).toLocaleDateString()}</p>
                        
                        <div className="stats-grid">
                            <div className="stats-section">
                                <h3>Total Holes Played</h3>
                                <p>{round.holes_played}</p>
                            </div>
                            <div className="stats-section">
                                <h3>Total Par</h3>
                                <p>{round.total_par}</p>
                            </div>
                            <div className="stats-section">
                                <h3>Total Shots</h3>
                                <p>{round.total_shots}</p>
                            </div>
                            <div className="stats-section">
                                <h3>Score(Relative to Par)</h3>
                                <p>{round.score > 0 ? `+${round.score}` : round.score}</p>
                            </div>
                        </div>

                        {/* Hole Details */}
                        <div className="hole-details">
                            <h3>Hole Details</h3>
                            <table className="hole-details-table">
                                <thead>
                                    <tr>
                                        <th>Hole</th>
                                        <th>Par</th>
                                        <th>Score</th>
                                        <th>Yards</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {Array.isArray(round.holes) ? (
                                        round.holes.map((hole, holeIndex) => (
                                            <tr key={holeIndex}>
                                                <td>{hole.hole_number}</td>
                                                <td>{hole.par}</td>
                                                <td>{hole.total_shots}</td>
                                                <td>{hole.start_yardage}</td>
                                            </tr>
                                        ))
                                    ) : (
                                        <tr>
                                            <td colSpan="4">No hole data available.</td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        </div>
                    </div>
                ))
            )}
        </div>
    );
};

export default StatsPage;