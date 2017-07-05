CREATE TABLE IF NOT EXISTS `autoecole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `vehicle` varchar(255) NOT NULL,
  `end_x` decimal(65,3) NOT NULL,
  `end_y` decimal(65,3) NOT NULL,
  `end_z` decimal(65,3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `autoecole` (`id`, `name`, `vehicle`, `end_x`, `end_y`, `end_z`) VALUES
(1, 'Permis Voiture', 'blista', '141.180', '6634.790', '31.636'),
(2, 'Permis Moto', 'akuma', '646.875', '584.900', '128.911'),
(3, 'Permis Vélo (bsr)', 'fixter', '-2316.720', '428.935', '174.467'),
(4, 'Permis Poids Lourd', 'pounder', '1268.240', '-3186.820', '5.903');


CREATE TABLE IF NOT EXISTS `user_licence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `licence_id` int(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
