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
(1, 'Travelled to put it by love.', 'travelled-to-put-it-by-love', 'Nodded all possible for help but instead he spoke, nothing he tilted his bare shins.', 'surfer.jpg', 'bus.mp4', 'staggs'),
(2, 'Look at several of unsatisfiable desire.', 'look-at-several-of-unsatisfiable-desire', 'Never upset by them because the true had risen, much longer existed and bad people are so well. Means that my cousin in charge of disgust, slowly that we\'ve already held the food.', 'surfer.jpg', 'train.mp4', 'staggs'),
(3, 'Past I shall not yet existing like him.', 'past-i-shall-not-yet-existing-like-him', 'Once he must not due to go, read in words so long. Your house locked the which used to devour him.', 'surfer.jpg', 'bus.mp4', 'mazurek'),
(4, 'Awakened as had venerated a sound.', 'awakened-as-had-venerated-a-sound', 'I stayed there existed a wife had pointed to experience, has reached a proud state of rice-cake. How do many wrinkles and himself like it already, same pain also want me beautiful pleasure-garden.', 'surfer.jpg', 'train.mp4', 'mazurek'),
(5, 'Being which have sought shelter and words.', 'being-which-have-sought-shelter-and-words', 'Different from time it all perceived it attentively perceived, friend with spite of service before by letter. People bustling like foolishness you follow the word.', 'surfer.jpg', 'train.mp4', 'staggs'),
(6, 'Would also follow the courtesans.', 'would-also-follow-the-courtesans', 'Haven\'t said and helped him commit foolish world. Interrupted him under a reality, as true essence of the opposite to serve. Finding peace was ever a deep tiredness he dreamt of.', 'surfer.jpg', 'train.mp4', 'mazurek'),
(7, 'Understood and with her.', 'understood-and-with-her', 'On time is this yet, rarely laughed and voice which were accepted.', 'palm_tree.jpg', 'bus.mp4', 'dachelet'),
(8, 'Children joined the run-away.', 'children-joined-the-run-away', 'Young daughters when fell asleep, didn\'t you haven\'t expected any sleep, she owned locked the house there\'ll still all. Watched the large harvest seasons passed on.', 'surfer.jpg', 'bus.mp4', 'mazurek'),
(9, 'One talked to seek rest now shadow.', 'one-talked-to-seek-rest-now-shadow', 'Stayed the moving waters were reached them. Failed to picture these things, better and sweet voice inside that line.', 'surfer.jpg', 'train.mp4', 'staggs'),
(10, 'Deeply shocked and stupid.', 'deeply-shocked-and-stupid', 'Can teach me you waiting for. Talking turned all foolish and illusion. Teachings though without shoes pretty at about it. Told about myself in perfect or bored by as ever.', 'palm_tree.jpg', 'train.mp4', 'staggs');

CREATE TABLE `CONTACT` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Name` TEXT NULL, 
  `Email` TEXT NULL, 
  `Message` TEXT NULL, 
  `DateTime` DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `CONTACT` (`Id`, `Name`, `Email`, `Message`, `DateTime`) VALUES
(1, 'Roch', 'engin.wesolowski@mail.com', 'Verieeracyr', '2013-07-09 09:18:18'),
(2, 'Autoquote', 'pen.feild@outlook.com', 'Arkurrarritu', '2015-01-06 23:47:18'),
(3, 'Duda', 'lindie.salter@live.com', 'Gopalyf', '2015-10-16 08:56:10'),
(4, 'Meissner', 'ronn.louladakis@live.com', 'Ofmardorolan', '2012-09-26 05:28:57'),
(5, 'Syrett', 'arda.dpierre@mail.com', 'Artoluly', '2014-10-08 05:46:33');

CREATE TABLE `SECTION` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Name` TEXT NULL, 
  `Slug` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `SECTION` (`Id`, `Name`, `Slug`) VALUES
(1, 'Dachelet', 'dachelet'),
(2, 'Staggs', 'staggs'),
(3, 'Mazurek', 'mazurek');

CREATE TABLE `TEXT` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Slug` TEXT NULL, 
  `Text` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `TEXT` (`Id`, `Slug`, `Text`) VALUES
(1, 'ombarase', 'Wound did not committed all that line, turned to draw some news had perceived it. Being given her face which used crude swearwords, same manner in past I can\'t do so.'),
(2, 'orgetec', 'You in those whatever for so clearly, this essence of peace was written on it. Beautiful she held a pity if she asked again, wouldn\'t take my consent only separated from himself despised.'),
(3, 'rozieripep', 'Different life away that you\'re having his life. Two old previous life starting to understand this, latter had tried to worship in secrets. Always there perhaps very hard to walk on, late in agreement with doubt but with sky-blue ones.'),
(4, 'ingamy', 'Again in days he can laugh he could tell, no money with grief boiled over shoulder embraced him. That\'s not wash off by on face at all.'),
(5, 'leishagomur', 'Purpose in memory but eternal in on your amusement, have thought that entire world and most was necessary. Father who have fallen asleep in truth had disappeared, got up again make a joke or discard them. Turned all falling leaf which helps you insist upon.');

CREATE TABLE `USER` (
  `Id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `Email` TEXT NULL, 
  `Pseudonym` TEXT NULL, 
  `Password` TEXT NULL, 
  `IsAdministrator` TINYINT UNSIGNED NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `USER` (`Id`, `Email`, `Pseudonym`, `Password`, `IsAdministrator`) VALUES
(1, 'root@root.com', 'root', 'xyz', 1),
(2, 'emmaline.cummings@gmail.com', 'emmalinecummings', '5aokihH%', 0),
(3, 'padriac.jiang@gmail.com', 'padriacjiang', '=heMro0ste', 0),
(4, 'shan.mcintomny@outlook.com', 'shanmcintomny', 'raxowsDk0i/', 0),
(5, 'charlena.wessell@mail.com', 'charlenawessell', 'edP/d2ipo', 0);

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

