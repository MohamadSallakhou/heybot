# Verwende das offizielle Python-Image
FROM python:3.11-slim

# Setze das Arbeitsverzeichnis
WORKDIR /app

# Installiere systemweite Abhängigkeiten
RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installiere Trivy für Sicherheitsprüfungen (optional)
RUN curl -sfL https://github.com/aquasecurity/trivy/releases/download/v0.30.0/trivy_0.30.0_Linux-64bit.deb -o trivy.deb \
    && dpkg -i trivy.deb \
    && rm trivy.deb

# Kopiere die Anwendungsdateien ins Container-Verzeichnis
COPY ./app /app

# Installiere Python-Abhängigkeiten
RUN pip install --no-cache-dir -r requirements.txt

# Starte Trivy-Scan (optional)
RUN trivy fs --format json -o /app/trivy_output.json .

# Starte die Anwendung
CMD ["python", "main.py"]
