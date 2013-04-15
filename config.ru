require "./app_server"

map(AppServer.pinion.mount_point) { run AppServer.pinion }
map("/") { run AppServer }