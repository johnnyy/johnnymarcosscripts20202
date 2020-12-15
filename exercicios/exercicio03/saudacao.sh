#!/bin/bash

echo -e  $"Olá $(who | cut -d' ' -f1), \nHoje é dia $(date +%d), do mês $(date +%m) do ano de $(date +%G)." | tee -a saudacao.log
