# Welcome to the Fairway Figures App

Track your golf game, analyze your performance, and connect with friends!

## Description 
This project aims to bridge the gap between golfers and their performance data, enhancing the experience of tracking and improving golf skills. This app will provide a user-friendly interface for golfers to enter their scores, track stats, and visualize their progress over time.


## Table of Contents
  Installation
  Usage
  Contributing
  Credits
  License
  Notes

## Installation

1 Clone the repo

2 Run command:

    npm install
    
3 Run command:

    cd ../back-end && npm install
    
    cd ../back-end && npm install


## Usage Account Management
Create Account: 
    Sign up with username, email, password, and password confirmation. Upon successful sign up, the user will be directed to the login page.
    Login: Enter user credentials to access user profile. Once successful, user will be directed to user's personalized dashboard.
Tracking Golf Rounds
    Navigate to the Round Input section on the dashboard.
    Enter user round details: Course, Course Name, State, City, and Date Played. The user will then be taken to the hole by hole input form. Where the user will add the par of the hole, the yardage of the hole, and the score of the hole. 
    The user may submit the round at any point. Once the user enters the desired amount of holes played, the page will be directed to the stats page, where the users round information will display. Additionally, other round stats will display. 
Visualizing Performance
    Dashboard Widgets: The user will be able to navigate to their proile, add round page, and stats page.
Connecting with Friends
    Search Friends: The user will be able to search for friends via search bar. All user name's containing the entered string will display. 
    Follow: Users can follow other users, which will then populate under the following portion of the page. 
Personalizing the Dashboard
    Edit Mode: Use the edit button to rearrange dashboard widgets.
  Save Layout: Customize and save the widget layout using local storage.

## Contributing 
Grace Lee.

## Credits 
React for front end, Express for backend. 

## License 
Distributed under the MIT License. See LICENSE for more information.

## Notes
### `npm start`

Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

To kill a running port: 

    sudo lsof -i:5001

    sudo kill -9 pid(replace the actual pid)
