#!/bin/bash

echo -e  $"Olá $(whoami), \nHoje é dia $(date +%d), do mês $(date +%m) do ano de $(date +%G)." | tee -a saudacao.log
