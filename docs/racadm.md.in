See [How to access the iDRAC management interface](access.md) before
reading this document.

# The racadm command

The `racadm` command will generally be your interface to remote
management functionality.  For example, to reboot the system:

    racadm serveraction powercycle

Or to get information about various system sensors:

    racadm getsensorinfo

You can get help for all commands by running `racadm help <command>`.
For example:

    racadm help serveraction

You can see the complete list of available `racadm` commands
[here](samples/help.txt).

## Getting system information

Use the `racadm getsysinfo` command to retrieve system summary
information, including MAC addresses and firmware versions:

    /admin1-> racadm getsysinfo

    RAC Information:
    RAC Date/Time           = Wed Jul 25 00:16:35 2018

    Firmware Version        = 2.60.60.60
    Firmware Build          = 52
    Last Firmware Update    = 07/20/2018 16:50:54
    Hardware Version        = 0.01
    MAC Address             = C0:FF:EE:DF:64:D0
    [...]

You can see complete example output [here](samples/sysinfo.txt).

## Power control

The `racadm serveraction` command lets you control server power:

  - `graceshutdown`: perform a graceful shutdown of server
  - `powerdown`: power server off
  - `powerup`: power server on
  - `powercycle`: perform server power cycle
  - `hardreset`: force hard server power reset
  - `powerstatus`: display current power status of server
  - `nmi`: Genarate Non-Masking Interrupt to halt system operation

For example, to power cycle the host:

    /admin1-> racadm serveraction powercycle

## Applying iDRAC firmware updates

You can upgrade the iDRAC firmware using the `racadm fwupdate`
command.  The `fwupdate` command is able to download a firmware update
image from:

- A TFTP server
- An FTP server

You can start an appropriately configured ftp server on `kzn-h` by
running:

    systemctl start pure-ftpd

Place firmware images in the `/srv/firmware` directory.  Assuming
that there exists an iDRAC firmware update image named
`/var/ftp/firmware/firmimg.d7`, the following command can be used to
apply the update:

    racadm fwupdate \
      -f 10.0.0.1 anonymous anon@ \
      -d /firmware/firmimg.d7

This should immediately start the firmware upgrade process, after
which the iDRAC will reboot. The iDRAC firmware upgrade does not
require a host reboot.

In some situations, the iDRAC update fails to start and instead gets
scheduled as a job to be executed in the future (you can see the job
queue by running `racadm jobqueue view`).  This situation typically
requires manual intervention, see [Troubleshooting iDRAC firmware
updates](idrac-troubleshooting.md) for more information.

## Applying BIOS firmware updates

You can apply BIOS updates using the `racadm update` command. The
`update` command is able to download a firmware update image from:

- a CIFS share
- an NFS share

You can start an appropriately configured Samba server on `kzn-h` by
running:

    systemctl start smb

Place firmware images in the `/srv/firmware` directory.  Assuming that
there exists a firmware update named `BIOS_NGYCX_WN64_2.7.0.EXE`, the
following command can be used to apply the update:

    racadm update \
      -f BIOS_NGYCX_WN64_2.7.0.EXE
      -l //10.0.0.1/firmware
      -u guest -p guest

This will schedule a BIOS update job that will execute the next time
the server reboots. You can view the status of the job with the
`racadm jobqueue view` command.  Prior to the reboot you should see:

    /admin1-> racadm jobqueue view
    -------------------------JOB QUEUE------------------------
    [Job ID=JID_466849276889]
    Job Name=Firmware Update: BIOS
    Status=Scheduled
    Start Time=[Next Reboot]
    Expiration Time=[Not Applicable]
    Message=[JCP001: Task successfully scheduled.]
    ----------------------------------------------------------

You can reboot the host by running:

    racadm serveraction powercycle

## Configuring the network

If you have a new iDRAC, or if you use the `racresetcfg` command to
reset the iDRAC back to the default settings, you can still remotely
access it in order to configure the network.

You will need to log into `kzn-h` directly.  Recall that the default
iDRAC address is `192.168.0.120`.  Ensure that `kzn-h` has an address
on the appropriate network; for example:

    ip addr add 192.168.0.1/24 dev enp4s0f1

You can can connect to the iDRAC at the default address:

    ssh root@192.168.0.120

And you can use the `setniccfg` command:

    racadm setniccfg -s 10.0.15.39 255.255.224.0 10.0.0.1

The iDRAC should eventually reboot and start using the new address.
You can force the iDRAC reboot by running `racadm racreset`.
