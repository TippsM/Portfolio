from datetime import datetime
import streamlit as st
import main_functions
#import plotly.express as px
#import pandas as pd


currencies = main_functions.getListOf_Currencies()
list_of_currencies=['']

for i in currencies:
    list_of_currencies.append(i)


st.title("Welcome to Currency Converter")
st.sidebar.write("Currency Converter")

currency_options = [f"{code} - {name}" for code, name in currencies.items()]

amount = st.sidebar.text_input("Insert an amount")
option1 = st.sidebar.selectbox("Select a currency", options=currency_options)
option2 = st.sidebar.selectbox("Select another currency", options=currency_options)

currency1 = option1.split(" - ")[0]
currency2 = option2.split(" - ")[0]

submit = st.sidebar.button("Submit")
if submit:
    conversion = main_functions.currencyExchange(currency1,currency2,amount)

    if conversion['success']:
        st.sidebar.success("Success!")
        results = conversion['result']
        timestamp = conversion['info']['timestamp']
        quote = conversion['info']['quote']
        date_time = datetime.fromtimestamp(timestamp)
        date = date_time.date()
        st.subheader(f":green[{amount} ] {currency1} equals :green[{results}] {currency2}\n:green[{date}]")
        # df = pd.DataFrame(quote)
        # current_rate_chart = px.line(df, x=df['quote'], y=df['date'])

    else:
        st.sidebar.error("Something went wrong!")
        st.sidebar.write("Error Code: ",conversion['error']['code'])



