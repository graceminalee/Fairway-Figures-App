import React, { useState, useEffect } from 'react';
import { getToken } from '../utils/auth';
import './FollowersPage.css';

const FollowersPage = () => {
    const [searchQuery, setSearchQuery] = useState('');
    const [searchResults, setSearchResults] = useState([]);
    const [followers, setFollowers] = useState([]);
    const [following, setFollowing] = useState([]);
    const [error, setError] = useState('');

    // Fetch followers/following list
    useEffect(() => {
        const fetchFollowData = async () => {
            try {
                // Fetch current user's followers
                const followersResponse = await fetch('http://localhost:5001/api/auth/followers/my-followers', {
                    headers: {
                        'Authorization': `Bearer ${getToken()}`
                    }
                });

                // Fetch current user's following
                const followingResponse = await fetch('http://localhost:5001/api/auth/followers/my-following', {
                    headers: {
                        'Authorization': `Bearer ${getToken()}`
                    }
                });

                if (!followersResponse.ok || !followingResponse.ok) {
                    throw new Error('Failed to fetch follow data');
                }

                const followersData = await followersResponse.json();
                const followingData = await followingResponse.json();

                setFollowers(followersData);
                setFollowing(followingData);
            } catch (err) {
                setError(err.message);
            }
        };

        fetchFollowData();
    }, []);

    // Search users
    const handleSearch = async (e) => {
        e.preventDefault();
        try {
            const response = await fetch(`http://localhost:5001/api/auth/users/search?query=${searchQuery}`, {
                headers: {
                    'Authorization': `Bearer ${getToken()}`
                }
            });

            if (!response.ok) {
                throw new Error('Search failed');
            }

            const data = await response.json();
            setSearchResults(data);
        } catch (err) {
            setError(err.message);
        }
    };

    // Follow user
    const handleFollow = async (username) => {
        try {
            const response = await fetch('http://localhost:5001/api/auth/followers/follow', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${getToken()}`
                },
                body: JSON.stringify({ username })
            });

            if (!response.ok) {
                throw new Error('Failed to follow user');
            }

            // Refresh followers and following lists
            const followersResponse = await fetch('http://localhost:5001/api/auth/followers/my-followers', {
                headers: {
                    'Authorization': `Bearer ${getToken()}`
                }
            });

            const followingResponse = await fetch('http://localhost:5001/api/auth/followers/my-following', {
                headers: {
                    'Authorization': `Bearer ${getToken()}`
                }
            });

            const followersData = await followersResponse.json();
            const followingData = await followingResponse.json();

            setFollowers(followersData);
            setFollowing(followingData);
        } catch (err) {
            setError(err.message);
        }
    };

    // Unfollow user
    const handleUnfollow = async (username) => {
        try {
            const response = await fetch('http://localhost:5001/api/auth/followers/unfollow', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${getToken()}`
                },
                body: JSON.stringify({ username })
            });

            if (!response.ok) {
                throw new Error('Failed to unfollow user');
            }

            // Refresh followers and following lists
            const followersResponse = await fetch('http://localhost:5001/api/auth/followers/my-followers', {
                headers: {
                    'Authorization': `Bearer ${getToken()}`
                }
            });

            const followingResponse = await fetch('http://localhost:5001/api/auth/followers/my-following', {
                headers: {
                    'Authorization': `Bearer ${getToken()}`
                }
            });

            const followersData = await followersResponse.json();
            const followingData = await followingResponse.json();

            setFollowers(followersData);
            setFollowing(followingData);
        } catch (err) {
            setError(err.message);
        }
    };

    return (
        <div className="followers-container">
            <h2>Followers & Following</h2>
            
            {/* Search Bar */}
            <form onSubmit={handleSearch} className="search-form">
                <input 
                    type="text" 
                    placeholder="Search users..." 
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="search-input"
                />
                <button type="submit" className="search-button">Search</button>
            </form>

            {/* Search Results */}
            {searchResults.length > 0 && (
                <div className="search-results">
                    <h3>Search Results</h3>
                    {searchResults.map(user => (
                        <div key={user.username} className="search-result-item">
                            <span>{`${user.first_name} ${user.last_name} (${user.username})`}</span>
                            {following.some(f => f.username === user.username) ? (
                                <button 
                                    onClick={() => handleUnfollow(user.username)}
                                    className="unfollow-button"
                                >
                                    Unfollow
                                </button>
                            ) : (
                                <button 
                                    onClick={() => handleFollow(user.username)}
                                    className="follow-button"
                                >
                                    Follow
                                </button>
                            )}
                        </div>
                    ))}
                </div>
            )}

            {/* Followers List */}
            <div className="followers-list">
                <h3>Followers ({followers.length})</h3>
                {followers.map(follower => (
                    <div key={follower.username} className="follower-item">
                        {`${follower.first_name} ${follower.last_name} (${follower.username})`}
                    </div>
                ))}
            </div>

            {/* Following List */}
            <div className="following-list">
                <h3>Following ({following.length})</h3>
                {following.map(followedUser => (
                    <div key={followedUser.username} className="following-item">
                        {`${followedUser.first_name} ${followedUser.last_name} (${followedUser.username})`}
                        <button 
                            onClick={() => handleUnfollow(followedUser.username)}
                            className="unfollow-button"
                        >
                            Unfollow
                        </button>
                    </div>
                ))}
            </div>

            {error && <div className="error-message">{error}</div>}
        </div>
    );
};

export default FollowersPage;