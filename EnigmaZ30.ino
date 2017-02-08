#define ringsettingkeyidx 3
#define rotorkeyidx 7
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

byte KeyPressed = 0;
byte KeyIn = 0;

byte SetType = 0;
byte SetRing = 0;
byte SetWheel = 0;
byte SetStep = 0;

byte printmode = 0;

byte stepmode = 2;


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
    // stepmode 1: when ring position 9 is at current wheel position, step
    // stepmode 2: when wheel shows 9 step
    if (((calculateRing(0, i) == 9) && (stepmode == 1)) || ((enigmakey[rotorkeyidx + i] == 9) && (stepmode == 2))) {
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
    Serial.print('0');
    Serial.print(enigmakey[i]);
    if (i < 10) {
      Serial.print('+');
    }
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


void settype(int type) {
  for (byte i = 0; i < 3; i++) {
    enigmakey[2 - i] = type % 10;
    type = type / 10;
  }
}


void setrings(int rings) {
  for (byte i = 0; i < 4; i++) {
    enigmakey[ringsettingkeyidx + 3 - i] = rings % 10;
    rings = rings / 10;
  }
}


void setwheel(int wheel) {
  for (byte i = 0; i < 4; i++) {
    enigmakey[rotorkeyidx + 3 - i] = wheel % 10;
    wheel = wheel / 10;
  }
}


byte groups = 0;
void print(byte o)
{
  Serial.print(o);
  if (groups++ == 3) {
    Serial.print(' ');
    groups = 0;
  }
}


int encode(const char str[]) {

  int i = 0;
  char v;
  byte o;

  do {
    v = str[i++];

    if (v == 0) {
      break;
    }
    else {
      if ((v >= '0') && (v <= '9')) {
        o = enigma(v - '0');
        print(o);
      }
      if (((v >= 'A') && (v <= 'Z')) || ((v >= 'a') && (v <= 'z'))) {
        v = ((v | 32) - 32 ) - 'A' + 1;

        o = enigma(v / 10);
        print(o);
        o = enigma(v - (v / 10) * 10);
        print(o);
      }
    }

  } while (true);

}


void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);

  settype(312);
  setrings(4257);
  setwheel(8672);

  printkey();

  char msgkey[] = "0000";
  encode(msgkey);

  setwheel(3359);

  Serial.println(' ');

  char msg[] = "TEST";
  encode(msg);

  Serial.println("");
}


void loop() {
  // put your main code here, to run repeatedly:

  if (Serial.available())
  {
    KeyPressed = Serial.read();

    if (KeyPressed == '!') {
      SetType = 3;
      SetRing = 0;
      SetWheel = 0;
      SetStep = 0;
      groups = 0;

      Serial.println("");
    }

    if (KeyPressed == '@') {
      SetType = 0;
      SetRing = 4;
      SetWheel = 0;
      SetStep = 0;
      groups = 0;

      Serial.println("");
    }

    if (KeyPressed == '#') {
      SetType = 0;
      SetRing = 0;
      SetWheel = 4;
      SetStep = 0;
      groups = 0;

      Serial.println("");
    }

    if (KeyPressed == '$') {
      groups = 0;
      Serial.println("");
      printkey();
    }

    if (KeyPressed == '%') {
      groups = 0;
      Serial.println("");

      if (printmode) {
        Serial.println("printing rotors and key in/out");
        printmode = 0;
      }
      else {
        Serial.println("printing key out only");
        printmode = 1;
      }
    }

    if (KeyPressed == '^') {
      SetType = 0;
      SetRing = 0;
      SetWheel = 0;
      SetStep = 1;
      groups = 0;

      Serial.println("");
    }

    if ((KeyPressed >= '0') && (KeyPressed <= '9')) {
      KeyIn = (KeyPressed - '0');

      if (SetType + SetRing + SetWheel + SetStep == 0) {
        byte o = enigma(KeyIn);

        if (printmode) {
          print(o);
        }
        else {
          printenigma();
        }
      }

      if (SetType)
      {
        enigmakey[3 - SetType] = KeyIn;
        SetType--;
        if (SetType == 0) {
          printkey();
        }
      }

      if (SetRing)
      {
        enigmakey[ringsettingkeyidx + 4 - SetRing] = KeyIn;
        SetRing--;
        if (SetRing == 0) {
          printkey();
        }
      }

      if (SetWheel)
      {
        enigmakey[rotorkeyidx + 4 - SetWheel] = KeyIn;
        SetWheel--;
        if (SetWheel == 0) {
          printkey();
        }
      }

      if (SetStep)
      {
        SetStep--;
        if ((KeyIn == 1) || (KeyIn == 2)) {
          stepmode = KeyIn;
        }

        if (stepmode == 1) {
          Serial.println("1: stepping on ring position 9");
        }

        if (stepmode == 2) {
          Serial.println("2: stepping on wheel position 9");
        }
      }
    }
  }
}
