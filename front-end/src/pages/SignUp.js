import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './SignUp.css';

const SignUp = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        password: '',
        confirmPassword: ''
    });
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setSuccess('');

        if (formData.password !== formData.confirmPassword) {
            setError('Passwords do not match');
            return;
        }

        try {
            console.log('Sending signup request with data:', {
                ...formData,
                password: '[REDACTED]',
                confirmPassword: '[REDACTED]'
            });

            const response = await fetch('http://localhost:5001/api/auth/sign-up', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    firstName: formData.firstName,
                    lastName: formData.lastName,
                    username: formData.username,
                    email: formData.email,
                    password: formData.password
                })
            });

            console.log('Response status:', response.status);
            const data = await response.json();
            console.log('Response data:', data);

            if (!response.ok) {
                throw new Error(data.error || 'Signup failed');
            }

            setSuccess('Your account was succesffuly created! Redirecting to login...');
            setTimeout(() => navigate('/login'), 2000);
        } catch (err) {
            console.error('Signup error:', err);
            setError(err.message || 'Failed to sign up');
        }
    };

    return (
        <div className="sign-up-container">
            <h2 className="sign-up-title">Sign Up</h2>
            {error && <div className="error-message">{error}</div>}  {/* If error occurs */}
            {success && <div className="success-message">{success}</div>}  {/* Signifier for sucess */}

            <form onSubmit={handleSubmit}>
                <div className="input-group">
                    <input
                        type="text"
                        name="firstName"
                        placeholder="First Name"
                        value={formData.firstName}
                        onChange={handleChange}
                        className="input-field"
                        required
                    />
                </div>
                <div className="input-group">
                    <input
                        type="text"
                        name="lastName"
                        placeholder="Last Name"
                        value={formData.lastName}
                        onChange={handleChange}
                        className="input-field"
                        required
                    />
                </div>
                <div className="input-group">
                    <input
                        type="text"
                        name="username"
                        placeholder="Username"
                        value={formData.username}
                        onChange={handleChange}
                        className="input-field"
                        required
                    />
                </div>
                <div className="input-group">
                    <input
                        type="email"
                        name="email"
                        placeholder="Email"
                        value={formData.email}
                        onChange={handleChange}
                        className="input-field"
                        required
                    />
                </div>
                <div className="input-group">
                    <input
                        type="password"
                        name="password"
                        placeholder="Password"
                        value={formData.password}
                        onChange={handleChange}
                        className="input-field"
                        required
                    />
                </div>
                <div className="input-group">
                    <input
                        type="password"
                        name="confirmPassword"
                        placeholder="Confirm Password"
                        value={formData.confirmPassword}
                        onChange={handleChange}
                        className="input-field"
                        required
                    />
                </div>
                <button
                    type="submit"
                    className="submit-button"
                >
                    Sign Up
                </button>
            </form>
        </div>
    );
};

export default SignUp;
