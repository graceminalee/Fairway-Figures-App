import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { getToken } from './utils/auth';

// Pages
import SignUp from './pages/SignUp';
import Login from './pages/Login';
import Profile from './pages/Profile';
import NavBar from './components/NavBar';
import EditProfile from './pages/EditProfile';
import Home from './pages/Home';
import Dashboard from './pages/Dashboard';
import CourseInput from './pages/CourseInput';
import HoleInput from './pages/HoleInput';
import StatsPage from './pages/StatsPage';
import FollowersPage from './pages/FollowersPage';
import ClubManager from './pages/ClubManager';

// Protected Route wrapper
const ProtectedRoute = ({ children }) => {
    const token = getToken();
    
    if (!token) {
        return <Navigate to="/login" replace />;
    }

    return children;
};

const PublicRoute = ({ children }) => {
    const token = getToken();
    
    if (token) {
        return <Navigate to="/dashboard" replace />;
    }

    return children;
};

const App = () => {
    return (
        <Router>
            <div className="screen">
                <NavBar />
                <div className="container mx-auto px-4">
                    <Routes>
                        {/* Public Routes */}
                        <Route 
                            path="/" 
                            element={
                                <PublicRoute>
                                    <Home />
                                </PublicRoute>
                            } 
                        />
                        <Route 
                            path="/sign-up" 
                            element={
                                <PublicRoute>
                                    <SignUp />
                                </PublicRoute>
                            } 
                        />
                        <Route 
                            path="/login" 
                            element={
                                <PublicRoute>
                                    <Login />
                                </PublicRoute>
                            } 
                        />

                        {/* Protected Routes */}
                        <Route 
                            path="/profile" 
                            element={
                                <ProtectedRoute>
                                    <Profile />
                                </ProtectedRoute>
                            }
                        />
                        
                        <Route
                            path="/edit-profile" element={
                                <ProtectedRoute>
                                    <EditProfile />
                                </ProtectedRoute>
                            }   />

                        <Route 
                            path="/dashboard" 
                            element={
                                <ProtectedRoute>
                                    <Dashboard />
                                </ProtectedRoute>
                            }/>
                        <Route 
                            path="/round-input" 
                            element={
                                <ProtectedRoute>
                                    <CourseInput />
                                </ProtectedRoute>
                            }/>


                        <Route 
                            path="/course-input" 
                            element={
                                <ProtectedRoute>
                                    <CourseInput />
                                </ProtectedRoute>
                            } />
                        
                        <Route 
                            path="/hole-input" 
                            element={
                                <ProtectedRoute>
                                    <HoleInput />
                                </ProtectedRoute>
                            } />

                        <Route 
                            path="/stats-page" 
                            element={
                                <ProtectedRoute>
                                    <StatsPage />
                                </ProtectedRoute>
                            } />

                        <Route 
                            path="/followers-page" 
                            element={
                                <ProtectedRoute>
                                    <FollowersPage />
                                </ProtectedRoute>
                            } />

                        <Route 
                            path="/club-manager" 
                            element={
                                <ProtectedRoute>
                                    <ClubManager />
                                </ProtectedRoute>
                            } />
                       {/* Catch-all route */}
                        <Route 
                            path="*" 
                            element={
                                <div className="text-center mt-20">
                                    <h1 className="text-4xl font-bold mb-4">404</h1>
                                    <p>Page not found</p>
                                </div>
                            }  />


                    </Routes>
                </div>
            </div>
        </Router>
    );
};

export default App;
