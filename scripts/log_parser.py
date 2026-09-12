#!/usr/bin/env python3

"""
log_parser.py - Production log analyser (Python Version)
Usage : python3 log_parser.py <logfile> [--filter LEVEL]
"""

import argparse
import os
import sys
import json
from datetime import datetime


def parse_args():
    parser = argparse.ArgumentParser(description="Analyse DevOps Log files")
    parser.add_argument("logfile", help="Path to log file")
    parser.add_argument(
        "--filter",
        choices=["error", "warn", "alert", "ok", "info", "all"],
        default="all",
        help="Filter by log level (default: all)"
    )
    parser.add_argument(
        "--output",
        choices=["text", "json"],
        default="text",
        help="Output format (default: text)"
    )
    return parser.parse_args()

def read_log(filepath):
    """Read log file and return list of lines."""
    if not os.path.exists(filepath):
        print(f"[ERROR] Log file not found: {filepath}", file=sys.stderr)
        sys.exit(1)

    with open(filepath, "r") as f:
        return f.readlines()

def count_level(lines, level):
    """Count lines mathching a log level."""
    return sum(1 for line in lines if f"[{level.upper()}]" in line)

def filter_lines(lines, level):
    """Return lines matching a log level."""
    if level == "all":
        return lines
    return [line for line in lines if f"[{level.upper()}]" in line]

def build_report(filepath, lines, filter_level):
    """Build a summary report dictionary."""
    return {
        "file": filepath,
        "analysed_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "summary": {
            "total": len(lines),
            "ok": count_level(lines, "ok"),
            "info": count_level(lines, "info"),
            "alert": count_level(lines, "alert"),
            "warn": count_level(lines, "warn"),
            "error": count_level(lines, "error")
        },
        "filter": filter_level,
        "entries": filter_lines(lines, filter_level)
    }

def print_text_report(report):
    """Print report in human readable format"""
    s = report["summary"]
    print("=" * 40)
    print("Log Analysis Report")
    print("=" * 40)
    print(f"File     : {report['file']}")
    print(f"Analysed : {report['analysed_at']}")
    print("-" * 40)
    print(f"Total    : {s['total']}")
    print(f"OK       : {s['ok']}")
    print(f"Info     : {s['info']}")
    print(f"Alerts   : {s['alert']}")
    print(f"Warnings : {s['warn']}")
    print(f"Errors   : {s['error']}")
    print("-" * 40)
    print(f"Filter   : {report['filter'].upper()}")
    print("-" * 40)
    for line in report["entries"]:
        print(line, end="")
    print("=" * 40)

def main():
    args = parse_args()
    lines = read_log(args.logfile)
    report = build_report(args.logfile, lines, args.filter)

    if args.output == 'json':
        print(json.dumps(report, indent=2))
    else:
        print_text_report(report)

if __name__ == "__main__":
    main()