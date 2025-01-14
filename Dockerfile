FROM python:3.9-alpine3.13
LABEL maintainer="genxi.in"

ENV PYTHONBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user


# # Use a Windows base image with Python pre-installed
# FROM mcr.microsoft.com/windows/servercore:ltsc2022

# LABEL maintainer="genxi.in"

# # Set environment variables
# ENV PYTHONUNBUFFERED=1

# RUN powershell -NoProfile -Command \
#     Set-ExecutionPolicy Bypass -Scope Process -Force; \
#     [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
#     iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# # Install Python using Chocolatey
# RUN choco install python --version=3.9.9 -y && \
#     refreshenv

# # Verify Python installation
# RUN python --version && pip --version

# # Copy files
# COPY .\requirements.txt C:\temp\requirements.txt
# COPY .\app C:\app
# WORKDIR C:\app

# # Expose port
# EXPOSE 8000

# # Install Python and dependencies
# RUN powershell -Command `
#     python -m venv C:\py && `
#     C:\py\Scripts\pip install --upgrade pip && `
#     C:\py\Scripts\pip install -r C:\temp\requirements.txt && `
#     Remove-Item -Recurse -Force C:\temp

# # Add user (Windows version)
# RUN powershell -Command `
#     net user django-user /add && `
#     net localgroup Users django-user /delete && `
#     net localgroup "Remote Desktop Users" django-user /add

# # Update PATH
# ENV PATH="C:\py\Scripts;C:\py;%PATH%"

# # Run as non-admin user
# USER django-user
