#ifndef __ARRAY_H__
#define __ARRAY_H__

#define DIMENSIONS 3         // number of channels going into the PCA
#define FEATURES 1           // number of reduced dimensions going into the SVM
#define SUPPORTS 10           // number of support vectors for SVM
#define CLASSIFIERS 1        // number of classifiers created

#define NUMTAPS 6         // number of filter taps, for output adjustment
#define WINDOW 32         // number of lanes/bins/window, for output adjustment

#define DATA_WIDTH 32         // total bit size
#define DATA_BP 8         // number of fractional components

static double pcaVector[FEATURES][DIMENSIONS] = {{0.5431032698, 0.5818986773, 0.6053369043}};

static double SVMSupportVector[SUPPORTS][FEATURES] = {{-0.9158935467}, {-0.9155814039}, {-0.9153876406}, {-0.9151054178}, {-0.9149624295}, {-0.9147590469}, {-0.9142624858}, {-0.9138086068}, {-0.9137395282}, {-0.9137296489}};

static double SVMAlphaVector[CLASSIFIERS][SUPPORTS] = {{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}};

static double SVMIntercept[CLASSIFIERS] = {6.6405560472};

static double in[] = {-1.7489339859, -0.8390265197, -2.9996568755, -2.0930022821, -2.5597323275, -2.7229842157, -2.4412193659, -1.9633178189, -1.8096975773, -1.383549798, -1.7424164568, -0.9443414988, -2.3866432508, -0.3656476908, -2.9178372204, -0.9885974695, -1.7480855929, -1.3239305147, -2.5788391842, -2.4056955327, -0.597766294, -0.0952152728, -2.0597274655, -0.923032153, -0.3708325431, -0.3161800095, -2.7448673659, -2.8828356503, -2.4905087413, -0.3655724897, -2.7049594985, -1.736677125, -0.1263314095, -1.4005041451, -0.9243686581, -2.053453107, -0.940497217, -0.4961229843, -2.945135168, -0.7495670552, -0.0334167333, -0.7555030369, -2.1586680238, -0.6321620146, -2.6903219803, -1.6563194215, -0.2742134907, -2.1191575549, -2.1366739842, -2.6099142836, -490.3165210649, -160.5822335301, -394.185942, -367.2266703139, -254.2134203598, -473.3187274415, -212.941197254, -426.6357125471, -205.3472315484, -150.1208199895, -448.8327855861, -292.9720060902, -152.7999211361, -292.9103652365, -475.023270527, -232.0517970422, -168.1026773901, -242.5554439708, -27.7026220046, -206.722479749, -48.2990423561, -431.2626479269, -430.3618263746, -96.3043556452, -301.1615815072, -417.3229014415, -36.245709802, -326.1170701272, -124.5939484319, -137.0010073248, -58.3469543971, -188.1638964722, -124.5287829863, -325.5508290111, -365.0360541175, -52.056890902, -285.9544050644, -17.5799764258, -168.2792510908, -189.1521398954, -442.6270135233, -25.2553706465, -275.04393326, -210.8051928064, -295.9315986194, -381.4865098785, -48.3102397189, -213.1602566639, -498.5648364844, -191.4275431896};

static double ex[][2] = {{0.0, 89.9818083773563}, {0.0, 88.7549197095478}, {0.0, 82.25306263428116}, {0.0, 74.35868064469042}, {0.0, 74.86233483792932}, {0.0, 74.70058738297611}, {0.0, 82.06456621449826}, {0.0, 88.97264905614841}, {0.0, 89.18623847226254}, {0.0, 89.80613462745494}, {0.0, 92.9104822562868}, {0.0, 104.0062292102717}, {0.0, 105.49477525553841}, {0.0, 124.78448784568009}, {0.0, 14215.6394436034}, {0.0, 25778.55920995525}, {0.0, 257285.80702030857}, {0.0, 798406.535339669}, {0.0, 979489.945060441}, {0.0, 883292.7730304478}, {0.0, 652802.8592037325}, {0.0, 507408.94931444613}, {0.0, 504375.9499635645}, {0.0, 516689.7353547035}, {0.0, 496840.62622770027}, {0.0, 452337.06809291564}, {0.0, 513927.7741244112}, {0.0, 909469.8002923356}, {0.0, 919335.087921392}, {0.0, 790056.2721002016}, {0.0, 752814.0248705884}, {0.0, 1003058.6740415817}, {0.0, 985573.6040529523}, {0.0, 846911.0691389472}, {0.0, 762260.6615760565}, {0.0, 761337.8536806558}, {0.0, 777779.0473948233}, {0.0, 965628.8545605547}, {0.0, 1611409.1208693022}, {0.0, 1691891.1194919776}, {0.0, 1531142.7307143295}, {0.0, 1177403.5591231203}, {0.0, 1113251.0853576954}, {0.0, 1172804.368660507}, {0.0, 1349397.3106479784}, {0.0, 1334809.3443494192}, {0.0, 1192099.3722292446}, {0.0, 1060298.7337880754}, {0.0, 1012984.1915449603}, {0.0, 940150.4552948194}, {0.0, 988807.6897792532}, {0.0, 1052435.9199871614}, {0.0, 1286229.3093629729}, {0.0, 1446173.909145035}, {0.0, 1438076.3517289194}, {0.0, 1293242.1394974068}, {0.0, 1443048.90040143}, {0.0, 1546983.370801371}, {0.0, 1569104.2321833654}};

#endif
