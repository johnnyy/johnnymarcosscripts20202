sed -i '1 s/#!\/bin\/python/#!\/usr\/bin\/python3/' atividade04.py
sed -i 's/nota\|notaFinal/\U&/g' atividade04.py
sed -i '4 iimport time' atividade04.py
sed -i '$a \ \ \ print(time.ctime())' atividade04.py
