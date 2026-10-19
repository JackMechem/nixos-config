{ pkgs, ... }:
{

    services.printing.enable = true;
    services.printing.drivers = [ pkgs.brlaser ];

    services.printing.browsing = true;
    services.printing.browsedConf = ''
    BrowseDNSSDSubTypes _cups,_print
    BrowseLocalProtocols all
    BrowseRemoteProtocols all
    CreateIPPPrinterQueues All

    BrowseProtocols all
        '';
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };

}
