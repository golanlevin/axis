/*
AxisApplet by Golan Levin
 http://www.flong.com/
 15 August 2002.
 
 Ported to Processing, January 2026.
 
 -------------------------
 "An Axis can't have more than three countries," explained Iraqi President
 Saddam Hussein. "This is not my rule, it's tradition. In World War II you
 had Germany, Italy, and Japan in the evil Axis. So you can only have three.
 And a secret handshake. Ours is wicked cool."[1]
 
 President Bush's recent assertion that North Korea, Iraq and Iran form an
 "Axis of Evil"[2] was more than a calculated political act -- it was also
 an imaginatively formal, geometric one, which had the effect of erecting a
 monumental, virtual, globe-spanning triangle.
 
 Axis is an online tool intended to broaden opportunities for similar kinds
 of Axis creation. It allows its participant to connect any three points in
 space [countries] into a new Axis of his or her own design. With the help
 of multidimensional statistical metrics culled from international public
 databases, the commonalities amongst the user's choices are revealed.
 In this manner, Axis presents an inversion of Bush's praxis, obtaining
 lexico-political meaning from the formal act of spatial selection.
 
 -------------------------
 References:
 [1] "Angered by Snubbing, Libya, China, Syria Form 'Axis of Just as Evil'".
 SatireWire, 1/30/2002. http://www.satirewire.com/news/jan02/axis.shtml
 [2] "In Speech, Bush Calls Iraq, Iran and North Korea 'Axis of Evil'".
 State of the Union Address, 1/29/2002.
 [3] The databases referenced in this project are listed at the
 end of this document.
 */

// Constants
final int FF = 255;
final int BASE = 72;
final int PDEC = 8;
final int NCOL = 256;
final int IW = 919;
final int IH = 476;
final int IY = 64;
final int APP_W = 919;
final int APP_H = IH + IY;
final int AXI_W = APP_W * 2 / 3;

// Image and pixel data
PImage srcImg;
int[] srcArray;  // Stores country IDs from the indexed image

// Palette arrays (current colors for each country ID)
int[] palr, palg, palb;
int[] curr, curg, curb;

// State variables
int[] whichSel = new int[3];
int[] highlites;
int curCtryID = 0;
int nSelectedCountries = 0;

// Floating indicator box
float bxf, byf;
float bxa = 0.36;
float bxb = 1.0 - bxa;
float bya = 0.29;
float byb = 1.0 - bya;
int bx, by, bw, bh = 20;

// Text strings
String axisStr = "";
String ctryStr = "";
String liteStr = "";
String axisStr2 = "";
char[] iCh = new char[3];
boolean doText = true;

// Fonts
PFont ctryFont, axisFont, liteFont;

// Colors
color colb = color(102, 102, 102);
color col1 = color(72, 72, 72);
color col2 = color(60, 60, 60);
color colu;

void setup() {
  size(919, 540);
  
  // Load and set up fonts
  ctryFont = createFont("Helvetica-Bold", 14);
  axisFont = createFont("Helvetica", 11);
  liteFont = createFont("Helvetica-Bold", 12);

  // Load the world map image
  srcImg = loadImage("world.gif");
  srcImg.loadPixels();

  // Extract country IDs from the indexed image
  // The GIF uses indexed colors where the blue channel encodes the country ID
  // Black (RGB 0,0,0) is used for boundaries and ocean - not a valid country
  srcArray = new int[IW * IH];
  for (int i = 0; i < IW * IH; i++) {
    int px = srcImg.pixels[i];
    int r = (px >> 16) & 0xFF;
    int g = (px >> 8) & 0xFF;
    int b = px & 0xFF;

    // Check for black (boundary/ocean) - use 255 as "no country" marker
    if (r == 0 && g == 0 && b == 0) {
      srcArray[i] = 255;  // No country
    } else {
      // Use the blue channel as the country index
      srcArray[i] = b;
    }
  }

  // Initialize palette arrays
  palr = new int[NCOL];
  palg = new int[NCOL];
  palb = new int[NCOL];
  curr = new int[NCOL];
  curg = new int[NCOL];
  curb = new int[NCOL];

  // Construct the base color palette
  for (int i = 0; i < NCOL; i++) {
    float fi = (float)i / (float)(NCOL - 1);
    curr[i] = curg[i] = curb[i] = 0;
    palr[i] = (int)(BASE + 40.0 * pow(fi, 9.0));
    palg[i] = (int)(BASE + 80.0 * pow(fi, 6.0));
    palb[i] = (int)(BASE + 120.0 * pow(fi, 3.0));
  }

  // Set the highlight color
  colu = color(palr[NCOL-1], palg[NCOL-1], palb[NCOL-1]);

  // Initialize selection arrays
  highlites = new int[nCountries];
  for (int i = 0; i < 3; i++) {
    whichSel[i] = -1;
  }
  for (int i = 0; i < nCountries; i++) {
    highlites[i] = 0;
  }

  // Initialize box position
  bxf = APP_W / 2;
  byf = APP_H / 2;
}

