FROM python:3.12-slim
WORKDIR /app
COPY scripts/log_parser.py .
COPY samples/ samples/
ENTRYPOINT ["python", "log_parser.py"]
