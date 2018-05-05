-- MySQL dump 10.13  Distrib 5.5.54, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: material
-- ------------------------------------------------------
-- Server version	5.5.54-0+deb8u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `material`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `material` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `material`;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add permission',3,'add_permission'),(8,'Can change permission',3,'change_permission'),(9,'Can delete permission',3,'delete_permission'),(10,'Can add user',4,'add_user'),(11,'Can change user',4,'change_user'),(12,'Can delete user',4,'delete_user'),(13,'Can add content type',5,'add_contenttype'),(14,'Can change content type',5,'change_contenttype'),(15,'Can delete content type',5,'delete_contenttype'),(16,'Can add session',6,'add_session'),(17,'Can change session',6,'change_session'),(18,'Can delete session',6,'delete_session'),(19,'Can add photo_ img_ tag',7,'add_photo_img_tag'),(20,'Can change photo_ img_ tag',7,'change_photo_img_tag'),(21,'Can delete photo_ img_ tag',7,'delete_photo_img_tag'),(22,'Can add user',8,'add_user'),(23,'Can change user',8,'change_user'),(24,'Can delete user',8,'delete_user'),(25,'Can add photo_ sendword',9,'add_photo_sendword'),(26,'Can change photo_ sendword',9,'change_photo_sendword'),(27,'Can delete photo_ sendword',9,'delete_photo_sendword'),(28,'Can add photo',10,'add_photo'),(29,'Can change photo',10,'change_photo'),(30,'Can delete photo',10,'delete_photo'),(31,'Can add about',11,'add_about'),(32,'Can change about',11,'change_about'),(33,'Can delete about',11,'delete_about'),(34,'Can add backends',12,'add_backends'),(35,'Can change backends',12,'change_backends'),(36,'Can delete backends',12,'delete_backends');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(12,'frame','backends'),(6,'sessions','session'),(11,'travel','about'),(10,'travel','photo'),(7,'travel','photo_img_tag'),(9,'travel','photo_sendword'),(8,'travel','user');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2017-04-18 17:06:00'),(2,'auth','0001_initial','2017-04-18 17:06:00'),(3,'admin','0001_initial','2017-04-18 17:06:00'),(4,'admin','0002_logentry_remove_auto_add','2017-04-18 17:06:00'),(5,'contenttypes','0002_remove_content_type_name','2017-04-18 17:06:00'),(6,'auth','0002_alter_permission_name_max_length','2017-04-18 17:06:00'),(7,'auth','0003_alter_user_email_max_length','2017-04-18 17:06:00'),(8,'auth','0004_alter_user_username_opts','2017-04-18 17:06:00'),(9,'auth','0005_alter_user_last_login_null','2017-04-18 17:06:00'),(10,'auth','0006_require_contenttypes_0002','2017-04-18 17:06:00'),(11,'auth','0007_alter_validators_add_error_messages','2017-04-18 17:06:00'),(12,'auth','0008_alter_user_username_max_length','2017-04-18 17:06:00'),(13,'frame','0001_initial','2017-04-18 17:06:00'),(14,'sessions','0001_initial','2017-04-18 17:06:00'),(15,'travel','0001_initial','2017-04-18 17:06:00'),(16,'travel','0002_auto_20170502_1543','2017-05-02 15:43:30'),(17,'travel','0003_auto_20170502_2357','2017-05-02 23:57:54');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0uurngzpbawplny7kaxi9igw7xpbs5in','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-07 16:39:55'),('1ktmbbj2fccg589aqjkd12n2esiyhlzc','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-12 18:20:27'),('2e59vtnew92i8lpuky62i82c73otnk7e','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-07 23:14:50'),('3szp7l3a122zde930ctb65bwg0athf0v','NGFmNzJiNGNlNmYwNmYwYjkxMjI2YWFhNGEzOTllZjY1NGE1MDJkNzp7Il9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-19 06:28:50'),('3zhjf4ix0b2iir5fbu7wkexeqeucdazp','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-11 19:13:10'),('5b7pjrryjbsmvboismmekkablp2nj9o5','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-28 14:14:22'),('8yfhl8xzrcqd9h33jr4ftxa27srlsttn','NGFmNzJiNGNlNmYwNmYwYjkxMjI2YWFhNGEzOTllZjY1NGE1MDJkNzp7Il9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-18 17:07:26'),('99zmetsimsyuw3jr7obmogo51hnf6b73','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-21 10:40:00'),('9gbuanftr7mis7471qozns14k4k53hxw','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-05 09:01:21'),('9hlepransa7rzs3tz6obchpg9czggwd6','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-20 15:57:45'),('9ypvog42vogsh3jsx3knmyeojnrp8mnr','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-04 20:15:32'),('a16hd04lq1v6l7cikicpmil7mvgivte1','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-10 15:29:07'),('bz9fgrjc4gy0gzpv1vqi3w1hyp45vn7x','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-12 17:54:28'),('c45pnw5o7iovsx00lgr79sckhb66a0n2','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-06 14:16:38'),('c8wsbdfl9deni2ohkjdha2xnbic3gzet','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-21 02:36:11'),('ckuhx5gqspi8qa9w3l7i3doiza8lohwn','NGFmNzJiNGNlNmYwNmYwYjkxMjI2YWFhNGEzOTllZjY1NGE1MDJkNzp7Il9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-19 06:53:32'),('exh2xf7g77r4umow3zo1rgwxlnv9wigu','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-06 16:28:54'),('f1agww5cpzls1sht4ktardods3oo2iw4','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-06 14:19:00'),('fizxqpt3u1ws2bacrtg01bn59qgmi7dl','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-18 06:01:03'),('ft2atc61qafc01uyuhxitkmy0et2r58i','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-18 17:24:34'),('hvupcjybfh5tyofw534fshbftg2vfnnl','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-08 15:11:56'),('ibirjtc860y3cj9wwkm5d14y8h36vtfu','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-04-20 19:48:46'),('idq0fb6miz145xmuk8my2kpscfyckcy8','NGFmNzJiNGNlNmYwNmYwYjkxMjI2YWFhNGEzOTllZjY1NGE1MDJkNzp7Il9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-21 12:41:57'),('jvop4ipuwpcodpkjy43juc9a5pevpi0f','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-05 07:10:44'),('k7uq7qhlgpqcm3m6pjhkj2jvex9p48rq','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-08 15:12:02'),('karce7dwuvlhrqmv30o7sr41nattmlw1','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-10 16:03:20'),('ksv9fctncotuw8kgmcckte4vw9ir3khn','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-28 15:39:36'),('l37b0kvtax1e6fs6lbdj4m0xamlzs053','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-28 15:38:15'),('lkw32x6gtj4f55mmvn6s1wj9dx0eadvn','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-07 13:30:46'),('ltqziqh8c2clgpbzi1wartkrfcbw620w','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-04 19:54:07'),('n2isdfjenqpp7it3gdp4ua5bbjkz0k55','NGFmNzJiNGNlNmYwNmYwYjkxMjI2YWFhNGEzOTllZjY1NGE1MDJkNzp7Il9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-31 12:38:55'),('ome5yei6hha2l88ktihi75gxgztcxlzo','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-05 15:57:24'),('oqlrp55raraolugvwzquufdgxyleu6y3','NGFmNzJiNGNlNmYwNmYwYjkxMjI2YWFhNGEzOTllZjY1NGE1MDJkNzp7Il9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-19 05:09:18'),('qv9vhl5d0ictc50hh1snxsf6wymvu11i','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-14 02:02:08'),('s4pff7w97svjqsqon3xk20lsbt3zej46','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-19 06:20:17'),('sivo43d96q7p9uacpvu858kwl56e3ynt','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-21 11:40:23'),('uhx09m4a0tqve89ohisju5id2zwm4bz8','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-10 15:58:04'),('vfpzsoi70nctt8h7hb4h4efesdajp50i','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-07 00:10:02'),('vj3gowf0ogoxf913ipw3yc43ycezo1zn','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-04 20:07:29'),('x1ood9isci1orv1jpc1ijavmgm7sou37','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-21 11:38:27'),('xt1odajmm013w6ole07i2sgiflagbq0l','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-18 11:01:11'),('ykinp59n9v55weyc8t9ydtgml6r0fwrf','ZjY2Y2I1NGQzYzg0OTg1OTQ4NDllMTg2OGEyNzQ3MjYxNDg3NTlkODp7InVzZXJuYW1lIjoiaG9uZ3hpIiwiX3Nlc3Npb25fZXhwaXJ5IjowfQ==','2017-05-04 20:00:56'),('ykrjtn5t8b6rn24jfrqslpqix54zeuqv','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-05 20:49:20'),('yo93ka7rblg03cqd26yx2js41r3fc2zb','YTc2OTUyZWE0Y2ZhZGJkNThkNTRhNDY5ODM4NGIwMTgyYWRmOTVkMzp7InVzZXJuYW1lIjoieml5aSIsIl9zZXNzaW9uX2V4cGlyeSI6MH0=','2017-05-17 13:15:41');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `frame_backends`
--

