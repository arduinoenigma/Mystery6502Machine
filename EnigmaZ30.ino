#define rotorkeyidx 7
#define ringsettingkeyidx 3
#define keyinoutidx 11

byte enigmakey[] = {
  //1, 2, 3, 1, 6, 7, 8, 4, 9, 8, 6, 0, 0
  //1, 2, 3, 1, 1, 1, 1, 8, 8, 8, 8, 0, 0
  //1, 2, 3, 1, 6, 7, 8, 4, 9, 8, 9, 0, 0
  1, 2, 3, 4, 5, 6, 7, 8, 8, 8, 8, 0, 0
};

const byte rotorindex[] PROGMEM = {
  30, 0, 10, 20
};

const byte rotors[] PROGMEM = {
  9, 6, 4, 1, 8, 2, 7, 0, 3, 5,
  2, 5, 8, 4, 1, 0, 9, 7, 6, 3,
  4, 3, 5, 8, 1, 6, 2, 0, 7, 9,
  2, 5, 0, 7, 9, 1, 8, 3, 6, 4,
  7, 3, 5, 8, 2, 9, 1, 6, 4, 0,
  5, 4, 0, 9, 3, 1, 8, 7, 2, 6,
  7, 4, 6, 1, 0, 2, 5, 8, 3, 9,
};

byte calculateRing(byte KeyIn,  byte RotorIdx)
{
  char t = 0;  // signed type

  t = KeyIn + enigmakey[rotorkeyidx + RotorIdx] + 1;

  if (t > 9) t = t - 10;

  t = t - enigmakey[ringsettingkeyidx + RotorIdx];

  if (t < 0) t = t + 10;

  return t;
}

void steprotor() {
  byte step[5];

  step[0] = 0;
  for (char i = 1; i < 4; i++) {
    step[i] = 0;
    if (calculateRing(0, i) == 9) {
      step[i] = 1;
    }
  }
  step[4] = 1;

  for (char i = 0; i < 4; i++) {
    if (step[i] || step[i + 1]) {
      enigmakey[rotorkeyidx + i]++;
      if (enigmakey[rotorkeyidx + i] > 9) {
        enigmakey[rotorkeyidx + i] = 0;
      }
    }
  }

}

byte enigma(byte KeyIn)
{
  char t = KeyIn;
  char nextrotor = -1;
  char currrotor = 3;
  char currrotortype;
  char reverserotor = 0;

  enigmakey[keyinoutidx] = KeyIn;

  steprotor();

  for (char i = 0; i < 7; i++) {

    t = calculateRing(t, currrotor);

    currrotortype = 0;
    if (currrotor != 0) {
      currrotortype = enigmakey[currrotor - 1];
    }

    currrotortype =  pgm_read_byte_near(rotorindex + currrotortype);

    t = pgm_read_byte_near(rotors + currrotortype + reverserotor + t);

    currrotortype = calculateRing(0, currrotor);
    t = t - currrotortype;
    if (t < 0) {
      t += 10;
    }

    currrotor += nextrotor;

    if (i == 2) {
      nextrotor = 1;
    }

    if (i == 3) {
      reverserotor = 40;
    }
  }

  enigmakey[keyinoutidx + 1 ] = t;

  return t;
}

void printkey() {
  for (char i = 0; i < 11; i++) {
    Serial.print(enigmakey[i]);
    Serial.print(' ');
  }
  Serial.println("");
}

void printrotor() {
  for (char i = 0; i < 4; i++) {
    Serial.print(enigmakey[rotorkeyidx + i]);
  }
  Serial.println("");
}

void printenigma() {
  for (char i = 0; i < 4; i++) {
    Serial.print(enigmakey[rotorkeyidx + i]);
  }

  Serial.print(' ');
  Serial.print(enigmakey[keyinoutidx]);
  Serial.print(' ');
  Serial.println(enigmakey[keyinoutidx + 1]);
}

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);

  printkey();

  for (byte i = 0; i < 30; i++) {
    enigma(0);
    printenigma();
  }

}

void loop() {
  // put your main code here, to run repeatedly:

}
