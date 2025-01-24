# Automate-Services-Runner

Automate Services Runner is a PowerShell script designed to streamline the management of Django microservices in a microservice architecture. Instead of running each service individually, this script automates the process of starting or stopping all services at once, making development and testing more efficient.

# Features
Start all Django microservices simultaneously.
Stop all running services cleanly.
Logs the status of each service for easy monitoring.


# Installation and Setup

1. Clone the repository
2. Navigate to the directory containing the script:
    cd <YOUR_PROJECT_ROOT_PATH>\<FOLDER_NAME>
3.Update the script with the root path and folder name in place of <YOUR_PROJECT_ROOT_PATH> and <FOLDER_NAME>.
4.Ensure all microservice directories and the shared venv directory are correctly configured within the script.

# Usage

1. Start Services
    .\start_services.ps1 start
2. Stop Services
   .\start_services.ps1 stop

![image](https://github.com/user-attachments/assets/cee1a184-e7de-4af4-bce3-be6f5c81f75f)
![image](https://github.com/user-attachments/assets/70c6b901-c255-400a-8da2-b2e1e12736e6)





# Testing

After starting the services, test them by visiting the localhost URL with the assigned ports:

http://127.0.0.1:8000 

http://127.0.0.1:8001