DROP TABLE IF EXISTS `frame_backends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `frame_backends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `backend_class` varchar(1024) NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frame_backends`
--

LOCK TABLES `frame_backends` WRITE;
/*!40000 ALTER TABLE `frame_backends` DISABLE KEYS */;
INSERT INTO `frame_backends` VALUES (1,'travel.views.Involve','2017-04-09 15:52:41');
/*!40000 ALTER TABLE `frame_backends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel_about`
--

DROP TABLE IF EXISTS `travel_about`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `travel_about` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` longtext NOT NULL,
  `about_img` varchar(40) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel_about`
--

LOCK TABLES `travel_about` WRITE;
/*!40000 ALTER TABLE `travel_about` DISABLE KEYS */;
/*!40000 ALTER TABLE `travel_about` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel_photo`
--

DROP TABLE IF EXISTS `travel_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `travel_photo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) NOT NULL,
  `area` varchar(40) NOT NULL,
  `city` varchar(40) NOT NULL,
  `tag` longtext NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel_photo`
--

LOCK TABLES `travel_photo` WRITE;
/*!40000 ALTER TABLE `travel_photo` DISABLE KEYS */;
INSERT INTO `travel_photo` VALUES (1,2017,'fu_jian','xia_men','福建-厦门','2017-04-18 17:30:24','2017-04-18 17:30:24'),(2,2016,'hu_nan','zhang_jia_jie','湖南-张家界','2017-04-18 17:30:19','2017-04-18 17:30:19'),(3,2017,'guang_dong','shen_zhen','广东-深圳','2017-05-06 12:30:35','2017-05-06 12:30:35'),(4,2016,'gui_zhou','zhen_yuan','贵州-镇远','2017-04-23 23:15:26','2017-04-23 23:15:26'),(6,2017,'guang_dong','zhu_hai','广东-珠海','2017-05-06 12:37:48','2017-05-06 12:37:48'),(7,2017,'guang_dong','guang_zhou','广东-广州','2017-05-06 12:37:49','2017-05-06 12:37:49');
/*!40000 ALTER TABLE `travel_photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel_photo_img_tag`
--

DROP TABLE IF EXISTS `travel_photo_img_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `travel_photo_img_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(40) NOT NULL,
  `update_time` datetime NOT NULL,
  `photo_id` int(11) NOT NULL,
  `img_name` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `travel_photo_img_tag_photo_id_f33cf2b5_fk_travel_photo_id` (`photo_id`),
  CONSTRAINT `travel_photo_img_tag_photo_id_f33cf2b5_fk_travel_photo_id` FOREIGN KEY (`photo_id`) REFERENCES `travel_photo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel_photo_img_tag`
--

LOCK TABLES `travel_photo_img_tag` WRITE;
/*!40000 ALTER TABLE `travel_photo_img_tag` DISABLE KEYS */;
INSERT INTO `travel_photo_img_tag` VALUES (1,'肥肥生日','2017-05-03 16:03:03',3,'IMG_2257.JPG'),(2,'专心吃螺','2017-05-04 06:05:11',1,'IMG_2157.JPG'),(3,'专心亲瘦瘦','2017-05-04 06:06:36',1,'IMG_2188.JPG'),(4,'前苏联大使馆','2017-05-04 15:58:21',7,'68号.jpg'),(5,'情侣北路の小憩壹','2017-05-05 05:27:37',6,'IMG_2431_mh1493893777034.jpg'),(6,'pt201','2017-05-05 05:08:56',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(7,'前苏联大使馆','2017-05-05 05:21:41',7,'前苏联大使馆.jpg'),(8,'pt2017_05_03_11_51_44_mh1493783533666','2017-05-05 05:09:06',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(9,'pt2017_05_03','2017-05-05 05:09:09',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(10,'沙面街的阳光boy1','2017-05-05 05:20:25',7,'IMG_20170501_171709_mh1493873670671.jpg'),(11,'肥肥~帅帅哒','2017-05-05 05:19:27',7,'IMG_20170501_173621_mh1493896823131.jpg'),(12,'沙面街的阳光boy2','2017-05-05 05:20:42',7,'IMG_20170501_171726_mh1493878383697.jpg'),(13,'私家门庭','2017-05-05 05:21:33',7,'IMG_20170501_172055_mh1493783846558.jpg'),(14,'！','2017-05-05 05:21:53',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(15,'          ！','2017-05-05 05:21:58',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(16,'！！！','2017-05-05 05:22:27',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(17,'！！！','2017-05-05 05:22:44',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(18,'[捂脸]','2017-05-05 05:23:19',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(19,'[捂脸]','2017-05-05 05:23:47',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(20,'[捂脸]','2017-05-05 05:24:30',7,'pt2017_05_03_11_51_44_mh1493783533666.jp'),(21,'情侣北路の小憩壹','2017-05-05 06:28:35',6,'情侣北路の小憩貳.jpg'),(22,'情侣北路の小憩貳','2017-05-05 06:28:40',6,'情侣北路の小憩叁.jpg'),(23,'情侣北路の小憩叁','2017-05-05 06:28:43',6,'情侣北路の小憩肆.jpg'),(24,'情侣北路の小憩肆','2017-05-05 06:28:48',6,'情侣北路の小憩壹.jpg'),(25,'小丑','2017-05-07 10:42:19',2,'IMG_0947.JPG');
/*!40000 ALTER TABLE `travel_photo_img_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel_photo_sendword`
--

DROP TABLE IF EXISTS `travel_photo_sendword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `travel_photo_sendword` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` longtext NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `photo_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `travel_photo_sendword_photo_id_2c39d30c_fk_travel_photo_id` (`photo_id`),
  CONSTRAINT `travel_photo_sendword_photo_id_2c39d30c_fk_travel_photo_id` FOREIGN KEY (`photo_id`) REFERENCES `travel_photo` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel_photo_sendword`
--

LOCK TABLES `travel_photo_sendword` WRITE;
/*!40000 ALTER TABLE `travel_photo_sendword` DISABLE KEYS */;
INSERT INTO `travel_photo_sendword` VALUES (1,'<h1>肥肥爱瘦瘦*^_^*</h1>','2017-04-26 15:30:08','2017-04-26 15:30:08',3),(2,'ff 好帅 ss 好丑','2017-04-26 15:30:18','2017-04-26 15:30:18',1),(3,'ff 好帅 ss 好丑','2017-04-26 15:31:05','2017-04-26 15:31:05',4),(4,'ff 好帅 ss 好丑','2017-04-26 15:31:06','2017-04-26 15:31:06',2),(6,'here is guang_dong zhu_hai','2017-04-30 01:57:07','2017-04-30 01:57:07',6),(7,'<p style=\"text-align: center;\"><b>广州塔——珠江夜游</b></p><h5 style=\"text-align: left;\"><span style=\"font-weight: normal;\">&nbsp; &nbsp; &nbsp;从珠海客车站坐车到达广东省客运站（与广州市客运站隔街相对）已是22：00左右，原来打算21：00到广州后直接去珠江乘坐游艇夜游珠江、观广州塔夜景，但后来未赶上游艇开放时间（18：00-22：30）导致计划取消，一方面，因客车到达时间延误；另一方面，客车中途会经停中山大学<span style=\"text-align: left;\">，</span><span style=\"text-align: left;\">中山大学到广州塔很近，由于</span><span style=\"text-align: left;\">不清楚路线，我们没有在在那点下车，因此，从中山大学继续开往省站的路途上浪费了30分钟左右的时间。最后，吃夜宵的心情也没有，在省站附近吃了碗酸辣粉就回酒店休息了。。。</span></span></h5><div style=\"text-align: center;\"><b>早茶——點都德</b></div><h5 style=\"text-align: left;\">&nbsp;<span style=\"font-weight: normal;\"> &nbsp; 一直都听说广州是吃货的天堂，尤其想感受一下粤式早茶，其实最想的还是本地的流沙包，想着那一口咬下去，包子馅立马就溢出来了，金色的、像金沙一样，哈哈哈，想想一下就觉得好饿好饿~~睡好起床后，便开始在美团上搜索广州比较出名的早茶餐厅。根据我们所住的海珠区鹭江区域，选择了點都德茶餐厅（凤凰楼店），也同样在中山大学附近。12：00到时已排起了长队，去吃的人还挺多，不过排位还算比较快，不过大众点评上可以网上排队，也可以优惠买单，美团也可以优惠买单，但无法网上预约排队。<br>&nbsp; &nbsp; 总体感觉味道还可以，只是可能因为自己菜没点好的原因，餐后觉得比较腻，最主要是没有吃到流沙包，流沙包早上就卖完啦，超级郁闷。在美团上，还有很多人推荐他们家的乳鸽，但是这个菜只有下午场才做，也没有吃到，有点遗憾。另外这家没人必须消费茶位，我们点的贡菊，配上菜品，还是挺清新地。在美团上还有推荐陶陶居，人均消费略高，下次再去广州可以去尝尝~~</span></h5><div style=\"text-align: center;\"><b>广州沙面建筑群</b></div><h5 style=\"text-align: left;\"><span style=\"font-weight: normal;\">&nbsp; &nbsp; 下午16：00左右，肥肥临时决定带我去广州沙面建筑群看看，不错，懂我，很喜欢有文化底蕴的地方。广州沙面建筑群是广州最具异国风情的欧洲建筑，岛上</span><span style=\"font-weight: normal; color: rgb(51, 51, 51); font-family: arial, 宋体, sans-serif; font-size: 14px; text-indent: 28px; background-color: rgb(255, 255, 255);\">共有</span><span style=\"font-weight: normal;\">欧式建筑150多座，沙面曾是中国唯一的租界人工岛，是旧中国半封建半殖民地的历史见证，也是近代西方建筑文化输入中国的一个重要窗口；目前是多个国家驻广州领事馆所在地和在穗（广州的别称）外国人的主要活动区域。</span><span style=\"font-weight: normal;\">沙面岛外环绕着一条河，珠江河，映衬着这里的建筑，不错，很有国外的感觉。我们从地铁黄沙站下车后，过了一座人行天桥，来到沙面岛后便骑了摩拜单车环岛观赏，节省了很多体力，走走停停，遇到喜欢的建筑就停足拍照，超级适合拍照，美美哒！哈哈哈哈哈</span></h5>','2017-05-04 06:10:38','2017-05-04 06:10:38',7);
/*!40000 ALTER TABLE `travel_photo_sendword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel_user`
--

DROP TABLE IF EXISTS `travel_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `travel_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(1024) NOT NULL,
  `password` varchar(1024) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel_user`
--

LOCK TABLES `travel_user` WRITE;
/*!40000 ALTER TABLE `travel_user` DISABLE KEYS */;
INSERT INTO `travel_user` VALUES (1,'hongxi','10b6e404ab108ae47f855bc2cc2e4dd8','2017-04-13 20:03:44','2017-04-13 20:03:44'),(2,'ziyi','10b6e404ab108ae47f855bc2cc2e4dd8','2017-04-13 20:04:24','2017-04-13 20:04:24');
/*!40000 ALTER TABLE `travel_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-05-17 21:00:01
