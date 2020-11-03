CREATE TABLE `ARTICLE` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Title` TEXT NULL, 
  `Slug` TEXT NULL, 
  `Text` TEXT NULL, 
  `Image` TEXT NULL, 
  `Video` TEXT NULL, 
  `SectionSlug` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `ARTICLE` (`Id`, `Title`, `Slug`, `Text`, `Image`, `Video`, `SectionSlug`) VALUES
(1, 'They\'ve become empty rumours.', 'they-ve-become-empty-rumours', 'Afterwards insight but eternal not-finding. Wisdom cannot deny my willingness my wife\'s funeral pile.', 'palm_tree.jpg', 'train.mp4', 'leiwe'),
(2, 'Speaking which have teachers and called upon.', 'speaking-which-have-teachers-and-called-upon', 'Wondrous teachings he alone like good things are smiling oneness, I\'ll also learn that I\'ve found, near perfection I praise you. Smile quiet a frightening emptiness was knowledgeable one dwells.', 'beach.jpg', 'train.mp4', 'jaakkola'),
(3, 'Until it\'ll becomes old childlike face.', 'until-it-ll-becomes-old-childlike-face', 'If you\'re saying something dying quiet smile, body like holiness to emit like sadly he used to. Arrow-fast he stood not this we must praise you, wheel once twice the woman whom is good sir.', 'surfer.jpg', 'bus.mp4', 'jaakkola'),
(4, 'Who petitioned him when left him.', 'who-petitioned-him-when-left-him', 'Mouth is fading now which the multitude of offerings. Arrow-fast he pleased he should also have I followed him. Still on and remained as such hair.', 'palm_tree.jpg', 'train.mp4', 'leiwe'),
(5, 'Wisdom actually something he read for you.', 'wisdom-actually-something-he-read-for-you', 'Want me go this been sitting on hers, willingness delights my best thought of patience. Even more on that teachings. Apparently he demanded him with words.', 'surfer.jpg', 'train.mp4', 'lavorata'),
(6, 'Perhaps enjoyable to understand spoke.', 'perhaps-enjoyable-to-understand-spoke', 'Body full the rig-veda being without reason why, sounded strange may I am standing here twenty paces away, got some time a teaching you are awaiting him.', 'palm_tree.jpg', 'bus.mp4', 'leiwe'),
(7, 'You\'ll see his bowl of expertise.', 'you-ll-see-his-bowl-of-expertise', 'Most people wearing a thousand other hand, want back for much between the houses leaving monk. Pilgrims you he belong to.', 'beach.jpg', 'bus.mp4', 'lavorata'),
(8, 'Look did and princes hunting for himself.', 'look-did-and-princes-hunting-for-himself', 'Sounded new face watched them the arrangement of unsatisfiable desire. Close to life full breast when my pilgrimage, stood up and long before on their travels. Exalted one suffering on loaned money.', 'palm_tree.jpg', 'bus.mp4', 'lavorata'),
(9, 'Scent of your house for yourself.', 'scent-of-your-house-for-yourself', 'I\'ll continue travelling by teachers without being indestructible the path, was happy and bad whether the bodies of people own, though she called name is divine grace to side.', 'surfer.jpg', 'train.mp4', 'lavorata'),
(10, 'Has lived among carters and kissed with words.', 'has-lived-among-carters-and-kissed-with-words', 'Lost jewelry and carefully he knows just to enlightenment, for two friendly ferryman yes. Truly wanted to friend unstoppable like it fly.', 'beach.jpg', 'bus.mp4', 'jaakkola');

CREATE TABLE `CONTACT` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Name` TEXT NULL, 
  `Email` TEXT NULL, 
  `Message` TEXT NULL, 
  `DateTime` DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `CONTACT` (`Id`, `Name`, `Email`, `Message`, `DateTime`) VALUES
(1, 'Klaudt', 'nhut.benschop@yahoo.com', 'Inspahata', '2010-08-15 12:28:40'),
(2, 'Pickens', 'keven.singh@outlook.com', 'Dunalbraj', '2011-11-07 09:13:12'),
(3, 'Dinsmore', 'carlen.negandhi@mail.com', 'Dovassoduloh', '2011-04-25 17:36:35'),
(4, 'Pulcher', 'rafaelita.powney@yahoo.com', 'Ergarrirnig', '2013-11-16 13:24:12'),
(5, 'Caviness', 'coursey.setterfield@yahoo.com', 'Zenkevicius', '2007-10-16 02:20:12');

CREATE TABLE `SECTION` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Name` TEXT NULL, 
  `Slug` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `SECTION` (`Id`, `Name`, `Slug`) VALUES
(1, 'Jaakkola', 'jaakkola'),
(2, 'Lavorata', 'lavorata'),
(3, 'Leiwe', 'leiwe');

CREATE TABLE `TEXT` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Slug` TEXT NULL, 
  `Text` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `TEXT` (`Id`, `Slug`, `Text`) VALUES
(1, 'axtotchiedul', 'Just ready to pleasure with thanks returned asked it, surrounded by her old he considered indispensable and salvation. Wouldn\'t you don\'t quite understand this repetition this time.'),
(2, 'eighowskidi', 'Like happiness something by that curious more willing, forgive me how wise his kindness this way. Black ones with agonising pain also be achieved it.'),
(3, 'otturkade', 'Pearls he has done differently sound it also do, spoke little child from men talked incessantly. Majority of many there pondering while begging buying bananas, evening had occupied their richness and golden cage.'),
(4, 'sourupparnit', 'Warrior and into emptiness let escape of paths. How shall let his spirit to receive, they\'ve become dead jackal was hidden so clearly, would kill and evil words it\'s you kidding. Face lying by killing the mute gaze asked.'),
(5, 'manulkeu', 'Monks on gods saw whom had gathered dust, arrow-fast he wanted for any given upper garments. Half gray in learning from one suffering.');

CREATE TABLE `USER` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Email` TEXT NULL, 
  `Pseudonym` TEXT NULL, 
  `Password` TEXT NULL, 
  `IsAdministrator` TINYINT UNSIGNED NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `USER` (`Id`, `Email`, `Pseudonym`, `Password`, `IsAdministrator`) VALUES
(1, 'root@root.com', 'root', 'xyz', 1),
(2, 'manuel.litz@mail.com', 'manuellitz', 'm8anW;ilki', 1),
(3, 'cezary.disalvo@hotmail.com', 'cezarydisalvo', 'rO?9adop', 1),
(4, 'gertie.juhan@gmail.com', 'gertiejuhan', 'Ukas/3o', 1),
(5, 'jaquelin.tieu@hotmail.com', 'jaquelintieu', '&otHsa0do', 1);

ALTER TABLE `ARTICLE`
  ADD PRIMARY KEY (`Id`);

ALTER TABLE `CONTACT`
  ADD PRIMARY KEY (`Id`);

ALTER TABLE `SECTION`
  ADD PRIMARY KEY (`Id`);

ALTER TABLE `TEXT`
  ADD PRIMARY KEY (`Id`);

ALTER TABLE `USER`
  ADD PRIMARY KEY (`Id`);

