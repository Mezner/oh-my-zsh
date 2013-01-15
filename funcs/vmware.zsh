vmware-player-stop () {
    NET STOP "VMware NAT Service"
    NET STOP VMnetDHCP
    NET STOP VMAuthdService
    NET STOP VMUSBArbService
}

vmware-player-start () {
    NET START "VMware NAT Service"
    NET START VMnetDHCP
    NET START VMAuthdService
    NET START VMUSBArbService
}
