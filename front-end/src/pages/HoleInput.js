import React, { useState, useEffect } from 'react';
import { getToken } from '../utils/auth';
import { useSearchParams, useNavigate } from 'react-router-dom';
import './HoleInput.css';

const HoleInput = () => {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();

    const courseId = searchParams.get('courseId');
    const roundId = searchParams.get('roundId');

    useEffect(() => {
        if (!courseId || !roundId) {
            navigate('/course-input');
        }
    }, [courseId, roundId, navigate]);

    const [currentHole, setCurrentHole] = useState(1);
    const [holeData, setHoleData] = useState({
        par: '',
        startYardage: '',
        score: '' 
    });
    const [message, setMessage] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleHoleSubmit = async (e) => {
        e.preventDefault();

        if (!courseId || !roundId) {
            setMessage('Missing course or round information. Please start over.');
            navigate('/course-input');
            return;
        }

        try {
            const response = await fetch('http://localhost:5001/api/auth/add-hole-info', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${getToken()}`
                },
                body: JSON.stringify({
                    course_id: parseInt(courseId),
                    round_id: parseInt(roundId),
                    hole_number: currentHole,
                    par: parseInt(holeData.par),
                    start_yardage: parseInt(holeData.startYardage),
                    score: parseInt(holeData.score)
                })
            });

            if (response.ok) {
                setMessage(`Hole ${currentHole} information saved.`);
                
                if (currentHole < 18) {
                    setCurrentHole(currentHole + 1);
                    setHoleData({ par: '', startYardage: '', score: '' }); 
                } else {
                    setMessage('Round completed! All holes have been recorded.');
                    navigate('/stats-page');
                }
            } else {
                const data = await response.json();
                setMessage(data.error || 'Error saving hole information');
            }
        } catch (error) {
            console.error('Error:', error);
            setMessage('Error saving hole information');
        }
    };

    const handleSubmitRound = async () => {
        setIsSubmitting(true);
        try {
            const response = await fetch('http://localhost:5001/api/auth/submit-round', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${getToken()}`
                },
                body: JSON.stringify({
                    round_id: roundId
                })
            });

            if (response.ok) {
                navigate('/stats-page');
            } else {
                const data = await response.json();
                setMessage(data.error || 'Failed to submit round');
            }
        } catch (error) {
            setMessage('Error submitting round');
            console.error('Error:', error);
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="hole-input-container">
            <h2 className="hole-input-title">Hole {currentHole}</h2>
            <form onSubmit={handleHoleSubmit} className="form-group">
                <div className="form-group">
                    <label>Par: </label>
                    <input
                        type="number"
                        value={holeData.par}
                        onChange={(e) => setHoleData({ ...holeData, par: e.target.value })}
                        className="input-field"
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Starting Yardage: </label>
                    <input
                        type="number"
                        value={holeData.startYardage}
                        onChange={(e) => setHoleData({ ...holeData, startYardage: e.target.value })}
                        className="input-field"
                        required
                    />
                </div>
                <div className="form-group">
                    <label>Score on Hole: </label>
                    <input
                        type="number"
                        value={holeData.score}
                        onChange={(e) => setHoleData({ ...holeData, score: e.target.value })}
                        className="input-field"
                        required
                    />
                </div>
                <button type="submit" className="submit-button">Save Hole Info</button>
            </form>
            <div>
                <p className={message.includes('Error') ? 'error-message' : ''}>{message}</p>
            </div>
            <div className="mt-4">
                <button
                    onClick={handleSubmitRound}
                    disabled={isSubmitting}
                    className="submit-button"
                >
                    {isSubmitting ? 'Submitting...' : 'Submit Round'}
                </button>
            </div>
        </div>
    );
};

export default HoleInput;
