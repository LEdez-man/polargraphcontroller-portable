# Polargraph – Guide pour les nuls

**Pour tous ceux qui veulent simplement commencer à dessiner** : enseignants, parents, groupes de
jeunes, ateliers d'art. Aucune connaissance préalable n'est nécessaire. Ce guide explique chaque
étape.

[Deutsch](de.md) · [English](en.md) · [Español](es.md)

---

## Qu'est-ce qu'un Polargraph ?

Un Polargraph est un **robot dessinateur suspendu au mur**. En haut à gauche et en haut à droite se
trouve un petit moteur. Une ficelle descend de chaque moteur, et les deux ficelles tiennent un
porte-crayon au milieu. Quand les moteurs allongent ou raccourcissent les ficelles, le crayon se
déplace sur le papier et dessine, trait après trait.

C'est un ordinateur qui pilote la machine. Il fait tourner le programme **Polargraph Controller**,
qui indique à la machine, par un câble USB, où le crayon doit aller.

Idéal pour : afficher ses propres dessins en grand au mur, faire dessiner des prénoms et des motifs,
transformer des photos en dessins au trait, et observer comment un robot « réfléchit ».

---

## Ce dont vous avez besoin

- [ ] Une **machine Polargraph entièrement montée**, avec son bloc d'alimentation
- [ ] Un **ordinateur Windows** (Windows 10 ou 11). Vous n'avez **pas** besoin d'installer Java ni
      aucun autre programme.
- [ ] Le **câble USB** adapté à la machine
- [ ] Du **papier**, fixé au mur ou sur un grand panneau
- [ ] Un **feutre** qui entre dans le porte-crayon
- [ ] Environ **une heure** la première fois ; ensuite, quelques minutes suffisent

---

## Vue d'ensemble : trois étapes

