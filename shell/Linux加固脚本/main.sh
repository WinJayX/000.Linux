#!/bin/bash
#Version internal-v1222
#By Security@CloudBU
suse='/etc/suseRegister.conf'
rh='/etc/redhat-release'
unbuntu=''
restart_flag=1
ostype='unknow'
if [ -f /etc/susRegister.conf ];then
    ostype='suse'
elif [ -f /etc/SuSE-release ];then
    ostype='suse'
fi
#elif [ -f /etc/centos-release ];then
#   grep -i 'centos' /etc/centos-release > /dev/null
#    if [ $? == 0 ];then
#        ostype='centos'
#    fi
#elif [ -f /etc/fedora-release ];then
#    grep -i 'fedora' /etc/fedora-release > /dev/null
#    if [ $? == 0 ];then
#        ostype='fedora'
#    fi
#elif [-f /etc/euleros-release ];then
#    ostype='euleros'
if [ -f /etc/issue ];then
    grep -i 'ubuntu' /etc/issue > /dev/null
    if [ $? == 0 ];then
        ostype='debian/ubuntu'
    fi
    grep -i 'debian' /etc/issue > /dev/null
    if [ $? == 0 ];then
        ostype='debian/ubuntu'
    fi
fi
if [ -f /etc/redhat-release ];then
    grep -i 'centos' /etc/redhat-release > /dev/null
    if [ $? == 0 ];then
        ostype='centos'
    fi
    grep -i 'fedora' /etc/redhat-release > /dev/null
    if [ $? == 0 ];then
        ostype='fedora'
    fi
    grep -i 'euleros' /etc/redhat-release > /dev/null
    if [ $? == 0 ];then
        ostype='euleros'
    fi
    grep -i 'redhat' /etc/redhat-release > /dev/null
    if [ $? == 0 ];then
        ostype='redhat'
    fi
fi
if [ -f /etc/centos-release ];then
    grep -i 'centos' /etc/centos-release > /dev/null
    if [ $? == 0 ];then
        ostype='centos'
    fi
    grep -i 'euleros' /etc/centos-release > /dev/null
    if [ $? == 0 ];then
        ostype='euleros'
    fi
fi
if [ -f /etc/fedora-release ];then
    grep -i 'fedora' /etc/fedora-release > /dev/null
    if [ $? == 0 ];then
        ostype='fedora'
    fi
fi
if [ -f /etc/euleros-release ];then
    ostype='euleros'
fi
if [ -f /etc/os-release ];then
    grep -i 'coreos' /etc/os-release > /dev/null
    if [ $? == 0 ];then
        ostype='coreos'
    fi
fi
echo "OS type is $ostype"

function backup(){
if [ ! -x "backup" ]; then 
    mkdir backup
    if [ -f "/etc/pam.d/system-auth" ];then
        cp /etc/pam.d/system-auth backup/system-auth.bak
    elif [ -f /etc/pam.d/common-password ];then
        cp /etc/pam.d/common-password backup/common-password.bak
    fi
    if [ -f ~/.ssh/authorized_keys ];then
        cp ~/.ssh/authorized_keys backup/authorized_keys.bak
    fi
    cp /etc/ssh/sshd_config backup/sshd_config.bak
    cp /etc/profile backup/profile.bak
    cp /etc/pam.d/su backup/su.bak
    echo "Auto backup successfully"
else
    echo "Backup file already exist, to avoid overwriting these files, backup will not perform again "
fi
}
backup

function recover(){
if [ -f "backup/system-auth.bak" ];then
    cp backup/system-auth.bak /etc/pam.d/system-auth
elif [ -f backup/common-password.bak ];then
    cp backup/common-password.bak /etc/pam.d/common-password
fi
if [ -f backup/authorized_keys.bak ];then
    cp backup/authorized_keys.bak ~/.ssh/authorized_keys
fi
cp backup/sshd_config.bak /etc/ssh/sshd_config
cp backup/profile.bak /etc/profile
source /etc/profile
cp backup/su.bak /etc/pam.d/su
restart_flag=0
echo "Recover success"
}


