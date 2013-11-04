#!/bin/bash

###########################################################
# Criado por Adler Parnas <adler.parnas@doisdeum.com.br>  #
# 2011-02-23                                              #
#                                                         #
# Editado por Thiago Moreira <loganguns@gmail.com>        #
# 2013-11-2                                               #
#                                                         #
###########################################################
#                                                         #
# Script para criar um virtual host no apache e adicionar #
# o nome do host no arquivo hosts                         #
#                                                         #
###########################################################

if [[ $EUID -ne 0 ]]; then

    echo "Você deve executar como root" 2>&1
    exit 1

else

    echo "Informe o nome do server (Ex.: adler) :"
    read server

    echo "Informe o caminho do site (Ex.: /var/www/adler) :"
    read path

    echo "Criando configuração de VHost para o server"

    echo "
    <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName $server.dev
        ServerAlias www.$server.dev

        DocumentRoot "$path"

        <Directory "$path">
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            Allow from all
        </Directory>
    </VirtualHost>
    " > /etc/apache2/sites-available/$server.conf

    echo "Ativando VHOST $server"
    #ln -s /etc/apache2/sites-available/$server.conf /etc/apache2/sites-enabled/$server.conf
    a2ensite $server

    echo "Atualizando arquivo hosts"
    echo "127.0.0.1 $server.dev www.$server.dev" >> /etc/hosts

    echo "Reiniciando apache";
    service apache2 restart

    echo "VHOST criado";

fi