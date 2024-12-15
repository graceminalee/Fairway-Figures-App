import React, { useState, useEffect } from 'react';
import { DragDropContext, Droppable, Draggable } from 'react-beautiful-dnd';
import { Link } from 'react-router-dom';
import { getToken } from '../utils/auth';
import './Dashboard.css';


const Dashboard = () => {
    const [showSettings, setShowSettings] = useState(false);
    const [editMode, setEditMode] = useState(false);
    const [userName, setUserName] = useState('');
    const [settings, setSettings] = useState({
        backgroundColor: '#ffffff', 
        buttonPosition: 'top',
    });
    const [widgetOrder, setWidgetOrder] = useState(() => {
        const savedOrder = localStorage.getItem('widgetOrder');
        return savedOrder
            ? JSON.parse(savedOrder)
            : [
                { id: 'course-input', title: 'Add Round', description: 'Enter details about your golf rounds.', link: '/course-input' },
                { id: 'view-stats', title: 'View Stats', description: 'Review your golf performance stats.', link: '/stats-page' },
                { id: 'profile', title: 'Profile', description: 'View and edit your profile.', link: '/profile' },
                // { id: 'friends', title: 'Friends', description: 'Manage your friends and view their updates.', link: '/followers-page' },
            ];
    });

    const fetchName = async () => {
        try {
            const response = await fetch('http://localhost:5001/api/auth/dashboard', {
                headers: {
                    'Authorization': `Bearer ${getToken()}`
                }
            });

            if (!response.ok) {
                throw new Error('Please login again');
            } 
            const data = await response.json();
            setUserName(`${data.first_name} ${data.last_name}`);
        
        } catch (err) {
            console.error(err.message);

        }
    };
        
    useEffect(() => {
        fetchName();
    }, []);

    const handleSettingsUpdate = (newSettings) => {
        setSettings(newSettings);
        setShowSettings(false);
    };

    const toggleEditMode = () => {
        if (editMode) {
            localStorage.setItem('widgetOrder', JSON.stringify(widgetOrder));
        }
        setEditMode((prev) => !prev);
    };

    const onDragEnd = (result) => {
        if (!result.destination) return;

        const reorderedWidgets = Array.from(widgetOrder);
        const [movedWidget] = reorderedWidgets.splice(result.source.index, 1);
        reorderedWidgets.splice(result.destination.index, 0, movedWidget);
        setWidgetOrder(reorderedWidgets);
    };

    useEffect(() => {
        const savedSettings = JSON.parse(localStorage.getItem('dashboardSettings'));
        if (savedSettings) {
            setSettings(savedSettings);
        }
    }, []);

    useEffect(() => {
        localStorage.setItem('dashboardSettings', JSON.stringify(settings));
    }, [settings]);

    return (
        <div className="dashboard-container" style={{ backgroundColor: settings.backgroundColor }}>
            <header className="dashboard-header">
                <h1 id="dashboard-title">{userName ? `${userName}'s Dashboard` : 'Dashboard'}</h1>
            </header>

            <div className="dashboard-content">
                <button className="button" onClick={toggleEditMode}>
                    {editMode ? 'Save Layout' : 'Edit Layout'}
                </button>

                {showSettings ? (
                    <Settings currentSettings={settings} onSettingsUpdate={handleSettingsUpdate} />
                ) : (
                    <DragDropContext onDragEnd={onDragEnd}>
                        <Droppable droppableId="widgets" direction="horizontal">
                            {(provided) => (
                                <div ref={provided.innerRef} {...provided.droppableProps} className="widgets-container">
                                    {widgetOrder.map((widget, index) => (
                                        <Draggable key={widget.id} draggableId={widget.id} index={index} isDragDisabled={!editMode}>
                                            {(provided) => (
                                                <div ref={provided.innerRef} {...provided.draggableProps} {...provided.dragHandleProps}>
                                                    <Widget
                                                        title={widget.title}
                                                        description={widget.description}
                                                        link={editMode ? null : widget.link} // Disable link in edit mode
                                                    />
                                                </div>
                                            )}
                                        </Draggable>
                                    ))}
                                    {provided.placeholder}
                                </div>
                            )}
                        </Droppable>
                    </DragDropContext>
                )}
            </div>
        </div>
    );
};

const Settings = ({ currentSettings, onSettingsUpdate }) => {
    const [backgroundColor, setBackgroundColor] = useState(currentSettings.backgroundColor);
    const [buttonPosition, setButtonPosition] = useState(currentSettings.buttonPosition);

    const handleSubmit = () => {
        onSettingsUpdate({ backgroundColor, buttonPosition });
    };

    return (
        <div className="settings-container">
            <h2>Dashboard Settings</h2>
            <div className="widget-options">
                <label htmlFor="background-color">Background Color</label>
                <input
                    type="color"
                    id="background-color"
                    value={backgroundColor}
                    onChange={(e) => setBackgroundColor(e.target.value)}
                />
            </div>
            <div className="widget-options">
                <label htmlFor="button-position">Button Position</label>
                <select
                    id="button-position"
                    value={buttonPosition}
                    onChange={(e) => setButtonPosition(e.target.value)}
                >
                    <option value="top">Top</option>
                    <option value="bottom">Bottom</option>
                </select>
            </div>
            <button className="button" onClick={handleSubmit}>Save Settings</button>
        </div>
    );
};

const Widget = ({ title, description, link }) => (
    <div className="widget">
        <h3>{title}</h3>
        <p>{description}</p>
        {link && <Link to={link}><button className="button">Go</button></Link>}
    </div>
);



export default Dashboard;