FROM continuumio/miniconda3

# Update packages and install nano and curl
RUN apt-get update -y 
RUN apt-get install nano curl -y

# THIS IS SPECIFIC TO HUGGINFACE
# We create a new user named "user" with ID of 1000
RUN useradd -m -u 1000 user
# We switch from "root" to "user" 
USER user

# We set two environment variables
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# We set working directory to $HOME/app (<=> /home/user/app)
WORKDIR $HOME/app

# Copy all local files to /home/user/app with "user" as owner of these files
# Always use --chown=user when using HUGGINGFACE to avoid permission errors
COPY --chown=user . $HOME/app

# Install all dependencies
# Set up packet managing
RUN pip install -v --no-cache-dir --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --prefer-binary

EXPOSE $PORT
# Run FastAPI

CMD uvicorn app:app --host 0.0.0.0 --port $PORT
#CMD fastapi run app.py --port $PORT