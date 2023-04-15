# Application stage
FROM nvidia/cuda:12.0.1-cudnn8-runtime-ubuntu22.04

WORKDIR /app

# Install python3 and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3.10-venv git libgl1-mesa-dev libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

# Create a new user
RUN useradd -m webui

# Copy the installed packages from the builder stage
COPY --from=builder --chown=webui:webui /usr/local /usr/local

# Copy the source code and any other necessary files
COPY --chown=webui:webui . .

# Expose the port that the application will run on
EXPOSE 7860

RUN chmod -R 777 .
RUN chown -R webui .

USER webui

RUN python3 -m venv venv
RUN source ./venv/bin/activate
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Set the entrypoint to webui.sh
ENTRYPOINT ["python3", "./launch.py"]
