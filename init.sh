sudo apt update
sudo apt install make gcc libatomic-ops-dev libcurl4-openssl-dev libsqlite3-dev

sudo cp stonky-daemon.service /etc/systemd/system/stonky-backend.service
sudo systemctl daemon-reload
sudo systemctl enable stonky-backend.service
sudo systemctl start stonky-backend.service
sudo systemctl status stonky-backend.service


# show log
# sudo journalctl -u stonky-backend.service -r -n 50
