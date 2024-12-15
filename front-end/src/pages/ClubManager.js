import React, { useState, useEffect } from 'react';
import './ClubManager.css';
import { getToken } from '../utils/auth';

const ClubManager = () => {
const [clubs, setClubs] = useState([]);
const [groupedClubs, setGroupedClubs] = useState([]);
const [isGroupedByBrand, setIsGroupedByBrand] = useState(false);
const [newClub, setNewClub] = useState({
    clubType: '',
    brand: '',
    slotNumber: ''
});
const [error, setError] = useState('');

useEffect(() => {
    if (isGroupedByBrand) {
    fetchGroupedClubs();
    } else {
    fetchClubs();
    }
}, [isGroupedByBrand]);

const fetchClubs = async () => {
    try {
    const response = await fetch('http://localhost:5001/api/auth/equipment/my-clubs', {
        headers: {
        'Authorization': `Bearer ${getToken()}`
        }
    });
    
    if (response.ok) {
        const data = await response.json();
        setClubs(data);
    }
    } catch (err) {
    setError('Failed to fetch clubs');
    }
};

const fetchGroupedClubs = async () => {
    try {
    const response = await fetch('http://localhost:5001/api/auth/equipment/clubs-by-brand', {
        headers: {
        'Authorization': `Bearer ${getToken()}`
        }
    });
    
    if (response.ok) {
        const data = await response.json();
        setGroupedClubs(data);
    }
    } catch (err) {
    setError('Failed to fetch grouped clubs');
    }
};

const handleAddClub = async (e) => {
    e.preventDefault();
    try {
    const response = await fetch('http://localhost:5001/api/auth/equipment/add-club', {
        method: 'POST',
        headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getToken()}`
        },
        body: JSON.stringify(newClub)
    });
    
    if (response.ok) {
        if (isGroupedByBrand) {
        fetchGroupedClubs();
        } else {
        fetchClubs();
        }
        setNewClub({ clubType: '', brand: '', slotNumber: '' });
        setError('');
    } else {
        const data = await response.json();
        setError(data.error);
    }
    } catch (err) {
    setError('Failed to add club');
    }
};

const toggleGrouping = () => {
    setIsGroupedByBrand(!isGroupedByBrand);
};

return (
    <div className="club-container">
    <div className="header-container">
        <h1 className="title">My Golf Bag</h1>
    </div>

    <form onSubmit={handleAddClub} className="add-club-form">
        <div className="form-grid">
        <div className="form-group">
            <label>Club Type</label>
            <input
            type="text"
            placeholder="e.g. Driver, 7i"
            value={newClub.clubType}
            onChange={(e) => setNewClub({...newClub, clubType: e.target.value})}
            required
            />
        </div>
        <div className="form-group">
            <label>Brand</label>
            <input
            type="text"
            placeholder="e.g., PING, Taylormade"
            value={newClub.brand}
            onChange={(e) => setNewClub({...newClub, brand: e.target.value})}
            required
            />
        </div>
        <div className="form-group">
            <label>Slot Number (1-14)</label>
            <input
            type="number"
            min="1"
            max="14"
            value={newClub.slotNumber}
            onChange={(e) => setNewClub({...newClub, slotNumber: e.target.value})}
            required
            />
        </div>
        </div>
        <button type="submit" className="add-button">Add Club</button>
    </form>

    {error && (
        <div className="error-message">
        {error}
        </div>
    )}

    <div className="clubs-display">
        <h2 className="subtitle">Current Clubs</h2>
        <div>
            <button 
            onClick={toggleGrouping}
            className="toggle-button"
            >
            {isGroupedByBrand ? 'Show by Slot' : 'Group by Brand'}
            </button>
        </div>
        <div className="clubs-grid">
        {!isGroupedByBrand ? (
            clubs.map((club) => (
            <div key={club.slot_number} className="club-card">
                <span className="club-type">{club.club_type}</span>
                <p className="club-brand">{club.brand}</p>
                <p className="slot-number">Slot {club.slot_number}</p>
            </div>
            ))
        ) : (
            groupedClubs.map((group) => (
            <div key={group.brand} className="brand-group">
                <h3 className="brand-title">{group.brand}</h3>
                <div className="brand-clubs">
                {group.clubs.map((club_type, index) => (
                    <div key={index} className="club-card brand-grouped">
                    <span className="club-type">{club_type}</span>
                    </div>
                ))}
                </div>
            </div>
            ))
        )}
        </div>
        {(isGroupedByBrand ? groupedClubs : clubs).length === 0 && (
        <p className="no-clubs">No clubs added yet.</p>
        )}
    </div>
    </div>
);
};

export default ClubManager;

