import streamlit as st
import pandas
import requests
import snowflake.connector
from urllib.error import URLError
from PIL import Image
st.title('Snowflake Account Info App')

st.markdown("Use this app to quickly see high-level info about your Snowflake account.")

# Set a sidebar and change the color

st.markdown("""
<style>
.css-6qob1r {
    background-color: rgb(222, 224, 251);
}
</style>
    """, unsafe_allow_html=True)

# Add the logo in the sidebar

def add_logo(logo_path, width, height):
    """Read and return a resized logo"""
    logo = Image.open(logo_path)
    modified_logo = logo.resize((width, height))
    return modified_logo

st.sidebar.image(add_logo(logo_path="ff_logo_trans.png", width = 350, height = 280)) 

# Add the selection

sel_choice = st.sidebar.selectbox(
    "Select what account info you would like to see",
    ("None",
     "Shares",
     "Roles",
     "Grants",
     "Users",
     "Warehouses",
     "Databases",
     "Schemas",
     "Tables",
     "Views"     
    )
)

# Create the table base on selection

if sel_choice == "Grants":
    string_choice = "show " + sel_choice + " on account"
else:
    string_choice = "show " + sel_choice + " in account"
 
if sel_choice == "None":
    ""
else:
    my_cnx = snowflake.connector.connect(**st.secrets["snowflake"])
    my_cur = my_cnx.cursor()
    my_cur.execute(string_choice)
    my_data_rows = my_cur.fetchall()
    st.dataframe(my_data_rows)
