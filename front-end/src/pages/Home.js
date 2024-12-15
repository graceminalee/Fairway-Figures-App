import React from 'react';
import { Link } from 'react-router-dom';
import './Home.css';
import logoImage from './img/ff-logo.png';


const Home = () => {
    return (
        <div className="home-container">
            <header className="home-header">
                <h1 id="main-title">Fairway Figures</h1>
            </header>

            <main className="home-main">
                {/* <h1>Welcome to Fairway Figures!</h1> */}
                <img src={logoImage} alt="Logo" className="logo-image-home" />
                <p>Track your golf game, analyze your performance, and connect with friends.</p>
                <div className="buttonGroup">
                    <Link to="/login">
                        <button className="button">Login</button>
                    </Link>
                    <Link to="/sign-up">
                        <button className="button">Sign Up</button>
                    </Link>
                </div>

                <section className="about-us">
                    <h2>About Us</h2>
                    <p>
                        At Fairway Figures, we believe in enhancing your golfing experience. Our mission is to help you track your performance and improve your game.
                    </p>
                </section>

                <section className="features">
                    <h2>Our Features</h2>
                    <ul>
                        <li>📊 Visualize your performance with graphs</li>
                        <li>📅 Input detailed golf round metrics</li>
                        <li>👥 Connect with friends</li>
                        {/* <li>🔒 Control privacy settings for your profile</li> */}
                    </ul>
                </section>

                <section className="contact-us">
                    <h2>Contact Us</h2>
                    <p>
                        Phone: (123) 456-7890<br />
                        Email: info@fairwayfigures.com
                    </p>
                </section>
            </main>
        </div>
    );
};

export default Home;
