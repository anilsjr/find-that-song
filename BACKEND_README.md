# Find That Song - Backend Setup

## Quick Start

To resolve the connection error and start using the app:

### Option 1: Use the Batch File (Windows)

1. Double-click `start-backend.bat` in the project root
2. Wait for "Song search API running on port 3000" message
3. Keep the terminal window open
4. Run your Flutter app

### Option 2: Manual Start

1. Open a terminal/command prompt
2. Navigate to the backend directory:
   ```
   cd backend/song-serch-api
   ```
3. Install dependencies (first time only):
   ```
   npm install
   ```
4. Start the server:
   ```
   node index.js
   ```
5. You should see: "Song search API running on port 3000"
6. Keep the terminal open and run your Flutter app

### Option 3: Using npm scripts

```bash
cd backend/song-serch-api
npm start
```

## Troubleshooting

- **Connection Refused Error**: This means the backend server is not running. Follow the steps above to start it.
- **Port 3000 already in use**: Close any other applications using port 3000, or kill existing node processes.
- **Module not found**: Run `npm install` in the backend/song-serch-api directory.

## API Endpoint

The Flutter app connects to: `http://localhost:3000/search-song?song=QUERY`

Make sure this URL is accessible when testing the search functionality.
