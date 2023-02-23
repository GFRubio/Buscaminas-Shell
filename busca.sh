# variables
puntuacion=0
a="1 10 -10 -1"
b="-1 0 1"
c="0 1"
d="-1 0 1 -2 -3"
e="1 2 20 21 10 0 -10 -20 -23 -2 -1"
f="1 2 3 35 30 20 22 10 0 -10 -20 -25 -30 -35 -3 -2 -1"
g="1 4 6 9 10 15 20 25 30 -30 -24 -11 -10 -9 -8 -7"
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m" 

declare -a celda

# funciones


quitar(){
  printf '\n\n%s\n\n' "Has seleccionado cerrar el juego!"
  exit 1
}
jugar()
{
  cont=0
  printf "\e[2J\e[H"
  printf '%s' "     a   b   c   d   e   f   g   h   i   j"
  printf '\n   %s\n' "-----------------------------------------"
  for fil in $(seq 0 9); do
    printf '%d  ' "$fil" 
    for col in $(seq 0 9); do
       ((cont+=1))
       celdainvalida $cont
       printf '%s \e[33m%s\e[0m ' "|" "${celda[$cont]}"
    done
    printf '%s\n' "|" 
    printf '   %s\n' "-----------------------------------------"
  done
  printf '\n\n'
}
obtener_celdas()
{
  obtenerceldas=0
  for n in $(seq 1 ${#celda[@]}); do
    if [[ "${celda[$n]}" = "." ]]; then
      ((obtenerceldas+=1))
    fi
  done
}
celda_vacia()
{
  local f=$1
  local val=$2
  incorrecto=0
  if [[ "${celda[$f]}" = "." ]]; then
    celda[$f]=$val
    puntuacion=$((puntuacion+val))
  else
    incorrecto=1
  fi
}
celdainvalida() #
{
  local e=$1  
    if [[ -z "${celda[$e]}" ]];then
      celda[$cont]="."
    fi
}
obtener_minas()
{
  m=$(shuf -e a b c d e f g X -n 1)
  if [[ "$m" != "X" ]]; then
    for limit in ${!m}; do
      campo=$(shuf -i 0-5 -n 1)
      indice=$((i+limit))
      celda_vacia $indice $campo
    done
  elif [[ "$m" = "X" ]]; then
    g=0
    celda[$i]=X
    for j in {42..49}; do
      sal="Has Perdido"
      k=${sal:$g:1}
      celda[$j]=${k^^}
      ((g+=1)) 
    done
  fi
}
obtener_coordenadas()
{
  colm=${opt:0:1}
  ro=${opt:1:1}
  case $colm in
    a ) o=1;;
    b ) o=2;;
    c ) o=3;;
    d ) o=4;;
    e ) o=5;;
    f ) o=6;;
    g ) o=7;;
    h ) o=8;;
    i ) o=9;;
    j ) o=10;;
  esac
  i=$(((ro*10)+o))
  celda_vacia $i $(shuf -i 0-5 -n 1)
  if [[ $incorrecto -eq 1 ]] || [[ ! "$colm" =~ [a-j] ]]; then
    printf "$RED \n%s: %s\n$NC" "Incorrecto" "Introduce otro comando"
  else
    obtener_minas
    jugar
    obtener_celdas
    if [[ "$m" = "X" ]]; then
      printf "\n\n\t $RED%s: $NC %s %d\n" "has perdido" "tu puntuacion" "$puntuacion"
      printf '\n\n\t%s\n\n' "Aun tienes $obtenerceldas celdas"    
 elif [[ $obtenerceldas -eq 0 ]]; then printf "\n\n\t $GREEN%s: %s $NC %d\n\n' "You Win" 
      "tu puntuacion" "$puntuacion exit 0
    fi
  fi
}
# main

echo "Pulsa 1 para acceder al nivel 1 y pulsa 2 para salir del juego"
opciones="1 2"

select opcion in $opciones;
do
if [ $opcion = "1" ]; then
echo "Accediendo al nivel 1"
jugar
while true; do
  printf "Debes ingresar una letra desde la a hasta la j, seguido de un numero del 0 al 9 \n\n"
  read -p "Introduce la coordenada (ej: b1:) " opt
  obtener_coordenadas
done
    elif [ $opcion = "2" ]; then
  exit
    else
   echo "Opcion no permitida"
fi
done 

