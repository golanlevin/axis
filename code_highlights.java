//========================================================================
// Introductory header of AxisApplet.java (2002; edited 2026)
// Lines 2-61; 1257-1331:
//========================================================================

/*
AxisApplet by Golan Levin
http://www.flong.com/
15 August 2002.

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

//========================================================================
// THE 94 PROPERTIES: An eclectic database of country characteristics
// sourced from CIA, FAO, World Bank, Olympic records, and other databases.
// Lines 993-1041:
//========================================================================

static final String propNames[] = {
    "itsy-bitsy","small","huge","densely-populated",
    "sparsely-populated","long and skinny","peninsular","island-dwell",
    "landlocked","rainy","arid","cloudy",
    "earthquake-prone","officially polylingual","officially Anglophone",
    "Portuguese-speak","politically or territorially dependent",
    "largely illiterate","heavily-indebted and poor","monarchic",
    "dictatorially autocratic","communist","Slavic","predominantly Muslim",
    "predominantly Catholic","predominantly Orthodox","predominantly Buddhist",
    "Scandinavian","Baltic","Mediterranean","South Asian","Southeast Asian",
    "Sub-Saharan African","Southern African","South American","Central American",
    "South Pacific","East Asian","Middle Eastern","Central European",
    "North African","Balkan","former Soviet","China-neighboring",
    "camel-driv","tiger-roamed","pachyderm-keep","Olympic badminton medal winn",
    "oil-produc","vodka-export","nuclear-powered","juvenile-offender execut",
    "tourism-dependent","Olympic judo Silver medal winn","violence-ravaged",
    "pepper-produc","cricket-play","oil-guzzl","cannabis-cultivat","bug-eat",
    "least corrupt","insufficiently-reproducing","fermented mare's milk drink",
    "orange-white-and-green flag-wav","US visa-waiver pilot-program participat",
    "US bullet-buy","ancient pyramid-maintain","hydroelectric","border-disput",
    "AIDS crisis-stricken","perceived as egregiously corrupt","undersexed",
    "heavily landmined","person-traffick","shark-infested",
    "Simpsons' travel destination","former French colony",
    "comparatively depressed","comparatively happy","former Ottoman",
    "former Sassanid","former Habsburg","former Roman",
    "frequently lightning-struck","Australopithecus fossil-hous",
    "population-skyrocket","EU","UN Security Council Permanent Member",
    "G7","Fishery Committee for the Eastern Central Atlantic member"
};

//========================================================================
// GRAMMATICAL ENCODING: Flags indicating which properties are verbs or
// adjectives, enabling proper conjugation in generated sentences.
// propVerbs=1 means add "ing" or "ers"; propAdjs=1 means use "the" prefix.
// Lines 1059-1087:
//========================================================================

static final int propVerbs[] = {
    0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,1,
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
    0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,1,1,
    1,1,0,1, 0,1,0,1, 1,1,1,1, 0,0,1,1,
    1,1,1,0, 1,0,0,0, 0,1,0,0, 0,0,0,0,
    0,0,0,0, 1,1,0,0, 0,0,0,0, 0,1};

static final int propAdjs[] = {
    1,1,1,1, 1,1,0,0, 1,1,1,1, 1,1,1,0,
    1,1,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
    0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
    0,0,0,0, 0,0,0,0, 0,0,0,0, 1,1,0,0,
    0,0,0,0, 0,0,0,1, 1,0,1,0, 0,1,1,0,
    0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0};

//========================================================================
// BINARY PROPERTY INTERSECTION: The core algorithm. Each country's
// properties are bit-packed into 64-bit longs. The bitwise "AND" operation
// finds commonalities among selected countries.
// Lines 525-545; 567-565:
//========================================================================

// Find properties common to all selected countries
long comProp1 = Long.MAX_VALUE;
long comProp2 = Long.MAX_VALUE;
for (int i=(nSelected-1);i>=0;i--){
    which = whichSel[i];
    if ((which>=0)&&(which<nCountries)){
        ctryStr += countryNames[which]+((i>0)?", ":" :  ");
        // Bitwise AND accumulates intersection:
        comProp1 &= countryProp1[which];  
        comProp2 &= countryProp2[which];
        iCh[i]=countryNames[which].charAt(0);
    }
}

// Count the shared properties by testing each bit
int nCommonProp1 = 0;
int nCommonProp2 = 0;
for (int b=0;b<63;b++){ if(((comProp1>>>b)&1)>0){nCommonProp1++;}}
for (int b=0;b<nProperties2; b++){if(((comProp2>>>b)&1)>0){nCommonProp2++;}}
int nProps = nCommonProp1+nCommonProp2;

//========================================================================
// STRING ASSEMBLY: Grammatical rules for constructing "Axis of..." phrases.
// Handles verb conjugation, adjective prefixes, and special cases like
// alliterative country names (e.g., "countries whose names start with I").
// Lines 573-675:
//========================================================================

if (nSelected == 3){
    // Check for alliteration:
    boolean initial=((iCh[0]==iCh[1])&&(iCh[1]==iCh[2]));  
    if (nProps>0){
        axisStr="Axis of ";
        int prop=0;
        for (int b=0;b<nProperties;b++){
            common = (b<63)?comProp1:comProp2;
            bit = (b<63)?b:(b-63);
            if (((common>>>bit)&1)>0){
                String pnb=propNames[b];
                if((nProps==1)&&(propAdjs[b]>0)){
                    // Single adjective: "Axis of the huge":
                    axisStr+="the "+pnb;  
                    if(initial){axisStr+=letStr+iCh[0];}
                    axisStr+=".";
                } else {
                    if((++prop)<nProps){
                        // Add "-ing" to verbs:
                        axisStr+=pnb;
                        if(propVerbs[b]>0){axisStr+="ing";}  
                        axisStr+=(nProps>2)?", ":" ";
                    } else {
                        // Final: "-ers" or "countries":
                        axisStr+=pnb;
                        axisStr+=(propVerbs[b]>0)?"ers":" countries";  
                        if(initial){axisStr+=letStr+iCh[0];}
                        axisStr+=".";
                    }
                }
            }
        }
    } else {
        if(initial){axisStr="Axis of countries"+letStr+iCh[0]+".";}
        else{axisStr="These countries have not yet registered their Axis.";}
    }
}

//========================================================================
// COUNTRY-FROM-PIXEL LOOKUP: The world map image uses indexed colors
// where each country has a unique palette index. Mouse position maps
// directly to country ID via the image's pixel values.
// Lines 787-819:
//========================================================================

void highlightCountryAtCursor(int x, int y){
    doText=true;
    csrIndex = -1;
    if ((x>=0)&&(x<APP_W)&&(y>=IY)&&(y<APP_H)){
        // Convert screen coords to pixel array index:
        csrIndex = (y-IY)*IW + x;  
        if ((csrIndex < NPELS)&&(csrIndex>=0)){
            // Pixel value IS the country ID:
            int ctryID = 0xFF & srcArray[csrIndex];  
            if ((ctryID >=0) && (ctryID < nCountries)){
                highlites[curCtryID=ctryID] = FF; // Mark for highlighting
                liteStr = ""+countryNames[curCtryID];
            } else {
                liteStr="";
            }
        }
    }
}

//========================================================================
// SAMPLE DATA: Binary property subscriptions for first few countries.
// Each 64-bit long encodes up to 63 boolean properties as individual bits.
// Lines 1099-1102:
//========================================================================

static final long countryProp1[] = {
    481603685151961092L,  // United States of America
    1668302186964082692L, // Canada
    907193884314963968L,  // Mexico
    869476237435731968L,  // Guatemala
    9288674250326176L,    // Cuba
    // ... 173 more countries
};
