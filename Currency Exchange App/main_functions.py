import json
import requests
import streamlit as st

def read_from_file(file_name):
    with open(file_name,"r") as read_file:
        data=json.load(read_file)
        print("You successfully read from {}.".format(file_name))
    return data

def save_to_file(data,file_name):
    with open(file_name,"w") as write_file:
        json.dump(data,write_file,indent=2)
        print("You successfully saved to {}.".format(file_name))

my_key = read_from_file("currency_ExchangeAPI.json")
currency_Exchange_Key = my_key["currency_layer"]


def get_flag_emoji(country_code):
    return ''.join(chr(0x1F1E6 - 65 + ord(char)) for char in country_code.upper())


@st.cache_data
def getListOf_Currencies():
    currency_list = f"https://api.currencylayer.com/list?access_key={currency_Exchange_Key}"
    currency_request = requests.get(currency_list).json()
    currency_dict = currency_request.get('currencies', {})
    #st.write(currency_dict)
    return currency_dict

@st.cache_data
def currencyExchange(currency1, currency2, amount):

    params = (
        ('access_key', currency_Exchange_Key),
        ('from',currency1),
        ('to', currency2),
        ('amount', amount),
    )

    conversion_url = f"https://api.currencylayer.com/convert"
    conversion_dict = requests.get(conversion_url, params=params).json()
    #save_to_file(conversion_dict,"exchange.json")
    #st.write(conversion_dict)
    return conversion_dict



