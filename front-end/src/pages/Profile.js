import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { getToken } from '../utils/auth'; //removeToken
import './Profile.css';

const Profile = () => {
    const navigate = useNavigate();
    const [profile, setProfile] = useState(null);
    const [error, setError] = useState('');


    useEffect(() => {
        const fetchProfile = async () => {
            try {
                const response = await fetch('http://localhost:5001/api/auth/profile', {
                    headers: {
                        'Authorization': `Bearer ${getToken()}`
                    }
                });

                if (!response.ok) {
                    throw new Error('Please login again');
                }

                const data = await response.json();
                setProfile(data);
            } catch (err) {
                setError(err.message);
                // removeToken();
                // navigate('/login');
            }
        };

        fetchProfile();
    }, [navigate]);

    if (!profile) {
        return <div className="loading">Loading...</div>;
    }

    return (
        <div className="profile-container">
            <div className="header">
                <h2 className="title">Profile</h2>
                <Link to="/edit-profile" className="edit-button">
                    Edit Profile
                </Link>
            </div>

            {error && <div className="error-message">{error}</div>}

            <div className="profile-details">
                <div className="profile-picture">
                    {profile.profile_picture ? (
                        <img 
                            src={profile.profile_picture} 
                            alt="Profile" 
                            className="profile-image"
                        />
                    ) : (
                        <div className="default-picture">
                            <span className="default-initial">
                                {profile.first_name?.[0]?.toUpperCase() || '?'}
                            </span>
                        </div>
                    )}
                </div>

                <div className="profile-info-grid">
                    <div>
                        <strong className="info-label">Name:</strong>
                        <p>{profile.first_name} {profile.last_name}</p>
                    </div>
                    <div>
                        <strong className="info-label">Username:</strong>
                        <p>{profile.username}</p>
                    </div>
                    <div>
                        <strong className="info-label">Email:</strong>
                        <p>{profile.email}</p>
                    </div>
                    <div>
                        <strong className="info-label">Phone:</strong>
                        <p>{profile.phone || 'Not set'}</p>
                    </div>
                    <div>
                        <strong className="info-label">Location:</strong>
                        <p>{profile.home_location || 'Not set'}</p>
                    </div>
                    <div>
                        <strong className="info-label">Home Course:</strong>
                        <p>{profile.home_course || 'Not set'}</p>
                    </div>
                </div>

                <div className="bio-section">
                    <strong className="info-label">Bio:</strong>
                    <p className="bio-text">{profile.bio || 'No bio yet'}</p>
                </div>
            </div>
        </div>
    );
};

export default Profile;