void draw() {
  compute();
  render();
}

void compute() {
  highlightCountryAtCursor(mouseX, mouseY);

  // Update the current palette based on highlight values
  for (int i = 0; i < nCountries; i++) {
    int vali = highlites[i] = max(0, highlites[i] - PDEC);
    curr[i] = palr[vali];
    curg[i] = palg[vali];
    curb[i] = palb[vali];
  }

  // Flash the selected countries yellow
  int which;
  int nSelected = 0;
  for (int i = 0; i < 3; i++) {
    which = whichSel[i];
    if ((which >= 0) && (which < nCountries)) {
      curr[which] = curg[which] = FF;
      curb[which] = 0;
      nSelected++;
    }
  }

  // Construct the displayed texts
  ctryStr = "";
  nSelectedCountries = nSelected;
  if (nSelected > 0) {
    long comProp1 = Long.MAX_VALUE;
    long comProp2 = Long.MAX_VALUE;
    for (int i = (nSelected - 1); i >= 0; i--) {
      which = whichSel[i];
      if ((which >= 0) && (which < nCountries)) {
        ctryStr += countryNames[which] + ((i > 0) ? ", " : " :  ");
        comProp1 &= countryProp1[which];
        comProp2 &= countryProp2[which];
        iCh[i] = countryNames[which].charAt(0);
      }
    }

    // Assemble the axis string
    if (doText) {
      // Intersect the properties
      int nCommonProp1 = 0;
      int nCommonProp2 = 0;
      for (int b = 0; b < 63; b++) {
        if (((comProp1 >>> b) & 1) > 0) nCommonProp1++;
      }
      for (int b = 0; b < nProperties2; b++) {
        if (((comProp2 >>> b) & 1) > 0) nCommonProp2++;
      }
      int nProps = nCommonProp1 + nCommonProp2;

      // Use grammatical rules to make something sensible
      axisStr2 = axisStr = "";
      if (nSelected == 3) {
        boolean initial = ((iCh[0] == iCh[1]) && (iCh[1] == iCh[2]));
        if (nProps > 0) {
          axisStr = "Axis of ";
          int prop = 0;
          long common;
          int bit;
          float strw;
          boolean wordy = false;
          for (int b = 0; b < nProperties; b++) {
            common = (b < 63) ? comProp1 : comProp2;
            bit = (b < 63) ? b : (b - 63);
            if (((common >>> bit) & 1) > 0) {
              String pnb = propNames[b];
              if ((nProps == 1) && (propAdjs[b] > 0)) {
                axisStr += "the " + pnb;
                if (initial) axisStr += letStr + iCh[0];
                axisStr += ".";
              } else {
                textFont(axisFont);
                strw = textWidth(axisStr + pnb);
                if ((++prop) < nProps) {
                  if (wordy || (strw > AXI_W)) {
                    axisStr2 += pnb;
                    if (propVerbs[b] > 0) axisStr2 += "ing";
                    axisStr2 += (nProps > 2) ? ", " : " ";
                    wordy = true;
                  } else {
                    axisStr += pnb;
                    if (propVerbs[b] > 0) axisStr += "ing";
                    axisStr += (nProps > 2) ? ", " : " ";
                  }
                } else {
                  if (wordy || (strw > AXI_W)) {
                    axisStr2 += pnb;
                    axisStr2 += (propVerbs[b] > 0) ? "ers" : " countries";
                    if (initial) axisStr2 += letStr + iCh[0];
                    axisStr2 += ".";
                    wordy = true;
                  } else {
                    axisStr += pnb;
                    axisStr += (propVerbs[b] > 0) ? "ers" : " countries";
                    if (initial) axisStr += letStr + iCh[0];
                    axisStr += ".";
                  }
                }
              }
            }
          }
        } else {
          if (initial) {
            axisStr = "Axis of countries" + letStr + iCh[0] + ".";
          } else {
            axisStr = "These countries have not yet registered their Axis.";
          }
        }
      }
    }
    doText = false;
  }

  // Construct the floating indicator box position
  textFont(liteFont);
  bw = max((int)textWidth(liteStr) + 12, 24);
  bxf = bxa * bxf + bxb * ((mouseX > (bw + 20)) ? (mouseX - bw - 20) : (mouseX + 20));
  byf = bya * byf + byb * (mouseY - bh / 2);
  bx = round(bxf);
  by = round(byf);
}