function password(){
echo '#############################################################################################################'
echo 'set password complexity requirements'
grep -i '^PasswordAuthentication no' /etc/ssh/sshd_config > /dev/null
noPwd=$?
if [ -f /etc/pam.d/system-auth ];then
    config="/etc/pam.d/system-auth"
elif [ -f /etc/pam.d/common-password ];then 
    config="/etc/pam.d/common-password"
    dpkg -l|grep libpam-cracklib > /dev/null
    if [ $? == 1 ];then
        echo "Missing libpam-cracklib, please install it first. Please try to use this tool after installing."
        exit
    fi
else
    echo "Doesn't support this OS"
    return 1
fi
if [ $noPwd != 0 ];then
#    grep -i "^password.*requisite.*pam_cracklib.so" $config  > /dev/null #/etc/pam.d/system-auth
#    if [ $? == 0 ];then
#        sed -i "s/^password.*requisite.*pam_cracklib.so.*$/password requisite pam_cracklib.so retry=5 difok=3 minlen=12 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1/g" $config
#    else
#        echo 'password	 requisite	 pam_cracklib.so retry=5 difok=3 minlen=12 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1' >> $config
#    fi
    grep -i "^password.*requisite.*pam_cracklib.so" $config  > /dev/null #/etc/pam.d/system-auth
    if [ $? == 0 ];then
        sed -i "s/^password.*requisite.*pam_cracklib\.so.*$/password    requisite       pam_cracklib.so retry=5 difok=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/g" $config
    else
        grep -i "pam_pwquality\.so" $config > /dev/null
        if [ $? == 0 ];then
            sed -i "s/password.*requisite.*pam_pwquality\.so.*$/password     requisite       pam_pwquality.so retry=5 difok=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/g" $config
        else
            echo 'password      requisite       pam_cracklib.so retry=5 difok=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1' >> $config
        fi

    fi

    if [ $? == 0 ];then
        echo '[success]'
    fi
else
    echo "PasswordAuthentication is disbled, no need to set the password complexity."
fi
}


function remote_login(){
    echo '#############################################################################################################'
    echo 'set remote user login'
    #set Protocol 2
    echo >> /etc/ssh/sshd_config
    grep -i '^Protocol' /etc/ssh/sshd_config > /dev/null
    if [ $? == 0 ];then
        sed -i 's/^Protocol.*$/Protocol 2/g' /etc/ssh/sshd_config
        if [ $? != 0 ];then
            echo "[##Error##]: Cannot to set Protocol to '2'"
        else
            echo '[Success: Set SSH Protocol to 2]'
         fi
    else
        echo 'Protocol 2' >> /etc/ssh/sshd_config
        echo '[Success: Set SSH Protocol to 2]'
    fi

    read -p "disable root remote login?[y/n](Please make sure you have created at least one another account):"
    case $REPLY in
    y)
        grep -i '^PermitRootLogin' /etc/ssh/sshd_config >/dev/null
        if [ $? == 0 ];then
            sed -i 's/^PermitRootLogin.*$/PermitRootLogin no/g' /etc/ssh/sshd_config
            if [ $? != 0 ];then
                echo "[##Error##]cannot to set PermitRootLogin to 'no'"
            else
                echo '[success]'
                restart_flag=0
            fi
        else
            echo 'PermitRootLogin no' >> /etc/ssh/sshd_config
            echo '[success]'
            restart_flag=0
        fi;;
    n)
        ;;
    *)
        remote_login;;
    esac
}
function max_tries(){
    read -p 'set max login tries?[y/n]:'
    case $REPLY in
    y)
        read -p 'please input the max login tires(recommend to 3-10):' tries
        if [ "$tries" -ge 3 -a "$tries" -le 10 ] 2>/dev/null;then            
            grep -i "^MaxAuthTries " /etc/ssh/sshd_config > /dev/null
            if [ $? == 0 ];then
                sed -i "s/^MaxAuthTries.*$/MaxAuthTries $tries/g" /etc/ssh/sshd_config
            else
                echo "MaxAuthTries $tries" >> /etc/ssh/sshd_config
            fi
            echo '[success]';
            restart_flag=0
        else
            echo "[##error##]:invalid input"
            max_tries
        fi
        ;;
    n)
        ;;
    *)
        max_tries;;
    esac
}

function allow_users(){
    read -p 'set allow users?[y/n]:'
    case $REPLY in
    y)
        #echo >> /etc/ssh/sshd_config
        echo -e "Currentlly AllowUsers is:"
        grep -i "^AllowUsers" /etc/ssh/sshd_config
        read -p 'please input allow users,for example: test1 test2 test3, it will overwrite the current configuration :' users
        grep -i "^AllowUsers" /etc/ssh/sshd_config >/dev/null
        if [ $? == 0 ];then
            sed -i "s/^AllowUsers.*$/AllowUsers $users/g" /etc/ssh/sshd_config
        else
            echo "AllowUsers $users" >> /etc/ssh/sshd_config
        fi
        echo "[success]"
        restart_flag=0;;
    n);;
    *)
        allow_users;;
    esac
}

