//
// 25183 91467 encrypts to 38760 15924
// what is the key???
//
// for testing
// 25183 91467 encrypts to 18019 06819
// with key
// settype(123);
// setrings(1111);
// setwheel(1234);
//

#define messagelength 10
#define maxerrors 3

char out[messagelength + 1];
char msg[] = "2518391467";   // input string
char enc[] = "3876015924";   // real string

//char enc[] = "3703712386";   // test string 01+02+03+00+00+00+01+01+02+03+08
//char enc[] = "3802267051";   // test string 01+02+03+00+00+01+05+01+02+03+08
//char enc[] = "1801906819";   // test string 01+02+03+01+01+01+01+01+02+03+04 // found at 1234 and 6734
//char enc[] = "1801906818";   // bad test string

// 8100 is the enigma z keyspace, reduce to test fewer cases and make sure all the logic is working
#define keyspace 8100

// 10000 (0000..9999) are all the ring settings, reduce to test fewer cases and make sure all the logic is working
#define ringspace 10000

byte stepmode = 2;        // 1: when ring position 9 is at current wheel position, step  //  2: when wheel shows 9 step
byte printalltries = 0;   // 0: only prints rollover message  //  1: prints every combination tried (slows down system)

// leftrotortype,midrotortype,rightrotortype,ringreflector,ringleftrotor,ringmidrotor,ringrightrotor,reflectorposition,leftrotorposition,midrotorposition,rightrotorposition,keyin,keyout
byte enigmakey[] = {
  1, 2, 3, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0
};

#define ringsettingkeyidx 3
#define rotorkeyidx 7
#define keyinoutidx 11

const uint16_t rotorcombo[] PROGMEM = {
  123, 132, 213, 231, 312, 321
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
    }

  } while (true);

}

void findkeypercentage() {

  bool savedstart = false;
  bool savednext = false;

  byte startrotor[] = {0, 0, 0, 0};
  byte nextrotor[] = {0, 0, 0, 0};

  int keystried = 0;
  byte ndx = 0;
  byte o;
  byte errors = 0;

  // start position
  byte rotorcombondx = 0;
  int ringtype = 0;
  int wheel = 0;

  // start position
  //byte rotorcombondx = 4;
  //int ringtype = 860;
  //int wheel = 0000;

  settype(pgm_read_word_near(rotorcombo + rotorcombondx));
  setrings(ringtype);
  setwheel(wheel);

  printkey();
  keystried = 0;

  do {

    ndx = 0;
    errors = 0;

    savedstart = false;
    savednext = false;

    keystried++;

    //Serial.println("new key");

    do {

      // save rotor starting position before enigma engine moves them
      if (!savedstart) {
        savedstart = true;
        for (byte i = 0; i < 4; i++) {
          startrotor[i] = enigmakey[rotorkeyidx + i];
        }
      }

      o = (enigma(msg[ndx] - '0')) + '0';
      out[ndx] = o;

      if (enc[ndx] != out[ndx]) {
        errors++;
      }

      //printenigma();

      if (!savednext) {
        savednext = true;
        for (byte i = 0; i < 4; i++) {
          nextrotor[i] = enigmakey[rotorkeyidx + i];
        }
      }

      ndx++;

      //Serial.print(ndx);
      //Serial.print(",");
      //Serial.println(errors);

    } while ((ndx < messagelength) && (errors <= maxerrors));

    out[ndx] = 0;

    if (errors <= maxerrors) {
      for (byte i = 0; i < 4; i++) {
        enigmakey[rotorkeyidx + i] = startrotor[i];
      }
      Serial.print("match,");
      Serial.print(messagelength - errors);
      Serial.print(",orig,");
      Serial.print(enc);
      Serial.print(",found,");
      Serial.print(out);
      Serial.print(",at,");
      printkey();
    }

    for (byte i = 0; i < 4; i++) {
      enigmakey[rotorkeyidx + i] = nextrotor[i];
    }

    if (keystried > keyspace + messagelength + 1)
    {
      keystried = 0;
      Serial.print("ROLLOVER: RINGS");
      //Serial.println(keystried);

      ringtype++;

      if (ringtype == ringspace)
      {
        Serial.print(": ROTORS");

        ringtype = 0000;

        rotorcombondx++;
        if (rotorcombondx == 6)
        {
          Serial.println(" ALL SETTINGS TRIED, STOPPING");
          return;
        }

        settype(pgm_read_word_near(rotorcombo + rotorcombondx));
      }

      setrings(ringtype);
      Serial.println(" ");
      printkey();
    }

  } while (true);
}