void render() {
  // Draw the header area
  noStroke();
  fill(colb);
  rect(0, 0, APP_W, IY);

  // Draw the world map with animated palette
  loadPixels();
  for (int y = 0; y < IH; y++) {
    for (int x = 0; x < IW; x++) {
      int srcIndex = y * IW + x;
      int dstIndex = (y + IY) * width + x;
      int ctryID = srcArray[srcIndex];
      if (ctryID < NCOL) {
        pixels[dstIndex] = color(curr[ctryID], curg[ctryID], curb[ctryID]);
      } else {
        pixels[dstIndex] = color(0);
      }
    }
  }
  updatePixels();

  // Draw border around the map
  stroke(0);
  noFill();
  rect(0, IY - 1, IW - 1, IH);

  // Draw the list of countries
  textFont(ctryFont);
  fill(col2);
  text(ctryStr, 11, 22);
  fill((nSelectedCountries == 3) ? color(255, 255, 0) : color(128));
  text(ctryStr, 10, 21);

  // Draw the axis string
  textFont(axisFont);
  fill(col2);
  text(axisStr, 11, 38);
  text(axisStr2, 11, 54);
  fill(255, 255, 0);
  text(axisStr, 10, 37);
  text(axisStr2, 10, 53);

  // Draw the floating indicator box
  if (!liteStr.equals("") && (mouseY >= IY)) {
    fill(colb);
    stroke(0);
    rect(bx, by, bw, bh);

    if ((whichSel[0] == curCtryID) ||
      (whichSel[1] == curCtryID) ||
      (whichSel[2] == curCtryID)) {
      fill(255, 255, 0);
    } else {
      fill(colu);
    }
    textFont(liteFont);
    text(liteStr, bx + 6, by + bh - 5);
  }
}

void mousePressed() {
  selectCountryAtCursor(mouseX, mouseY);
}

void selectCountryAtCursor(int x, int y) {
  if ((x >= 0) && (x < APP_W) && (y >= IY) && (y < APP_H)) {
    int csrIndex = (y - IY) * IW + x;
    if ((csrIndex < IW * IH) && (csrIndex >= 0)) {
      int ctryID = srcArray[csrIndex] & 0xFF;
      if ((ctryID >= 0) && (ctryID < nCountries)) {
        if ((ctryID != whichSel[0]) &&
          (ctryID != whichSel[1]) &&
          (ctryID != whichSel[2])) {
          whichSel[2] = whichSel[1];
          whichSel[1] = whichSel[0];
          whichSel[0] = (curCtryID = ctryID);
        }
      } else {
        ctryStr = axisStr2 = axisStr = liteStr = "";
        if (whichSel[0] > -1) highlites[whichSel[0]] = FF;
        if (whichSel[1] > -1) highlites[whichSel[1]] = FF;
        if (whichSel[2] > -1) highlites[whichSel[2]] = FF;
        whichSel[0] = whichSel[1] = whichSel[2] = -1;
      }
    }
  }
}

