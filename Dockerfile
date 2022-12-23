# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.11.1-bullseye AS compile-image

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install pip requirements
COPY requirements.txt .

RUN python -m pip install --user -r requirements.txt --no-warn-script-location

FROM python:3.11.1-slim-bullseye as build-image
WORKDIR /app
COPY --from=compile-image /root/.local /app/.local

COPY . /app

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN useradd -d /app appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["python", "retriever.py"]
