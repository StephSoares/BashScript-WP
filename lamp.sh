#!/bin/bash
choice = ""
# Reset
Color_Off='\033[0m'       # Text Reset
# Déclaration des variables :
choiceTheme="";
choice= "";


# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m' # Cyan

echo -e "$Cyan \n Installation d'Apache2 en cours $Color_Off"
sudo apt-get install apache2 -y
echo -e "$Green \n Apache2 Installé ! $Color_Off"

echo -e "$Cyan \n Installation de PHP 7.0 en cours $Color_Off"
sudo apt-get install php7.0 libapache2-mod-php7.0 php7.0-mysql -y
echo -e "$Green \n PHP 7.0 et dépendances Apache2 et MySQL Installés ! $Color_Off"

sudo rm index.html

echo -e "$Cyan Installation de wordpress $Color_Off"
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp core download --allow-root
echo -e "$Yellow \n Quel est le titre de votre site ?$Color_Off"
read title
echo -e "$Yellow \n Choisissez votre nom d'utilisateur :$Color_Off"
read user
echo -e "$Yellow \n Choisissez votre mot de passe : $Color_Off"
read password
echo -e "$Yellow \n Rentrez votre adresse email : $Color_Off"
read email
sudo wp config create --dbname=wordpress --dbuser=root --dbpass=0000 --dbhost=localhost --allow-root
sudo wp core install --url=192.168.33.10 --title=$title --admin_user=$user --admin_password=$password --admin_email=$email --allow-root

echo -e "$Yellow \n Voulez-vous gérer les thèmes ?$Color_Off"
select responseTheme in "Oui" "Non";do
  case $responseTheme in
    Oui ) choiceTheme="Oui";break;;
    Non ) choiceTheme="Non";break;;
  esac
done
if [ "$choiceTheme" == "Oui" ]
    then
        select response in "Ajouter un thème" "Supprimer un thème" "Activer un thème" "Quitter";do
            case $response in
                "Ajouter un thème" ) choice="Ajouter un thème" ;break;;
                "Supprimer un thème" ) choice="Supprimer un thème";break;;
                "Activer un thème" ) choice="Activer un thème";break;;
                "Quitter" ) "$choiceTheme" = "Non";break;;
            esac
        done
fi
if [ "$choice" == "Ajouter un thème" ]
       then
          echo -e "$Yellow \n Ecrivez le nom de votre thème :$Color_Off"
          read name
          echo -e "$Yellow \n Voici les thème qui correspondent à votre recherche :"
          wp theme $name
          echo -e "$Yellow \n Reécrivez votre thème avec le 'slug' qui lui correspond :$Color_Off"
          read slug
          echo -e "$Yellow \n Si votre thème est ajouter, cela marquera 0, si il n'est pas installer, cela marquera 1.$Color_Off"
          wp theme is-installed $slug
          echo $?
            if [ "$?" == 1 ]
                then
                  echo -e "$Cyan \n Installation de votre thème $Color_Off"
                  wp theme install $slug
            else [ "$?" == 0 ]
                then
                  echo - "$Red \n Le thème est déjà installé. $Color_Off"
            fi
fi

if [ "$choiceTheme" == "Non" ]
    then echo -e "$Yellow \n Voulez vous gérer les plugins ? $Color_Off"
     exit;

fi
sudo service apache2 restart
echo -e "$Green \n Serveur apache redémarré, vous pouvez accéder à votre site wordpress sur 192.168.33.10 ! Enjoy ! $Color_Off"