void highlightCountryAtCursor(int x, int y) {
  doText = true;
  if ((x >= 0) && (x < APP_W) && (y >= IY) && (y < APP_H)) {
    int csrIndex = (y - IY) * IW + x;
    if ((csrIndex < IW * IH) && (csrIndex >= 0)) {
      int ctryID = srcArray[csrIndex] & 0xFF;
      if ((ctryID >= 0) && (ctryID < nCountries)) {
        highlites[curCtryID = ctryID] = FF;
        liteStr = countryNames[curCtryID];
      } else {
        liteStr = "";
      }
    }
  } else {
    liteStr = "";
  }
}

// =========================================================================
// DATABASE: Country names
// =========================================================================
static final String[] countryNames = {
  "United States of America", "Canada", "Mexico", "Guatemala", "Cuba", "Haiti", "Dominican Republic", "Belize",
  "Honduras", "Nicaragua", "Costa Rica", "Panama", "Colombia", "Venezuela", "Guyana", "Suriname",
  "French Guyana", "Ecuador", "Peru", "Bolivia", "Chile", "Argentina", "Uruguay", "Andorra",
  "Paraguay", "Brazil", "Morocco", "Armenia", "Mauritania", "Senegal", "Gambia", "Guinea-Bissau",
  "Guinea", "Sierra Leone", "Liberia", "Cote d'Ivoire", "Ghana", "Togo", "Benin", "Nigeria",
  "Cameroon", "Equatorial Guinea", "Gabon", "Republic of the Congo",
  "Democratic Republic of Congo", "Angola", "Namibia", "South Africa",
  "Mozambique", "Tanzania", "Kenya", "Somalia", "Ethiopia", "Sudan", "Egypt", "Libya",
  "Tunisia", "Algeria", "Mali", "Burkina Faso", "Niger", "Chad", "Central African Republic", "Uganda",
  "Rwanda", "Burundi", "Zambia", "Malawi", "Zimbabwe", "Botswana", "Swaziland", "Lesotho",
  "Madagascar", "Greece", "Albania", "Yugoslavia", "Italy", "Spain", "Portugal", "France",
  "United Kingdom", "Ireland", "Azerbaijan", "Belgium", "Netherlands", "Denmark", "Germany", "Switzerland",
  "Austria", "Hungary", "Czech Republic", "Poland", "Sweden", "Norway", "Finland", "Romania",
  "Bulgaria", "Turkey", "Syria", "Israel", "Jordan", "Iraq", "Bahrain", "Kuwait",
  "Saudi Arabia", "Belarus", "Yemen", "Oman", "United Arab Emirates", "Iran", "Afghanistan", "Pakistan",
  "India", "Sri Lanka", "Nepal", "Bosnia and Herzegovina", "Bhutan", "Bangladesh", "Croatia", "Cyprus",
  "Burma", "Thailand", "Laos", "Cambodia", "Vietnam", "Off-By-One Error", "Malaysia", "Singapore",
  "Indonesia", "Djibouti", "Brunei", "El Salvador", "Hong Kong", "Eritrea", "Estonia", "Philippines",
  "Georgia", "Papua New Guinea", "Australia", "Gibraltar", "New Zealand", "China", "North Korea", "South Korea",
  "Mongolia", "Japan", "Russia", "Greenland", "Iceland", "Kazakhstan", "Kyrgyzstan", "Latvia",
  "Lebanon", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Moldova",
  "Monaco", "Qatar", "Slovak Republic", "Slovenia", "Taiwan", "Tajikistan", "Turkmenistan",
  "Ukraine", "Uzbekistan", "Antigua and Barbuda", "Bahamas", "Barbados", "Bermuda", "Cape Verde",
  "Dominica", "Grenada", "Guadeloupe", "Guam", "Jamaica", "Malta", "Mauritius", "New Caledonia", "Palau",
  "Puerto Rico", "Reunion", "Seychelles", "Trinidad and Tobago"
};

