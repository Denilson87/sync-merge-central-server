
#baixar do ondedrive
1 9 * * * /usr/bin/rclone sync assiduidade:RelatorioAssiduidade /srv/assiduidade --log-file=/srv/scripts/rclone.log --log-level=INFO

#Executar o script
2 9 * * * /usr/bin/Rscript /srv/scripts/atualizar_master.R >> /srv/scripts/rscript.log 2>&1
#5 1 * * * /usr/bin/Rscript /srv/scripts/atualizar_master.R >> /srv/scripts/rscript.log 2>&1

#para enviar ao onde drive
4 9 * * * /usr/bin/rclone copy /srv/assiduidade/efectividade-us/efectividade-maputo-cidade.xlsx assiduidade:RelatorioAssiduidade/efectividade-us --log-file=/srv/scripts/rclone.log --log-level=INFO

