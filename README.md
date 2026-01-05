### sync-merge-central-server

The sync-merge-central-server process is responsible for synchronizing and consolidating data on the central server. All automation scripts are located in /srv/scripts, including atualizar_master.R, which handles the master data update, along with log files such as rclone.log and rscript.log for synchronization and execution tracking. The operational data directories are stored under /srv/assiduidade, organized by site/location (e.g. cs_chamanculo, cs_inhagoia, cs_zimpeto, cs_mavalane, among others), as well as aggregated folders like efectividade-us and Maputo. This structure ensures consistent data synchronization, merging, and centralized management across all collection points.

### file location in the server

denilson@MEAPUBSRVR:/srv/scripts$
atualizar_master.R  rclone.log  rscript.log
denilson@MEAPUBSRVR:/srv/scripts$ 

