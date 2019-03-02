## AUTONOMOUS NODE SYSTEM (ANS) © cryon.io 2019

- modular and transparent
- simple setup and management
- auto updates to both ANS and the node software (speeds up and simplifies node network upgrades)
- health checks with auto-heal to maximize uptime
- simplifies development (devs can target and test specific OS while ANS provides support for main server side OSes)
- security - all modules are audited (does not include audit of node code)

Disclaimer: *ANS does not secure your server/VPS, as we believe that security configurations should be setup-specific, and security for multiple OSes would increase ANS's complexity. All setups provided by ANS are created as a hot-cold wallet scheme - your funds are stored safely on your local computer.*

## Prerequisites 

1. 64-bit installation
2. 3.10 or higher version of the Linux kernel (latest is recommended)

(If you run on VPS provider, which uses OpenVZ, setup requires OpenVZ 7 or newer)

### Supported OS

- Ubuntu 16.04+
- Fedora 26+
- CentOS 7
- Debian 7+

### Supported nodes

Check out wiki for list of [Supported Node Types](https://github.com/cryon-io/ans/wiki/Supported-Node-Types). 

### Contributions

Check out [Contributions Wiki Page](https://github.com/cryon-io/ans/wiki/Contributions)

### Quick Start

Note: *All parameters inside [] has to be submitted without [], e.g. `--user=[user]` as `--user=Johny`*

1. - `git clone "https://github.com/cryon-io/ans.git" [path] && cd [path] && chmod +x ./ans` # replace path with directory you want to store node in
   or 
   - `wget https://github.com/cryon-io/ans/archive/master.zip && unzip -o master.zip && mv ./ans-master [path] && cd [path] && chmod +x ./ans`
2. one of commands below depending of your preference (run as *root* or use *sudo*)
    - `./ans --full --node=[node_type]` # full setup of specific node for current user
    - `./ans --full --user=[user] --node=[node_type] --auto-update-level=[level]` # full setup of specific node for defined user (directory location and structure is preserved), sets specified auto update level (Refer to [Auto updates](https://github.com/cryon-io/ans/wiki/Autoupdates))
    - `./ans --full --user=[user] --node=[node_type] --auto-update-level=[level] -se=ip=[IP address] -se=nodeprivkey=[privkey]`
        * Refer to per coin documentation for usage of env variables and parameters (`-se=*|--set-env=*|-sp=*|--set-parameter=*`)
3. logout, login and check node status
    - `./ans --node-info`
4. Refer to specific node readme for node registration

#### Binding node IP and ports:

- `./ans --bind=[binding]`  #Sets binding for specified port. 
- Example: `--bind=127.0.0.1:3000:30305` # binds port 30305 from node to ip 127.0.0.1 port 3000 on machine