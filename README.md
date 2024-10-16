# Laravel Docker Compose

Docker Compose setup for Laravel applications.

## Overview

This project provides a Dockerized environment for Laravel applications, simplifying the setup and management of the necessary services.

## Getting Started

### Step 1: Environment Configuration

1. **Copy the Environment File**:
   - Create a copy of the `.env.example` file and rename it to `.env`. This file will contain your environment variable configurations.

2. **Persisted Configuration**:
   - The `.env.lock` file is already present to lock any configurations that need to be persisted consistently.

3. **Secrets Configuration**:
   - Create `mysql_root_password.txt` and `mysql_password.txt` files under the `secrets` folder for the MySQL root user and the MySQL user defined in your `.env` file.

   - Create `mariadb_root_password.txt` and `mariadb_password.txt` files under the `secrets` folder for the MariaDB root user and the MariaDB user defined in your `.env` file.

### Step 2: Convenience Script

For convenience, a script named `dc` is included. You can run the following command to set up the environment variables with default values, and you can modify them later:

```bash
. dc set
```

### Step 3: Configuration Files

You can find the configuration files for each service under the `conf.d` folder. Additionally, there is a `configure.sh` file in each service's folder for any runtime container adjustments that may be required.

### Step 4: Start the Containers

To set up and start the containers, run the following command, ensuring to pass both environment files:

```bash
docker-compose --env-file .env --env-file .env.lock up
```

Alternatively, you can use the convenience script to run the containers:

```bash
. dc up
```

### Additional Commands

The `dc` script accepts all parameters that the Docker Compose command accepts. You can use it as a base for your Docker commands. For example, to build without cache, use:

```bash
. dc build --no-cache
```

## Conclusion

This Docker Compose setup for Laravel simplifies the process of managing Laravel applications. By following the outlined steps, you can efficiently establish your environment and ensure that all necessary services are correctly configured.