static final String letStr = " whose names start with the letter ";
static final int nCountries = countryNames.length;

// =========================================================================
// DATABASE: Property names
// =========================================================================
static final String[] propNames = {
  "itsy-bitsy", "small", "huge", "densely-populated",
  "sparsely-populated", "long and skinny", "peninsular", "island-dwell",
  "landlocked", "rainy", "arid", "cloudy",
  "earthquake-prone", "officially polylingual", "officially Anglophone", "Portuguese-speak",
  "politically or territorially dependent", "largely illiterate", "heavily-indebted and poor", "monarchic",
  "dictatorially autocratic", "communist", "Slavic", "predominantly Muslim",
  "predominantly Catholic", "predominantly Orthodox", "predominantly Buddhist", "Scandinavian",
  "Baltic", "Mediterranean", "South Asian", "Southeast Asian",
  "Sub-Saharan African", "Southern African", "South American", "Central American",
  "South Pacific", "East Asian", "Middle Eastern", "Central European",
  "North African", "Balkan", "former Soviet", "China-neighboring",
  "camel-driv", "tiger-roamed", "pachyderm-keep", "Olympic badminton medal winn",
  "oil-produc", "vodka-export", "nuclear-powered", "juvenile-offender execut",
  "tourism-dependent", "Olympic judo Silver medal winn", "violence-ravaged", "pepper-produc",
  "cricket-play", "oil-guzzl", "cannabis-cultivat", "bug-eat",
  "least corrupt", "insufficiently-reproducing", "fermented mare's milk drink", "orange-white-and-green flag-wav",
  "US visa-waiver pilot-program participat", "US bullet-buy", "ancient pyramid-maintain", "hydroelectric",
  "border-disput", "AIDS crisis-stricken", "perceived as egregiously corrupt", "undersexed",
  "heavily landmined", "person-traffick", "shark-infested", "Simpsons' travel destination",
  "former French colony", "comparatively depressed", "comparatively happy", "former Ottoman",
  "former Sassanid", "former Habsburg", "former Roman", "frequently lightning-struck",
  "Australopithecus fossil-hous", "population-skyrocket", "EU", "UN Security Council Permanent Member",
  "G7", "Fishery Committee for the Eastern Central Atlantic member"
};

static final int nProperties = propNames.length;
static final int nProperties2 = nProperties - 63;

// =========================================================================
// DATABASE: Property grammar codes (verbs and adjectives)
// =========================================================================
static final int[] propVerbs = {
  0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1,
  1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1,
  1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1
};

