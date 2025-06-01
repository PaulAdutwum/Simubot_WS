#!/usr/bin/env python3
"""
Web Dashboard for SimuBot Simulation
This creates a simple web interface to visualize the simulation data
"""

import time
import json
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
import subprocess
import os

class SimuBotDashboard(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            
            html = """
<!DOCTYPE html>
<html>
<head>
    <title>SimuBot Dashboard</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background-color: #f0f0f0;
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto;
        }
        .header {
            text-align: center;
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .status-card {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .status-card h3 {
            color: #34495e;
            margin-top: 0;
        }
        .active { color: #27ae60; }
        .inactive { color: #e74c3c; }
        .data-display {
            font-family: monospace;
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            white-space: pre-wrap;
        }
        .refresh-btn {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .robot-visual {
            text-align: center;
            font-size: 48px;
            margin: 20px 0;
        }
    </style>
    <script>
        function refreshData() {
            fetch('/data')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('nodes-list').textContent = data.nodes.join('\\n');
                    document.getElementById('topics-list').textContent = data.topics.join('\\n');
                    document.getElementById('detections').textContent = data.detections || 'No detections yet';
                    document.getElementById('robot-pos').textContent = data.position || 'Position not available';
                    document.getElementById('last-update').textContent = data.timestamp;
                    
                    // Update status indicators
                    document.getElementById('gazebo-status').className = data.gazebo_running ? 'active' : 'inactive';
                    document.getElementById('vision-status').className = data.vision_running ? 'active' : 'inactive';
                    document.getElementById('decision-status').className = data.decision_running ? 'active' : 'inactive';
                });
        }
        
        // Auto-refresh every 3 seconds
        setInterval(refreshData, 3000);
        
        // Initial load
        window.onload = refreshData;
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🤖 SimuBot Live Dashboard</h1>
            <p>Real-time monitoring of your robot simulation</p>
            <button class="refresh-btn" onclick="refreshData()">🔄 Refresh Now</button>
        </div>
        
        <div class="status-grid">
            <div class="status-card">
                <h3>🎮 System Status</h3>
                <p>Gazebo Server: <span id="gazebo-status" class="inactive">●</span></p>
                <p>Vision Node: <span id="vision-status" class="inactive">●</span></p>
                <p>Decision Engine: <span id="decision-status" class="inactive">●</span></p>
                <p>Last Update: <span id="last-update">Never</span></p>
            </div>
            
            <div class="status-card">
                <h3>👁️ Vision System</h3>
                <div class="data-display" id="detections">Loading...</div>
            </div>
            
            <div class="status-card">
                <h3>📍 Robot Position</h3>
                <div class="robot-visual">🤖</div>
                <div class="data-display" id="robot-pos">Loading...</div>
            </div>
        </div>
        
        <div class="status-grid">
            <div class="status-card">
                <h3>🔗 Active ROS Nodes</h3>
                <div class="data-display" id="nodes-list">Loading...</div>
            </div>
            
            <div class="status-card">
                <h3>📡 Active Topics</h3>
                <div class="data-display" id="topics-list">Loading...</div>
            </div>
        </div>
    </div>
</body>
</html>
"""
            self.wfile.write(html.encode())
            
        elif self.path == '/data':
            # Get live data from ROS2
            data = self.get_simulation_data()
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            self.wfile.write(json.dumps(data).encode())
    
    def get_simulation_data(self):
        try:
            # Run commands inside Docker container
            def run_ros_cmd(cmd):
                full_cmd = f'docker exec inspiring_chatelet bash -c "source /opt/ros/humble/setup.bash && source /home/ros2/simu_ws/install/setup.bash && {cmd}"'
                try:
                    result = subprocess.run(full_cmd, shell=True, capture_output=True, text=True, timeout=3)
                    return result.stdout.strip()
                except:
                    return ""
            
            # Get node list
            nodes = run_ros_cmd("ros2 node list").split('\n') if run_ros_cmd("ros2 node list") else []
            
            # Get topic list
            topics = run_ros_cmd("ros2 topic list | grep -E '(camera|object|cmd_vel|odom)'").split('\n') if run_ros_cmd("ros2 topic list") else []
            
            # Check if key processes are running
            gazebo_running = '/gazebo' in run_ros_cmd("ros2 node list")
            vision_running = '/vision_node' in run_ros_cmd("ros2 node list")
            decision_running = '/decision_engine' in run_ros_cmd("ros2 node list")
            
            # Try to get robot position
            position = run_ros_cmd("timeout 2 ros2 topic echo /odom --once | head -10") or "Position data not available"
            
            # Try to get detections
            detections = run_ros_cmd("timeout 2 ros2 topic echo /object_detections --once") or "No detections (this is expected in simulation)"
            
            return {
                'nodes': [n for n in nodes if n.strip()],
                'topics': [t for t in topics if t.strip()],
                'gazebo_running': gazebo_running,
                'vision_running': vision_running,
                'decision_running': decision_running,
                'position': position,
                'detections': detections,
                'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
            }
        except Exception as e:
            return {
                'nodes': [f"Error: {str(e)}"],
                'topics': [],
                'gazebo_running': False,
                'vision_running': False,
                'decision_running': False,
                'position': "Error getting position",
                'detections': "Error getting detections",
                'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
            }

def start_dashboard():
    print("🌐 Starting SimuBot Web Dashboard...")
    print("📱 Open your browser and go to: http://localhost:8080")
    print("🔄 Dashboard will auto-refresh every 3 seconds")
    print("⏹️  Press Ctrl+C to stop")
    
    server = HTTPServer(('localhost', 8080), SimuBotDashboard)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 Dashboard stopped")
        server.shutdown()

if __name__ == '__main__':
    start_dashboard() 