function set_history_tmout(){
echo '##############################################################################################################'
echo 'set history'
    read -p "set history size, format, and TMOUT?[y/n]:"
    case $REPLY in
    y)
        grep -i "^HISTSIZE=" /etc/profile >/dev/null
        if [ $? == 0 ];then
            sed -i "s/^HISTSIZE=.*$/HISTSIZE=1000/g" /etc/profile
        else
            echo 'HISTSIZE=1000' >> /etc/profile
        fi
        echo "HISTSIZE has been set to 1000"
        grep -i "^export HISTTIMEFORMAT=" /etc/profile > /dev/null
        if [ $? == 0 ];then
            sed -i 's/^export HISTTIMEFORMAT=.*$/export HISTTIMEFORMAT="%F %T `whoami`"/g' /etc/profile
        else
            echo 'export HISTTIMEFORMAT="%F %T `whoami` "' >> /etc/profile 
        fi
        echo 'HISTTIMEFORMAT has been set to "%F %T `whoami`"'
        read -p "set shell TMOUT?[300-600]seconds:" tmout
        grep -i "^TMOUT=" /etc/profile> /dev/null
        if [ $? == 0 ];then
            sed -i "s/^TMOUT=.*$/TMOUT=$tmout/g" /etc/profile
        else
            echo "TMOUT=$tmout" >> /etc/profile
        fi
        source /etc/profile
        echo '[success]'
        ;;
    n)  
        ;;
    *)       
        set_history_tmout;;
    esac
    }

function login_key(){
    echo '##############################################################################################################'
    echo 'set login key'
    read -p "set login key?[y/n]"
    case $REPLY in
    y)
        echo >> ~/.ssh/authorized_keys
        echo >> /etc/ssh/sshd_config
        read -p "Please input the directory of the public key file(such as /root/id_rsa.pub): " dir
        if [ -f "${dir}" ];then
            cat "$dir" >> ~/.ssh/authorized_keys 
            if [ $? == 0 ];then
                #Set password login disabled : PasswordAuthentication & ChallengeResponseAuthentication
                grep -i "^PasswordAuthentication " /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^PasswordAuthentication.*$/PasswordAuthentication no/g" /etc/ssh/sshd_config
                else
                    echo "PasswordAuthentication no">> /etc/ssh/sshd_config
                fi
                grep -i "^ChallengeResponseAuthentication " /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^ChallengeResponseAuthentication .*$/ChallengeResponseAuthentication no/g" /etc/ssh/sshd_config
                else
                    echo "ChallengeResponseAuthentication no">> /etc/ssh/sshd_config
                fi
                #Set key login enabled
                grep -i "^RSAAuthentication " /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^RSAAuthentication .*$/RSAAuthentication yes/g" /etc/ssh/sshd_config
                else
                    echo "RSAAuthentication yes">> /etc/ssh/sshd_config
                fi
                grep -i "^PubkeyAuthentication " /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^PubkeyAuthentication .*$/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
                else
                    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
                fi
                #set AuthorizedKeysFile .ssh/authorized_keys
                grep -i "^AuthorizedKeysFile" /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^AuthorizedKeysFile.*$/AuthorizedKeysFile .ssh\/authorized_keys/g" /etc/ssh/sshd_config
                    if [ $? != 0 ];then
                        echo "[##Error##]cannot to set AuthorizedKeysFile .ssh/authorized_keys"
                    fi
                else
                    echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config
                fi
                #set PermitRootLogin to yes
                grep -i "^PermitRootLogin" /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^PermitRootLogin.*$/PermitRootLogin yes/g" /etc/ssh/sshd_config
                    if [ $? != 0 ];then
                        echo "[##Error##]cannot to set PermitRootLogin to 'yes'"
                    fi
                else
                    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
                fi
                #set AllowUsers marked
                grep -i "^AllowUsers" /etc/ssh/sshd_config > /dev/null
                if [ $? == 0 ];then
                    sed -i "s/^AllowUsers.*$/#AllowUsers /g" /etc/ssh/sshd_config
                #else
                    #echo "AllowUsers root" >> /etc/ssh/sshd_config
                fi

                echo "[Success: you can login using Root with the right private key after restarting SSH service]"
                restart_flag=0
            else 
                echo "[##ERROR##]"
            fi
        else
            echo "[##ERROR##]${dir}: No such file"
            login_key
        fi;;
    n)
    ;;
    *)
        login_key;;
    esac
}


