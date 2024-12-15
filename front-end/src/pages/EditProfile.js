import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { getToken } from '../utils/auth';
import './EditProfile.css';

const EditProfile = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        bio: '',
        location: '',
        phone: '',
        homeCourse: '',
    });
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');
    const [loading, setLoading] = useState(true);

    // Fetch current profile data
    useEffect(() => {
        const fetchProfile = async () => {
            try {
                const response = await fetch('http://localhost:5001/api/auth/profile', {
                    headers: {
                        'Authorization': `Bearer ${getToken()}`,
                    },
                });

                if (!response.ok) {
                    throw new Error('Failed to fetch profile');
                }

                const data = await response.json();
                setFormData({
                    bio: data.bio || '',
                    location: data.location || '',
                    phone: data.phone || '',
                    homeCourse: data.home_course || '',
                });
            } catch (err) {
                setError('Failed to load profile data');
            } finally {
                setLoading(false);
            }
        };

        fetchProfile();
    }, []);

    // Handle form input changes, also santizes values
    const handleChange = (e) => {
        const { name, value } = e.target;
        if(name === 'phone') {
            const sanitizedValue = value.replace(/\D/g, ''); // Take out non numeric vals
            setFormData((prev) => ({ ...prev, [name]: sanitizedValue }));
        }
        else {
            setFormData((prev) => ({ ...prev, [name]: value }));
        }

        // setFormData((prev) => ({ ...prev, [name]: value }));
    };

    // Submit the updated profile data
    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');

        try {
            const response = await fetch('http://localhost:5001/api/auth/profile/update', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${getToken()}`,
                },
                body: JSON.stringify(formData),
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to update profile');
            }

            setSuccess('Profile updated successfully!');
            setTimeout(() => navigate('/profile'), 1500);
        } catch (err) {
            setError(err.message);
        }
    };

    if (loading) {
        return <div className="loading-message">Loading...</div>;
    }

    return (
        <div className="edit-profile-container">
            <h2 className="edit-profile-title">Edit Profile</h2>

            {error && <div className="error-message">{error}</div>}
            {success && <div className="success-message">{success}</div>}

            {/* Form, does not allow phone to be non numeric.  */}
            <form onSubmit={handleSubmit} className="edit-profile-form">
                <div className="form-group">
                    <label htmlFor="bio">Bio</label>
                    <textarea 
                        id="bio"
                        name="bio"
                        value={formData.bio}
                        onChange={handleChange}
                        placeholder="Tell us about yourself!"
                    />
                </div>
                <div className="form-group">
                    <label htmlFor="home_location">Location</label>
                    <textarea 
                        id="home_location"
                        name="home_location"
                        value={formData.home_location}
                        onChange={handleChange}
                        placeholder="Your Home City and State"
                    />
                </div>
                <div className="form-group">
                    <label htmlFor="phone">Phone</label>
                    <textarea 
                        id="phone"
                        name="phone"
                        value={formData.phone}
                        onChange={handleChange}
                        placeholder="Your Phone Number"
                    />
                </div>
                <div className="form-group">
                    <label htmlFor="homeCourse">Home Course</label>
                    <textarea 
                        id="homeCourse"
                        name="homeCourse"
                        value={formData.homeCourse}
                        onChange={handleChange}
                        placeholder="Your Home Course"
                    />
                </div>
                <div className="button-group">
                    <button type="submit" className="save-button">Save Changes</button>
                    <button 
                        type="button"
                        onClick={() => navigate('/profile')}
                        className="cancel-button"
                    >
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    );
};

export default EditProfile;

