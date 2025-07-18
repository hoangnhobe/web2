FROM python:3.11

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt

EXPOSE 5000
CMD ["python", "app/main.py"]