function ssh_port(){
    echo '##############################################################################################################'
    echo 'set ssh port'
    read -p 'change ssh port?[y/n]:'
    case $REPLY in
    y)
        echo  >> /etc/ssh/sshd_config
        read -p 'please input the new ssh port(recommend to larger than 1000, please make sure the port is not in used):' port
        netstat -tlnp|awk -v port=$port '{lens=split($4,a,":");if(a[lens]==port){exit 2}}'  >/dev/null #2>&1
        res=$?
        if [ $res == 2 ];then
            echo "The port $port is already in used, try again"
            ssh_port
        elif [ $res == 1 ];then
            echo "[##Error##]"
            exit 1
        fi
        grep -i "^Port " /etc/ssh/sshd_config > /dev/null
        if [ $? == 0 ];then
            sed -i "s/^Port.*$/Port $port/g" /etc/ssh/sshd_config
        else
            echo "Port $port" >> /etc/ssh/sshd_config
        fi
        echo '[success]'
        restart_flag=0
        ;;
    n)
        ;;
    *)
        echo "[##Error:Invalid input##]"
        ssh_port;;
    esac
}

function restart_ssh(){
    if [ $restart_flag == 0 ];then
        echo "Please restart SSH service manully by using 'service sshd restart' or '/etc/init.d/ssh restart'"
    fi
}

function su_root(){
    echo '##############################################################################################################'
    echo 'Set which user can su to root'
    read -p 'set su conf[y/n]:'
    case $REPLY in
    
    
    y)
        read -p "please input the user:" user
        if [ $ostype == 'redhat' ] || [ $ostype == 'centos' ] || [ $ostype == 'fedora' ] || [ $ostype == 'euleros' ];then
            usermod -G wheel $user > /dev/null 2>&1
            grep -i "^auth.*required.*pam_wheel\.so.*use_uid" /etc/pam.d/su > /dev/null
            if [ $? == 1 ];then
                echo "auth       required   pam_wheel.so use_uid">> /etc/pam.d/su
            fi
            echo '[success]'
        elif [ $ostype == 'debian/ubuntu' ];then
            groupadd wheel > /dev/null 2>&1
            usermod -G wheel $user

            grep -i "^auth[\s\t]*required[\s\t]*pam_wheel" /etc/pam.d/su > /dev/null
            if [ $?  == 0 ];then
                sed -i "s/^auth.*required.*pam_wheel\.so.*$/auth    required    pam_wheel.so group=wheel/g" /etc/pam.d/su
            else
                echo "auth       required   pam_wheel.so group=wheel">> /etc/pam.d/su
            fi
            echo '[success]'
        elif [ $ostype == 'suse' ];then
            usermod -G wheel $user > /dev/null 2>&1
            grep -i "^auth.*required.*pam_wheel\.so.*use_uid" /etc/pam.d/su > /dev/null
            if [ $? == 1 ];then
                echo "auth     required   pam_wheel.so use_uid">> /etc/pam.d/su
            fi
            echo '[success]'
        else
            echo '[unknown os]'
        fi;;

 #   y)
 #       echo -e "The current configuration is:"
 #       grep -Pi "^auth[\s\t]*required[\s\t]*pam_wheel\.so[\s\t]*group\s*=" /etc/pam.d/su
 #       read -p 'please input the group name which is allowed to su to Root, for example "wheel test"("wheel" is as default, and it will overwrite the current configuration):' group
#        if [ -z "$group" ];then
#           group='wheel'
#        fi
#        grep -Pi "^auth[\s\t]*required[\s\t]*pam_wheel\.so[\s\t]*group\s*=" /etc/pam.d/su > /dev/null
#        if [ $?  == 0 ];then
#            sed -i "s/^auth.*group *=.*$/auth    required    pam_wheel.so group=$group/g" /etc/pam.d/su
#            echo '[success]'
#        else
#            echo "auth    required    pam_wheel.so group=($group)">> /etc/pam.d/su
#            echo '[success]'
#        fi;;
    n)
        ;;
    *)
        su_root;;
    esac
}

function main(){
    echo  "
#########################################################################################
#                                        Menu                                           #
#         1:ALL                                                                         #
#         2:Set Password Complexity Requirements                                        #
#         3:Set Remote Login Configuration(SSH)                                         #
#         4:Set Shell History and TMOUT                                                 #
#         5:Set Key Login(SSH)                                                          #
#         6:Set SSH Port                                                                #
#         7:Set Su User                                                                 #
#         8:Recover Configuration                                                       #
#         9:Exit                                                                        #
#########################################################################################"
    read -p "Please choice[1-9]:"
    case $REPLY in
    1)
        password
        remote_login
        max_tries
        allow_users
        login_key
        set_history_tmout
        ssh_port
        su_root
        restart_ssh
        ;;
    2)
        password;;
    3)
        remote_login
        max_tries
        allow_users
        restart_ssh;;
    4)
        set_history_tmout;;
    5)
        login_key
        restart_ssh;;
    6)
        ssh_port
        restart_ssh;;
    7)
        su_root;;
    8)
        recover
        restart_ssh;;
    9)
        exit 0;;
    *)
        echo "invalid input"
        main;;
    esac
}
main

