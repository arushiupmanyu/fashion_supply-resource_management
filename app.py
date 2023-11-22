import streamlit as st
import pandas as pd
import mysql.connector
from mysql.connector import connect, Error
from PIL import Image
import io

# Function to establish a connection to the MySQL database
def create_connection():
    return connect(
        host="localhost",
        port=3306,
        user="root",
        password="vflute123!",
        database="fashion_supply_resource_management",
        auth_plugin='sha256_password'
    )

# Function to execute SQL queries
def execute_query(conn, query, data=None):
    try:
        with conn.cursor() as cursor:
            if data:
                cursor.execute(query, data)
            else:
                cursor.execute(query)
        conn.commit()
        return True
    except Error as e:
        st.error(f"Error: {e}")
        conn.rollback()
        return False

# Function to fetch data from the database
def fetch_data(conn, query):
    with conn.cursor() as cursor:
        cursor.execute(query)
        return cursor.fetchall(), [desc[0] for desc in cursor.description]

# Function to display data in a table
def display_table(conn, table_name):
    query = f"SELECT * FROM {table_name};"
    result, columns = fetch_data(conn, query)
    st.table(pd.DataFrame(result, columns=columns))

# Function to add material for suppliers and manufacturers
def add_material(conn, supplier_id, manufacturer_id, material_id, quantity):
    query = "INSERT INTO materials(supplier_id, manufacturer_id, material_id, quantity) VALUES (%s, %s, %s, %s);"
    data = (supplier_id, manufacturer_id, material_id, quantity)
    execute_query(conn, query, data)
    st.success("Material added successfully!")

# Function to update material quantity for suppliers and manufacturers
def update_quantity(conn, supplier_id, manufacturer_id, material_id, new_quantity):
    query = "UPDATE materials SET quantity = %s WHERE supplier_id = %s AND manufacturer_id = %s AND material_id = %s;"
    data = (new_quantity, supplier_id, manufacturer_id, material_id)
    execute_query(conn, query, data)
    st.success("Quantity updated successfully!")

# Function to delete material for suppliers and manufacturers
def delete_material(conn, supplier_id, manufacturer_id, material_id):
    query = "DELETE FROM materials WHERE supplier_id = %s AND manufacturer_id = %s AND material_id = %s;"
    data = (supplier_id, manufacturer_id, material_id)
    execute_query(conn, query, data)
    st.success("Material deleted successfully!")

# Function to upload custom design prints for designers
def upload_design(conn, designer_id, design_name, image):
    query = "INSERT INTO designs(designer_id, name, image) VALUES (%s, %s, %s);"
    data = (designer_id, design_name, image)
    execute_query(conn, query, data)
    st.success("Design uploaded successfully!")

# Function to track orders for logistics
def track_orders(conn):
    display_table(conn, "logistics")

# Streamlit App
st.title("Fashion Supply Resource Management App")

# Create a connection
conn = create_connection()

# Select user role
user_role = st.radio("Select User Role:", ("Supplier", "Manufacturer", "Designer", "Logistics"))

if user_role == "Supplier" or user_role == "Manufacturer":
    st.header(f"{user_role} Operations")

    # Get user input
    supplier_id = st.number_input("Enter Supplier ID:", min_value=1, key="supplier_id")
    manufacturer_id = st.number_input("Enter Manufacturer ID:", min_value=1, key="manufacturer_id")
    material_id = st.number_input("Enter Material ID:", min_value=1, key="material_id")
    quantity = st.number_input("Enter Quantity:", min_value=1, key="quantity")

    # Select operation
    operation = st.radio("Select Operation:", ("Add Material", "Update Quantity", "Delete Material"))

    if operation == "Add Material":
        add_material(conn, supplier_id, manufacturer_id, material_id, quantity)
    elif operation == "Update Quantity":
        new_quantity = st.number_input("Enter New Quantity:", min_value=1, key="new_quantity")
        update_quantity(conn, supplier_id, manufacturer_id, material_id, new_quantity)
    elif operation == "Delete Material":
        delete_material(conn, supplier_id, manufacturer_id, material_id)

elif user_role == "Designer":
    st.header("Designer Operations")

    # Get user input
    designer_id = st.number_input("Enter Designer ID:", min_value=1, key="designer_id")
    design_name = st.text_input("Enter Design Name:", key="design_name")
    image = st.file_uploader("Upload PNG Image for Design:", type=["png"])

    if st.button("Upload Design"):
        if image is not None:
            # Convert the uploaded image to bytes
            image_bytes = io.BytesIO(image.read())
            # Display the uploaded image
            st.image(Image.open(image_bytes), caption=f"Uploaded Image for {design_name}", use_column_width=True)
            # Save the image to the database
            upload_design(conn, designer_id, design_name, image_bytes.getvalue())
        else:
            st.warning("Please upload a PNG image.")

elif user_role == "Logistics":
    st.header("Logistics Operations")

    # Select operation
    operation = st.radio("Select Operation:", ("Track Orders",))

    if operation == "Track Orders":
        track_orders(conn)

# Close the connection when done
conn.close()
