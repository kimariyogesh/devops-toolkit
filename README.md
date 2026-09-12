# DevOps Automation Toolkit

A collection of Bash and Python scripts for common DevOps tasks —
disk monitoring, log analysis, and system health checks.

Built as part of a structured DevOps learning journey.

---

## Tools

### 1. Disk Alert Monitor (`scripts/disk_alert.sh`)
Monitors disk usage across mount points and alerts when usage
exceeds a configurable threshold. Logs all results with timestamps.

**Usage:**
```bash
./scripts/disk_alert.sh [threshold]
```

**Examples:**
```bash
./scripts/disk_alert.sh        # uses default threshold of 80%
./scripts/disk_alert.sh 5      # alert if disk exceeds 5%
```

**Sample output:**

---

### 2. Log Parser — Bash (`scripts/log_parser.sh`)
Parses structured log files and generates summary reports.
Supports filtering by log level.

**Usage:**
```bash
./scripts/log_parser.sh <logfile> [filter]
```

**Examples:**
```bash
./scripts/log_parser.sh samples/sample.log
./scripts/log_parser.sh samples/sample.log alert
./scripts/log_parser.sh samples/sample.log error
```

---

### 3. Log Parser — Python (`scripts/log_parser.py`)
Python version of the log parser with additional features:
JSON output support and named CLI arguments.

**Usage:**
```bash
python3 scripts/log_parser.py <logfile> [--filter LEVEL] [--output FORMAT]
```

**Examples:**
```bash
python3 scripts/log_parser.py samples/sample.log
python3 scripts/log_parser.py samples/sample.log --filter alert
python3 scripts/log_parser.py samples/sample.log --output json
```

---

## Setup

No dependencies required for Bash scripts.

Python version requires Python 3.6+:
```bash
python3 --version
```

Clone the repo:
```bash
git clone git@github.com:YOUR_USERNAME/devops-toolkit.git
cd devops-toolkit
chmod +x scripts/*.sh
```

---

## Skills demonstrated

- Bash scripting with error handling (`set -euo pipefail`)
- Python scripting with argparse, os, subprocess, json
- Structured logging with timestamps and log levels
- Input validation and graceful error handling
- Git version control and project documentation
