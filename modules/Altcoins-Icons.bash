#!/bin/bash

coins-icon() {
    local symbol="$1"
    case $symbol in
        # Céu limpo/Sol
        BTC) echo "" ;;
        ETH) echo "" ;;
        XMR) echo "" ;;

        # Padrão para códigos desconhecidos
        *) echo -n "$symbol" ;;
    esac
}
