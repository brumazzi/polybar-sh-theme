#!/bin/bash

ICON_TEMPERATURE=""
ICON_HUMIDITY=""
ICON_VISIBILITY=""

weather-icon() {
    local code="$1"
    case $code in
        # Céu limpo/Sol
        113) echo "" ;;

        # Parcialmente nublado
        116) echo "" ;;

        # Nublado/Encoberto
        119|122) echo "" ;;

        # Névoa/Névoa gelada
        143|185|248|260) echo "" ;;

        # Chuva leve a moderada (garoa, chuvisco, chuva fraca)
        176|263|266|293|296|299|302|353) echo "" ;;

        # Chuva intensa/pesada
        305|308|356|359) echo "" ;;

        # Neve leve a moderada
        179|323|326|329|332|335|338|368|371) echo "" ;;

        # Neve com vento/Blizzard
        227|230) echo "🌨️" ;;

        # Chuva/neve misturada (sleet)
        182|317|320|362|365) echo "🌨️" ;;

        # Chuva/neve congelante
        281|284|311|314) echo "🧊" ;;

        # Granizo/Pelotas de gelo
        350|374|377) echo "🧊" ;;

        # Trovoadas (com chuva ou neve)
        200|386|389|392|395) echo "" ;;

        # Padrão para códigos desconhecidos
        *) echo "" ;;
    esac
}