static final int[] propAdjs = {
  1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0,
  1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0,
  0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

// =========================================================================
// DATABASE: Country properties (binary encoded as longs)
// =========================================================================
static final long[] countryProp1 = {
  481603685151961092L, 1668302186964082692L, 907193884314963968L, 869476237435731968L,
  9288674250326176L, 4503599644160128L, 4785074620858496L, 293296960109035522L,
  864691162831917056L, 576460786680205568L, 292734010155602432L, 4785108980597248L,
  883549969091400192L, 576742244476780544L, 864691145635282944L, 576742244460003344L,
  288230393348424192L, 576742244476787200L, 576742244476792832L, 576742244477042944L,
  576742244476784672L, 74027936071553024L, 17196646400L, 148618787720012033L,
  882705544161263872L, 875668669743530500L, 329062940018218016L, 2613798624001265920L,
  18691706455056L, 288318341385691648L, 4521191822213666L, 18084767254086144L,
  18084767262318592L, 18084771557294592L, 18084767253938688L, 288582219872862208L,
  288582224167845888L, 70373039415328L, 281479272071200L, 110690038886457344L,
  576812600320614912L, 351848033681410L, 576812600319279104L, 576812600319549440L,
  883057374981791744L, 594827003124023296L, 648606315861525520L, 938789424664174592L,
  882775904299024384L, 648588719380758528L, 941604170136576000L, 18102359448380416L,
  18103458951753984L, 18384933937742848L, 49840037998629888L, 300167220691984L,
  40832563865977856L, 54343362748093440L, 89060450510080L, 70373039546624L,
  89060450641152L, 18103458951603456L, 576531125342839040L, 666603117890257152L,
  18084771566215426L, 18014402821497090L, 576531129637814528L, 576531129637822720L,
  666603122184962304L, 576531129637560592L, 70377334661378L, 4503608217854210L,
  869194736672710784L, 185492010222751808L, 283674008358912L, 2342718430223798272L,
  266556803498651712L, 195625109368086528L, 149463212650172416L, 231653906386518016L,
  1235956622737041536L, 217017207060719744L, 306548239878849536L, 155092712184883202L,
  1407093408577103872L, 1369938711785515008L, 227150855961313280L, 1307451266821005568L,
  5348574330093824L, 2352849880096964864L, 2307813883810676992L, 9852173961658368L,
  1299007017654421504L, 1297881117747587168L, 1298725542677194752L, 2343842131103191040L,
  2352851529385381888L, 36310272540938304L, 299342585922560L, 99660009356420098L,
  5084416653657088L, 299342050239488L, 4802666799039627L, 299067171667970L,
  146666329939117056L, 2594922208379797760L, 2551141862999040L, 299342049575936L,
  72356936087502848L, 2551141862740992L, 4917948385283028224L, 75743158097572864L,
  938850989799141376L, 94645960986067072L, 364905920100573472L, 18016597536944128L,
  114350350663938L, 72444623213166600L, 22801672157802496L, 22517998707290242L,
  18410225985131008L, 869581758390599680L, 292848327205323552L, 869300283413889024L,
  576856578706377248L, 0L, 649046114070692352L, 1225260575836102793L,
  905751292838679168L, 18691706065922L, 281477133131779L, 288793360481652738L,
  76569989758402561L, 18033090207170560L, 2306691832458772480L, 288511853292712064L,
  2599425808002985984L, 653303491812946560L, 1946417124859724948L, 76561193682157569L,
  1374442379997638784L, 614723894391083012L, 325592883920896L, 767160186463850560L,
  4621282555981725968L, 767582398996545664L, 2605099288006494212L, 75920L,
  1302103242397718672L, 4900774013648769280L, 4900211063703732480L, 2306410357482061824L,
  18032266118702082L, 4503599644672257L, 2307818282138206208L, 1153484454577578241L,
  36030996079972610L, 288797724185198848L, 4503600181542921L, 299342049576002L,
  1970874613760256L, 1128098951081984L, 145522700465475720L, 4918225462213214464L,
  4611989483645043712L, 2596048108286640128L, 4621559632854254848L, 4503599627911297L,
  4785074604097664L, 581245826907521161L, 76561193665380481L, 45185L,
  2594073385382199425L, 2598576985010094209L, 4503599644213377L, 4503599644237953L,
  869757678035943554L, 4503600181043337L, 869194736672456841L, 68736319616L,
  4503601774878849L, 4785074620948608L, 8606777473L, 4503599644172417L,
  3175882179406217345L
};

static final long[] countryProp2 = {
  117479460L, 33558580L, 268437516L, 60L, 67108864L, 8224L, 4L, 134217764L,
  4194364L, 164L, 4194356L, 536870932L, 1048628L, 4227120L, 36L, 48L,
  4202528L, 148L, 536870932L, 134217892L, 36L, 36L, 22L, 524294L,
  537919504L, 134223892L, 336077344L, 82976L, 335552512L, 67117056L, 67108864L, 68157440L,
  68165680L, 68157440L, 67108864L, 71311489L, 68157456L, 68165632L, 201334800L, 67109024L,
  67117296L, 67108896L, 67117104L, 68165680L, 68157488L, 528L, 84L, 2099300L,
  268438096L, 2103472L, 6291696L, 4196384L, 2097712L, 1115184L, 590376L, 4784160L,
  598016L, 598048L, 268443664L, 134225920L, 8225L, 2105344L, 8272L, 1048752L,
  48L, 134225936L, 80L, 268435552L, 4194884L, 134217792L, 96L, 64L,
  269492272L, 76088356L, 589840L, 524320L, 109576198L, 76283942L, 545783814L, 126357542L,
  59248678L, 8421415L, 131232L, 143130630L, 76316678L, 8421414L, 41943046L, 524310L,
  9175062L, 852004L, 262180L, 603979780L, 8421382L, 67108918L, 8388614L, 67960832L,
  134758404L, 590884L, 4718624L, 4784164L, 4718596L, 4390944L, 134218752L, 196612L,
  4262916L, 134235136L, 0L, 4194304L, 4195364L, 4326432L, 132624L, 538050720L,
  289L, 16L, 16L, 135071248L, 134217744L, 134217888L, 786996L, 589856L,
  134218784L, 1049124L, 8208L, 1058336L, 1057328L, 0L, 269484064L, 1048614L,
  1049760L, 10240L, 134217762L, 2060L, 2304L, 544L, 0L, 536870948L,
  606224L, 536872960L, 38918L, 524288L, 22L, 16777512L, 48L, 67108896L,
  268435456L, 100669734L, 16794784L, 16L, 32822L, 32L, 1072L, 16L,
  599044L, 524322L, 32L, 8912914L, 269025280L, 268517408L, 268959746L, 4195328L,
  262144L, 786470L, 288L, 1072L, 131105L, 82048L, 0L, 0L,
  134217732L, 134217732L, 134217728L, 67108864L, 8208L, 0L, 8192L, 0L,
  4L, 268959744L, 268443680L, 10244L, 536870912L, 32768L, 8192L, 8224L, 4L
};

/*
-------------------------
Databases referenced in this project:
 http://www.cia.gov/cia/publications/factbook/
 http://www.fao.org/WAICENT/FAOINFO/SUSTDEV/EIdirect/climate/EIsp0007.htm
 http://www.fao.org/WAICENT/FAOINFO/SUSTDEV/EIdirect/climate/EIsp0056.htm
 http://www.fao.org/WAICENT/FAOINFO/SUSTDEV/EIdirect/climate/EIsp0009.htm
 http://www.ethnologue.com/country_index.asp?place=all
 http://www.ethnologue.com/show_language.asp?code=POR
 http://unstats.un.org/unsd/mi/mi_results.asp?row_ID=656&fID=r5
 http://www.worldbank.org/hipc/about/map/map.html
 http://www.panda.org/species/tiger/distribution.cfm
 http://www.olympic.org/uk/athletes/results/search_r_uk.asp
 http://www.eia.doe.gov/emeu/iea/tableg2.html
 http://www.ivodka.com/vodka-by-country.html
 http://www.eia.doe.gov/oiaf/ieo/figure_62.html
 http://www.deathpenaltyinfo.org/juvchar.html
 http://www.olympic.org/uk/athletes/results/search_r_uk.asp
 http://www.hotnsaucey.com/countries.html
 http://www.cricket.org/link_to_database/NATIONAL/ICC/
 http://www.bp.com/centres/energy2002/oil/consumption.asp#
 http://www.food-insects.com/book7_31/
 http://www.transparency.org/cpi/2001/cpi2001.html#cpi
 http://138.251.140.21/~josh/flags/alpha.html
 http://www.foreignborn.com/visas_imm/other_visas/11pilot_program.htm
 http://www.unaids.org/barcelona/presskit/barcelona%20report/table.html
 http://www.boston.com/news/daily/27/sex_chart.htm
 http://www.landmines.org/glc/index-glc.asp
 http://www.state.gov/g/tip/rls/tiprpt/2002/10678.htm
 http://www.flmnh.ufl.edu/fish/Sharks/statistics/GAttack/World.htm
 http://www.snpp.com/episodeguide.html
 http://www.eur.nl/fsw/research/happiness
 http://www.fsmitha.com/h3/map21-ot.html
 http://www.fsmitha.com/h1/map20per.htm
 http://www.fsmitha.com/h1/map19rm.htm
 http://faculty.vassar.edu/piketay/evolution/SiteMap.html
 http://users.erols.com/mwhite28/20c-pop3.htm
 http://www.fao.org/fi/body/rfb/cecaf/cecaf_mapandmem.htm
 "In the Line of Fire," National Geographic, August 2002
*/