| Étape | Ce qui se passe | Combien de fois ? |
|---|---|---|
| **A** | Le « cerveau » de la machine (l'Arduino) reçoit son logiciel de commande | **une seule fois** |
| **B** | Le programme de dessin est mis sur l'ordinateur | **une seule fois** |
| **C** | Connecter, régler et dessiner | à chaque dessin |

> **La machine a déjà dessiné ?** Alors sautez l'étape A et commencez par l'étape B.

---

## Étape A : charger le logiciel de commande sur l'Arduino (une seule fois)

Dans la machine se trouve une petite carte électronique, l'**Arduino**. C'est le cerveau de la
machine. Pour comprendre les ordres de l'ordinateur, il a besoin d'un logiciel de commande, appelé
**firmware** (micrologiciel). Vous le chargez une fois, et il y reste pour toujours.

### A1. Trouver quel cerveau a votre machine

Regardez les cartes électroniques dans la machine :

| Ce que vous voyez | Votre firmware |
|---|---|
| Une carte marquée **« UNO »**, avec par-dessus une deuxième carte **Adafruit** (« Motor Shield ») | **Variante 1 :** `polargraph_server_a1` |
| Une longue carte marquée **« MEGA »**, avec par-dessus une carte munie d'un petit **écran** (PolarShield, PolargraphSD) | **Variante 2 :** `polargraph_server_polarshield` |

La variante 1 existe avec deux versions du Motor Shield :
- Si la carte porte l'inscription **« v2 »** (par exemple « Motor Shield v2.3 »), c'est la **v2**.
- Sinon, c'est presque toujours la **v1**. On la reconnaît à ses deux grosses puces noires marquées
  « L293D ».

Vous hésitez ? Demandez à la personne qui a construit la machine, ou prenez la carte en photo et
consultez le [wiki Polargraph](https://github.com/euphy/polargraph/wiki) (en anglais).

### A2. Installer le programme Arduino

1. Ouvrez [arduino.cc/en/software](https://www.arduino.cc/en/software).
2. Téléchargez l'**Arduino IDE pour Windows** et installez-le. Quand il demande d'installer des
   pilotes, cliquez sur « Installer ».

### A3. Télécharger le firmware

1. Ouvrez la
   [page de téléchargement de Polargraph](https://github.com/euphy/polargraphcontroller/releases/tag/2017-11-01-20-30)
   et cliquez sur **`Polargraph.2017-11-01.zip`**.
2. Faites un clic droit sur le fichier téléchargé, choisissez **« Extraire tout… »**, puis
   **« Extraire »**.
3. Dans le dossier extrait, vous trouverez le sous-dossier **`arduino-source`**. Vous en avez besoin
   maintenant.

### A4. Copier les compléments au bon endroit

Le firmware a besoin de quelques compléments, appelés bibliothèques.

1. Dans le dossier `arduino-source`, ouvrez le dossier **`libraries`**. Il contient cinq dossiers
   (AccelStepper, AFMotor, Adafruit_MotorShield, UTFT, UTouch).
2. Sélectionnez les cinq et copiez-les (Ctrl + C).
3. Ouvrez votre dossier **Documents**, puis **`Arduino`**, puis **`libraries`**. S'il n'y a pas de
   dossier `libraries`, créez-le (clic droit → Nouveau → Dossier).
4. Collez-y les cinq dossiers (Ctrl + V).
5. Si l'Arduino IDE était déjà ouvert, redémarrez-le.

### A5. Ouvrir le firmware

- **Variante 1 (UNO) :** double-cliquez sur
  `arduino-source\polargraph_server_a1\polargraph_server_a1.ino`
- **Variante 2 (MEGA) :** double-cliquez sur
  `arduino-source\polargraph_server_polarshield\polargraph_server_polarshield.ino`

L'Arduino IDE s'ouvre et affiche beaucoup de texte (le code du programme). Pas d'inquiétude, vous
n'avez pas besoin de le comprendre.

### A6. Seulement pour le Motor Shield v2 : deux petites modifications

**Pour la v1 et pour la variante 2, sautez cette étape.**

Vers le haut du texte, vous trouverez ces lignes :

```cpp
#define ADAFRUIT_MOTORSHIELD_V1
#include <AFMotor.h>
```

et en dessous :

```cpp
//#define ADAFRUIT_MOTORSHIELD_V2
//#include <Wire.h>
//#include <Adafruit_MotorShield.h>
//#include "utility/Adafruit_PWMServoDriver.h"
```

Deux barres obliques `//` en début de ligne signifient « désactiver cette ligne ». Modifiez ainsi :

- Tapez `//` **devant** les deux lignes v1.
- Supprimez le `//` **devant** les quatre lignes v2.

Le résultat ressemble à ceci :

```cpp
//#define ADAFRUIT_MOTORSHIELD_V1
//#include <AFMotor.h>

#define ADAFRUIT_MOTORSHIELD_V2
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"
```

### A7. Téléverser

1. Reliez la machine à l'ordinateur avec le câble USB.
2. Menu **Outils → Type de carte** : choisissez **« Arduino Uno »** (variante 1) ou
   **« Arduino Mega or Mega 2560 »** (variante 2).
3. Menu **Outils → Port** : choisissez l'entrée avec **COM** et un numéro, par exemple `COM3`. S'il y
   en a plusieurs, débranchez un instant le câble USB. L'entrée qui disparaît est la bonne.
4. Cliquez sur la **flèche vers la droite** en haut (« Téléverser »).
5. Attendez que **« Téléversement terminé »** s'affiche en bas. Cela prend environ une minute.
6. **Fermez l'Arduino IDE.** Sinon, il bloque la connexion avec la machine.

C'est fait ! Vous n'aurez plus jamais à refaire cette étape.

---

## Étape B : le programme de dessin sur l'ordinateur (une seule fois)

1. Ouvrez la
   [page de téléchargement de ce paquet](https://github.com/LEdez-man/polargraphcontroller-portable/releases)
   et cliquez sur **`Polargraph-portable-win64-…zip`**.
2. Clic droit sur le fichier téléchargé → **« Extraire tout… »** → **« Extraire »**. Choisissez un
   endroit facile à retrouver, par exemple le bureau ou une clé USB.
3. **Important :** ne lancez jamais rien directement depuis le fichier zip, toujours depuis le
   dossier extrait.

Rien n'est installé. Pour le supprimer plus tard, effacez simplement le dossier.

---

## Étape C : connecter, régler, dessiner

### C1. Lancer le programme

1. Ouvrez le dossier **`Polargraph-portable`**.
2. Double-cliquez sur **`start-polargraph.cmd`**.
3. Si Windows affiche **« Windows a protégé votre ordinateur »** : cliquez sur
   **« Informations complémentaires »**, puis sur **« Exécuter quand même »**. Cela arrive parce que
   le programme vient d'Internet et n'a pas de signature payante.

Après quelques secondes, la fenêtre **Polargraph Controller** s'ouvre. Au milieu, vous voyez une
image de votre machine.

### C2. Connecter la machine

1. Branchez le **bloc d'alimentation** de la machine et reliez le **câble USB**.
2. Dans le programme, cliquez sur **« Serial port… »** (port série) et choisissez le même port COM
   qu'à l'étape A7.
3. Regardez la ligne d'état en haut :
   - **Vert « Polargraph READY! »** : tout est connecté.
   - **Rouge « Polargraph is not connected. »** : voir « Si ça ne marche pas » plus bas.
4. Plus haut, une ligne rouge indique **« CommandQueue: QUEUE PAUSED - click to start »**.
   Cliquez dessus jusqu'à ce qu'elle affiche en vert **« QUEUE RUNNING »**. C'est seulement alors
   que la machine exécute les ordres.

### C3. Indiquer la taille de la machine (la première fois)

Le programme doit savoir quelle est la taille de votre machine. Cliquez en haut sur l'onglet
**« Setup »** (réglages).

| Champ | Que saisir ? |
|---|---|
| **Machine Width** (largeur de la machine) | Distance entre les deux moteurs en millimètres, d'axe à axe |
| **Machine Height** (hauteur de la machine) | Jusqu'où descend le papier, en millimètres à partir des moteurs |
| **MM Per Rev** (mm par tour) | Longueur de ficelle enroulée par un tour de moteur. La personne qui a construit la machine connaît cette valeur. |
| **Steps Per Rev** (pas par tour) | En général **200** |

Cliquez ensuite sur **« Upload machine spec »** pour que la machine reçoive les valeurs, et sur
**« Save »** pour que le programme les retienne. La prochaine fois, elles seront déjà là.

### C4. Définir le point de départ (avant chaque dessin)

Après la mise en marche, la machine ne sait pas où se trouve le crayon. C'est pourquoi il existe un
**point de départ** fixe (« Home »). À l'écran, il est représenté par une **croix** ; les chiffres à
côté indiquent où il se trouve (en mm depuis la gauche et depuis la ligne entre les moteurs). Il est
souvent marqué sur la machine.

1. Amenez délicatement le porte-crayon à ce point, à la main.
2. Dans l'onglet **« input »** (entrée), cliquez sur **« Set home »**.

Avec **« Pen lift »** (lever le crayon) et **« Pen drop »** (baisser le crayon), vous pouvez
vérifier que le crayon bouge.

### C5. Charger un dessin et le dessiner

La machine dessine le mieux les **dessins au trait** au format **SVG**.

1. Dans l'onglet **« input »**, cliquez sur **« Load vector »** et choisissez un fichier SVG.
   (Un deuxième clic sur « Load vector » retire le dessin pour en charger un autre.)
2. Le dessin apparaît sur l'image de la machine. Avec **« Move vector »** (déplacer) et
   **« Resize vector »** (redimensionner), ajustez sa position et sa taille.
3. Cliquez sur **« Draw vectors »**. La machine commence à dessiner.
4. Pour faire une pause, cliquez en haut sur **« QUEUE RUNNING - click to pause »**.
5. Quand elle a fini : **« Return to home »** ramène le crayon au point de départ.

**Où trouver des fichiers SVG ?**
- Dessinez-les vous-même avec le logiciel gratuit [Inkscape](https://inkscape.org).
- **Dessins d'enfants** : scannez-les ou prenez-les en photo, ouvrez-les dans Inkscape et
  transformez-les en traits avec **Chemin → Vectoriser un objet matriciel**. Cela marche le mieux
  avec des traits épais et foncés sur du papier blanc.
- De nombreux dessins au trait gratuits sont disponibles sur [openclipart.org](https://openclipart.org).

Les photos fonctionnent aussi : avec **« Load image file »**, choisissez ensuite une zone avec
**« Select Area »** puis cliquez sur **« Render pixels… »**. Gardez cela pour plus tard, quand les
premiers dessins fonctionnent.

---

## Conseils pour travailler avec des enfants

- **Bien fixer la machine :** elle doit être solidement accrochée au mur ou au panneau et ne doit
  pas pouvoir tomber.
- **Ne pas toucher pendant qu'elle dessine :** on peut se pincer les doigts dans les moteurs et les
  ficelles. Rester à un pas du mur est une bonne règle.
- **Alimentation :** n'utilisez que le bloc d'alimentation de la machine. Débranchez-le après
  l'atelier.
- **Feutres :** les feutres lavables sont idéaux. Ne changez le feutre que lorsque le porte-crayon
  est levé.
- **Commencer petit :** un dessin au format carte postale est fini en quelques minutes. Les grandes
  images peuvent prendre plus d'une heure, parfait pour regarder et deviner ce qui va apparaître.
- **Idée pour le groupe :** chaque enfant dessine une partie, et la machine les réunit en un grand
  dessin collectif.

---

## Si ça ne marche pas

| Problème | Solution |
|---|---|
| Aucun port COM sous « Serial port… » | Vérifiez le câble USB ; certains câbles ne font que charger et ne transmettent pas de données. Beaucoup d'Arduino bon marché ont besoin une fois du pilote **CH340** (cherchez « pilote CH340 Windows »). |
| Rouge « Polargraph is not connected. » | Choisissez un autre port COM. Fermez l'Arduino IDE. L'étape A a-t-elle été faite ? |
| Connectée, mais la machine ne bouge pas | Est-ce écrit « QUEUE PAUSED » en haut ? Cliquez dessus. Le bloc d'alimentation est-il branché ? |
| Le dessin est déformé ou trop grand | Vérifiez les dimensions dans l'onglet « Setup » (étape C3) et redéfinissez le point de départ (étape C4). |
| Le programme ne démarre pas | Lancez `start-polargraph-console.cmd`. Il affiche des messages d'erreur à joindre si vous demandez de l'aide. |

Plus d'aide (en anglais) : [Dépannage](../troubleshooting.md), [Firmware en détail](../firmware.md),
[wiki Polargraph](https://github.com/euphy/polargraph/wiki).

---

## Petit lexique

| Mot | Signification |
|---|---|
| **Arduino** | Petite carte électronique, le « cerveau » de la machine |
| **Firmware** | Le logiciel de commande qui tourne sur l'Arduino |
| **Port COM** | Le nom que Windows donne à la connexion USB avec la machine, par exemple `COM3` |
| **SVG** | Format de fichier pour les dessins au trait |
| **Fichier zip** | Un dossier compressé ; il faut l'« extraire » avant de l'utiliser |
| **Home** | Le point de départ fixe du crayon |
| **Queue** | La file d'attente des ordres envoyés à la machine les uns après les autres |

---

*Polargraph a été créé par Sandy Noble ([polargraph.co.uk](http://www.polargraph.co.uk)).
Ce paquet portable et ce guide : Samuel Peters, réalisés avec l'aide de Claude (Anthropic).*
