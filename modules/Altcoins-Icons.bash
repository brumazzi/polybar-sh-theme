#!/bin/bash

coins-icon() {
    local symbol="$1"
    case $symbol in
        BTC) echo -e "\Ue09b";;
        ETH) echo -e "\Ue178";;
        USDT) echo -e "\Ue54f";;
        XRP) echo -e "\Ue5d5";;
        RVN) echo -e "\Ue45e";;
        MBL) echo -e "\Ue2f2";;

        # Padrão para códigos desconhecidos
        *) echo -n "$symbol" ;;
    esac
}
