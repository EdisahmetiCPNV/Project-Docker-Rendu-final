Projet – Déploiement automatisé d’une application web avec base de données

Description du projet
Ce projet met en place un environnement de développement et de production automatisé pour une application web WordPress, appuyée sur une base de données MySQL et un reverse proxy Nginx.
L’objectif est d’utiliser Docker et des techniques d’Infrastructure as Code (IaC) pour automatiser le déploiement et la configuration des services.

Structure du projet
Le projet est organisé en plusieurs dossiers représentant les différents services et configurations :
- app/ : contient le code de l’application WordPress et la configuration Nginx
- config/ : regroupe les fichiers de configuration MySQL et WordPress
- docker/ : inclut les Dockerfiles pour chaque service (WordPress, MySQL, Nginx)
- prometheus/ et grafana/ : contiennent les fichiers de configuration pour le monitoring
- scripts/ : scripts Bash pour l’initialisation de la base de données et le déploiement
- Fichiers racine : docker-compose.yml, docker-compose.prod.yml, .env, README.md

Services et fonctionnalités
1. WordPress
- Déployé dans un conteneur Docker à partir de l’image officielle
- Configuré via un fichier wp-config.php personnalisé
- Contient les thèmes et plugins dans le dossier wp-content

2. MySQL
- Base de données utilisée par WordPress
- Configuration stockée dans config/mysql/my.cnf
- Initialisation automatisée via le script init-db.sh
- Variables d’environnement définies dans le fichier .env

3. Nginx
- Sert de reverse proxy devant WordPress
- Configuration personnalisée dans app/nginx/default.conf
- Supporte le HTTPS et le routage sécurisé des requêtes

4. Monitoring (Prometheus & Grafana)
- Prometheus collecte les métriques du système et des conteneurs
- Grafana affiche les tableaux de bord personnalisés
- Configurations disponibles dans les dossiers prometheus et grafana

Déploiement et automatisation
Environnement de développement
Pour lancer tous les services, il suffit d’exécuter la commande Docker Compose correspondante.

Environnement de production
Le déploiement de production utilise un fichier docker-compose spécifique.
Un script de déploiement permet d’automatiser tout le processus (construction, configuration, démarrage des conteneurs).

Sécurité
- Utilisation d’images Docker officielles
- Configuration HTTPS sur le reverse proxy Nginx
- Gestion des variables sensibles via le fichier .env
- Accès restreint et sécurisé à la base MySQL

Bonnes pratiques et maintenance
- Sauvegardes régulières de la base de données
- Monitoring via Prometheus et Grafana
- Mises à jour régulières des images Docker
- Application des bonnes pratiques de sécurité Docker

Auteurs
Projet réalisé dans le cadre du module E-169 – Déploiement automatisé d’applications web
Par : Breena lockser,Edis Ahmetaj, Joao Goncalves
Date de rendu : 29/10/2024
