#!/bin/bash

# Bolt.diy Startup Script
echo "🚀 Starting Bolt.diy..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null; then
    echo "❌ pnpm is not installed. Installing pnpm..."
    npm install -g pnpm
fi

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    pnpm install
fi

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    echo "⚠️  Warning: .env.local file not found!"
    echo "   Please copy .env.local and add your API keys for the AI providers you want to use."
    echo "   The application will still run, but you'll need to configure API keys in the settings."
fi

# Start the development server
echo "🌐 Starting development server..."
echo "   You can access the application at: http://localhost:5173"
echo "   Press Ctrl+C to stop the server"
echo ""

pnpm run dev