from flask import Flask, request, jsonify
import mysql.connector
import os

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASS", "123456"),
        database=os.getenv("DB_NAME", "ecommerce")
    )

@app.route('/')
def home():
    return 'Web bán hàng chạy OK!'

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", (data['username'], data['password']))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    if user:
        return jsonify({"message": "Đăng nhập thành công"})
    else:
        return jsonify({"message": "Sai tài khoản hoặc mật khẩu"}), 401

@app.route('/buy', methods=['POST'])
def buy():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO orders (username, product_id) VALUES (%s, %s)", (data['username'], data['product_id']))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Mua hàng thành công!"})

@app.route('/cancel', methods=['POST'])
def cancel():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM orders WHERE id = %s", (data['order_id'],))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({"message": "Huỷ đơn hàng thành công!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
