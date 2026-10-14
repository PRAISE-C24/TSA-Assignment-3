# Bash DevOps CLI Tool & Local CI/CD Pipeline

A lightweight, robust, Bash-based command-line toolkit for system diagnostics, network connectivity checks, and containerized operations. The project includes automated testing, Docker integration, static code validation, and a GitHub Actions CI pipeline.

## Features

The core application, `app/app.sh`, provides the following subcommands:

| Command | Description |
|---|---|
| `system-info` | Displays runtime system information, including hostname, current user, kernel version, and uptime. |
| `check-host <host>` | Resolves a target hostname and checks its reachability. |
| `check-port <host> <port>` | Validates the port range (`1–65535`) and checks TCP connectivity to the target host and port. |
| `help` | Displays the application's usage instructions. |

**Error handling:** Invalid subcommands, missing arguments, and out-of-range port values exit with status code `2`.

## Project Structure

```text
.
├── app/
│   └── app.sh                 # Core CLI application
├── tests/
│   └── test.sh                # Automated test suite (8 tests)
├── scripts/
│   └── build.sh               # Docker build and smoke tests
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions CI pipeline
├── Dockerfile                 # Docker image definition
├── .dockerignore              # Docker build exclusions
├── .gitignore                 # Git exclusions
├── lint.sh                    # Static analysis and syntax validation
└── README.md                  # Project documentation
```

## Prerequisites

Ensure the following tools are installed:

- Bash
- Git
- Docker
- ShellCheck, if required by the linting script
- GitHub account, for running the CI pipeline through GitHub Actions

## Getting Started

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd <your-repository-directory>
```

Replace the placeholders with your actual repository URL and directory name.

### 2. Grant Execution Permissions

Make the application and supporting scripts executable:

```bash
chmod +x app/app.sh lint.sh tests/test.sh scripts/build.sh
```

### 3. Run the Application

Display the help menu:

```bash
./app/app.sh help
```

Display system information:

```bash
./app/app.sh system-info
```

Check hostname resolution and reachability:

```bash
./app/app.sh check-host localhost
```

Check TCP connectivity to port 80:

```bash
./app/app.sh check-port localhost 80
```

**Note:** A host being reachable does not necessarily mean a particular TCP port is open. The target service must be listening, and network rules must permit the connection.

## Development and Testing

### 1. Run Static Analysis

Execute the linting and syntax-validation script:

```bash
./lint.sh
```

This validates the shell scripts for syntax errors and performs the static checks configured in the project.

### 2. Run Automated Tests

Execute the test suite:

```bash
./tests/test.sh
```

The eight tests cover application behavior and edge cases, including:

- Help output
- System information
- Invalid subcommands
- Missing arguments
- Port-range validation

### 3. Build and Smoke-Test the Docker Image

Run the build script:

```bash
./scripts/build.sh
```

This script builds the Docker image named `devops-tool` and runs smoke tests to verify basic containerized application behavior, including invalid-command exit codes.

## Docker Usage

Build the image manually:

```bash
docker build -t devops-tool .
```

Run the application inside a container:

```bash
docker run --rm devops-tool help
```

Display system information from the container:

```bash
docker run --rm devops-tool system-info
```

Check a host from the container:

```bash
docker run --rm devops-tool check-host example.com
```

Check TCP connectivity from the container:

```bash
docker run --rm devops-tool check-port example.com 443
```

Network checks run from inside the container's network environment, which may differ from the host machine.

## Continuous Integration with GitHub Actions

The project uses GitHub Actions to automate validation, testing, and Docker build verification.

**Workflow file:** `.github/workflows/ci.yml`

The workflow runs automatically on:

- Pushes to the repository
- Pull requests
- Manual execution using `workflow_dispatch`

### CI Pipeline Stages

The pipeline executes three stages sequentially:

1. **Validate** — Runs `lint.sh` to perform static analysis and shell syntax checks.
2. **Test** — Runs `tests/test.sh` to verify application behavior and edge cases.
3. **Docker** — Runs `scripts/build.sh` to build the container image and execute smoke tests.

The later stages depend on the successful completion of earlier stages, helping prevent invalid code from progressing through the pipeline.

## Error Handling and Exit Codes

The application uses exit codes to communicate command outcomes.

| Exit code | Meaning |
|---|---|
| `0` | Command completed successfully. |
| `2` | Invalid subcommand, missing required arguments, or invalid port range. |

Other failures, such as hostname resolution errors or unsuccessful network connections, should follow the exit-code behavior implemented in the application.

## Skills Demonstrated

This project demonstrates practical DevOps fundamentals:

- Bash scripting and command-line interface design
- Input validation and exit-code handling
- Linux system diagnostics
- DNS resolution and TCP connectivity checks
- Automated testing and edge-case validation
- Shell linting and syntax validation
- Docker image creation and container execution
- Git-based version control
- GitHub Actions continuous integration
- Sequential CI pipeline design
- Smoke testing and basic automation

## Future Improvements

Potential enhancements include:

- Add command-line options for timeouts and verbose output.
- Expand test coverage for DNS failures and TCP connection failures.
- Add structured logging and improved error messages.
- Publish versioned Docker images to a container registry.
- Add release automation and image vulnerability scanning.
- Extend CI to test supported Bash versions.

## License

No license has been specified yet. Add a `LICENSE` file and identify the chosen license before distributing the project for reuse.

---

**Project:** Bash DevOps CLI Tool & Local CI/CD Pipeline  
**Purpose:** Practice building, testing, containerizing, and validating a Bash application through an automated CI workflow.