void findkey() {

  bool savekeyposition = false;
  int keystried = 0;
  int prevkeystried = 0;

  byte startrotor[] = {0, 0, 0, 0};
  byte prevrotor[] = {0, 0, 0, 0};
  byte foundat[] = {0, 0, 0, 0};
  byte ndx = 0;
  byte o;
  int checkrollover = 0;

  byte rotorcombondx = 0;

  int ringtype = 0000;
  int wheel = 0000;

  settype(pgm_read_word_near(rotorcombo + rotorcombondx));
  setrings(ringtype);
  setwheel(wheel);

  printkey();

  do {

    keystried++;

    // save rotor starting position before enigma engine moves them
    for (byte i = 0; i < 4; i++) {
      startrotor[i] = enigmakey[rotorkeyidx + i];
    }

    o = (enigma(msg[ndx] - '0')) + '0';
    if (printalltries)
    {
      printenigma();
      //Serial.println(keystried);
    }

    // if over machine period
    // need to do machine period + key to overlap search
    // in case it occurs in a period boundary
    // try with start position = 1236
    if (keystried > keyspace + messagelength + 2)
    {
      Serial.print("ROLLOVER: ");
      //Serial.println(keystried);

      keystried = 0;
      savekeyposition = false;
      prevkeystried = 0;
      ndx = 0;

      ringtype++;
      Serial.print("RINGS ");
      setrings(ringtype);

      if (ringtype == ringspace)
      {
        ringtype = 0000;

        rotorcombondx++;
        if (rotorcombondx == 6)
        {
          Serial.println("not found, stopping");
          return;
        }
        Serial.print("ROTORS");
        settype(pgm_read_word_near(rotorcombo + rotorcombondx));
        setrings(ringtype);
      }

      Serial.println(" ");
      printkey();
    }

    if (o == enc[ndx]) {
      ndx++;
      //Serial.println("match found");
      if (savekeyposition == false) {
        savekeyposition = true;
        prevkeystried = keystried;
        for (byte i = 0; i < 4; i++) {
          foundat[i] = startrotor[i];
          prevrotor[i] = enigmakey[rotorkeyidx + i];
        }
      }
    }
    else {
      if (savekeyposition) {
        //Serial.println("restoring");
        savekeyposition = false;
        ndx = 0;
        keystried = prevkeystried;
        for (byte i = 0; i < 4; i++) {
          enigmakey[rotorkeyidx + i] = prevrotor[i];
        }
      }
    }

  } while (msg[ndx] != 0);

  if (savekeyposition) {
    Serial.println("found at:");
    /*
      for (byte i = 0; i < 4; i++) {
      Serial.print(foundat[i]);
      }
      Serial.println("");
    */
    for (byte i = 0; i < 4; i++) {
      enigmakey[rotorkeyidx + i] = foundat[i] ;
    }
    printkey();
  }

}

void encodesamplekey() {

  settype(123);
  setrings(1);
  setwheel(1238);
  printkey();
  encode(msg);

}

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
  //Serial.begin(115200);

  delay(1000);

  //encodesamplekey();

  //findkey();

  findkeypercentage();
}

void loop() {
  // put your main code here, to run repeatedly:


}
