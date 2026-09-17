import hashlib
import re
import pyodbc

server = "127.0.0.1"
database = "ACCOUNT_DBF"
username_db = "sa"
password_db = "flyff"
salt = "kikugalanet"

# Requires the Microsoft ODBC Driver for SQL Server installed locally
conn_str = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username_db};PWD={password_db}"
conn = pyodbc.connect(conn_str)
cursor = conn.cursor()


def clean_input(text):
  return re.sub(r"[^\w]", "", text).lower()


def create_test_account(username, raw_password, email):
  username = clean_input(username)
  password = clean_input(raw_password)

  # Exact same hashing logic used by the MMO database
  password_hashed = hashlib.md5((salt + password).encode("utf-8")).hexdigest()

  # Check if username exists
  cursor.execute(
      "SELECT COUNT(*) FROM dbo.ACCOUNT_TBL WHERE account = ?", username
  )
  if cursor.fetchone()[0] > 0:
    print(f"Error: Username '{username}' already exists.")
    return

  # Call the stored procedure
  cursor.execute(
      "EXEC dbo.usp_CreateNewAccount @account = ?, @pw = ?, @email = ?",
      (username, password_hashed, email),
  )
  conn.commit()
  print(f"Successfully created test account: {username}")


# Quick local test execution
create_test_account("test1", "test1", "test@local.dev")
