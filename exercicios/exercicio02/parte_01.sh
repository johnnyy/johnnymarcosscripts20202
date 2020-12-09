# Correção: 0,75. Veja observação nos arquivos.

grep -E "[0-9]+ A" emailsordenados.txt
# Você deveria ter utilizado o marcador \b para indicar a busca no início das palavras. 
grep -E " A" emailsordenados.txt
grep -E ".br$" emailsordenados.txt 
grep -E " [^A-Z].*[1-9]+.*@" emailsordenados.txt
