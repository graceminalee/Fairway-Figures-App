import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { getToken, removeToken } from '../utils/auth';
import './NavBar.css'; 

import logoImage from '../pages/img/ff-logo.png';



const NavBar = () => {
    const navigate = useNavigate();
    const token = getToken();

    const handleLogout = () => {
        removeToken();
        navigate('/');
    };

    return (
        <nav className="navbar">
            <div className="navbar-container">
                <div className="navbar-content">
                    <Link to="/" className="logo">
                        {/* <img src="../pages/img/fairway-figures-logo.jpg" alt="Fairway Figures Logo" className="logo-image" /> */}
                        <img src={logoImage} alt="Logo" className="logo-image" />
                        Fairway Figures
                    </Link>
                    <p className="image-logo"></p>
                    <div className="navbar-links">
                    </div>
                    <div className="navbar-links">
                        {token ? (
                            <>
                                <Link 
                                    to="/dashboard" 
                                    className="navbar-link"
                                >
                                    Dashboard
                                </Link>
                                <Link 
                                    to="/course-input" 
                                    className="navbar-link"
                                >
                                    Add Round
                                </Link>
                                <Link 
                                    to="/profile" 
                                    className="navbar-link"
                                >
                                    Profile
                                </Link>
                                <Link 
                                    to="/followers-page" 
                                    className="navbar-link"
                                >
                                    Friends
                                </Link>
                                <Link 
                                    to="/stats-page" 
                                    className="navbar-link"
                                >
                                    Stats
                                </Link>
                                <Link 
                                    to="/club-manager" 
                                    className="navbar-link"
                                >
                                    My Equipment
                                </Link>
                               
                               
                                
                                <button
                                    onClick={handleLogout}
                                    className="logout-button"
                                >
                                    Logout
                                </button>
                            </>
                            ) : (
                            <>
                                <Link 
                                    to="/login" 
                                    className="navbar-link"
                                >
                                    Login
                                </Link>
                                <Link 
                                    to="/sign-up" 
                                    className="signup-button"
                                >
                                    Sign Up
                                </Link>
                            </>
                        )}
                    </div>
                </div>
            </div>
        </nav>
    );
};

export default NavBar;
