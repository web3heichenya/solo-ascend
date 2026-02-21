// Main trait SVG data structure
window.TRAIT_SVG_DATA = {
  "BACKGROUND": {},
  "BASE": {},
  "EYES": {},
  "MOUTH": {},
  "FACE_FEATURE": {},
  "GLASSES": {},
  "HAIR_HAT": {},
  "BODY": {},
  "LEGS": {},
  "FOOT": {},
  "WEAPON": {}
};

// New trait data to be integrated
window.NEW_TRAIT_SVG_DATA = {
  "BACKGROUND": {
    "forest_dawn": `<rect width="400" height="200" fill="#FF9999"/>
<rect width="400" height="80" y="120" fill="#FFB366"/>
<rect width="400" height="100" y="200" fill="#228B22"/>
<rect x="50" y="180" width="8" height="40" fill="#8B4513"/>
<rect x="46" y="160" width="16" height="20" fill="#228B22"/>
<rect x="42" y="140" width="24" height="20" fill="#32CD32"/>
<rect x="120" y="190" width="6" height="30" fill="#8B4513"/>
<rect x="117" y="170" width="12" height="20" fill="#228B22"/>
<rect x="300" y="185" width="10" height="35" fill="#8B4513"/>
<rect x="295" y="165" width="20" height="20" fill="#228B22"/>
<rect x="291" y="145" width="28" height="20" fill="#32CD32"/>
<rect x="0" y="300" width="400" height="100" fill="#006400"/>`,

    "basalt_lavafield": `<!-- 深色火山天空 -->
<rect width="400" height="140" fill="#2d1b1b"/>
<rect width="400" height="60" y="140" fill="#4a2c2c"/>

<!-- 火山烟雾方块柱 -->
<rect x="60" y="80" width="16" height="16" fill="#666666"/>
<rect x="64" y="64" width="16" height="16" fill="#777777"/>
<rect x="68" y="48" width="16" height="16" fill="#888888"/>
<rect x="72" y="32" width="12" height="16" fill="#999999"/>
<rect x="76" y="16" width="8" height="16" fill="#aaaaaa"/>

<rect x="180" y="90" width="20" height="20" fill="#666666"/>
<rect x="185" y="70" width="20" height="20" fill="#777777"/>
<rect x="190" y="50" width="20" height="20" fill="#888888"/>
<rect x="195" y="30" width="16" height="20" fill="#999999"/>
<rect x="200" y="10" width="12" height="20" fill="#aaaaaa"/>

<rect x="310" y="85" width="18" height="18" fill="#666666"/>
<rect x="315" y="67" width="18" height="18" fill="#777777"/>
<rect x="320" y="49" width="18" height="18" fill="#888888"/>
<rect x="325" y="31" width="14" height="18" fill="#999999"/>
<rect x="330" y="13" width="10" height="18" fill="#aaaaaa"/>

<!-- 大块玄武岩地面 -->
<rect x="0" y="200" width="50" height="50" fill="#0f0f0f"/>
<rect x="50" y="200" width="50" height="50" fill="#1a1a1a"/>
<rect x="100" y="200" width="50" height="50" fill="#0f0f0f"/>
<rect x="150" y="200" width="50" height="50" fill="#1a1a1a"/>
<rect x="200" y="200" width="50" height="50" fill="#0f0f0f"/>
<rect x="250" y="200" width="50" height="50" fill="#1a1a1a"/>
<rect x="300" y="200" width="50" height="50" fill="#0f0f0f"/>
<rect x="350" y="200" width="50" height="50" fill="#1a1a1a"/>

<rect x="0" y="250" width="50" height="50" fill="#1a1a1a"/>
<rect x="50" y="250" width="50" height="50" fill="#0f0f0f"/>
<rect x="100" y="250" width="50" height="50" fill="#1a1a1a"/>
<rect x="150" y="250" width="50" height="50" fill="#0f0f0f"/>
<rect x="200" y="250" width="50" height="50" fill="#1a1a1a"/>
<rect x="250" y="250" width="50" height="50" fill="#0f0f0f"/>
<rect x="300" y="250" width="50" height="50" fill="#1a1a1a"/>
<rect x="350" y="250" width="50" height="50" fill="#0f0f0f"/>

<rect x="0" y="300" width="50" height="50" fill="#0f0f0f"/>
<rect x="50" y="300" width="50" height="50" fill="#1a1a1a"/>
<rect x="100" y="300" width="50" height="50" fill="#0f0f0f"/>
<rect x="150" y="300" width="50" height="50" fill="#1a1a1a"/>
<rect x="200" y="300" width="50" height="50" fill="#0f0f0f"/>
<rect x="250" y="300" width="50" height="50" fill="#1a1a1a"/>
<rect x="300" y="300" width="50" height="50" fill="#0f0f0f"/>
<rect x="350" y="300" width="50" height="50" fill="#1a1a1a"/>

<rect x="0" y="350" width="400" height="50" fill="#050505"/>

<!-- 宽阔的岩浆河流 -->
<rect x="0" y="225" width="400" height="30" fill="#ff4500"/>
<rect x="0" y="225" width="400" height="6" fill="#ffff00"/>
<rect x="0" y="249" width="400" height="6" fill="#ff6600"/>

<rect x="25" y="310" width="350" height="25" fill="#ff4500"/>
<rect x="25" y="310" width="350" height="5" fill="#ffff00"/>
<rect x="25" y="330" width="350" height="5" fill="#ff6600"/>

<!-- 岩浆喷发效果 -->
<rect x="80" y="215" width="12" height="12" fill="#ff6600"/>
<rect x="84" y="203" width="8" height="12" fill="#ff8800"/>
<rect x="86" y="191" width="4" height="12" fill="#ffaa00"/>

<rect x="180" y="220" width="16" height="16" fill="#ff6600"/>
<rect x="184" y="204" width="12" height="16" fill="#ff8800"/>
<rect x="188" y="188" width="8" height="16" fill="#ffaa00"/>

<rect x="300" y="305" width="14" height="14" fill="#ff6600"/>
<rect x="304" y="291" width="10" height="14" fill="#ff8800"/>
<rect x="306" y="277" width="6" height="14" fill="#ffaa00"/>

<!-- 地面裂缝 -->
<rect x="120" y="270" width="60" height="8" fill="#ff4500"/>
<rect x="240" y="275" width="80" height="6" fill="#ff4500"/>
<rect x="160" y="340" width="50" height="10" fill="#ff4500"/>

<!-- 散落的发光矿物 -->
<rect x="110" y="360" width="8" height="8" fill="#ffaa00"/>
<rect x="111" y="361" width="2" height="2" fill="#ffff99"/>

<rect x="280" y="370" width="12" height="8" fill="#ff4500"/>
<rect x="281" y="371" width="3" height="2" fill="#ff8888"/>

<rect x="340" y="365" width="10" height="10" fill="#ff6600"/>
<rect x="341" y="366" width="2" height="2" fill="#ffaa88"/>

<!-- 热浪效果 -->
<rect x="0" y="180" width="400" height="8" fill="#ff8800" opacity="0.4"/>
<rect x="20" y="188" width="360" height="6" fill="#ffaa00" opacity="0.3"/>
<rect x="40" y="194" width="320" height="6" fill="#ffcc00" opacity="0.2"/>

<rect x="30" y="280" width="340" height="6" fill="#ff8800" opacity="0.4"/>
<rect x="50" y="286" width="300" height="4" fill="#ffaa00" opacity="0.3"/>`,

    "cavern_torchlight": `<!-- 深色洞穴背景 -->
<rect width="400" height="400" fill="#0d0d0d"/>

<!-- 大型方块状石头瓦片 -->
<rect x="0" y="0" width="80" height="80" fill="#3d3d3d"/>
<rect x="80" y="0" width="80" height="80" fill="#4d4d4d"/>
<rect x="160" y="0" width="80" height="80" fill="#3d3d3d"/>
<rect x="240" y="0" width="80" height="80" fill="#5d5d5d"/>
<rect x="320" y="0" width="80" height="80" fill="#3d3d3d"/>

<rect x="0" y="80" width="80" height="80" fill="#4d4d4d"/>
<rect x="80" y="80" width="80" height="80" fill="#3d3d3d"/>
<rect x="160" y="80" width="80" height="80" fill="#5d5d5d"/>
<rect x="240" y="80" width="80" height="80" fill="#3d3d3d"/>
<rect x="320" y="80" width="80" height="80" fill="#4d4d4d"/>

<rect x="0" y="160" width="80" height="80" fill="#3d3d3d"/>
<rect x="80" y="160" width="80" height="80" fill="#5d5d5d"/>
<rect x="160" y="160" width="80" height="80" fill="#3d3d3d"/>
<rect x="240" y="160" width="80" height="80" fill="#4d4d4d"/>
<rect x="320" y="160" width="80" height="80" fill="#3d3d3d"/>

<rect x="0" y="240" width="80" height="80" fill="#5d5d5d"/>
<rect x="80" y="240" width="80" height="80" fill="#3d3d3d"/>
<rect x="160" y="240" width="80" height="80" fill="#4d4d4d"/>
<rect x="240" y="240" width="80" height="80" fill="#3d3d3d"/>
<rect x="320" y="240" width="80" height="80" fill="#5d5d5d"/>

<rect x="0" y="320" width="80" height="80" fill="#3d3d3d"/>
<rect x="80" y="320" width="80" height="80" fill="#4d4d4d"/>
<rect x="160" y="320" width="80" height="80" fill="#3d3d3d"/>
<rect x="240" y="320" width="80" height="80" fill="#5d5d5d"/>
<rect x="320" y="320" width="80" height="80" fill="#3d3d3d"/>

<!-- 方块状钟乳石 -->
<rect x="35" y="0" width="20" height="48" fill="#2d2d2d"/>
<rect x="39" y="48" width="12" height="24" fill="#1d1d1d"/>
<rect x="43" y="72" width="4" height="12" fill="#0d0d0d"/>

<rect x="140" y="0" width="24" height="40" fill="#2d2d2d"/>
<rect x="146" y="40" width="12" height="20" fill="#1d1d1d"/>
<rect x="150" y="60" width="4" height="10" fill="#0d0d0d"/>

<rect x="280" y="0" width="16" height="32" fill="#2d2d2d"/>
<rect x="284" y="32" width="8" height="16" fill="#1d1d1d"/>
<rect x="286" y="48" width="4" height="8" fill="#0d0d0d"/>

<rect x="350" y="0" width="28" height="52" fill="#2d2d2d"/>
<rect x="358" y="52" width="12" height="24" fill="#1d1d1d"/>
<rect x="362" y="76" width="4" height="12" fill="#0d0d0d"/>

<!-- 多个火把照亮洞穴 -->
<rect x="60" y="120" width="6" height="12" fill="#8B4513"/>
<rect x="57" y="118" width="12" height="8" fill="#FF6600"/>
<rect x="55" y="115" width="16" height="3" fill="#FFAA00"/>
<!-- 方形光晕效果 -->
<rect x="40" y="100" width="48" height="48" fill="#FF8800" opacity="0.3"/>
<rect x="45" y="105" width="38" height="38" fill="#FFAA00" opacity="0.2"/>
<rect x="50" y="110" width="28" height="28" fill="#FFCC00" opacity="0.1"/>

<rect x="280" y="200" width="6" height="12" fill="#8B4513"/>
<rect x="277" y="198" width="12" height="8" fill="#FF6600"/>
<rect x="275" y="195" width="16" height="3" fill="#FFAA00"/>
<!-- 方形光晕效果 -->
<rect x="260" y="180" width="48" height="48" fill="#FF8800" opacity="0.3"/>
<rect x="265" y="185" width="38" height="38" fill="#FFAA00" opacity="0.2"/>
<rect x="270" y="190" width="28" height="28" fill="#FFCC00" opacity="0.1"/>

<rect x="150" y="280" width="6" height="12" fill="#8B4513"/>
<rect x="147" y="278" width="12" height="8" fill="#FF6600"/>
<rect x="145" y="275" width="16" height="3" fill="#FFAA00"/>
<!-- 方形光晕效果 -->
<rect x="130" y="260" width="48" height="48" fill="#FF8800" opacity="0.3"/>
<rect x="135" y="265" width="38" height="38" fill="#FFAA00" opacity="0.2"/>
<rect x="140" y="270" width="28" height="28" fill="#FFCC00" opacity="0.1"/>

<!-- 散落的发光矿物 -->
<rect x="100" y="180" width="8" height="8" fill="#FFD700"/>
<rect x="101" y="181" width="2" height="2" fill="#FFFF99"/>
<rect x="104" y="184" width="2" height="2" fill="#FFFF99"/>

<rect x="300" y="120" width="12" height="8" fill="#FF4500"/>
<rect x="301" y="121" width="3" height="2" fill="#FF8888"/>
<rect x="306" y="124" width="3" height="2" fill="#FF8888"/>

<rect x="200" y="350" width="8" height="8" fill="#4169E1"/>
<rect x="201" y="351" width="2" height="2" fill="#87CEEB"/>
<rect x="204" y="354" width="2" height="2" fill="#87CEEB"/>

<rect x="80" y="320" width="10" height="6" fill="#32CD32"/>
<rect x="81" y="321" width="2" height="2" fill="#98FB98"/>

<!-- 深度阴影点缀 -->
<rect x="0" y="360" width="4" height="4" fill="#000000"/>
<rect x="8" y="368" width="4" height="4" fill="#000000"/>
<rect x="16" y="376" width="4" height="4" fill="#000000"/>
<rect x="24" y="384" width="4" height="4" fill="#000000"/>

<rect x="370" y="350" width="4" height="4" fill="#000000"/>
<rect x="378" y="358" width="4" height="4" fill="#000000"/>
<rect x="386" y="366" width="4" height="4" fill="#000000"/>
<rect x="394" y="374" width="4" height="4" fill="#000000"/>

<!-- 洞穴深处的黑暗 -->
<rect x="0" y="390" width="400" height="10" fill="#000000"/>`,

    "mountain_sunset": `<!-- Mountain Sunset - Minecraft Pixel Style -->
<!-- Sky layers -->
<rect x="0" y="0" width="400" height="80" fill="#FF4500"/>
<rect x="0" y="80" width="400" height="60" fill="#FF8C00"/>
<rect x="0" y="140" width="400" height="60" fill="#FFA500"/>
<!-- Far mountains -->
<rect x="50" y="180" width="80" height="20" fill="#4B0082"/>
<rect x="70" y="160" width="40" height="20" fill="#4B0082"/>
<rect x="80" y="140" width="20" height="20" fill="#4B0082"/>
<rect x="270" y="170" width="100" height="30" fill="#4B0082"/>
<rect x="290" y="150" width="60" height="20" fill="#4B0082"/>
<rect x="300" y="130" width="40" height="20" fill="#4B0082"/>
<rect x="310" y="110" width="20" height="20" fill="#4B0082"/>
<!-- Near mountains -->
<rect x="120" y="160" width="160" height="40" fill="#2F4F4F"/>
<rect x="140" y="140" width="120" height="20" fill="#2F4F4F"/>
<rect x="160" y="120" width="80" height="20" fill="#2F4F4F"/>
<rect x="180" y="100" width="40" height="20" fill="#2F4F4F"/>
<rect x="190" y="80" width="20" height="20" fill="#2F4F4F"/>
<!-- Ground blocks -->
<rect x="0" y="200" width="400" height="200" fill="#654321"/>
<!-- Dirt texture blocks -->
<rect x="0" y="200" width="40" height="40" fill="#8B4513"/>
<rect x="80" y="200" width="40" height="40" fill="#8B4513"/>
<rect x="160" y="200" width="40" height="40" fill="#8B4513"/>
<rect x="240" y="200" width="40" height="40" fill="#8B4513"/>
<rect x="320" y="200" width="40" height="40" fill="#8B4513"/>
<rect x="40" y="240" width="40" height="40" fill="#8B4513"/>
<rect x="120" y="240" width="40" height="40" fill="#8B4513"/>
<rect x="200" y="240" width="40" height="40" fill="#8B4513"/>
<rect x="280" y="240" width="40" height="40" fill="#8B4513"/>
<rect x="360" y="240" width="40" height="40" fill="#8B4513"/>
<rect x="0" y="280" width="40" height="40" fill="#8B4513"/>
<rect x="80" y="280" width="40" height="40" fill="#8B4513"/>
<rect x="160" y="280" width="40" height="40" fill="#8B4513"/>
<rect x="240" y="280" width="40" height="40" fill="#8B4513"/>
<rect x="320" y="280" width="40" height="40" fill="#8B4513"/>
<rect x="40" y="320" width="40" height="40" fill="#8B4513"/>
<rect x="120" y="320" width="40" height="40" fill="#8B4513"/>
<rect x="200" y="320" width="40" height="40" fill="#8B4513"/>
<rect x="280" y="320" width="40" height="40" fill="#8B4513"/>
<rect x="360" y="320" width="40" height="40" fill="#8B4513"/>
<rect x="0" y="360" width="40" height="40" fill="#8B4513"/>
<rect x="80" y="360" width="40" height="40" fill="#8B4513"/>
<rect x="160" y="360" width="40" height="40" fill="#8B4513"/>
<rect x="240" y="360" width="40" height="40" fill="#8B4513"/>
<rect x="320" y="360" width="40" height="40" fill="#8B4513"/>`,

    "underwater_ruins": `<!-- Underwater Ruins - Minecraft Pixel Style -->
<!-- Water layers -->
<rect x="0" y="0" width="400" height="100" fill="#001F3F"/>
<rect x="0" y="100" width="400" height="100" fill="#003366"/>
<rect x="0" y="200" width="400" height="100" fill="#004080"/>
<rect x="0" y="300" width="400" height="100" fill="#0066CC"/>
<!-- Ancient stone pillars -->
<!-- Left pillar -->
<rect x="50" y="220" width="32" height="180" fill="#708090"/>
<rect x="50" y="220" width="8" height="180" fill="#5F6A75"/>
<rect x="74" y="220" width="8" height="180" fill="#8A95A1"/>
<rect x="54" y="224" width="24" height="8" fill="#696969"/>
<rect x="54" y="240" width="24" height="8" fill="#696969"/>
<rect x="54" y="256" width="24" height="8" fill="#696969"/>
<!-- Center pillar -->
<rect x="180" y="150" width="40" height="250" fill="#708090"/>
<rect x="180" y="150" width="8" height="250" fill="#5F6A75"/>
<rect x="212" y="150" width="8" height="250" fill="#8A95A1"/>
<rect x="184" y="154" width="32" height="8" fill="#696969"/>
<rect x="184" y="170" width="32" height="8" fill="#696969"/>
<rect x="184" y="186" width="32" height="8" fill="#696969"/>
<!-- Right pillar -->
<rect x="300" y="180" width="36" height="220" fill="#708090"/>
<rect x="300" y="180" width="8" height="220" fill="#5F6A75"/>
<rect x="328" y="180" width="8" height="220" fill="#8A95A1"/>
<rect x="304" y="184" width="28" height="8" fill="#696969"/>
<rect x="304" y="200" width="28" height="8" fill="#696969"/>
<!-- Seaweed -->
<rect x="90" y="360" width="8" height="40" fill="#2E8B57"/>
<rect x="94" y="352" width="8" height="8" fill="#2E8B57"/>
<rect x="98" y="344" width="8" height="8" fill="#2E8B57"/>
<rect x="94" y="336" width="8" height="8" fill="#2E8B57"/>
<rect x="140" y="370" width="8" height="30" fill="#2E8B57"/>
<rect x="144" y="362" width="8" height="8" fill="#2E8B57"/>
<rect x="148" y="354" width="8" height="8" fill="#2E8B57"/>
<rect x="250" y="380" width="8" height="20" fill="#2E8B57"/>
<rect x="254" y="372" width="8" height="8" fill="#2E8B57"/>
<rect x="258" y="364" width="8" height="8" fill="#2E8B57"/>
<rect x="254" y="356" width="8" height="8" fill="#2E8B57"/>
<!-- Bubbles rising -->
<rect x="100" y="300" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="102" y="280" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="100" y="260" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="102" y="240" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="100" y="220" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="260" y="320" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="262" y="300" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="260" y="280" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="262" y="260" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="160" y="340" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="162" y="320" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<rect x="160" y="300" width="4" height="4" fill="#FFFFFF" opacity="0.6"/>
<!-- Light rays from surface -->
<rect x="80" y="0" width="12" height="200" fill="#87CEEB" opacity="0.2"/>
<rect x="180" y="0" width="16" height="250" fill="#87CEEB" opacity="0.2"/>
<rect x="280" y="0" width="12" height="180" fill="#87CEEB" opacity="0.2"/>`
  },

  "BASE": {
    "human": `<!-- 人类基础层 - Minecraft强烈像素风格 -->
  
  <!-- 方块头部 -->
  <g id="head">
    <rect x="67" y="0" width="66" height="65" fill="#d2a679"/>
    
    <!-- 像素化皮肤纹理 -->
    <rect x="69" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="75" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="81" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="87" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="93" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="99" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="105" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="111" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="117" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="123" y="2" width="4" height="4" fill="#c49565"/>
    <rect x="129" y="2" width="4" height="4" fill="#c49565"/>
    
    <rect x="71" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="77" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="83" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="89" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="95" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="101" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="107" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="113" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="119" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="125" y="6" width="4" height="4" fill="#c49565"/>
    <rect x="131" y="6" width="4" height="4" fill="#c49565"/>
    
    <!-- 方块阴影 -->
    <rect x="67" y="0" width="8" height="65" fill="#b38451"/>
    <rect x="125" y="0" width="8" height="65" fill="#e8bb8d"/>
    <rect x="67" y="57" width="66" height="8" fill="#b38451"/>
    
    <!-- 硬边缘轮廓 -->
    <rect x="66" y="-1" width="68" height="1" fill="#a67541"/>
    <rect x="66" y="0" width="1" height="65" fill="#a67541"/>
    <rect x="133" y="0" width="1" height="65" fill="#a67541"/>
    <rect x="67" y="65" width="66" height="1" fill="#a67541"/>
    
    <!-- 脖子 -->
    <rect x="87" y="65" width="26" height="13" fill="#d2a679"/>
    <rect x="87" y="65" width="4" height="13" fill="#b38451"/>
    <rect x="109" y="65" width="4" height="13" fill="#e8bb8d"/>
  </g>
  
  <!-- 方块手臂 -->
  <g id="arms">
    <rect x="33" y="78" width="26" height="78" fill="#d2a679"/>
    <rect x="33" y="78" width="4" height="78" fill="#b38451"/>
    <rect x="55" y="78" width="4" height="78" fill="#e8bb8d"/>
    
    <!-- 皮肤纹理 -->
    <rect x="37" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="43" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="49" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="37" y="88" width="4" height="4" fill="#c49565"/>
    <rect x="43" y="88" width="4" height="4" fill="#c49565"/>
    <rect x="49" y="88" width="4" height="4" fill="#c49565"/>
    
    <!-- 左手 -->
    <rect x="33" y="156" width="26" height="26" fill="#d2a679"/>
    <rect x="33" y="156" width="4" height="26" fill="#b38451"/>
    
    <rect x="141" y="78" width="26" height="78" fill="#d2a679"/>
    <rect x="141" y="78" width="4" height="78" fill="#b38451"/>
    <rect x="163" y="78" width="4" height="78" fill="#e8bb8d"/>
    
    <!-- 皮肤纹理 -->
    <rect x="145" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="151" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="157" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="145" y="88" width="4" height="4" fill="#c49565"/>
    <rect x="151" y="88" width="4" height="4" fill="#c49565"/>
    <rect x="157" y="88" width="4" height="4" fill="#c49565"/>
    
    <!-- 右手 -->
    <rect x="141" y="156" width="26" height="26" fill="#d2a679"/>
    <rect x="163" y="156" width="4" height="26" fill="#e8bb8d"/>
  </g>
  
  <!-- 方块躯干 -->
  <g id="torso-base">
    <rect x="60" y="78" width="80" height="117" fill="#d2a679"/>
    <rect x="60" y="78" width="8" height="117" fill="#b38451"/>
    <rect x="132" y="78" width="8" height="117" fill="#e8bb8d"/>
    
    <!-- 密集的皮肤纹理 -->
    <rect x="68" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="74" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="80" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="86" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="92" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="98" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="104" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="110" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="116" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="122" y="82" width="4" height="4" fill="#c49565"/>
    <rect x="128" y="82" width="4" height="4" fill="#c49565"/>
    
    <rect x="70" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="76" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="82" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="88" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="94" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="100" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="106" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="112" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="118" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="124" y="86" width="4" height="4" fill="#c49565"/>
    <rect x="130" y="86" width="4" height="4" fill="#c49565"/>
    
    <!-- 胸部肌理 -->
    <rect x="88" y="95" width="24" height="8" fill="#b38451"/>
    <rect x="75" y="110" width="50" height="4" fill="#b38451"/>
  </g>
  
  <!-- 方块腿部 -->
  <g id="legs-base">
    <rect x="60" y="195" width="33" height="65" fill="#d2a679"/>
    <rect x="60" y="195" width="4" height="65" fill="#b38451"/>
    <rect x="89" y="195" width="4" height="65" fill="#e8bb8d"/>
    
    <rect x="107" y="195" width="33" height="65" fill="#d2a679"/>
    <rect x="107" y="195" width="4" height="65" fill="#b38451"/>
    <rect x="136" y="195" width="4" height="65" fill="#e8bb8d"/>
    
    <!-- 腿部纹理 -->
    <rect x="64" y="199" width="4" height="4" fill="#c49565"/>
    <rect x="70" y="199" width="4" height="4" fill="#c49565"/>
    <rect x="76" y="199" width="4" height="4" fill="#c49565"/>
    <rect x="82" y="199" width="4" height="4" fill="#c49565"/>
    
    <rect x="111" y="199" width="4" height="4" fill="#c49565"/>
    <rect x="117" y="199" width="4" height="4" fill="#c49565"/>
    <rect x="123" y="199" width="4" height="4" fill="#c49565"/>
    <rect x="129" y="199" width="4" height="4" fill="#c49565"/>
    
    <rect x="93" y="195" width="14" height="65" fill="#b38451"/>
  </g>`,

    "elf": `<!-- 精灵基础层 - Minecraft强烈像素风格 -->
  
  <!-- 方块头部 -->
  <g id="head">
    <rect x="67" y="0" width="66" height="65" fill="#b8d8b8"/>
    
    <!-- 像素化皮肤纹理 -->
    <rect x="69" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="75" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="81" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="87" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="93" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="99" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="105" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="111" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="117" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="123" y="2" width="4" height="4" fill="#a0c8a0"/>
    <rect x="129" y="2" width="4" height="4" fill="#a0c8a0"/>
    
    <rect x="71" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="77" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="83" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="89" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="95" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="101" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="107" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="113" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="119" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="125" y="6" width="4" height="4" fill="#a0c8a0"/>
    <rect x="131" y="6" width="4" height="4" fill="#a0c8a0"/>
    
    <!-- 方块阴影 -->
    <rect x="67" y="0" width="8" height="65" fill="#88b888"/>
    <rect x="125" y="0" width="8" height="65" fill="#d0e8d0"/>
    <rect x="67" y="57" width="66" height="8" fill="#88b888"/>
    
    <!-- 尖耳朵像素块 -->
    <rect x="59" y="12" width="8" height="12" fill="#b8d8b8"/>
    <rect x="55" y="16" width="4" height="8" fill="#b8d8b8"/>
    <rect x="51" y="18" width="4" height="4" fill="#b8d8b8"/>
    
    <rect x="133" y="12" width="8" height="12" fill="#b8d8b8"/>
    <rect x="141" y="16" width="4" height="8" fill="#b8d8b8"/>
    <rect x="145" y="18" width="4" height="4" fill="#b8d8b8"/>
    
    <!-- 硬边缘轮廓 -->
    <rect x="66" y="-1" width="68" height="1" fill="#78a878"/>
    <rect x="66" y="0" width="1" height="65" fill="#78a878"/>
    <rect x="133" y="0" width="1" height="65" fill="#78a878"/>
    <rect x="67" y="65" width="66" height="1" fill="#78a878"/>
    
    <!-- 脖子 -->
    <rect x="87" y="65" width="26" height="13" fill="#b8d8b8"/>
    <rect x="87" y="65" width="4" height="13" fill="#88b888"/>
    <rect x="109" y="65" width="4" height="13" fill="#d0e8d0"/>
  </g>
  
  <!-- 方块手臂 -->
  <g id="arms">
    <rect x="33" y="78" width="26" height="78" fill="#b8d8b8"/>
    <rect x="33" y="78" width="4" height="78" fill="#88b888"/>
    <rect x="55" y="78" width="4" height="78" fill="#d0e8d0"/>
    
    <!-- 皮肤纹理 -->
    <rect x="37" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="43" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="49" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="37" y="88" width="4" height="4" fill="#a0c8a0"/>
    <rect x="43" y="88" width="4" height="4" fill="#a0c8a0"/>
    <rect x="49" y="88" width="4" height="4" fill="#a0c8a0"/>
    
    <!-- 左手 -->
    <rect x="33" y="156" width="26" height="26" fill="#b8d8b8"/>
    <rect x="33" y="156" width="4" height="26" fill="#88b888"/>
    
    <rect x="141" y="78" width="26" height="78" fill="#b8d8b8"/>
    <rect x="141" y="78" width="4" height="78" fill="#88b888"/>
    <rect x="163" y="78" width="4" height="78" fill="#d0e8d0"/>
    
    <!-- 皮肤纹理 -->
    <rect x="145" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="151" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="157" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="145" y="88" width="4" height="4" fill="#a0c8a0"/>
    <rect x="151" y="88" width="4" height="4" fill="#a0c8a0"/>
    <rect x="157" y="88" width="4" height="4" fill="#a0c8a0"/>
    
    <!-- 右手 -->
    <rect x="141" y="156" width="26" height="26" fill="#b8d8b8"/>
    <rect x="163" y="156" width="4" height="26" fill="#d0e8d0"/>
  </g>
  
  <!-- 方块躯干 -->
  <g id="torso-base">
    <rect x="60" y="78" width="80" height="117" fill="#b8d8b8"/>
    <rect x="60" y="78" width="8" height="117" fill="#88b888"/>
    <rect x="132" y="78" width="8" height="117" fill="#d0e8d0"/>
    
    <!-- 密集的皮肤纹理 -->
    <rect x="68" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="74" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="80" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="86" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="92" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="98" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="104" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="110" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="116" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="122" y="82" width="4" height="4" fill="#a0c8a0"/>
    <rect x="128" y="82" width="4" height="4" fill="#a0c8a0"/>
    
    <rect x="70" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="76" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="82" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="88" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="94" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="100" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="106" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="112" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="118" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="124" y="86" width="4" height="4" fill="#a0c8a0"/>
    <rect x="130" y="86" width="4" height="4" fill="#a0c8a0"/>
    
    <!-- 胸部肌理 -->
    <rect x="88" y="95" width="24" height="8" fill="#88b888"/>
    <rect x="75" y="110" width="50" height="4" fill="#88b888"/>
  </g>
  
  <!-- 方块腿部 -->
  <g id="legs-base">
    <rect x="60" y="195" width="33" height="65" fill="#b8d8b8"/>
    <rect x="60" y="195" width="4" height="65" fill="#88b888"/>
    <rect x="89" y="195" width="4" height="65" fill="#d0e8d0"/>
    
    <rect x="107" y="195" width="33" height="65" fill="#b8d8b8"/>
    <rect x="107" y="195" width="4" height="65" fill="#88b888"/>
    <rect x="136" y="195" width="4" height="65" fill="#d0e8d0"/>
    
    <!-- 腿部纹理 -->
    <rect x="64" y="199" width="4" height="4" fill="#a0c8a0"/>
    <rect x="70" y="199" width="4" height="4" fill="#a0c8a0"/>
    <rect x="76" y="199" width="4" height="4" fill="#a0c8a0"/>
    <rect x="82" y="199" width="4" height="4" fill="#a0c8a0"/>
    
    <rect x="111" y="199" width="4" height="4" fill="#a0c8a0"/>
    <rect x="117" y="199" width="4" height="4" fill="#a0c8a0"/>
    <rect x="123" y="199" width="4" height="4" fill="#a0c8a0"/>
    <rect x="129" y="199" width="4" height="4" fill="#a0c8a0"/>
    
    <rect x="93" y="195" width="14" height="65" fill="#88b888"/>
  </g>`,

    "undead": `<!-- 亡灵基础层 - Minecraft强烈像素风格 -->
  
  <!-- 方块头部 -->
  <g id="head">
    <rect x="67" y="0" width="66" height="65" fill="#9099a9"/>
    
    <!-- 像素化亡灵皮肤纹理 -->
    <rect x="69" y="2" width="4" height="4" fill="#707888"/>
    <rect x="75" y="2" width="4" height="4" fill="#707888"/>
    <rect x="81" y="2" width="4" height="4" fill="#707888"/>
    <rect x="87" y="2" width="4" height="4" fill="#707888"/>
    <rect x="93" y="2" width="4" height="4" fill="#707888"/>
    <rect x="99" y="2" width="4" height="4" fill="#707888"/>
    <rect x="105" y="2" width="4" height="4" fill="#707888"/>
    <rect x="111" y="2" width="4" height="4" fill="#707888"/>
    <rect x="117" y="2" width="4" height="4" fill="#707888"/>
    <rect x="123" y="2" width="4" height="4" fill="#707888"/>
    <rect x="129" y="2" width="4" height="4" fill="#707888"/>
    
    <rect x="71" y="6" width="4" height="4" fill="#707888"/>
    <rect x="77" y="6" width="4" height="4" fill="#707888"/>
    <rect x="83" y="6" width="4" height="4" fill="#707888"/>
    <rect x="89" y="6" width="4" height="4" fill="#707888"/>
    <rect x="95" y="6" width="4" height="4" fill="#707888"/>
    <rect x="101" y="6" width="4" height="4" fill="#707888"/>
    <rect x="107" y="6" width="4" height="4" fill="#707888"/>
    <rect x="113" y="6" width="4" height="4" fill="#707888"/>
    <rect x="119" y="6" width="4" height="4" fill="#707888"/>
    <rect x="125" y="6" width="4" height="4" fill="#707888"/>
    <rect x="131" y="6" width="4" height="4" fill="#707888"/>
    
    <!-- 方块阴影 -->
    <rect x="67" y="0" width="8" height="65" fill="#606878"/>
    <rect x="125" y="0" width="8" height="65" fill="#b0b9c9"/>
    <rect x="67" y="57" width="66" height="8" fill="#606878"/>
    
    <!-- 裂痕疤痕像素块 -->
    <rect x="85" y="18" width="4" height="12" fill="#505868"/>
    <rect x="89" y="22" width="8" height="4" fill="#505868"/>
    <rect x="108" y="28" width="4" height="16" fill="#505868"/>
    <rect x="112" y="32" width="8" height="4" fill="#505868"/>
    
    <!-- 硬边缘轮廓 -->
    <rect x="66" y="-1" width="68" height="1" fill="#505868"/>
    <rect x="66" y="0" width="1" height="65" fill="#505868"/>
    <rect x="133" y="0" width="1" height="65" fill="#505868"/>
    <rect x="67" y="65" width="66" height="1" fill="#505868"/>
    
    <!-- 透明度建议的棋盘抖动 -->
    <rect x="69" y="4" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    <rect x="73" y="6" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    <rect x="125" y="8" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    <rect x="129" y="10" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    
    <!-- 脖子 -->
    <rect x="87" y="65" width="26" height="13" fill="#9099a9"/>
    <rect x="87" y="65" width="4" height="13" fill="#606878"/>
    <rect x="109" y="65" width="4" height="13" fill="#b0b9c9"/>
  </g>
  
  <!-- 方块手臂 -->
  <g id="arms">
    <rect x="33" y="78" width="26" height="78" fill="#9099a9"/>
    <rect x="33" y="78" width="4" height="78" fill="#606878"/>
    <rect x="55" y="78" width="4" height="78" fill="#b0b9c9"/>
    
    <!-- 亡灵皮肤纹理 -->
    <rect x="37" y="82" width="4" height="4" fill="#707888"/>
    <rect x="43" y="82" width="4" height="4" fill="#707888"/>
    <rect x="49" y="82" width="4" height="4" fill="#707888"/>
    <rect x="37" y="88" width="4" height="4" fill="#707888"/>
    <rect x="43" y="88" width="4" height="4" fill="#707888"/>
    <rect x="49" y="88" width="4" height="4" fill="#707888"/>
    
    <!-- 左手 -->
    <rect x="33" y="156" width="26" height="26" fill="#9099a9"/>
    <rect x="33" y="156" width="4" height="26" fill="#606878"/>
    
    <rect x="141" y="78" width="26" height="78" fill="#9099a9"/>
    <rect x="141" y="78" width="4" height="78" fill="#606878"/>
    <rect x="163" y="78" width="4" height="78" fill="#b0b9c9"/>
    
    <!-- 亡灵皮肤纹理 -->
    <rect x="145" y="82" width="4" height="4" fill="#707888"/>
    <rect x="151" y="82" width="4" height="4" fill="#707888"/>
    <rect x="157" y="82" width="4" height="4" fill="#707888"/>
    <rect x="145" y="88" width="4" height="4" fill="#707888"/>
    <rect x="151" y="88" width="4" height="4" fill="#707888"/>
    <rect x="157" y="88" width="4" height="4" fill="#707888"/>
    
    <!-- 右手 -->
    <rect x="141" y="156" width="26" height="26" fill="#9099a9"/>
    <rect x="163" y="156" width="4" height="26" fill="#b0b9c9"/>
    
    <!-- 稀疏方形像素光环 -->
    <rect x="29" y="82" width="2" height="2" fill="#c0c8d0" opacity="0.4"/>
    <rect x="25" y="88" width="2" height="2" fill="#c0c8d0" opacity="0.4"/>
    <rect x="169" y="84" width="2" height="2" fill="#c0c8d0" opacity="0.4"/>
    <rect x="173" y="90" width="2" height="2" fill="#c0c8d0" opacity="0.4"/>
  </g>
  
  <!-- 方块躯干 -->
  <g id="torso-base">
    <rect x="60" y="78" width="80" height="117" fill="#9099a9"/>
    <rect x="60" y="78" width="8" height="117" fill="#606878"/>
    <rect x="132" y="78" width="8" height="117" fill="#b0b9c9"/>
    
    <!-- 密集的亡灵皮肤纹理 -->
    <rect x="68" y="82" width="4" height="4" fill="#707888"/>
    <rect x="74" y="82" width="4" height="4" fill="#707888"/>
    <rect x="80" y="82" width="4" height="4" fill="#707888"/>
    <rect x="86" y="82" width="4" height="4" fill="#707888"/>
    <rect x="92" y="82" width="4" height="4" fill="#707888"/>
    <rect x="98" y="82" width="4" height="4" fill="#707888"/>
    <rect x="104" y="82" width="4" height="4" fill="#707888"/>
    <rect x="110" y="82" width="4" height="4" fill="#707888"/>
    <rect x="116" y="82" width="4" height="4" fill="#707888"/>
    <rect x="122" y="82" width="4" height="4" fill="#707888"/>
    <rect x="128" y="82" width="4" height="4" fill="#707888"/>
    
    <rect x="70" y="86" width="4" height="4" fill="#707888"/>
    <rect x="76" y="86" width="4" height="4" fill="#707888"/>
    <rect x="82" y="86" width="4" height="4" fill="#707888"/>
    <rect x="88" y="86" width="4" height="4" fill="#707888"/>
    <rect x="94" y="86" width="4" height="4" fill="#707888"/>
    <rect x="100" y="86" width="4" height="4" fill="#707888"/>
    <rect x="106" y="86" width="4" height="4" fill="#707888"/>
    <rect x="112" y="86" width="4" height="4" fill="#707888"/>
    <rect x="118" y="86" width="4" height="4" fill="#707888"/>
    <rect x="124" y="86" width="4" height="4" fill="#707888"/>
    <rect x="130" y="86" width="4" height="4" fill="#707888"/>
    
    <!-- 更多透明度抖动 -->
    <rect x="62" y="84" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    <rect x="66" y="86" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    <rect x="134" y="88" width="2" height="2" fill="#ffffff" opacity="0.2"/>
    
    <!-- 胸部肌理 -->
    <rect x="88" y="95" width="24" height="8" fill="#606878"/>
    <rect x="75" y="110" width="50" height="4" fill="#606878"/>
  </g>
  
  <!-- 方块腿部 -->
  <g id="legs-base">
    <rect x="60" y="195" width="33" height="65" fill="#9099a9"/>
    <rect x="60" y="195" width="4" height="65" fill="#606878"/>
    <rect x="89" y="195" width="4" height="65" fill="#b0b9c9"/>
    
    <rect x="107" y="195" width="33" height="65" fill="#9099a9"/>
    <rect x="107" y="195" width="4" height="65" fill="#606878"/>
    <rect x="136" y="195" width="4" height="65" fill="#b0b9c9"/>
    
    <!-- 腿部纹理 -->
    <rect x="64" y="199" width="4" height="4" fill="#707888"/>
    <rect x="70" y="199" width="4" height="4" fill="#707888"/>
    <rect x="76" y="199" width="4" height="4" fill="#707888"/>
    <rect x="82" y="199" width="4" height="4" fill="#707888"/>
    
    <rect x="111" y="199" width="4" height="4" fill="#707888"/>
    <rect x="117" y="199" width="4" height="4" fill="#707888"/>
    <rect x="123" y="199" width="4" height="4" fill="#707888"/>
    <rect x="129" y="199" width="4" height="4" fill="#707888"/>
    
    <rect x="93" y="195" width="14" height="65" fill="#606878"/>
  </g>`,

    "orc": `<!-- Orc Base Layer - Minecraft Pixel Style -->
  
  <!-- Block head (slightly larger) -->
  <g id="head">
    <rect x="65" y="0" width="70" height="68" fill="#2F7D32"/>
    
    <!-- Pixel skin texture -->
    <rect x="69" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="77" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="85" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="93" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="101" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="109" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="117" y="4" width="4" height="4" fill="#1B5E20"/>
    <rect x="125" y="4" width="4" height="4" fill="#1B5E20"/>
    
    <rect x="71" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="79" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="87" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="95" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="103" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="111" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="119" y="12" width="4" height="4" fill="#1B5E20"/>
    <rect x="127" y="12" width="4" height="4" fill="#1B5E20"/>
    
    <!-- Block shadows -->
    <rect x="65" y="0" width="8" height="68" fill="#1B5E20"/>
    <rect x="127" y="0" width="8" height="68" fill="#388E3C"/>
    <rect x="65" y="60" width="70" height="8" fill="#1B5E20"/>
    
    <!-- Tusks -->
    <rect x="85" y="50" width="4" height="8" fill="#FFFFFF"/>
    <rect x="111" y="50" width="4" height="8" fill="#FFFFFF"/>
    
    <!-- Neck -->
    <rect x="85" y="68" width="30" height="13" fill="#2F7D32"/>
    <rect x="85" y="68" width="4" height="13" fill="#1B5E20"/>
    <rect x="111" y="68" width="4" height="13" fill="#388E3C"/>
  </g>
  
  <!-- Block arms (more muscular) -->
  <g id="arms">
    <!-- Left arm -->
    <rect x="30" y="81" width="30" height="78" fill="#2F7D32"/>
    <rect x="30" y="81" width="4" height="78" fill="#1B5E20"/>
    <rect x="56" y="81" width="4" height="78" fill="#388E3C"/>
    
    <!-- Muscle texture -->
    <rect x="36" y="85" width="4" height="4" fill="#1B5E20"/>
    <rect x="44" y="85" width="4" height="4" fill="#1B5E20"/>
    <rect x="52" y="85" width="4" height="4" fill="#1B5E20"/>
    <rect x="38" y="93" width="4" height="4" fill="#1B5E20"/>
    <rect x="46" y="93" width="4" height="4" fill="#1B5E20"/>
    
    <!-- Left hand -->
    <rect x="30" y="159" width="30" height="26" fill="#2F7D32"/>
    <rect x="30" y="159" width="4" height="26" fill="#1B5E20"/>
    
    <!-- Right arm -->
    <rect x="140" y="81" width="30" height="78" fill="#2F7D32"/>
    <rect x="140" y="81" width="4" height="78" fill="#1B5E20"/>
    <rect x="166" y="81" width="4" height="78" fill="#388E3C"/>
    
    <!-- Muscle texture -->
    <rect x="146" y="85" width="4" height="4" fill="#1B5E20"/>
    <rect x="154" y="85" width="4" height="4" fill="#1B5E20"/>
    <rect x="162" y="85" width="4" height="4" fill="#1B5E20"/>
    <rect x="148" y="93" width="4" height="4" fill="#1B5E20"/>
    <rect x="156" y="93" width="4" height="4" fill="#1B5E20"/>
    
    <!-- Right hand -->
    <rect x="140" y="159" width="30" height="26" fill="#2F7D32"/>
    <rect x="166" y="159" width="4" height="26" fill="#388E3C"/>
  </g>
  
  <!-- Block torso (wider) -->
  <g id="torso-base">
    <rect x="56" y="81" width="88" height="120" fill="#2F7D32"/>
    <rect x="56" y="81" width="8" height="120" fill="#1B5E20"/>
    <rect x="136" y="81" width="8" height="120" fill="#388E3C"/>
    
    <!-- Dense muscle texture -->
    <rect x="68" y="85" width="8" height="8" fill="#1B5E20"/>
    <rect x="80" y="85" width="8" height="8" fill="#1B5E20"/>
    <rect x="92" y="85" width="8" height="8" fill="#1B5E20"/>
    <rect x="104" y="85" width="8" height="8" fill="#1B5E20"/>
    <rect x="116" y="85" width="8" height="8" fill="#1B5E20"/>
    <rect x="128" y="85" width="8" height="8" fill="#1B5E20"/>
    
    <rect x="72" y="97" width="8" height="8" fill="#1B5E20"/>
    <rect x="84" y="97" width="8" height="8" fill="#1B5E20"/>
    <rect x="96" y="97" width="8" height="8" fill="#1B5E20"/>
    <rect x="108" y="97" width="8" height="8" fill="#1B5E20"/>
    <rect x="120" y="97" width="8" height="8" fill="#1B5E20"/>
    
    <!-- Chest muscles -->
    <rect x="76" y="105" width="24" height="8" fill="#1B5E20"/>
    <rect x="100" y="105" width="24" height="8" fill="#1B5E20"/>
    <rect x="88" y="120" width="24" height="4" fill="#1B5E20"/>
  </g>
  
  <!-- Block legs (thick) -->
  <g id="legs-base">
    <rect x="58" y="201" width="36" height="59" fill="#2F7D32"/>
    <rect x="58" y="201" width="4" height="59" fill="#1B5E20"/>
    <rect x="90" y="201" width="4" height="59" fill="#388E3C"/>
    
    <rect x="106" y="201" width="36" height="59" fill="#2F7D32"/>
    <rect x="106" y="201" width="4" height="59" fill="#1B5E20"/>
    <rect x="138" y="201" width="4" height="59" fill="#388E3C"/>
    
    <!-- Leg texture -->
    <rect x="64" y="205" width="4" height="4" fill="#1B5E20"/>
    <rect x="72" y="205" width="4" height="4" fill="#1B5E20"/>
    <rect x="80" y="205" width="4" height="4" fill="#1B5E20"/>
    
    <rect x="112" y="205" width="4" height="4" fill="#1B5E20"/>
    <rect x="120" y="205" width="4" height="4" fill="#1B5E20"/>
    <rect x="128" y="205" width="4" height="4" fill="#1B5E20"/>
    
    <!-- Gap between legs -->
    <rect x="94" y="201" width="12" height="59" fill="#1B5E20"/>
  </g>`,

    "frost_clan": `<rect x="67" y="0" width="66" height="65" fill="#87CEEB"/>
<rect x="69" y="2" width="4" height="4" fill="#F0F8FF"/>
<rect x="75" y="2" width="4" height="4" fill="#FFFFFF"/>
<rect x="81" y="2" width="4" height="4" fill="#F0F8FF"/>
<rect x="87" y="2" width="4" height="4" fill="#FFFFFF"/>
<rect x="93" y="2" width="4" height="4" fill="#F0F8FF"/>
<rect x="99" y="2" width="4" height="4" fill="#FFFFFF"/>
<rect x="105" y="2" width="4" height="4" fill="#F0F8FF"/>
<rect x="111" y="2" width="4" height="4" fill="#FFFFFF"/>
<rect x="117" y="2" width="4" height="4" fill="#F0F8FF"/>
<rect x="123" y="2" width="4" height="4" fill="#FFFFFF"/>
<rect x="129" y="2" width="4" height="4" fill="#F0F8FF"/>
<rect x="71" y="6" width="4" height="4" fill="#FFFFFF"/>
<rect x="77" y="6" width="4" height="4" fill="#F0F8FF"/>
<rect x="83" y="6" width="4" height="4" fill="#FFFFFF"/>
<rect x="89" y="6" width="4" height="4" fill="#F0F8FF"/>
<rect x="95" y="6" width="4" height="4" fill="#FFFFFF"/>
<rect x="101" y="6" width="4" height="4" fill="#F0F8FF"/>
<rect x="107" y="6" width="4" height="4" fill="#FFFFFF"/>
<rect x="113" y="6" width="4" height="4" fill="#F0F8FF"/>
<rect x="119" y="6" width="4" height="4" fill="#FFFFFF"/>
<rect x="125" y="6" width="4" height="4" fill="#F0F8FF"/>
<rect x="131" y="6" width="4" height="4" fill="#FFFFFF"/>
<rect x="67" y="0" width="8" height="65" fill="#4682B4"/>
<rect x="125" y="0" width="8" height="65" fill="#B0E0E6"/>
<rect x="67" y="57" width="66" height="8" fill="#4682B4"/>
<rect x="66" y="-1" width="68" height="1" fill="#2F4F4F"/>
<rect x="66" y="0" width="1" height="65" fill="#2F4F4F"/>
<rect x="133" y="0" width="1" height="65" fill="#2F4F4F"/>
<rect x="67" y="65" width="66" height="1" fill="#2F4F4F"/>
<rect x="87" y="65" width="26" height="13" fill="#87CEEB"/>
<rect x="87" y="65" width="4" height="13" fill="#4682B4"/>
<rect x="109" y="65" width="4" height="13" fill="#B0E0E6"/>
<rect x="33" y="78" width="26" height="78" fill="#87CEEB"/>
<rect x="33" y="78" width="4" height="78" fill="#4682B4"/>
<rect x="55" y="78" width="4" height="78" fill="#B0E0E6"/>
<rect x="37" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="43" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="49" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="37" y="88" width="4" height="4" fill="#F0F8FF"/>
<rect x="43" y="88" width="4" height="4" fill="#FFFFFF"/>
<rect x="49" y="88" width="4" height="4" fill="#F0F8FF"/>
<rect x="33" y="156" width="26" height="26" fill="#87CEEB"/>
<rect x="33" y="156" width="4" height="26" fill="#4682B4"/>
<rect x="141" y="78" width="26" height="78" fill="#87CEEB"/>
<rect x="141" y="78" width="4" height="78" fill="#4682B4"/>
<rect x="163" y="78" width="4" height="78" fill="#B0E0E6"/>
<rect x="145" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="151" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="157" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="145" y="88" width="4" height="4" fill="#F0F8FF"/>
<rect x="151" y="88" width="4" height="4" fill="#FFFFFF"/>
<rect x="157" y="88" width="4" height="4" fill="#F0F8FF"/>
<rect x="141" y="156" width="26" height="26" fill="#87CEEB"/>
<rect x="163" y="156" width="4" height="26" fill="#B0E0E6"/>
<rect x="60" y="78" width="80" height="117" fill="#87CEEB"/>
<rect x="60" y="78" width="8" height="117" fill="#4682B4"/>
<rect x="132" y="78" width="8" height="117" fill="#B0E0E6"/>
<rect x="68" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="74" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="80" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="86" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="92" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="98" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="104" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="110" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="116" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="122" y="82" width="4" height="4" fill="#F0F8FF"/>
<rect x="128" y="82" width="4" height="4" fill="#FFFFFF"/>
<rect x="70" y="86" width="4" height="4" fill="#F0F8FF"/>
<rect x="76" y="86" width="4" height="4" fill="#FFFFFF"/>
<rect x="82" y="86" width="4" height="4" fill="#F0F8FF"/>
<rect x="88" y="86" width="4" height="4" fill="#FFFFFF"/>
<rect x="94" y="86" width="4" height="4" fill="#F0F8FF"/>
<rect x="100" y="86" width="4" height="4" fill="#FFFFFF"/>
<rect x="106" y="86" width="4" height="4" fill="#F0F8FF"/>
<rect x="112" y="86" width="4" height="4" fill="#FFFFFF"/>
<rect x="118" y="86" width="4" height="4" fill="#F0F8FF"/>
<rect x="124" y="86" width="4" height="4" fill="#FFFFFF"/>
<rect x="130" y="86" width="4" height="4" fill="#F0F8FF"/>
<rect x="88" y="95" width="24" height="8" fill="#4682B4"/>
<rect x="75" y="110" width="50" height="4" fill="#4682B4"/>
<rect x="60" y="195" width="33" height="65" fill="#87CEEB"/>
<rect x="60" y="195" width="4" height="65" fill="#4682B4"/>
<rect x="89" y="195" width="4" height="65" fill="#B0E0E6"/>
<rect x="107" y="195" width="33" height="65" fill="#87CEEB"/>
<rect x="107" y="195" width="4" height="65" fill="#4682B4"/>
<rect x="136" y="195" width="4" height="65" fill="#B0E0E6"/>
<rect x="64" y="199" width="4" height="4" fill="#FFFFFF"/>
<rect x="70" y="199" width="4" height="4" fill="#F0F8FF"/>
<rect x="76" y="199" width="4" height="4" fill="#FFFFFF"/>
<rect x="82" y="199" width="4" height="4" fill="#F0F8FF"/>
<rect x="111" y="199" width="4" height="4" fill="#FFFFFF"/>
<rect x="117" y="199" width="4" height="4" fill="#F0F8FF"/>
<rect x="123" y="199" width="4" height="4" fill="#FFFFFF"/>
<rect x="129" y="199" width="4" height="4" fill="#F0F8FF"/>
<rect x="93" y="195" width="14" height="65" fill="#4682B4"/>`
  },

  "EYES": {
    "blue_spark": `<rect x="8" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="8" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="8" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="5" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="29" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="14" y="5" width="7" height="6" fill="#1E90FF"/>
<rect x="16" y="6" width="3" height="3" fill="#1a1a1a"/>
<rect x="18" y="6" width="1" height="1" fill="#ffffff"/>
<rect x="37" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="37" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="37" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="34" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="58" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="43" y="5" width="7" height="6" fill="#1E90FF"/>
<rect x="45" y="6" width="3" height="3" fill="#1a1a1a"/>
<rect x="47" y="6" width="1" height="1" fill="#ffffff"/>
<rect x="8" y="0" width="21" height="2" fill="#8b6239"/>
<rect x="37" y="0" width="21" height="2" fill="#8b6239"/>`,

    "red_glow": `<rect x="8" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="8" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="8" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="5" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="29" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="14" y="5" width="7" height="6" fill="#DC143C"/>
<rect x="16" y="6" width="3" height="3" fill="#FF6347"/>
<rect x="13" y="4" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="22" y="4" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="13" y="11" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="22" y="11" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="12" y="5" width="1" height="6" fill="#FF6347" opacity="0.4"/>
<rect x="23" y="5" width="1" height="6" fill="#FF6347" opacity="0.4"/>
<rect x="37" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="37" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="37" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="34" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="58" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="43" y="5" width="7" height="6" fill="#DC143C"/>
<rect x="45" y="6" width="3" height="3" fill="#FF6347"/>
<rect x="42" y="4" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="51" y="4" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="42" y="11" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="51" y="11" width="1" height="1" fill="#FF6347" opacity="0.6"/>
<rect x="41" y="5" width="1" height="6" fill="#FF6347" opacity="0.4"/>
<rect x="52" y="5" width="1" height="6" fill="#FF6347" opacity="0.4"/>
<rect x="8" y="0" width="21" height="2" fill="#8b6239"/>
<rect x="37" y="0" width="21" height="2" fill="#8b6239"/>`,

    "void_black": `<rect x="8" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="8" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="8" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="5" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="29" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="13" y="4" width="9" height="8" fill="#808080"/>
<rect x="14" y="5" width="7" height="6" fill="#000000"/>
<rect x="16" y="5" width="1" height="1" fill="#1a1a1a"/>
<rect x="19" y="5" width="1" height="1" fill="#1a1a1a"/>
<rect x="37" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="37" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="37" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="34" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="58" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="42" y="4" width="9" height="8" fill="#808080"/>
<rect x="43" y="5" width="7" height="6" fill="#000000"/>
<rect x="45" y="5" width="1" height="1" fill="#1a1a1a"/>
<rect x="48" y="5" width="1" height="1" fill="#1a1a1a"/>
<rect x="8" y="0" width="21" height="2" fill="#8b6239"/>
<rect x="37" y="0" width="21" height="2" fill="#8b6239"/>`,

    "purple_mystic": `<rect x="8" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="8" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="8" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="5" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="29" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="14" y="5" width="7" height="6" fill="#6A0DAD"/>
<rect x="16" y="6" width="3" height="3" fill="#000000"/>
<rect x="17" y="6" width="1" height="1" fill="#FF00FF"/>
<rect x="37" y="3" width="21" height="10" fill="#ffffff"/>
<rect x="37" y="3" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="37" y="10" width="21" height="3" fill="#2c1810" opacity="0.2"/>
<rect x="34" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="58" y="3" width="3" height="10" fill="#2c1810"/>
<rect x="43" y="5" width="7" height="6" fill="#6A0DAD"/>
<rect x="45" y="6" width="3" height="3" fill="#000000"/>
<rect x="46" y="6" width="1" height="1" fill="#FF00FF"/>
<rect x="8" y="0" width="21" height="2" fill="#8b6239"/>
<rect x="37" y="0" width="21" height="2" fill="#8b6239"/>`,

    "yellow_cat": `<rect x="8" y="3" width="21" height="10" fill="#FFFACD"/>
<rect x="8" y="3" width="21" height="3" fill="#8B4513"/>
<rect x="8" y="10" width="21" height="3" fill="#8B4513"/>
<rect x="5" y="3" width="3" height="10" fill="#8B4513"/>
<rect x="29" y="3" width="3" height="10" fill="#8B4513"/>
<rect x="14" y="5" width="7" height="6" fill="#FFD700"/>
<rect x="17" y="4" width="1" height="8" fill="#000000"/>
<rect x="37" y="3" width="21" height="10" fill="#FFFACD"/>
<rect x="37" y="3" width="21" height="3" fill="#8B4513"/>
<rect x="37" y="10" width="21" height="3" fill="#8B4513"/>
<rect x="34" y="3" width="3" height="10" fill="#8B4513"/>
<rect x="58" y="3" width="3" height="10" fill="#8B4513"/>
<rect x="43" y="5" width="7" height="6" fill="#FFD700"/>
<rect x="46" y="4" width="1" height="8" fill="#000000"/>
<rect x="8" y="0" width="21" height="2" fill="#8b6239"/>
<rect x="37" y="0" width="21" height="2" fill="#8b6239"/>`
  },

  "MOUTH": {
    "grit_teeth": `<!-- Rectangle mouth opening with aggressive angle - centered -->
  <rect x="11" y="4" width="18" height="6" fill="#2c1810"/>
  <rect x="9" y="5" width="2" height="4" fill="#2c1810"/>
  <rect x="29" y="5" width="2" height="4" fill="#2c1810"/>
  
  <!-- White blocky teeth row -->
  <rect x="11" y="5" width="3" height="4" fill="#ffffff"/>
  <rect x="15" y="5" width="3" height="4" fill="#ffffff"/>
  <rect x="19" y="5" width="3" height="4" fill="#ffffff"/>
  <rect x="23" y="5" width="3" height="4" fill="#ffffff"/>
  <rect x="27" y="5" width="3" height="4" fill="#ffffff"/>
  
  <!-- Dark outline -->
  <rect x="10" y="3" width="20" height="1" fill="#1a0f08"/>
  <rect x="8" y="4" width="1" height="6" fill="#1a0f08"/>
  <rect x="31" y="4" width="1" height="6" fill="#1a0f08"/>
  <rect x="10" y="10" width="20" height="1" fill="#1a0f08"/>`,

    "surprised_open": `<!-- Square open mouth -->
  <rect x="18" y="4" width="6" height="6" fill="#8B0000"/>
  <rect x="17" y="3" width="8" height="1" fill="#1a0f08"/>
  <rect x="16" y="4" width="1" height="6" fill="#1a0f08"/>
  <rect x="25" y="4" width="1" height="6" fill="#1a0f08"/>
  <rect x="17" y="10" width="8" height="1" fill="#1a0f08"/>
  
  <!-- 1px highlight at top edge -->
  <rect x="18" y="4" width="6" height="1" fill="#FF6B6B"/>`,

    "smile_simple": `<!-- Simple smile - more compact design -->
  <!-- Upper lip line -->
  <rect x="12" y="3" width="16" height="1" fill="#c66b5a"/>
  <!-- Mouth opening -->
  <rect x="10" y="4" width="20" height="3" fill="#c66b5a"/>
  <rect x="8" y="5" width="24" height="1" fill="#c66b5a"/>
  <!-- Teeth -->
  <rect x="13" y="4" width="2" height="2" fill="#ffffff"/>
  <rect x="16" y="4" width="2" height="2" fill="#ffffff"/>
  <rect x="19" y="4" width="2" height="2" fill="#ffffff"/>
  <rect x="22" y="4" width="2" height="2" fill="#ffffff"/>
  <rect x="25" y="4" width="2" height="2" fill="#ffffff"/>
  <!-- Lower lip curve -->
  <rect x="10" y="7" width="4" height="1" fill="#d4826a"/>
  <rect x="14" y="8" width="12" height="1" fill="#d4826a"/>
  <rect x="26" y="7" width="4" height="1" fill="#d4826a"/>`,

    "neutral_line": `<!-- Neutral Line Mouth - Minecraft Pixel Style -->
  
  <!-- Simple horizontal line -->
  <rect x="10" y="5" width="20" height="2" fill="#654321"/>`,

    "fangs_vampire": `<!-- Vampire Fangs Mouth - Minecraft Pixel Style -->
  
  <!-- Upper lip -->
  <rect x="10" y="0" width="20" height="2" fill="#8B0000"/>
  
  <!-- Mouth opening -->
  <rect x="10" y="2" width="20" height="4" fill="#000000"/>
  
  <!-- Lower lip -->
  <rect x="10" y="6" width="20" height="2" fill="#8B0000"/>
  
  <!-- Left fang -->
  <rect x="13" y="2" width="4" height="6" fill="#FFFFFF"/>
  <rect x="14" y="8" width="2" height="2" fill="#FFFFFF"/>
  
  <!-- Right fang -->
  <rect x="23" y="2" width="4" height="6" fill="#FFFFFF"/>
  <rect x="24" y="8" width="2" height="2" fill="#FFFFFF"/>
  
  <!-- Blood drop (optional detail) -->
  <rect x="15" y="10" width="2" height="2" fill="#DC143C"/>`
  },

  "FACE_FEATURE": {
    "blue_tattoo": `<!-- Angular tribal tattoo around left eye -->
  <rect x="15" y="15" width="2" height="6" fill="#0080FF"/>
  <rect x="17" y="15" width="4" height="2" fill="#0080FF"/>
  <rect x="21" y="17" width="2" height="4" fill="#0080FF"/>
  <rect x="17" y="21" width="4" height="2" fill="#0080FF"/>
  <rect x="15" y="23" width="2" height="4" fill="#0080FF"/>
  
  <!-- Stepped corners accent -->
  <rect x="13" y="17" width="2" height="2" fill="#00BFFF"/>
  <rect x="23" y="19" width="2" height="2" fill="#00BFFF"/>
  <rect x="19" y="25" width="2" height="2" fill="#00BFFF"/>
  
  <!-- Symmetrical fragments around right eye -->
  <rect x="55" y="18" width="2" height="4" fill="#0080FF"/>
  <rect x="57" y="16" width="4" height="2" fill="#0080FF"/>
  <rect x="61" y="18" width="2" height="4" fill="#0080FF"/>
  <rect x="57" y="22" width="4" height="2" fill="#0080FF"/>
  
  <!-- Accent fragments -->
  <rect x="53" y="20" width="2" height="2" fill="#00BFFF"/>
  <rect x="63" y="20" width="2" height="2" fill="#00BFFF"/>`,

    "scar_cheek": `<!-- Battle scar across left side -->
  <rect x="18" y="16" width="3" height="8" fill="#c67b7b"/>
  <rect x="20" y="22" width="3" height="8" fill="#c67b7b"/>
  <rect x="22" y="28" width="3" height="8" fill="#c67b7b"/>
  <rect x="24" y="34" width="3" height="8" fill="#c67b7b"/>
  <rect x="26" y="40" width="3" height="8" fill="#c67b7b"/>
  <!-- Scar shading -->
  <rect x="19" y="17" width="1" height="6" fill="#a65d5d"/>
  <rect x="21" y="23" width="1" height="6" fill="#a65d5d"/>
  <rect x="23" y="29" width="1" height="6" fill="#a65d5d"/>
  <rect x="25" y="35" width="1" height="6" fill="#a65d5d"/>
  <rect x="27" y="41" width="1" height="6" fill="#a65d5d"/>`,

    "warpaint_red": `<!-- Two horizontal red paint stripes on left cheek -->
  <rect x="20" y="22" width="12" height="2" fill="#DC143C"/>
  <rect x="21" y="22" width="1" height="2" fill="#8B0000"/>
  <rect x="30" y="22" width="1" height="2" fill="#FF6B6B"/>
  
  <rect x="18" y="26" width="14" height="2" fill="#DC143C"/>
  <rect x="19" y="26" width="1" height="2" fill="#8B0000"/>
  <rect x="31" y="26" width="1" height="2" fill="#FF6B6B"/>
  
  <!-- Slightly uneven pixel edges -->
  <rect x="17" y="27" width="1" height="1" fill="#DC143C"/>
  <rect x="32" y="23" width="1" height="1" fill="#DC143C"/>
  
  <!-- Two horizontal red paint stripes on right cheek -->
  <rect x="48" y="22" width="12" height="2" fill="#DC143C"/>
  <rect x="49" y="22" width="1" height="2" fill="#8B0000"/>
  <rect x="58" y="22" width="1" height="2" fill="#FF6B6B"/>
  
  <rect x="46" y="26" width="14" height="2" fill="#DC143C"/>
  <rect x="47" y="26" width="1" height="2" fill="#8B0000"/>
  <rect x="59" y="26" width="1" height="2" fill="#FF6B6B"/>
  
  <!-- Slightly uneven pixel edges -->
  <rect x="45" y="27" width="1" height="1" fill="#DC143C"/>
  <rect x="60" y="23" width="1" height="1" fill="#DC143C"/>`,

    "freckles": `<!-- Freckles - Minecraft Pixel Style -->
  
  <!-- Left cheek freckles -->
  <rect x="10" y="15" width="2" height="2" fill="#C19A6B"/>
  <rect x="14" y="18" width="2" height="2" fill="#C19A6B"/>
  <rect x="8" y="22" width="2" height="2" fill="#C19A6B"/>
  <rect x="12" y="20" width="2" height="2" fill="#C19A6B"/>
  <rect x="16" y="24" width="2" height="2" fill="#C19A6B"/>
  <rect x="6" y="26" width="2" height="2" fill="#C19A6B"/>
  <rect x="10" y="28" width="2" height="2" fill="#C19A6B"/>
  <rect x="14" y="26" width="2" height="2" fill="#C19A6B"/>
  
  <!-- Right cheek freckles -->
  <rect x="66" y="15" width="2" height="2" fill="#C19A6B"/>
  <rect x="62" y="18" width="2" height="2" fill="#C19A6B"/>
  <rect x="68" y="22" width="2" height="2" fill="#C19A6B"/>
  <rect x="64" y="20" width="2" height="2" fill="#C19A6B"/>
  <rect x="60" y="24" width="2" height="2" fill="#C19A6B"/>
  <rect x="70" y="26" width="2" height="2" fill="#C19A6B"/>
  <rect x="66" y="28" width="2" height="2" fill="#C19A6B"/>
  <rect x="62" y="26" width="2" height="2" fill="#C19A6B"/>
  
  <!-- Nose bridge freckles -->
  <rect x="38" y="16" width="2" height="2" fill="#C19A6B"/>
  <rect x="40" y="20" width="2" height="2" fill="#C19A6B"/>
  <rect x="36" y="18" width="2" height="2" fill="#C19A6B"/>
  <rect x="42" y="18" width="2" height="2" fill="#C19A6B"/>
  <rect x="39" y="22" width="2" height="2" fill="#C19A6B"/>`,

    "tribal_white": `<!-- White Tribal Markings - Minecraft Pixel Style -->
  
  <!-- Left side pattern -->
  <!-- Under eye horizontal line -->
  <rect x="8" y="8" width="16" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Diagonal down pattern -->
  <rect x="10" y="10" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="12" y="12" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="14" y="14" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="16" y="16" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="18" y="18" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Secondary pattern -->
  <rect x="6" y="22" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="8" y="24" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="10" y="26" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="12" y="28" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Cheek accent -->
  <rect x="14" y="22" width="8" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="16" y="24" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Right side pattern (mirrored) -->
  <!-- Under eye horizontal line -->
  <rect x="56" y="8" width="16" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Diagonal down pattern -->
  <rect x="66" y="10" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="64" y="12" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="62" y="14" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="60" y="16" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="58" y="18" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Secondary pattern -->
  <rect x="72" y="22" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="70" y="24" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="68" y="26" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="66" y="28" width="2" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Cheek accent -->
  <rect x="58" y="22" width="8" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="60" y="24" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  
  <!-- Forehead mark -->
  <rect x="38" y="2" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="36" y="4" width="8" height="2" fill="#FFFFFF" opacity="0.9"/>
  <rect x="38" y="6" width="4" height="2" fill="#FFFFFF" opacity="0.9"/>`
  },

  "GLASSES": {
    "monocle": `<rect x="48" y="8" width="12" height="8" fill="#FFD700"/>
<rect x="49" y="9" width="10" height="6" fill="#FFFF99"/>
<rect x="50" y="10" width="8" height="4" fill="#ffffff" opacity="0.3"/>
<rect x="52" y="16" width="1" height="1" fill="#FFD700"/>
<rect x="51" y="17" width="1" height="1" fill="#FFD700"/>
<rect x="50" y="18" width="1" height="1" fill="#FFD700"/>
<rect x="49" y="19" width="1" height="1" fill="#FFD700"/>
<rect x="48" y="20" width="1" height="1" fill="#FFD700"/>
<rect x="47" y="21" width="1" height="1" fill="#FFD700"/>
<rect x="52" y="15" width="2" height="1" fill="#B8860B"/>`,

    "round_glasses": `<rect x="12" y="6" width="23" height="3" fill="#2c2c2c"/>
<rect x="12" y="13" width="23" height="3" fill="#2c2c2c"/>
<rect x="10" y="9" width="3" height="7" fill="#2c2c2c"/>
<rect x="35" y="9" width="3" height="7" fill="#2c2c2c"/>
<rect x="15" y="9" width="18" height="4" fill="#e6f3ff" opacity="0.4"/>
<rect x="42" y="6" width="23" height="3" fill="#2c2c2c"/>
<rect x="42" y="13" width="23" height="3" fill="#2c2c2c"/>
<rect x="38" y="9" width="3" height="7" fill="#2c2c2c"/>
<rect x="65" y="9" width="3" height="7" fill="#2c2c2c"/>
<rect x="44" y="9" width="18" height="4" fill="#e6f3ff" opacity="0.4"/>
<rect x="35" y="10" width="6" height="1" fill="#2c2c2c"/>`,

    "square_goggles": `<rect x="12" y="6" width="20" height="12" fill="#808080"/>
<rect x="13" y="7" width="18" height="10" fill="#606060"/>
<rect x="15" y="9" width="14" height="6" fill="#008B8B"/>
<rect x="48" y="6" width="20" height="12" fill="#808080"/>
<rect x="49" y="7" width="18" height="10" fill="#606060"/>
<rect x="51" y="9" width="14" height="6" fill="#008B8B"/>
<rect x="32" y="11" width="16" height="2" fill="#606060"/>
<rect x="33" y="12" width="14" height="1" fill="#808080"/>
<rect x="8" y="11" width="4" height="2" fill="#404040"/>
<rect x="68" y="11" width="4" height="2" fill="#404040"/>
<rect x="11" y="5" width="22" height="1" fill="#2c2c2c"/>
<rect x="11" y="18" width="22" height="1" fill="#2c2c2c"/>
<rect x="11" y="6" width="1" height="12" fill="#2c2c2c"/>
<rect x="32" y="6" width="1" height="12" fill="#2c2c2c"/>
<rect x="47" y="5" width="22" height="1" fill="#2c2c2c"/>
<rect x="47" y="18" width="22" height="1" fill="#2c2c2c"/>
<rect x="47" y="6" width="1" height="12" fill="#2c2c2c"/>
<rect x="68" y="6" width="1" height="12" fill="#2c2c2c"/>`,

    "visor_tech": `<rect x="0" y="4" width="80" height="14" fill="#C0C0C0"/>
<rect x="0" y="4" width="80" height="2" fill="#E0E0E0"/>
<rect x="0" y="16" width="80" height="2" fill="#808080"/>
<rect x="4" y="6" width="30" height="10" fill="#00CED1" opacity="0.7"/>
<rect x="4" y="6" width="30" height="2" fill="#00FFFF" opacity="0.5"/>
<rect x="46" y="6" width="30" height="10" fill="#00CED1" opacity="0.7"/>
<rect x="46" y="6" width="30" height="2" fill="#00FFFF" opacity="0.5"/>
<rect x="34" y="8" width="12" height="4" fill="#C0C0C0"/>
<rect x="38" y="9" width="4" height="2" fill="#808080"/>
<rect x="2" y="10" width="2" height="2" fill="#00FF00"/>
<rect x="76" y="10" width="2" height="2" fill="#00FF00"/>
<rect x="8" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.5"/>
<rect x="12" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.5"/>
<rect x="16" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.5"/>
<rect x="50" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.5"/>
<rect x="54" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.5"/>
<rect x="58" y="8" width="2" height="2" fill="#FFFFFF" opacity="0.5"/>`,

    "eye_patch": `<rect x="0" y="9" width="80" height="4" fill="#3E2723"/>
<rect x="0" y="9" width="80" height="1" fill="#2E1A1A"/>
<rect x="0" y="12" width="80" height="1" fill="#4E3333"/>
<rect x="8" y="3" width="24" height="16" fill="#000000"/>
<rect x="8" y="3" width="24" height="2" fill="#1A1A1A"/>
<rect x="8" y="17" width="24" height="2" fill="#1A1A1A"/>
<rect x="8" y="3" width="2" height="16" fill="#1A1A1A"/>
<rect x="30" y="3" width="2" height="16" fill="#1A1A1A"/>
<rect x="10" y="5" width="2" height="1" fill="#808080"/>
<rect x="14" y="5" width="2" height="1" fill="#808080"/>
<rect x="18" y="5" width="2" height="1" fill="#808080"/>
<rect x="22" y="5" width="2" height="1" fill="#808080"/>
<rect x="26" y="5" width="2" height="1" fill="#808080"/>
<rect x="10" y="16" width="2" height="1" fill="#808080"/>
<rect x="14" y="16" width="2" height="1" fill="#808080"/>
<rect x="18" y="16" width="2" height="1" fill="#808080"/>
<rect x="22" y="16" width="2" height="1" fill="#808080"/>
<rect x="26" y="16" width="2" height="1" fill="#808080"/>
<rect x="10" y="8" width="1" height="2" fill="#808080"/>
<rect x="10" y="12" width="1" height="2" fill="#808080"/>
<rect x="28" y="8" width="1" height="2" fill="#808080"/>
<rect x="28" y="12" width="1" height="2" fill="#808080"/>`
  },

  "HAIR_HAT": {
    "green_hood": `<!-- Ranger hood main body -->
  <rect x="20" y="0" width="60" height="20" fill="#228B22"/>
  <rect x="15" y="5" width="70" height="18" fill="#32CD32"/>
  <rect x="10" y="10" width="80" height="15" fill="#228B22"/>
  
  <!-- Square folds -->
  <rect x="25" y="8" width="4" height="12" fill="#1F5F1F"/>
  <rect x="35" y="6" width="4" height="14" fill="#1F5F1F"/>
  <rect x="45" y="8" width="4" height="12" fill="#1F5F1F"/>
  <rect x="55" y="6" width="4" height="14" fill="#1F5F1F"/>
  <rect x="65" y="8" width="4" height="12" fill="#1F5F1F"/>
  <rect x="75" y="10" width="4" height="10" fill="#1F5F1F"/>
  
  <!-- Boxed opening around face -->
  <rect x="35" y="15" width="30" height="20" fill="none" stroke="#1F5F1F" stroke-width="2"/>
  
  <!-- Hood edge details -->
  <rect x="12" y="12" width="76" height="2" fill="#006400"/>
  <rect x="18" y="22" width="64" height="2" fill="#006400"/>
  
  <!-- Side draping -->
  <rect x="8" y="20" width="12" height="10" fill="#228B22"/>
  <rect x="80" y="20" width="12" height="10" fill="#228B22"/>
  <rect x="6" y="25" width="8" height="8" fill="#32CD32"/>
  <rect x="86" y="25" width="8" height="8" fill="#32CD32"/>`,

    "short_brown_hair": `<!-- Short brown hair - pixel art style, overlaps with head but not glasses -->
  <rect x="12" y="0" width="76" height="18" fill="#654321" rx="9"/>
  <rect x="8" y="3" width="12" height="12" fill="#654321" rx="6"/>
  <rect x="80" y="3" width="12" height="12" fill="#654321" rx="6"/>
  <!-- Hair extends down to overlap head -->
  <rect x="15" y="16" width="70" height="20" fill="#654321" rx="8"/>
  <!-- Hair highlights -->
  <rect x="18" y="2" width="64" height="4" fill="#8B4513" rx="2"/>
  <rect x="22" y="8" width="56" height="3" fill="#8B4513" rx="1"/>
  <rect x="20" y="20" width="60" height="3" fill="#8B4513" rx="1"/>`,

    "silver_long_hair": `<!-- Long straight hair main body -->
  <rect x="15" y="0" width="70" height="16" fill="#C0C0C0"/>
  <rect x="10" y="8" width="80" height="20" fill="#D3D3D3"/>
  <rect x="5" y="16" width="90" height="15" fill="#C0C0C0"/>
  
  <!-- Rectangular strands -->
  <rect x="8" y="20" width="6" height="12" fill="#A9A9A9"/>
  <rect x="16" y="18" width="6" height="14" fill="#A9A9A9"/>
  <rect x="24" y="20" width="6" height="12" fill="#A9A9A9"/>
  <rect x="32" y="18" width="6" height="14" fill="#A9A9A9"/>
  <rect x="40" y="20" width="6" height="12" fill="#A9A9A9"/>
  <rect x="48" y="18" width="6" height="14" fill="#A9A9A9"/>
  <rect x="56" y="20" width="6" height="12" fill="#A9A9A9"/>
  <rect x="64" y="18" width="6" height="14" fill="#A9A9A9"/>
  <rect x="72" y="20" width="6" height="12" fill="#A9A9A9"/>
  <rect x="80" y="18" width="6" height="14" fill="#A9A9A9"/>
  <rect x="88" y="20" width="6" height="12" fill="#A9A9A9"/>
  
  <!-- Stepped tips -->
  <rect x="10" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="18" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="26" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="34" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="42" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="50" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="58" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="66" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="74" y="32" width="4" height="3" fill="#A9A9A9"/>
  <rect x="82" y="32" width="4" height="3" fill="#A9A9A9"/>
  
  <!-- Silver highlights -->
  <rect x="20" y="2" width="60" height="2" fill="#E5E5E5"/>
  <rect x="15" y="10" width="70" height="1" fill="#E5E5E5"/>
  <rect x="10" y="18" width="80" height="1" fill="#E5E5E5"/>`,

    "royal_crown_hat": `<rect x="15" y="20" width="70" height="15" fill="#8B0000"/>
<rect x="15" y="20" width="70" height="3" fill="#DC143C"/>
<rect x="15" y="32" width="70" height="3" fill="#4B0000"/>
<rect x="15" y="32" width="70" height="3" fill="#FFFFFF"/>
<rect x="13" y="33" width="74" height="2" fill="#F5F5DC"/>
<rect x="20" y="15" width="60" height="5" fill="#8B0000"/>
<rect x="25" y="10" width="50" height="5" fill="#DC143C"/>
<rect x="10" y="15" width="80" height="8" fill="#FFD700"/>
<rect x="10" y="15" width="80" height="2" fill="#FFA500"/>
<rect x="10" y="21" width="80" height="2" fill="#DAA520"/>
<rect x="15" y="10" width="8" height="8" fill="#FFD700"/>
<rect x="17" y="6" width="4" height="4" fill="#FFD700"/>
<rect x="30" y="8" width="8" height="10" fill="#FFD700"/>
<rect x="32" y="4" width="4" height="4" fill="#FFD700"/>
<rect x="46" y="5" width="8" height="13" fill="#FFD700"/>
<rect x="48" y="0" width="4" height="5" fill="#FFD700"/>
<rect x="62" y="8" width="8" height="10" fill="#FFD700"/>
<rect x="64" y="4" width="4" height="4" fill="#FFD700"/>
<rect x="77" y="10" width="8" height="8" fill="#FFD700"/>
<rect x="79" y="6" width="4" height="4" fill="#FFD700"/>
<rect x="20" y="17" width="4" height="4" fill="#DC143C"/>
<rect x="35" y="17" width="4" height="4" fill="#B22222"/>
<rect x="48" y="17" width="4" height="4" fill="#DC143C"/>
<rect x="61" y="17" width="4" height="4" fill="#B22222"/>
<rect x="76" y="17" width="4" height="4" fill="#DC143C"/>
<rect x="15" y="16" width="2" height="2" fill="#FFFF99"/>
<rect x="48" y="16" width="2" height="2" fill="#FFFF99"/>
<rect x="81" y="16" width="2" height="2" fill="#FFFF99"/>`,

    "mohawk_red": `<!-- Red Mohawk - Minecraft Pixel Style -->
  
  <!-- Shaved sides (transparent to show scalp) -->
  <!-- Center mohawk stripe -->
  
  <!-- Base of mohawk -->
  <rect x="44" y="20" width="12" height="15" fill="#8B0000"/>
  
  <!-- Middle section -->
  <rect x="44" y="10" width="12" height="10" fill="#FF0000"/>
  
  <!-- Top section -->
  <rect x="44" y="0" width="12" height="10" fill="#FF6666"/>
  
  <!-- Spikes on top -->
  <rect x="46" y="0" width="2" height="4" fill="#FF9999"/>
  <rect x="50" y="0" width="2" height="4" fill="#FF9999"/>
  <rect x="54" y="0" width="2" height="4" fill="#FF9999"/>
  
  <!-- Side gradients for depth -->
  <rect x="42" y="15" width="2" height="20" fill="#8B0000"/>
  <rect x="56" y="15" width="2" height="20" fill="#8B0000"/>
  
  <rect x="42" y="8" width="2" height="7" fill="#FF0000"/>
  <rect x="56" y="8" width="2" height="7" fill="#FF0000"/>
  
  <!-- Highlight stripe down center -->
  <rect x="49" y="2" width="2" height="28" fill="#FF3333"/>
  
  <!-- Extra spiky details at top -->
  <rect x="45" y="0" width="1" height="2" fill="#FFCCCC"/>
  <rect x="47" y="0" width="1" height="2" fill="#FFCCCC"/>
  <rect x="49" y="0" width="1" height="2" fill="#FFCCCC"/>
  <rect x="51" y="0" width="1" height="2" fill="#FFCCCC"/>
  <rect x="53" y="0" width="1" height="2" fill="#FFCCCC"/>
  <rect x="55" y="0" width="1" height="2" fill="#FFCCCC"/>`
  },

  "BODY": {
    "cloth_tunic": `<!-- 棕色布质上衣 - 保持torso原位，两侧添加手臂 -->
  
  <!-- 左手臂区域 (x=0-21) -->
  <rect x="0" y="0" width="22" height="78" fill="#8B4513"/>
  <rect x="0" y="78" width="22" height="26" fill="#8B4513"/>
  <!-- 左臂阴影 -->
  <rect x="0" y="0" width="4" height="104" fill="#654321"/>
  <rect x="18" y="0" width="4" height="104" fill="#CD853F"/>
  <!-- 左臂纹理 -->
  <rect x="2" y="4" width="4" height="4" fill="#A0522D"/>
  <rect x="8" y="4" width="4" height="4" fill="#A0522D"/>
  <rect x="14" y="4" width="4" height="4" fill="#A0522D"/>
  <!-- 左袖口 -->
  <rect x="0" y="74" width="22" height="8" fill="#654321"/>
  <!-- 左手套 -->
  <rect x="2" y="80" width="18" height="22" fill="#8B4513"/>
  <rect x="2" y="80" width="4" height="22" fill="#654321"/>
  <rect x="16" y="80" width="4" height="22" fill="#CD853F"/>
  
  <!-- 主躯干区域 (x=22-111, 保持原来90px宽度的设计) -->
  <rect x="27" y="0" width="80" height="117" fill="#8B4513"/>
  
  <!-- 方形衣领 -->
  <rect x="52" y="0" width="30" height="12" fill="#654321"/>
  <rect x="50" y="8" width="34" height="4" fill="#654321"/>
  
  <!-- 3层阴影渐变 -->
  <rect x="27" y="0" width="8" height="117" fill="#654321"/>
  <rect x="99" y="0" width="8" height="117" fill="#CD853F"/>
  <rect x="27" y="109" width="80" height="8" fill="#654321"/>
  
  <!-- 像素编织纹理 -->
  <rect x="29" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="35" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="41" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="47" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="53" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="59" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="65" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="71" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="77" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="83" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="89" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="95" y="2" width="4" height="4" fill="#A0522D"/>
  <rect x="101" y="2" width="4" height="4" fill="#A0522D"/>
  
  <rect x="31" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="37" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="43" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="49" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="55" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="61" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="67" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="73" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="79" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="85" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="91" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="97" y="6" width="4" height="4" fill="#A0522D"/>
  <rect x="103" y="6" width="4" height="4" fill="#A0522D"/>
  
  <!-- 方块状躯干细节 -->
  <rect x="37" y="25" width="60" height="4" fill="#654321"/>
  <rect x="42" y="45" width="50" height="4" fill="#654321"/>
  <rect x="47" y="65" width="40" height="4" fill="#654321"/>
  
  <!-- 腰带区域 -->
  <rect x="32" y="85" width="70" height="8" fill="#654321"/>
  <rect x="57" y="83" width="20" height="12" fill="#8B4513"/>
  <rect x="62" y="85" width="10" height="8" fill="#CD853F"/>
  
  <!-- 右手臂区域 (x=112-134) -->
  <rect x="112" y="0" width="22" height="78" fill="#8B4513"/>
  <rect x="112" y="78" width="22" height="26" fill="#8B4513"/>
  <!-- 右臂阴影 -->
  <rect x="112" y="0" width="4" height="104" fill="#654321"/>
  <rect x="130" y="0" width="4" height="104" fill="#CD853F"/>
  <!-- 右臂纹理 -->
  <rect x="114" y="4" width="4" height="4" fill="#A0522D"/>
  <rect x="120" y="4" width="4" height="4" fill="#A0522D"/>
  <rect x="126" y="4" width="4" height="4" fill="#A0522D"/>
  <!-- 右袖口 -->
  <rect x="112" y="74" width="22" height="8" fill="#654321"/>
  <!-- 右手套 -->
  <rect x="114" y="80" width="18" height="22" fill="#8B4513"/>
  <rect x="114" y="80" width="4" height="22" fill="#654321"/>
  <rect x="128" y="80" width="4" height="22" fill="#CD853F"/>`,

    "iron_cuirass": `<!-- 铁制胸甲 - 保持torso原位，两侧添加手臂护甲 -->
  
  <!-- 左手臂护甲 (x=0-21) -->
  <rect x="0" y="10" width="22" height="80" fill="#808080"/>
  <rect x="0" y="10" width="4" height="80" fill="#696969"/>
  <rect x="18" y="10" width="4" height="80" fill="#A9A9A9"/>
  <rect x="2" y="10" width="18" height="1" fill="#D3D3D3"/>
  
  <!-- 主胸甲躯干 (x=22-111, 保持原90px设计) -->
  <rect x="30" y="0" width="74" height="100" fill="#808080"/>
  
  <!-- 金属阴影 -->
  <rect x="30" y="0" width="6" height="100" fill="#696969"/>
  <rect x="98" y="0" width="6" height="100" fill="#A9A9A9"/>
  <rect x="30" y="94" width="74" height="6" fill="#696969"/>
  
  <!-- 边缘高光 -->
  <rect x="36" y="0" width="62" height="1" fill="#D3D3D3"/>
  <rect x="29" y="1" width="1" height="98" fill="#D3D3D3"/>
  <rect x="104" y="1" width="1" height="98" fill="#D3D3D3"/>
  
  <!-- 铆钉 -->
  <rect x="42" y="10" width="2" height="2" fill="#2F2F2F"/>
  <rect x="52" y="10" width="2" height="2" fill="#2F2F2F"/>
  <rect x="62" y="10" width="2" height="2" fill="#2F2F2F"/>
  <rect x="72" y="10" width="2" height="2" fill="#2F2F2F"/>
  <rect x="82" y="10" width="2" height="2" fill="#2F2F2F"/>
  <rect x="92" y="10" width="2" height="2" fill="#2F2F2F"/>
  
  <!-- 胸甲板 -->
  <rect x="42" y="15" width="20" height="25" fill="#A9A9A9"/>
  <rect x="72" y="15" width="20" height="25" fill="#A9A9A9"/>
  <rect x="43" y="16" width="18" height="1" fill="#D3D3D3"/>
  <rect x="73" y="16" width="18" height="1" fill="#D3D3D3"/>
  
  <!-- 中央分割线 -->
  <rect x="66" y="0" width="2" height="100" fill="#696969"/>
  
  <!-- 右手臂护甲 (x=112-134) -->
  <rect x="112" y="10" width="22" height="80" fill="#808080"/>
  <rect x="112" y="10" width="4" height="80" fill="#696969"/>
  <rect x="130" y="10" width="4" height="80" fill="#A9A9A9"/>
  <rect x="114" y="10" width="18" height="1" fill="#D3D3D3"/>`,

    "gold_robe_runes": `<!-- 金色法师长袍 - 保持torso原位，两侧添加袖子 -->
  
  <!-- 左袖子 (x=0-21) -->
  <rect x="0" y="15" width="22" height="80" fill="#DAA520"/>
  <rect x="0" y="15" width="6" height="80" fill="#B8860B"/>
  <rect x="16" y="15" width="6" height="80" fill="#FFD700"/>
  <!-- 袖口装饰 -->
  <rect x="2" y="17" width="18" height="16" fill="#B8860B"/>
  <rect x="0" y="15" width="22" height="20" fill="#FFD700"/>
  
  <!-- 主长袍躯干 (x=22-111, 保持原90px设计) -->
  <rect x="32" y="0" width="70" height="110" fill="#DAA520"/>
  
  <!-- 金色阴影 -->
  <rect x="32" y="0" width="8" height="110" fill="#B8860B"/>
  <rect x="94" y="0" width="8" height="110" fill="#FFD700"/>
  
  <!-- 垂直符文带 -->
  <rect x="47" y="5" width="2" height="100" fill="#00FFFF"/>
  <rect x="85" y="5" width="2" height="100" fill="#00FFFF"/>
  
  <!-- 符文符号 -->
  <rect x="48" y="10" width="1" height="3" fill="#00FFFF"/>
  <rect x="48" y="18" width="1" height="3" fill="#00FFFF"/>
  <rect x="48" y="26" width="1" height="3" fill="#00FFFF"/>
  <rect x="48" y="34" width="1" height="3" fill="#00FFFF"/>
  <rect x="48" y="42" width="1" height="3" fill="#00FFFF"/>
  <rect x="48" y="50" width="1" height="3" fill="#00FFFF"/>
  
  <rect x="85" y="12" width="1" height="3" fill="#00FFFF"/>
  <rect x="85" y="20" width="1" height="3" fill="#00FFFF"/>
  <rect x="85" y="28" width="1" height="3" fill="#00FFFF"/>
  <rect x="85" y="36" width="1" height="3" fill="#00FFFF"/>
  <rect x="85" y="44" width="1" height="3" fill="#00FFFF"/>
  <rect x="85" y="52" width="1" height="3" fill="#00FFFF"/>
  
  <!-- 中央符文图案 -->
  <rect x="66" y="20" width="2" height="2" fill="#00FFFF"/>
  <rect x="64" y="22" width="6" height="2" fill="#00FFFF"/>
  <rect x="66" y="24" width="2" height="2" fill="#00FFFF"/>
  
  <!-- 腰带 -->
  <rect x="47" y="80" width="40" height="6" fill="#B8860B"/>
  <rect x="62" y="78" width="10" height="10" fill="#FFD700"/>
  
  <!-- 右袖子 (x=112-134) -->
  <rect x="112" y="15" width="22" height="80" fill="#DAA520"/>
  <rect x="112" y="15" width="6" height="80" fill="#B8860B"/>
  <rect x="128" y="15" width="6" height="80" fill="#FFD700"/>
  <!-- 袖口装饰 -->
  <rect x="114" y="17" width="18" height="16" fill="#B8860B"/>
  <rect x="112" y="15" width="22" height="20" fill="#FFD700"/>`,

    "leather_vest": `<!-- Leather Vest with Arm Guards - Minecraft Pixel Style -->
  
  <!-- Left arm guard (0-22px) -->
  <rect x="0" y="10" width="22" height="30" fill="#8B4513"/>
  <rect x="0" y="10" width="4" height="30" fill="#654321"/>
  <rect x="18" y="10" width="4" height="30" fill="#A0522D"/>
  <!-- Arm strap -->
  <rect x="2" y="20" width="18" height="4" fill="#654321"/>
  <rect x="2" y="28" width="18" height="4" fill="#654321"/>
  
  <!-- Main vest body (center 74px) -->
  <rect x="30" y="0" width="74" height="100" fill="#8B4513"/>
  
  <!-- V-neck cutout -->
  <rect x="57" y="0" width="20" height="15" fill="transparent"/>
  <rect x="60" y="0" width="14" height="12" fill="transparent"/>
  <rect x="63" y="0" width="8" height="8" fill="transparent"/>
  
  <!-- Left side shadow -->
  <rect x="30" y="0" width="6" height="100" fill="#654321"/>
  <!-- Right side highlight -->
  <rect x="98" y="0" width="6" height="100" fill="#A0522D"/>
  <!-- Bottom shadow -->
  <rect x="30" y="94" width="74" height="6" fill="#654321"/>
  
  <!-- Buttons -->
  <rect x="65" y="25" width="4" height="4" fill="#B87333"/>
  <rect x="65" y="45" width="4" height="4" fill="#B87333"/>
  <rect x="65" y="65" width="4" height="4" fill="#B87333"/>
  
  <!-- Button shadows -->
  <rect x="65" y="27" width="4" height="2" fill="#8B6914"/>
  <rect x="65" y="47" width="4" height="2" fill="#8B6914"/>
  <rect x="65" y="67" width="4" height="2" fill="#8B6914"/>
  
  <!-- Left pocket -->
  <rect x="40" y="35" width="16" height="12" fill="#654321"/>
  <rect x="42" y="37" width="12" height="8" fill="#8B4513"/>
  
  <!-- Right pocket -->
  <rect x="78" y="35" width="16" height="12" fill="#654321"/>
  <rect x="80" y="37" width="12" height="8" fill="#8B4513"/>
  
  <!-- Seam lines -->
  <rect x="36" y="0" width="1" height="100" fill="#654321"/>
  <rect x="97" y="0" width="1" height="100" fill="#654321"/>
  
  <!-- Right arm guard (112-134px) -->
  <rect x="112" y="10" width="22" height="30" fill="#8B4513"/>
  <rect x="112" y="10" width="4" height="30" fill="#654321"/>
  <rect x="130" y="10" width="4" height="30" fill="#A0522D"/>
  <!-- Arm strap -->
  <rect x="114" y="20" width="18" height="4" fill="#654321"/>
  <rect x="114" y="28" width="18" height="4" fill="#654321"/>`,

    "diamond_plate": `<!-- Diamond Plate Armor with Arm Guards - Minecraft Pixel Style -->
  
  <!-- Left shoulder guard (0-22px) -->
  <rect x="0" y="10" width="22" height="40" fill="#00BFFF"/>
  <rect x="0" y="10" width="4" height="40" fill="#0080FF"/>
  <rect x="18" y="10" width="4" height="40" fill="#40D0FF"/>
  <!-- Shoulder highlights -->
  <rect x="0" y="10" width="22" height="2" fill="#FFFFFF"/>
  <!-- Joint blocks -->
  <rect x="8" y="25" width="4" height="4" fill="#0000CD"/>
  <rect x="8" y="35" width="4" height="4" fill="#0000CD"/>
  
  <!-- Main chest armor (center 74px) -->
  <rect x="30" y="0" width="74" height="100" fill="#00BFFF"/>
  
  <!-- Armor plate divisions -->
  <!-- Top left plate -->
  <rect x="30" y="0" width="35" height="40" fill="#00BFFF"/>
  <rect x="30" y="0" width="35" height="2" fill="#FFFFFF"/>
  <rect x="30" y="38" width="35" height="2" fill="#0000CD"/>
  
  <!-- Top right plate -->
  <rect x="69" y="0" width="35" height="40" fill="#00BFFF"/>
  <rect x="69" y="0" width="35" height="2" fill="#FFFFFF"/>
  <rect x="69" y="38" width="35" height="2" fill="#0000CD"/>
  
  <!-- Middle left plate -->
  <rect x="30" y="42" width="35" height="28" fill="#00BFFF"/>
  <rect x="30" y="42" width="35" height="2" fill="#FFFFFF"/>
  <rect x="30" y="68" width="35" height="2" fill="#0000CD"/>
  
  <!-- Middle right plate -->
  <rect x="69" y="42" width="35" height="28" fill="#00BFFF"/>
  <rect x="69" y="42" width="35" height="2" fill="#FFFFFF"/>
  <rect x="69" y="68" width="35" height="2" fill="#0000CD"/>
  
  <!-- Bottom left plate -->
  <rect x="30" y="72" width="35" height="28" fill="#00BFFF"/>
  <rect x="30" y="72" width="35" height="2" fill="#FFFFFF"/>
  <rect x="30" y="98" width="35" height="2" fill="#0000CD"/>
  
  <!-- Bottom right plate -->
  <rect x="69" y="72" width="35" height="28" fill="#00BFFF"/>
  <rect x="69" y="72" width="35" height="2" fill="#FFFFFF"/>
  <rect x="69" y="98" width="35" height="2" fill="#0000CD"/>
  
  <!-- Center dividing line -->
  <rect x="65" y="0" width="4" height="100" fill="#0000CD"/>
  
  <!-- Central diamond gem -->
  <rect x="63" y="48" width="8" height="8" fill="#FFFFFF"/>
  <rect x="61" y="50" width="12" height="4" fill="#FFFFFF"/>
  <rect x="65" y="46" width="4" height="12" fill="#FFFFFF"/>
  <rect x="65" y="50" width="4" height="4" fill="#E0FFFF"/>
  
  <!-- Side shadows -->
  <rect x="30" y="0" width="4" height="100" fill="#0080FF"/>
  <rect x="100" y="0" width="4" height="100" fill="#40D0FF"/>
  
  <!-- Right shoulder guard (112-134px) -->
  <rect x="112" y="10" width="22" height="40" fill="#00BFFF"/>
  <rect x="112" y="10" width="4" height="40" fill="#0080FF"/>
  <rect x="130" y="10" width="4" height="40" fill="#40D0FF"/>
  <!-- Shoulder highlights -->
  <rect x="112" y="10" width="22" height="2" fill="#FFFFFF"/>
  <!-- Joint blocks -->
  <rect x="122" y="25" width="4" height="4" fill="#0000CD"/>
  <rect x="122" y="35" width="4" height="4" fill="#0000CD"/>`
  },

  "LEGS": {
    "cloth_pants": `<!-- Brown pants main body -->
  <rect x="5" y="0" width="28" height="65" fill="#8B4513"/>
  <rect x="47" y="0" width="28" height="65" fill="#8B4513"/>
  
  <!-- Grid-like texture hint -->
  <rect x="7" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="11" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="15" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="19" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="23" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="27" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="31" y="2" width="2" height="2" fill="#A0522D"/>
  
  <rect x="49" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="53" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="57" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="61" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="65" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="69" y="2" width="2" height="2" fill="#A0522D"/>
  <rect x="73" y="2" width="2" height="2" fill="#A0522D"/>
  
  <!-- Hard knee edges -->
  <rect x="10" y="35" width="18" height="2" fill="#654321"/>
  <rect x="52" y="35" width="18" height="2" fill="#654321"/>
  
  <!-- Crotch connection -->
  <rect x="33" y="0" width="14" height="8" fill="#654321"/>`,

    "iron_greaves": `<!-- Iron leg armor main body -->
  <rect x="5" y="0" width="28" height="65" fill="#808080"/>
  <rect x="47" y="0" width="28" height="65" fill="#808080"/>
  
  <!-- Segmented rectangular plates -->
  <rect x="7" y="0" width="24" height="20" fill="#A9A9A9"/>
  <rect x="49" y="0" width="24" height="20" fill="#A9A9A9"/>
  
  <rect x="8" y="22" width="22" height="18" fill="#A9A9A9"/>
  <rect x="50" y="22" width="22" height="18" fill="#A9A9A9"/>
  
  <rect x="9" y="42" width="20" height="18" fill="#A9A9A9"/>
  <rect x="51" y="42" width="20" height="18" fill="#A9A9A9"/>
  
  <!-- Rivets and connection points -->
  <rect x="15" y="5" width="2" height="2" fill="#2F2F2F"/>
  <rect x="25" y="5" width="2" height="2" fill="#2F2F2F"/>
  <rect x="57" y="5" width="2" height="2" fill="#2F2F2F"/>
  <rect x="67" y="5" width="2" height="2" fill="#2F2F2F"/>
  
  <!-- Crotch connection -->
  <rect x="33" y="0" width="14" height="8" fill="#696969"/>`,

    "robe_tails_blue": `<!-- Wizard robe tails main body -->
  <rect x="10" y="0" width="60" height="65" fill="#191970"/>
  <rect x="5" y="5" width="70" height="60" fill="#1E90FF"/>
  
  <!-- Deep blue 2 shades -->
  <rect x="10" y="0" width="8" height="65" fill="#0F0F50"/>
  <rect x="62" y="0" width="8" height="65" fill="#4169E1"/>
  
  <!-- Straight hem line with stepped pixels -->
  <rect x="12" y="60" width="56" height="5" fill="#0F0F50"/>
  <rect x="14" y="58" width="52" height="2" fill="#0F0F50"/>
  <rect x="16" y="56" width="48" height="2" fill="#0F0F50"/>
  <rect x="18" y="54" width="44" height="2" fill="#0F0F50"/>
  
  <!-- Minimal folds -->
  <rect x="25" y="10" width="2" height="50" fill="#0F0F50"/>
  <rect x="35" y="8" width="2" height="52" fill="#0F0F50"/>
  <rect x="45" y="10" width="2" height="50" fill="#0F0F50"/>
  <rect x="55" y="8" width="2" height="52" fill="#0F0F50"/>
  
  <!-- Side draping -->
  <rect x="5" y="15" width="8" height="45" fill="#191970"/>
  <rect x="67" y="15" width="8" height="45" fill="#191970"/>
  <rect x="3" y="25" width="5" height="35" fill="#1E90FF"/>
  <rect x="72" y="25" width="5" height="35" fill="#1E90FF"/>
  
  <!-- Decorative trim -->
  <rect x="15" y="2" width="50" height="2" fill="#4169E1"/>
  <rect x="20" y="45" width="40" height="2" fill="#4169E1"/>`,

    "chain_leggings": `<!-- Chain Mail Leggings - Minecraft Pixel Style -->
  
  <!-- Left leg -->
  <rect x="0" y="0" width="36" height="70" fill="#808080"/>
  
  <!-- Chain texture pattern left leg -->
  <rect x="2" y="2" width="2" height="2" fill="#696969"/>
  <rect x="6" y="2" width="2" height="2" fill="#696969"/>
  <rect x="10" y="2" width="2" height="2" fill="#696969"/>
  <rect x="14" y="2" width="2" height="2" fill="#696969"/>
  <rect x="18" y="2" width="2" height="2" fill="#696969"/>
  <rect x="22" y="2" width="2" height="2" fill="#696969"/>
  <rect x="26" y="2" width="2" height="2" fill="#696969"/>
  <rect x="30" y="2" width="2" height="2" fill="#696969"/>
  
  <rect x="4" y="4" width="2" height="2" fill="#696969"/>
  <rect x="8" y="4" width="2" height="2" fill="#696969"/>
  <rect x="12" y="4" width="2" height="2" fill="#696969"/>
  <rect x="16" y="4" width="2" height="2" fill="#696969"/>
  <rect x="20" y="4" width="2" height="2" fill="#696969"/>
  <rect x="24" y="4" width="2" height="2" fill="#696969"/>
  <rect x="28" y="4" width="2" height="2" fill="#696969"/>
  <rect x="32" y="4" width="2" height="2" fill="#696969"/>
  
  <!-- Repeat pattern down -->
  <rect x="2" y="6" width="2" height="2" fill="#696969"/>
  <rect x="6" y="6" width="2" height="2" fill="#696969"/>
  <rect x="10" y="6" width="2" height="2" fill="#696969"/>
  <rect x="14" y="6" width="2" height="2" fill="#696969"/>
  <rect x="18" y="6" width="2" height="2" fill="#696969"/>
  <rect x="22" y="6" width="2" height="2" fill="#696969"/>
  <rect x="26" y="6" width="2" height="2" fill="#696969"/>
  <rect x="30" y="6" width="2" height="2" fill="#696969"/>
  
  <rect x="4" y="8" width="2" height="2" fill="#696969"/>
  <rect x="8" y="8" width="2" height="2" fill="#696969"/>
  <rect x="12" y="8" width="2" height="2" fill="#696969"/>
  <rect x="16" y="8" width="2" height="2" fill="#696969"/>
  <rect x="20" y="8" width="2" height="2" fill="#696969"/>
  <rect x="24" y="8" width="2" height="2" fill="#696969"/>
  <rect x="28" y="8" width="2" height="2" fill="#696969"/>
  <rect x="32" y="8" width="2" height="2" fill="#696969"/>
  
  <!-- Left knee guard -->
  <rect x="10" y="25" width="16" height="16" fill="#C0C0C0"/>
  <rect x="10" y="25" width="16" height="2" fill="#E0E0E0"/>
  <rect x="10" y="39" width="16" height="2" fill="#808080"/>
  
  <!-- Right leg -->
  <rect x="44" y="0" width="36" height="70" fill="#808080"/>
  
  <!-- Chain texture pattern right leg -->
  <rect x="46" y="2" width="2" height="2" fill="#696969"/>
  <rect x="50" y="2" width="2" height="2" fill="#696969"/>
  <rect x="54" y="2" width="2" height="2" fill="#696969"/>
  <rect x="58" y="2" width="2" height="2" fill="#696969"/>
  <rect x="62" y="2" width="2" height="2" fill="#696969"/>
  <rect x="66" y="2" width="2" height="2" fill="#696969"/>
  <rect x="70" y="2" width="2" height="2" fill="#696969"/>
  <rect x="74" y="2" width="2" height="2" fill="#696969"/>
  
  <rect x="48" y="4" width="2" height="2" fill="#696969"/>
  <rect x="52" y="4" width="2" height="2" fill="#696969"/>
  <rect x="56" y="4" width="2" height="2" fill="#696969"/>
  <rect x="60" y="4" width="2" height="2" fill="#696969"/>
  <rect x="64" y="4" width="2" height="2" fill="#696969"/>
  <rect x="68" y="4" width="2" height="2" fill="#696969"/>
  <rect x="72" y="4" width="2" height="2" fill="#696969"/>
  <rect x="76" y="4" width="2" height="2" fill="#696969"/>
  
  <!-- Repeat pattern down -->
  <rect x="46" y="6" width="2" height="2" fill="#696969"/>
  <rect x="50" y="6" width="2" height="2" fill="#696969"/>
  <rect x="54" y="6" width="2" height="2" fill="#696969"/>
  <rect x="58" y="6" width="2" height="2" fill="#696969"/>
  <rect x="62" y="6" width="2" height="2" fill="#696969"/>
  <rect x="66" y="6" width="2" height="2" fill="#696969"/>
  <rect x="70" y="6" width="2" height="2" fill="#696969"/>
  <rect x="74" y="6" width="2" height="2" fill="#696969"/>
  
  <rect x="48" y="8" width="2" height="2" fill="#696969"/>
  <rect x="52" y="8" width="2" height="2" fill="#696969"/>
  <rect x="56" y="8" width="2" height="2" fill="#696969"/>
  <rect x="60" y="8" width="2" height="2" fill="#696969"/>
  <rect x="64" y="8" width="2" height="2" fill="#696969"/>
  <rect x="68" y="8" width="2" height="2" fill="#696969"/>
  <rect x="72" y="8" width="2" height="2" fill="#696969"/>
  <rect x="76" y="8" width="2" height="2" fill="#696969"/>
  
  <!-- Right knee guard -->
  <rect x="54" y="25" width="16" height="16" fill="#C0C0C0"/>
  <rect x="54" y="25" width="16" height="2" fill="#E0E0E0"/>
  <rect x="54" y="39" width="16" height="2" fill="#808080"/>
  
  <!-- Center dividing line -->
  <rect x="36" y="0" width="8" height="70" fill="#000000"/>`,

    "shorts_simple": `<!-- Simple Shorts - Minecraft Pixel Style -->
  
  <!-- Main shorts body -->
  <rect x="0" y="0" width="80" height="35" fill="#F0E68C"/>
  
  <!-- Waistband -->
  <rect x="0" y="0" width="80" height="4" fill="#8B4513"/>
  <rect x="0" y="0" width="80" height="1" fill="#654321"/>
  
  <!-- Left leg opening -->
  <rect x="0" y="33" width="36" height="2" fill="#8B4513"/>
  
  <!-- Right leg opening -->
  <rect x="44" y="33" width="36" height="2" fill="#8B4513"/>
  
  <!-- Center seam/divide -->
  <rect x="38" y="4" width="4" height="31" fill="#D2B48C"/>
  <rect x="39" y="4" width="2" height="31" fill="#8B4513"/>
  
  <!-- Left pocket -->
  <rect x="8" y="10" width="12" height="10" fill="#D2B48C"/>
  <rect x="8" y="10" width="12" height="1" fill="#8B4513"/>
  <rect x="8" y="10" width="1" height="10" fill="#8B4513"/>
  <rect x="19" y="10" width="1" height="10" fill="#8B4513"/>
  
  <!-- Right pocket -->
  <rect x="60" y="10" width="12" height="10" fill="#D2B48C"/>
  <rect x="60" y="10" width="12" height="1" fill="#8B4513"/>
  <rect x="60" y="10" width="1" height="10" fill="#8B4513"/>
  <rect x="71" y="10" width="1" height="10" fill="#8B4513"/>
  
  <!-- Side seams -->
  <rect x="0" y="4" width="2" height="31" fill="#D2B48C"/>
  <rect x="78" y="4" width="2" height="31" fill="#D2B48C"/>
  
  <!-- Fabric texture -->
  <rect x="4" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="10" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="16" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="22" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="28" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="34" y="6" width="2" height="2" fill="#D2B48C"/>
  
  <rect x="44" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="50" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="56" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="62" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="68" y="6" width="2" height="2" fill="#D2B48C"/>
  <rect x="74" y="6" width="2" height="2" fill="#D2B48C"/>`
  },

  "FOOT": {
    "gold_rune_shoes": `<!-- Gold shoes main body -->
  <rect x="8" y="6" width="28" height="14" fill="#DAA520"/>
  <rect x="54" y="6" width="28" height="14" fill="#DAA520"/>
  
  <!-- Flat gold 2 shades -->
  <rect x="8" y="6" width="4" height="14" fill="#B8860B"/>
  <rect x="32" y="6" width="4" height="14" fill="#FFD700"/>
  <rect x="54" y="6" width="4" height="14" fill="#B8860B"/>
  <rect x="78" y="6" width="4" height="14" fill="#FFD700"/>
  
  <!-- Cyan rune pixels along rim (1-2px each) -->
  <rect x="10" y="4" width="1" height="1" fill="#00FFFF"/>
  <rect x="13" y="4" width="2" height="1" fill="#00FFFF"/>
  <rect x="17" y="4" width="1" height="1" fill="#00FFFF"/>
  <rect x="20" y="4" width="2" height="1" fill="#00FFFF"/>
  <rect x="24" y="4" width="1" height="1" fill="#00FFFF"/>
  <rect x="27" y="4" width="2" height="1" fill="#00FFFF"/>
  <rect x="31" y="4" width="1" height="1" fill="#00FFFF"/>
  <rect x="34" y="4" width="1" height="1" fill="#00FFFF"/>
  
  <!-- Pointed toe design -->
  <rect x="4" y="10" width="6" height="6" fill="#FFD700"/>
  <rect x="2" y="12" width="4" height="2" fill="#FFD700"/>
  
  <rect x="50" y="10" width="6" height="6" fill="#FFD700"/>
  <rect x="48" y="12" width="4" height="2" fill="#FFD700"/>
  
  <!-- Sole -->
  <rect x="5" y="19" width="34" height="2" fill="#B8860B"/>
  <rect x="51" y="19" width="34" height="2" fill="#B8860B"/>`,

    "iron_sabatons": `<!-- Iron boots main body -->
  <rect x="5" y="3" width="32" height="17" fill="#808080"/>
  <rect x="53" y="3" width="32" height="17" fill="#808080"/>
  
  <!-- Boxy caps -->
  <rect x="2" y="6" width="8" height="11" fill="#A9A9A9"/>
  <rect x="50" y="6" width="8" height="11" fill="#A9A9A9"/>
  
  <!-- Gray 3 shades -->
  <rect x="5" y="3" width="4" height="17" fill="#696969"/>
  <rect x="33" y="3" width="4" height="17" fill="#D3D3D3"/>
  <rect x="53" y="3" width="4" height="17" fill="#696969"/>
  <rect x="81" y="3" width="4" height="17" fill="#D3D3D3"/>
  
  <!-- Rivet dots at 1px -->
  <rect x="12" y="8" width="1" height="1" fill="#2F2F2F"/>
  <rect x="18" y="8" width="1" height="1" fill="#2F2F2F"/>
  <rect x="24" y="8" width="1" height="1" fill="#2F2F2F"/>
  <rect x="30" y="8" width="1" height="1" fill="#2F2F2F"/>
  
  <rect x="60" y="8" width="1" height="1" fill="#2F2F2F"/>
  <rect x="66" y="8" width="1" height="1" fill="#2F2F2F"/>
  <rect x="72" y="8" width="1" height="1" fill="#2F2F2F"/>
  <rect x="78" y="8" width="1" height="1" fill="#2F2F2F"/>`,

    "leather_boots": `<!-- Brown leather boots -->
  <rect x="5" y="5" width="32" height="15" fill="#8B4513"/>
  <rect x="53" y="5" width="32" height="15" fill="#8B4513"/>
  
  <!-- Chunky square toes -->
  <rect x="2" y="8" width="8" height="9" fill="#654321"/>
  <rect x="50" y="8" width="8" height="9" fill="#654321"/>
  
  <!-- 2 shade volumes -->
  <rect x="5" y="5" width="4" height="15" fill="#654321"/>
  <rect x="33" y="5" width="4" height="15" fill="#A0522D"/>
  <rect x="53" y="5" width="4" height="15" fill="#654321"/>
  <rect x="81" y="5" width="4" height="15" fill="#A0522D"/>
  
  <!-- 1px laces pattern -->
  <rect x="15" y="7" width="1" height="1" fill="#D2691E"/>
  <rect x="17" y="9" width="1" height="1" fill="#D2691E"/>
  <rect x="19" y="11" width="1" height="1" fill="#D2691E"/>
  <rect x="21" y="13" width="1" height="1" fill="#D2691E"/>
  <rect x="23" y="15" width="1" height="1" fill="#D2691E"/>
  <rect x="25" y="17" width="1" height="1" fill="#D2691E"/>
  
  <rect x="63" y="7" width="1" height="1" fill="#D2691E"/>
  <rect x="65" y="9" width="1" height="1" fill="#D2691E"/>
  <rect x="67" y="11" width="1" height="1" fill="#D2691E"/>
  <rect x="69" y="13" width="1" height="1" fill="#D2691E"/>
  <rect x="71" y="15" width="1" height="1" fill="#D2691E"/>
  <rect x="73" y="17" width="1" height="1" fill="#D2691E"/>
  
  <!-- Hard sole edge -->
  <rect x="3" y="19" width="36" height="3" fill="#654321"/>
  <rect x="51" y="19" width="36" height="3" fill="#654321"/>
  <rect x="4" y="20" width="34" height="1" fill="#A0522D"/>
  <rect x="52" y="20" width="34" height="1" fill="#A0522D"/>`,

    "sandals_strapped": `<!-- Strapped Sandals - Minecraft Pixel Style -->
  
  <!-- Left sandal -->
  <!-- Sole -->
  <rect x="0" y="16" width="40" height="6" fill="#654321"/>
  <rect x="0" y="20" width="40" height="2" fill="#4A3018"/>
  <rect x="0" y="16" width="40" height="1" fill="#7D5A3C"/>
  
  <!-- Straps -->
  <!-- Front strap -->
  <rect x="8" y="4" width="4" height="12" fill="#8B4513"/>
  <rect x="20" y="4" width="4" height="12" fill="#8B4513"/>
  
  <!-- Cross strap -->
  <rect x="4" y="8" width="32" height="4" fill="#8B4513"/>
  <rect x="4" y="8" width="32" height="1" fill="#A0522D"/>
  
  <!-- Ankle strap -->
  <rect x="2" y="12" width="36" height="4" fill="#8B4513"/>
  <rect x="2" y="12" width="36" height="1" fill="#A0522D"/>
  
  <!-- Toe gaps (transparent areas showing skin) -->
  <rect x="12" y="4" width="4" height="4" fill="transparent"/>
  <rect x="16" y="4" width="4" height="4" fill="transparent"/>
  <rect x="24" y="4" width="4" height="4" fill="transparent"/>
  <rect x="28" y="4" width="4" height="4" fill="transparent"/>
  
  <!-- Right sandal -->
  <!-- Sole -->
  <rect x="50" y="16" width="40" height="6" fill="#654321"/>
  <rect x="50" y="20" width="40" height="2" fill="#4A3018"/>
  <rect x="50" y="16" width="40" height="1" fill="#7D5A3C"/>
  
  <!-- Straps -->
  <!-- Front strap -->
  <rect x="58" y="4" width="4" height="12" fill="#8B4513"/>
  <rect x="70" y="4" width="4" height="12" fill="#8B4513"/>
  
  <!-- Cross strap -->
  <rect x="54" y="8" width="32" height="4" fill="#8B4513"/>
  <rect x="54" y="8" width="32" height="1" fill="#A0522D"/>
  
  <!-- Ankle strap -->
  <rect x="52" y="12" width="36" height="4" fill="#8B4513"/>
  <rect x="52" y="12" width="36" height="1" fill="#A0522D"/>
  
  <!-- Toe gaps (transparent areas showing skin) -->
  <rect x="62" y="4" width="4" height="4" fill="transparent"/>
  <rect x="66" y="4" width="4" height="4" fill="transparent"/>
  <rect x="74" y="4" width="4" height="4" fill="transparent"/>
  <rect x="78" y="4" width="4" height="4" fill="transparent"/>`,

    "armored_greaves": `<!-- Heavy Armored Greaves - Minecraft Pixel Style -->
  
  <!-- Left greave -->
  <rect x="0" y="0" width="40" height="22" fill="#2F4F4F"/>
  
  <!-- Gold trim top -->
  <rect x="0" y="0" width="40" height="2" fill="#FFD700"/>
  <!-- Gold trim bottom -->
  <rect x="0" y="20" width="40" height="2" fill="#FFD700"/>
  
  <!-- Armor plates (3 sections) -->
  <!-- Section 1 -->
  <rect x="0" y="2" width="12" height="18" fill="#2F4F4F"/>
  <rect x="11" y="2" width="2" height="18" fill="#1C1C1C"/>
  
  <!-- Section 2 -->
  <rect x="13" y="2" width="14" height="18" fill="#2F4F4F"/>
  <rect x="26" y="2" width="2" height="18" fill="#1C1C1C"/>
  
  <!-- Section 3 -->
  <rect x="28" y="2" width="12" height="18" fill="#2F4F4F"/>
  
  <!-- Rivets -->
  <rect x="4" y="6" width="4" height="4" fill="#000000"/>
  <rect x="4" y="14" width="4" height="4" fill="#000000"/>
  
  <rect x="18" y="6" width="4" height="4" fill="#000000"/>
  <rect x="18" y="14" width="4" height="4" fill="#000000"/>
  
  <rect x="32" y="6" width="4" height="4" fill="#000000"/>
  <rect x="32" y="14" width="4" height="4" fill="#000000"/>
  
  <!-- Highlight -->
  <rect x="0" y="2" width="40" height="1" fill="#708090"/>
  
  <!-- Right greave -->
  <rect x="50" y="0" width="40" height="22" fill="#2F4F4F"/>
  
  <!-- Gold trim top -->
  <rect x="50" y="0" width="40" height="2" fill="#FFD700"/>
  <!-- Gold trim bottom -->
  <rect x="50" y="20" width="40" height="2" fill="#FFD700"/>
  
  <!-- Armor plates (3 sections) -->
  <!-- Section 1 -->
  <rect x="50" y="2" width="12" height="18" fill="#2F4F4F"/>
  <rect x="61" y="2" width="2" height="18" fill="#1C1C1C"/>
  
  <!-- Section 2 -->
  <rect x="63" y="2" width="14" height="18" fill="#2F4F4F"/>
  <rect x="76" y="2" width="2" height="18" fill="#1C1C1C"/>
  
  <!-- Section 3 -->
  <rect x="78" y="2" width="12" height="18" fill="#2F4F4F"/>
  
  <!-- Rivets -->
  <rect x="54" y="6" width="4" height="4" fill="#000000"/>
  <rect x="54" y="14" width="4" height="4" fill="#000000"/>
  
  <rect x="68" y="6" width="4" height="4" fill="#000000"/>
  <rect x="68" y="14" width="4" height="4" fill="#000000"/>
  
  <rect x="82" y="6" width="4" height="4" fill="#000000"/>
  <rect x="82" y="14" width="4" height="4" fill="#000000"/>
  
  <!-- Highlight -->
  <rect x="50" y="2" width="40" height="1" fill="#708090"/>`
  },

  "WEAPON": {
    "warrior_longsword_stage1": `<!-- 战士长剑 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 剑柄 -->
  <rect x="26" y="138" width="13" height="32" fill="#8B4513"/>
  <rect x="26" y="138" width="3" height="32" fill="#654321"/>
  <rect x="36" y="138" width="3" height="32" fill="#A0522D"/>
  
  <!-- 皮革握把纹理 -->
  <rect x="28" y="142" width="3" height="3" fill="#654321"/>
  <rect x="33" y="142" width="3" height="3" fill="#654321"/>
  <rect x="28" y="150" width="3" height="3" fill="#654321"/>
  <rect x="33" y="150" width="3" height="3" fill="#654321"/>
  <rect x="28" y="158" width="3" height="3" fill="#654321"/>
  <rect x="33" y="158" width="3" height="3" fill="#654321"/>
  <rect x="28" y="166" width="3" height="3" fill="#654321"/>
  <rect x="33" y="166" width="3" height="3" fill="#654321"/>
  
  <!-- 护手 -->
  <rect x="16" y="134" width="32" height="6" fill="#808080"/>
  <rect x="16" y="134" width="6" height="6" fill="#696969"/>
  <rect x="42" y="134" width="6" height="6" fill="#D3D3D3"/>
  
  <!-- 剑刃 -->
  <rect x="28" y="10" width="10" height="124" fill="#C0C0C0"/>
  <rect x="28" y="10" width="3" height="124" fill="#A9A9A9"/>
  <rect x="34" y="10" width="3" height="124" fill="#E5E5E5"/>
  
  <!-- 1px边缘高光 -->
  <rect x="27" y="10" width="1" height="124" fill="#FFFFFF"/>
  <rect x="37" y="10" width="1" height="124" fill="#FFFFFF"/>
  
  <!-- 剑尖 -->
  <rect x="29" y="6" width="6" height="4" fill="#C0C0C0"/>
  <rect x="31" y="2" width="3" height="4" fill="#C0C0C0"/>
  <rect x="32" y="0" width="2" height="2" fill="#C0C0C0"/>
  
  <!-- 剑刃中央凹槽 -->
  <rect x="32" y="18" width="2" height="112" fill="#A9A9A9"/>
  
  <!-- 方块状细节 -->
  <rect x="23" y="136" width="3" height="3" fill="#808080"/>
  <rect x="39" y="136" width="3" height="3" fill="#808080"/>`,

    "warrior_longsword_stage2": `<!-- 战士长剑 - 第二阶段 -->
  
  <!-- 钢制剑身 -->
  <rect x="28" y="8" width="9" height="121" fill="#E5E5E5"/>
  <rect x="28" y="8" width="3" height="121" fill="#C0C0C0"/>
  <rect x="34" y="8" width="3" height="121" fill="#F8F8F8"/>
  
  <!-- 剑脊线（fuller） -->
  <rect x="32" y="12" width="2" height="114" fill="#A9A9A9"/>
  
  <!-- 剑尖 -->
  <rect x="29" y="4" width="6" height="4" fill="#E5E5E5"/>
  <rect x="31" y="2" width="3" height="2" fill="#E5E5E5"/>
  <rect x="32" y="0" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 增强护手 -->
  <rect x="13" y="129" width="39" height="6" fill="#808080"/>
  <rect x="13" y="129" width="8" height="6" fill="#696969"/>
  <rect x="44" y="129" width="8" height="6" fill="#D3D3D3"/>
  
  <!-- 红宝石（2x2px） -->
  <rect x="32" y="131" width="2" height="2" fill="#DC143C"/>
  <rect x="33" y="132" width="1" height="1" fill="#FF6347"/>
  
  <!-- 剑柄 -->
  <rect x="26" y="136" width="13" height="31" fill="#8B4513"/>
  <rect x="26" y="136" width="4" height="31" fill="#654321"/>
  <rect x="35" y="136" width="4" height="31" fill="#A0522D"/>
  
  <!-- 更厚的轮廓 -->
  <rect x="27" y="7" width="11" height="2" fill="#A9A9A9"/>
  <rect x="27" y="7" width="2" height="123" fill="#696969"/>
  <rect x="36" y="7" width="2" height="123" fill="#F8F8F8"/>
  <rect x="28" y="129" width="9" height="2" fill="#696969"/>
  
  <!-- 剑柄底端 -->
  <rect x="28" y="163" width="9" height="6" fill="#654321"/>
  <rect x="26" y="167" width="13" height="3" fill="#8B4513"/>`,

    "warrior_longsword_stage3": `<!-- 战士长剑 - 第三阶段（巨剑） -->
  
  <!-- 加宽的剑身 -->
  <rect x="25" y="10" width="15" height="113" fill="#F8F8F8"/>
  <rect x="25" y="10" width="5" height="113" fill="#E5E5E5"/>
  <rect x="36" y="10" width="5" height="113" fill="#FFFFFF"/>
  
  <!-- 阶梯式锯齿边缘 -->
  <rect x="23" y="21" width="2" height="3" fill="#F8F8F8"/>
  <rect x="23" y="29" width="2" height="3" fill="#F8F8F8"/>
  <rect x="23" y="36" width="2" height="3" fill="#F8F8F8"/>
  <rect x="40" y="25" width="2" height="3" fill="#F8F8F8"/>
  <rect x="40" y="32" width="2" height="3" fill="#F8F8F8"/>
  <rect x="40" y="40" width="2" height="3" fill="#F8F8F8"/>
  
  <!-- 红色发光符文沿剑脊 -->
  <rect x="32" y="14" width="2" height="106" fill="#DC143C"/>
  <rect x="29" y="17" width="1" height="1" fill="#FF4500"/>
  <rect x="35" y="17" width="1" height="1" fill="#FF4500"/>
  <rect x="28" y="29" width="1" height="1" fill="#FF6347"/>
  <rect x="36" y="29" width="1" height="1" fill="#FF6347"/>
  <rect x="30" y="44" width="1" height="1" fill="#FF4500"/>
  <rect x="34" y="44" width="1" height="1" fill="#FF4500"/>
  <rect x="29" y="59" width="1" height="1" fill="#FF6347"/>
  <rect x="36" y="59" width="1" height="1" fill="#FF6347"/>
  
  <!-- 剑尖 -->
  <rect x="28" y="6" width="9" height="4" fill="#F8F8F8"/>
  <rect x="29" y="4" width="6" height="2" fill="#F8F8F8"/>
  <rect x="31" y="2" width="3" height="2" fill="#F8F8F8"/>
  <rect x="32" y="0" width="2" height="2" fill="#F8F8F8"/>
  
  <!-- 巨大护手 -->
  <rect x="10" y="123" width="45" height="8" fill="#808080"/>
  <rect x="10" y="123" width="9" height="8" fill="#696969"/>
  <rect x="46" y="123" width="9" height="8" fill="#D3D3D3"/>
  
  <!-- 大块剑柄 -->
  <rect x="23" y="131" width="18" height="34" fill="#8B4513"/>
  <rect x="23" y="131" width="6" height="34" fill="#654321"/>
  <rect x="36" y="131" width="6" height="34" fill="#A0522D"/>
  
  <!-- 方形剑首帽 -->
  <rect x="22" y="161" width="21" height="9" fill="#654321"/>
  <rect x="20" y="165" width="24" height="3" fill="#8B4513"/>
  <rect x="28" y="162" width="9" height="6" fill="#A0522D"/>`,

    "warrior_shield_sword_set_stage1": `<!-- 战士盾剑套装 - 第一阶段 -->
  
  <!-- 木制方形盾牌 -->
  <rect x="1" y="45" width="41" height="41" fill="#8B4513"/>
  
  <!-- 木板像素纹理 -->
  <rect x="3" y="46" width="5" height="38" fill="#A0522D"/>
  <rect x="10" y="46" width="5" height="38" fill="#654321"/>
  <rect x="16" y="46" width="5" height="38" fill="#A0522D"/>
  <rect x="23" y="46" width="5" height="38" fill="#654321"/>
  <rect x="30" y="46" width="5" height="38" fill="#A0522D"/>
  <rect x="37" y="46" width="4" height="38" fill="#654321"/>
  
  <!-- 最小金属边缘 -->
  <rect x="0" y="44" width="44" height="1" fill="#696969"/>
  <rect x="0" y="44" width="1" height="44" fill="#696969"/>
  <rect x="42" y="44" width="1" height="44" fill="#696969"/>
  <rect x="1" y="86" width="41" height="1" fill="#696969"/>
  
  <!-- 短铁剑 -->
  <rect x="56" y="72" width="5" height="34" fill="#C0C0C0"/>
  <rect x="56" y="72" width="2" height="34" fill="#A9A9A9"/>
  <rect x="60" y="72" width="2" height="34" fill="#E5E5E5"/>
  
  <!-- 剑尖 -->
  <rect x="57" y="69" width="3" height="3" fill="#C0C0C0"/>
  <rect x="58" y="67" width="1" height="2" fill="#C0C0C0"/>
  
  <!-- 简单护手 -->
  <rect x="53" y="107" width="12" height="3" fill="#808080"/>
  
  <!-- 剑柄 -->
  <rect x="57" y="109" width="3" height="17" fill="#8B4513"/>
  <rect x="57" y="109" width="1" height="17" fill="#654321"/>
  <rect x="60" y="109" width="1" height="17" fill="#A0522D"/>
  
  <!-- 盾牌握把（背面暗示） -->
  <rect x="21" y="64" width="3" height="3" fill="#654321"/>`,

    "warrior_shield_sword_set_stage2": `<!-- 战士盾剑套装 - 第二阶段 -->
  
  <!-- 铁边盾牌 -->
  <rect x="1" y="47" width="39" height="39" fill="#8B4513"/>
  
  <!-- 木板像素纹理 -->
  <rect x="3" y="48" width="5" height="37" fill="#A0522D"/>
  <rect x="9" y="48" width="5" height="37" fill="#654321"/>
  <rect x="16" y="48" width="5" height="37" fill="#A0522D"/>
  <rect x="22" y="48" width="5" height="37" fill="#654321"/>
  <rect x="29" y="48" width="5" height="37" fill="#A0522D"/>
  <rect x="35" y="48" width="4" height="37" fill="#654321"/>
  
  <!-- 铁制边缘 -->
  <rect x="0" y="45" width="42" height="2" fill="#808080"/>
  <rect x="0" y="45" width="2" height="42" fill="#808080"/>
  <rect x="40" y="45" width="2" height="42" fill="#D3D3D3"/>
  <rect x="2" y="85" width="38" height="2" fill="#696969"/>
  
  <!-- 螺栓点 -->
  <rect x="5" y="52" width="1" height="1" fill="#2F2F2F"/>
  <rect x="5" y="78" width="1" height="1" fill="#2F2F2F"/>
  <rect x="34" y="52" width="1" height="1" fill="#2F2F2F"/>
  <rect x="34" y="78" width="1" height="1" fill="#2F2F2F"/>
  
  <!-- 光滑短剑 -->
  <rect x="54" y="73" width="7" height="33" fill="#E5E5E5"/>
  <rect x="54" y="73" width="2" height="33" fill="#C0C0C0"/>
  <rect x="58" y="73" width="2" height="33" fill="#F8F8F8"/>
  
  <!-- 1px高光 -->
  <rect x="56" y="74" width="1" height="30" fill="#FFFFFF"/>
  
  <!-- 剑尖 -->
  <rect x="55" y="70" width="4" height="3" fill="#E5E5E5"/>
  <rect x="56" y="68" width="1" height="2" fill="#E5E5E5"/>
  
  <!-- 护手鳍片 -->
  <rect x="49" y="106" width="16" height="3" fill="#808080"/>
  <rect x="51" y="104" width="3" height="1" fill="#808080"/>
  <rect x="61" y="104" width="3" height="1" fill="#808080"/>
  
  <!-- 剑柄 -->
  <rect x="55" y="108" width="4" height="16" fill="#8B4513"/>
  <rect x="55" y="108" width="1" height="16" fill="#654321"/>
  <rect x="58" y="108" width="1" height="16" fill="#A0522D"/>
  
  <!-- 盾牌握把（背面暗示） -->
  <rect x="18" y="64" width="5" height="5" fill="#654321"/>
  <rect x="17" y="65" width="1" height="3" fill="#8B4513"/>
  <rect x="22" y="65" width="1" height="3" fill="#8B4513"/>`,

    "warrior_shield_sword_set_stage3": `<!-- 战士盾剑套装 - 第三阶段 -->
  
  <!-- 风筝盾牌 -->
  <rect x="1" y="48" width="41" height="44" fill="#8B4513"/>
  
  <!-- 金边框 -->
  <rect x="0" y="47" width="44" height="2" fill="#DAA520"/>
  <rect x="0" y="47" width="2" height="47" fill="#DAA520"/>
  <rect x="42" y="47" width="2" height="47" fill="#FFD700"/>
  <rect x="2" y="91" width="40" height="2" fill="#B8860B"/>
  
  <!-- 纹章十字 -->
  <rect x="20" y="57" width="3" height="25" fill="#DAA520"/>
  <rect x="11" y="68" width="22" height="3" fill="#DAA520"/>
  
  <!-- 木板纹理 -->
  <rect x="3" y="49" width="5" height="40" fill="#A0522D"/>
  <rect x="9" y="49" width="5" height="40" fill="#654321"/>
  <rect x="16" y="49" width="5" height="40" fill="#A0522D"/>
  <rect x="22" y="49" width="5" height="40" fill="#654321"/>
  <rect x="28" y="49" width="5" height="40" fill="#A0522D"/>
  <rect x="35" y="49" width="5" height="40" fill="#654321"/>
  
  <!-- 宽剑身 -->
  <rect x="52" y="70" width="9" height="35" fill="#F8F8F8"/>
  <rect x="52" y="70" width="3" height="35" fill="#E5E5E5"/>
  <rect x="58" y="70" width="3" height="35" fill="#FFFFFF"/>
  
  <!-- 淡红色发光像素 -->
  <rect x="56" y="73" width="1" height="28" fill="#FF6B6B"/>
  <rect x="54" y="76" width="1" height="1" fill="#FF4500"/>
  <rect x="61" y="76" width="1" height="1" fill="#FF4500"/>
  <rect x="54" y="82" width="1" height="1" fill="#FF6347"/>
  <rect x="61" y="82" width="1" height="1" fill="#FF6347"/>
  <rect x="53" y="89" width="1" height="1" fill="#FF4500"/>
  <rect x="62" y="89" width="1" height="1" fill="#FF4500"/>
  
  <!-- 剑尖 -->
  <rect x="54" y="67" width="6" height="3" fill="#F8F8F8"/>
  <rect x="56" y="65" width="4" height="2" fill="#F8F8F8"/>
  <rect x="57" y="64" width="1" height="1" fill="#F8F8F8"/>
  
  <!-- 护手 -->
  <rect x="47" y="105" width="18" height="3" fill="#808080"/>
  
  <!-- 剑柄 -->
  <rect x="54" y="108" width="6" height="16" fill="#8B4513"/>
  <rect x="54" y="108" width="2" height="16" fill="#654321"/>
  <rect x="59" y="108" width="2" height="16" fill="#A0522D"/>
  
  <!-- 盾牌中央宝石（青色发光） -->
  <rect x="21" y="69" width="2" height="2" fill="#00FFFF"/>
  <rect x="21" y="69" width="1" height="1" fill="#FFFFFF"/>`,

    "warrior_warhammer_stage1": `<!-- 战士战锤 - 第一阶段 -->
  
  <!-- 木质方形手柄 -->
  <rect x="28" y="44" width="10" height="120" fill="#8B4513"/>
  <rect x="28" y="44" width="3" height="120" fill="#654321"/>
  <rect x="35" y="44" width="3" height="120" fill="#A0522D"/>
  
  <!-- 铁制带子 -->
  <rect x="26" y="64" width="14" height="4" fill="#808080"/>
  <rect x="26" y="104" width="14" height="4" fill="#808080"/>
  <rect x="26" y="144" width="14" height="4" fill="#808080"/>
  
  <!-- 铁制方块锤头 -->
  <rect x="3" y="4" width="60" height="40" fill="#808080"/>
  <rect x="3" y="4" width="10" height="40" fill="#696969"/>
  <rect x="53" y="4" width="10" height="40" fill="#D3D3D3"/>
  <rect x="3" y="36" width="60" height="8" fill="#696969"/>
  
  <!-- 矩形锤面 -->
  <rect x="8" y="9" width="50" height="30" fill="#A9A9A9"/>
  <rect x="10" y="11" width="46" height="26" fill="#C0C0C0"/>
  
  <!-- 连接部分 -->
  <rect x="23" y="39" width="20" height="10" fill="#808080"/>
  <rect x="25" y="41" width="16" height="6" fill="#696969"/>
  
  <!-- 锤头边缘细节 -->
  <rect x="1" y="2" width="64" height="2" fill="#A9A9A9"/>
  <rect x="1" y="2" width="2" height="44" fill="#696969"/>
  <rect x="63" y="2" width="2" height="44" fill="#FFFFFF"/>
  <rect x="3" y="44" width="60" height="2" fill="#696969"/>
  
  <!-- 手柄底端 -->
  <rect x="30" y="159" width="6" height="8" fill="#654321"/>
  <rect x="28" y="164" width="10" height="4" fill="#8B4513"/>`,

    "warrior_warhammer_stage2": `<!-- 战士战锤 - 第二阶段 -->
  
  <!-- 加厚木质手柄 -->
  <rect x="33" y="54" width="10" height="98" fill="#8B4513"/>
  <rect x="33" y="54" width="3" height="98" fill="#654321"/>
  <rect x="39" y="54" width="3" height="98" fill="#A0522D"/>
  
  <!-- 更厚的轴包裹 -->
  <rect x="31" y="70" width="13" height="4" fill="#654321"/>
  <rect x="31" y="102" width="13" height="4" fill="#654321"/>
  <rect x="31" y="135" width="13" height="4" fill="#654321"/>
  
  <!-- 钢制锤头 -->
  <rect x="11" y="17" width="52" height="37" fill="#A9A9A9"/>
  <rect x="11" y="17" width="10" height="37" fill="#808080"/>
  <rect x="54" y="17" width="10" height="37" fill="#E5E5E5"/>
  <rect x="11" y="50" width="52" height="7" fill="#808080"/>
  
  <!-- 尖刺后立方体 -->
  <rect x="3" y="25" width="8" height="20" fill="#808080"/>
  <rect x="0" y="29" width="3" height="12" fill="#696969"/>
  <rect x="5" y="27" width="2" height="2" fill="#696969"/>
  <rect x="5" y="32" width="2" height="2" fill="#696969"/>
  <rect x="5" y="37" width="2" height="2" fill="#696969"/>
  <rect x="5" y="42" width="2" height="2" fill="#696969"/>
  
  <!-- 锤面 -->
  <rect x="15" y="21" width="44" height="28" fill="#D3D3D3"/>
  <rect x="17" y="23" width="41" height="25" fill="#F0F0F0"/>
  
  <!-- 1px明亮钉子 -->
  <rect x="21" y="29" width="1" height="1" fill="#FFFFFF"/>
  <rect x="25" y="33" width="1" height="1" fill="#FFFFFF"/>
  <rect x="29" y="28" width="1" height="1" fill="#FFFFFF"/>
  <rect x="33" y="37" width="1" height="1" fill="#FFFFFF"/>
  <rect x="37" y="31" width="1" height="1" fill="#FFFFFF"/>
  <rect x="41" y="35" width="1" height="1" fill="#FFFFFF"/>
  <rect x="46" y="29" width="1" height="1" fill="#FFFFFF"/>
  <rect x="50" y="33" width="1" height="1" fill="#FFFFFF"/>
  
  <!-- 连接部分 -->
  <rect x="28" y="50" width="20" height="8" fill="#A9A9A9"/>
  <rect x="29" y="51" width="16" height="5" fill="#808080"/>
  
  <!-- 锤头边缘细节 -->
  <rect x="10" y="16" width="55" height="2" fill="#D3D3D3"/>
  <rect x="10" y="16" width="2" height="40" fill="#808080"/>
  <rect x="63" y="16" width="2" height="40" fill="#FFFFFF"/>
  <rect x="11" y="54" width="52" height="2" fill="#808080"/>
  
  <!-- 手柄底端 -->
  <rect x="34" y="147" width="7" height="7" fill="#654321"/>
  <rect x="33" y="151" width="10" height="3" fill="#8B4513"/>`,

    "warrior_warhammer_stage3": `<!-- 战士战锤 - 第三阶段（神圣战锤） -->
  
  <!-- 手柄 -->
  <rect x="28" y="62" width="9" height="86" fill="#8B4513"/>
  <rect x="28" y="62" width="3" height="86" fill="#654321"/>
  <rect x="34" y="62" width="3" height="86" fill="#A0522D"/>
  
  <!-- 金色侧板 -->
  <rect x="7" y="26" width="50" height="36" fill="#DAA520"/>
  <rect x="7" y="26" width="10" height="36" fill="#B8860B"/>
  <rect x="47" y="26" width="10" height="36" fill="#FFD700"/>
  <rect x="7" y="59" width="50" height="6" fill="#B8860B"/>
  
  <!-- 白色发光十字符文 -->
  <rect x="29" y="34" width="7" height="21" fill="#FFFFFF"/>
  <rect x="16" y="42" width="31" height="4" fill="#FFFFFF"/>
  
  <!-- 十字边缘发光 -->
  <rect x="28" y="33" width="9" height="1" fill="#F0F8FF"/>
  <rect x="28" y="56" width="9" height="1" fill="#F0F8FF"/>
  <rect x="16" y="41" width="1" height="6" fill="#F0F8FF"/>
  <rect x="48" y="41" width="1" height="6" fill="#F0F8FF"/>
  
  <!-- 锤面细节 -->
  <rect x="11" y="30" width="43" height="29" fill="#F0F0F0"/>
  <rect x="12" y="31" width="40" height="26" fill="#FFFFFF"/>
  
  <!-- 方形冲击痕迹 -->
  <rect x="21" y="39" width="2" height="2" fill="#D3D3D3"/>
  <rect x="36" y="44" width="2" height="2" fill="#D3D3D3"/>
  <rect x="29" y="51" width="2" height="2" fill="#D3D3D3"/>
  
  <!-- 连接部分 -->
  <rect x="24" y="59" width="17" height="7" fill="#DAA520"/>
  <rect x="25" y="60" width="14" height="4" fill="#B8860B"/>
  
  <!-- 辐射像素火花 -->
  <rect x="4" y="37" width="1" height="1" fill="#FFFFFF"/>
  <rect x="0" y="44" width="1" height="1" fill="#F0F8FF"/>
  <rect x="61" y="39" width="1" height="1" fill="#FFFFFF"/>
  <rect x="64" y="46" width="1" height="1" fill="#F0F8FF"/>
  <rect x="21" y="23" width="1" height="1" fill="#FFFFFF"/>
  <rect x="29" y="19" width="1" height="1" fill="#F0F8FF"/>
  <rect x="36" y="23" width="1" height="1" fill="#FFFFFF"/>
  <rect x="43" y="19" width="1" height="1" fill="#F0F8FF"/>
  
  <!-- 锤头边缘 -->
  <rect x="6" y="25" width="53" height="1" fill="#FFD700"/>
  <rect x="6" y="25" width="1" height="39" fill="#B8860B"/>
  <rect x="57" y="25" width="1" height="39" fill="#FFFFFF"/>
  <rect x="7" y="62" width="50" height="1" fill="#B8860B"/>
  
  <!-- 手柄底端 -->
  <rect x="29" y="144" width="6" height="6" fill="#654321"/>
  <rect x="28" y="148" width="9" height="3" fill="#8B4513"/>`,

    "mage_crystal_staff_stage1": `<!-- 法师水晶法杖 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 木质法杖主体 -->
  <rect x="28" y="14" width="8" height="149" fill="#8B4513"/>
  <rect x="28" y="14" width="2" height="149" fill="#654321"/>
  <rect x="34" y="14" width="2" height="149" fill="#A0522D"/>
  
  <!-- 木质纹理 -->
  <rect x="30" y="22" width="2" height="7" fill="#654321"/>
  <rect x="30" y="39" width="2" height="7" fill="#654321"/>
  <rect x="30" y="56" width="2" height="7" fill="#654321"/>
  <rect x="30" y="72" width="2" height="7" fill="#654321"/>
  <rect x="30" y="89" width="2" height="7" fill="#654321"/>
  <rect x="30" y="105" width="2" height="7" fill="#654321"/>
  <rect x="30" y="122" width="2" height="7" fill="#654321"/>
  <rect x="30" y="138" width="2" height="7" fill="#654321"/>
  <rect x="30" y="155" width="2" height="7" fill="#654321"/>
  
  <!-- 方形尖端插座 -->
  <rect x="24" y="10" width="17" height="10" fill="#8B4513"/>
  <rect x="24" y="10" width="3" height="10" fill="#654321"/>
  <rect x="37" y="10" width="3" height="10" fill="#A0522D"/>
  <rect x="23" y="12" width="20" height="7" fill="#654321"/>
  
  <!-- 小型蓝色水晶 2×2px -->
  <rect x="31" y="2" width="7" height="7" fill="#4169E1"/>
  <rect x="33" y="3" width="3" height="3" fill="#1E90FF"/>
  <rect x="33" y="4" width="2" height="2" fill="#87CEEB"/>
  
  <!-- 微弱像素光环 -->
  <rect x="29" y="0" width="2" height="2" fill="#87CEEB" opacity="0.6"/>
  <rect x="37" y="0" width="2" height="2" fill="#87CEEB" opacity="0.6"/>
  <rect x="29" y="8" width="2" height="2" fill="#87CEEB" opacity="0.6"/>
  <rect x="37" y="8" width="2" height="2" fill="#87CEEB" opacity="0.6"/>
  
  <rect x="28" y="2" width="2" height="2" fill="#B0E0E6" opacity="0.4"/>
  <rect x="39" y="2" width="2" height="2" fill="#B0E0E6" opacity="0.4"/>
  <rect x="28" y="7" width="2" height="2" fill="#B0E0E6" opacity="0.4"/>
  <rect x="39" y="7" width="2" height="2" fill="#B0E0E6" opacity="0.4"/>
  
  <!-- 握持区域 -->
  <rect x="27" y="130" width="12" height="25" fill="#654321"/>
  <rect x="28" y="132" width="8" height="22" fill="#8B4513"/>
  
  <!-- 底端 -->
  <rect x="30" y="163" width="5" height="7" fill="#654321"/>`,

    "mage_crystal_staff_stage2": `<!-- 法师水晶法杖 - 第二阶段 -->
  
  <!-- 雕刻法杖 -->
  <rect x="29" y="23" width="8" height="144" fill="#8B4513"/>
  <rect x="29" y="23" width="2" height="144" fill="#654321"/>
  <rect x="34" y="23" width="2" height="144" fill="#A0522D"/>
  
  <!-- 银色帽 -->
  <rect x="23" y="15" width="19" height="12" fill="#C0C0C0"/>
  <rect x="24" y="16" width="18" height="10" fill="#E5E5E5"/>
  
  <!-- 更大的多面水晶（3x3px） -->
  <rect x="29" y="7" width="6" height="6" fill="#4169E1"/>
  <rect x="30" y="8" width="5" height="5" fill="#1E90FF"/>
  <rect x="31" y="9" width="3" height="3" fill="#87CEEB"/>
  <rect x="32" y="10" width="2" height="2" fill="#F0F8FF"/>
  
  <!-- 阶梯发光环 -->
  <rect x="27" y="5" width="11" height="2" fill="#87CEEB" opacity="0.5"/>
  <rect x="27" y="14" width="11" height="2" fill="#87CEEB" opacity="0.5"/>
  <rect x="25" y="3" width="2" height="14" fill="#87CEEB" opacity="0.5"/>
  <rect x="38" y="3" width="2" height="14" fill="#87CEEB" opacity="0.5"/>
  
  <rect x="24" y="2" width="18" height="2" fill="#B0E0E6" opacity="0.3"/>
  <rect x="24" y="18" width="18" height="2" fill="#B0E0E6" opacity="0.3"/>
  <rect x="22" y="0" width="2" height="21" fill="#B0E0E6" opacity="0.3"/>
  <rect x="41" y="0" width="2" height="21" fill="#B0E0E6" opacity="0.3"/>
  
  <!-- 法杖雕刻细节 -->
  <rect x="27" y="39" width="11" height="2" fill="#654321"/>
  <rect x="27" y="55" width="11" height="2" fill="#654321"/>
  <rect x="27" y="71" width="11" height="2" fill="#654321"/>
  <rect x="27" y="87" width="11" height="2" fill="#654321"/>
  <rect x="27" y="103" width="11" height="2" fill="#654321"/>
  <rect x="27" y="119" width="11" height="2" fill="#654321"/>
  <rect x="27" y="135" width="11" height="2" fill="#654321"/>
  <rect x="27" y="151" width="11" height="2" fill="#654321"/>
  
  <!-- 银色细节 -->
  <rect x="30" y="41" width="1" height="1" fill="#C0C0C0"/>
  <rect x="34" y="41" width="1" height="1" fill="#C0C0C0"/>
  <rect x="30" y="57" width="1" height="1" fill="#C0C0C0"/>
  <rect x="34" y="57" width="1" height="1" fill="#C0C0C0"/>
  <rect x="30" y="73" width="1" height="1" fill="#C0C0C0"/>
  <rect x="34" y="73" width="1" height="1" fill="#C0C0C0"/>
  
  <!-- 法杖底端 -->
  <rect x="30" y="163" width="5" height="6" fill="#654321"/>
  <rect x="29" y="167" width="8" height="3" fill="#8B4513"/>`,

    "mage_crystal_staff_stage3": `<!-- 法师水晶法杖 - 第三阶段 -->
  
  <!-- 镀金法杖 -->
  <rect x="29" y="29" width="8" height="138" fill="#DAA520"/>
  <rect x="29" y="29" width="2" height="138" fill="#B8860B"/>
  <rect x="34" y="29" width="2" height="138" fill="#FFD700"/>
  
  <!-- 金色帽 -->
  <rect x="22" y="18" width="21" height="15" fill="#FFD700"/>
  <rect x="23" y="18" width="20" height="14" fill="#FFFFFF"/>
  
  <!-- 多面水晶（4x4px） -->
  <rect x="28" y="10" width="9" height="9" fill="#4169E1"/>
  <rect x="29" y="11" width="8" height="8" fill="#1E90FF"/>
  <rect x="29" y="11" width="6" height="6" fill="#87CEEB"/>
  <rect x="30" y="12" width="5" height="5" fill="#B0E0E6"/>
  <rect x="31" y="13" width="3" height="3" fill="#F0F8FF"/>
  <rect x="32" y="14" width="2" height="2" fill="#FFFFFF"/>
  
  <!-- 环绕1px粒子环 -->
  <rect x="21" y="15" width="1" height="1" fill="#87CEEB"/>
  <rect x="43" y="15" width="1" height="1" fill="#87CEEB"/>
  <rect x="25" y="6" width="1" height="1" fill="#87CEEB"/>
  <rect x="39" y="6" width="1" height="1" fill="#87CEEB"/>
  <rect x="33" y="2" width="1" height="1" fill="#87CEEB"/>
  
  <!-- 第二圈 -->
  <rect x="17" y="12" width="1" height="1" fill="#B0E0E6" opacity="0.7"/>
  <rect x="47" y="12" width="1" height="1" fill="#B0E0E6" opacity="0.7"/>
  <rect x="23" y="4" width="1" height="1" fill="#B0E0E6" opacity="0.7"/>
  <rect x="42" y="4" width="1" height="1" fill="#B0E0E6" opacity="0.7"/>
  <rect x="33" y="0" width="1" height="1" fill="#B0E0E6" opacity="0.7"/>
  
  <!-- 第三圈 -->
  <rect x="13" y="15" width="1" height="1" fill="#E6F3FF" opacity="0.5"/>
  <rect x="51" y="15" width="1" height="1" fill="#E6F3FF" opacity="0.5"/>
  <rect x="19" y="2" width="1" height="1" fill="#E6F3FF" opacity="0.5"/>
  <rect x="45" y="2" width="1" height="1" fill="#E6F3FF" opacity="0.5"/>
  
  <!-- 奥术符文在轴上 -->
  <rect x="30" y="41" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="41" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="56" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="56" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="71" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="71" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="87" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="87" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="102" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="102" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="117" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="117" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="132" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="132" width="2" height="2" fill="#00FFFF"/>
  <rect x="30" y="148" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="148" width="2" height="2" fill="#00FFFF"/>
  
  <!-- 法杖雕刻 -->
  <rect x="26" y="44" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="60" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="75" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="90" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="106" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="121" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="136" width="12" height="3" fill="#B8860B"/>
  <rect x="26" y="152" width="12" height="3" fill="#B8860B"/>
  
  <!-- 法杖底端 -->
  <rect x="30" y="163" width="5" height="6" fill="#B8860B"/>
  <rect x="29" y="167" width="8" height="3" fill="#DAA520"/>`,

    "mage_spellbook_stage1": `<!-- 法师法术书 - 第一阶段 -->
  
  <!-- 皮革书封 -->
  <rect x="13" y="60" width="40" height="50" fill="#8B4513"/>
  <rect x="15" y="62" width="36" height="46" fill="#A0522D"/>
  
  <!-- 书脊 -->
  <rect x="11" y="60" width="4" height="50" fill="#654321"/>
  <rect x="11" y="65" width="4" height="5" fill="#8B4513"/>
  <rect x="11" y="75" width="4" height="5" fill="#8B4513"/>
  <rect x="11" y="85" width="4" height="5" fill="#8B4513"/>
  <rect x="11" y="95" width="4" height="5" fill="#8B4513"/>
  
  <!-- 方形扣子（2px） -->
  <rect x="31" y="80" width="4" height="4" fill="#8B4513"/>
  <rect x="32" y="81" width="2" height="2" fill="#654321"/>
  
  <!-- 简单书脊像素 -->
  <rect x="12" y="62" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="67" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="72" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="77" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="82" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="87" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="92" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="97" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="102" width="2" height="1" fill="#A0522D"/>
  <rect x="12" y="107" width="2" height="1" fill="#A0522D"/>
  
  <!-- 边框 -->
  <rect x="12" y="59" width="42" height="1" fill="#654321"/>
  <rect x="12" y="59" width="1" height="52" fill="#654321"/>
  <rect x="53" y="59" width="1" height="52" fill="#A0522D"/>
  <rect x="13" y="110" width="40" height="1" fill="#654321"/>`,

    "mage_spellbook_stage2": `<!-- 法师法术书 - 第二阶段 -->
  
  <!-- 皮革书封 -->
  <rect x="8" y="55" width="50" height="60" fill="#8B4513"/>
  <rect x="10" y="57" width="46" height="56" fill="#A0522D"/>
  
  <!-- 银色角落 -->
  <rect x="8" y="55" width="8" height="8" fill="#C0C0C0"/>
  <rect x="50" y="55" width="8" height="8" fill="#E5E5E5"/>
  <rect x="8" y="107" width="8" height="8" fill="#C0C0C0"/>
  <rect x="50" y="107" width="8" height="8" fill="#E5E5E5"/>
  
  <!-- 青色符文字符（每个1px） -->
  <rect x="18" y="70" width="1" height="1" fill="#00FFFF"/>
  <rect x="21" y="68" width="1" height="1" fill="#00FFFF"/>
  <rect x="24" y="71" width="1" height="1" fill="#00FFFF"/>
  <rect x="28" y="67" width="1" height="1" fill="#00FFFF"/>
  <rect x="31" y="73" width="1" height="1" fill="#00FFFF"/>
  <rect x="35" y="69" width="1" height="1" fill="#00FFFF"/>
  <rect x="38" y="72" width="1" height="1" fill="#00FFFF"/>
  <rect x="41" y="66" width="1" height="1" fill="#00FFFF"/>
  <rect x="45" y="70" width="1" height="1" fill="#00FFFF"/>
  
  <rect x="20" y="85" width="1" height="1" fill="#00FFFF"/>
  <rect x="23" y="88" width="1" height="1" fill="#00FFFF"/>
  <rect x="27" y="83" width="1" height="1" fill="#00FFFF"/>
  <rect x="30" y="89" width="1" height="1" fill="#00FFFF"/>
  <rect x="34" y="86" width="1" height="1" fill="#00FFFF"/>
  <rect x="37" y="84" width="1" height="1" fill="#00FFFF"/>
  <rect x="40" y="90" width="1" height="1" fill="#00FFFF"/>
  <rect x="43" y="87" width="1" height="1" fill="#00FFFF"/>
  
  <!-- 书签标签 -->
  <rect x="56" y="65" width="3" height="25" fill="#DC143C"/>
  <rect x="57" y="66" width="1" height="23" fill="#FF6347"/>
  
  <!-- 书脊 -->
  <rect x="6" y="55" width="4" height="60" fill="#654321"/>
  <rect x="6" y="60" width="4" height="5" fill="#8B4513"/>
  <rect x="6" y="70" width="4" height="5" fill="#8B4513"/>
  <rect x="6" y="80" width="4" height="5" fill="#8B4513"/>
  <rect x="6" y="90" width="4" height="5" fill="#8B4513"/>
  <rect x="6" y="100" width="4" height="5" fill="#8B4513"/>
  
  <!-- 银色扣子 -->
  <rect x="31" y="80" width="4" height="6" fill="#C0C0C0"/>
  <rect x="32" y="81" width="2" height="4" fill="#E5E5E5"/>
  
  <!-- 边框 -->
  <rect x="7" y="54" width="52" height="1" fill="#654321"/>
  <rect x="7" y="54" width="1" height="62" fill="#654321"/>
  <rect x="58" y="54" width="1" height="62" fill="#A0522D"/>
  <rect x="8" y="115" width="50" height="1" fill="#654321"/>`,

    "mage_spellbook_stage3": `<!-- 法师法术书 - 第三阶段（魔法书） -->
  
  <!-- 皮革书封 -->
  <rect x="3" y="50" width="60" height="70" fill="#8B4513"/>
  <rect x="5" y="52" width="56" height="66" fill="#A0522D"/>
  
  <!-- 悬浮暗示（无阴影，仅位置偏移） -->
  <rect x="1" y="48" width="64" height="74" fill="none" stroke="#2F2F2F" stroke-width="1" opacity="0.3"/>
  
  <!-- 金色角落 -->
  <rect x="3" y="50" width="10" height="10" fill="#DAA520"/>
  <rect x="53" y="50" width="10" height="10" fill="#FFD700"/>
  <rect x="3" y="110" width="10" height="10" fill="#DAA520"/>
  <rect x="53" y="110" width="10" height="10" fill="#FFD700"/>
  
  <!-- 明亮青色发光符文网格 -->
  <rect x="13" y="65" width="1" height="1" fill="#00FFFF"/>
  <rect x="16" y="63" width="1" height="1" fill="#00FFFF"/>
  <rect x="19" y="66" width="1" height="1" fill="#00FFFF"/>
  <rect x="23" y="62" width="1" height="1" fill="#00FFFF"/>
  <rect x="26" y="68" width="1" height="1" fill="#00FFFF"/>
  <rect x="30" y="64" width="1" height="1" fill="#00FFFF"/>
  <rect x="33" y="67" width="1" height="1" fill="#00FFFF"/>
  <rect x="37" y="61" width="1" height="1" fill="#00FFFF"/>
  <rect x="40" y="65" width="1" height="1" fill="#00FFFF"/>
  <rect x="44" y="69" width="1" height="1" fill="#00FFFF"/>
  <rect x="47" y="63" width="1" height="1" fill="#00FFFF"/>
  <rect x="51" y="66" width="1" height="1" fill="#00FFFF"/>
  
  <rect x="15" y="80" width="1" height="1" fill="#00FFFF"/>
  <rect x="18" y="83" width="1" height="1" fill="#00FFFF"/>
  <rect x="22" y="78" width="1" height="1" fill="#00FFFF"/>
  <rect x="25" y="84" width="1" height="1" fill="#00FFFF"/>
  <rect x="29" y="81" width="1" height="1" fill="#00FFFF"/>
  <rect x="32" y="79" width="1" height="1" fill="#00FFFF"/>
  <rect x="36" y="85" width="1" height="1" fill="#00FFFF"/>
  <rect x="39" y="82" width="1" height="1" fill="#00FFFF"/>
  <rect x="43" y="80" width="1" height="1" fill="#00FFFF"/>
  <rect x="46" y="86" width="1" height="1" fill="#00FFFF"/>
  <rect x="49" y="83" width="1" height="1" fill="#00FFFF"/>
  <rect x="53" y="81" width="1" height="1" fill="#00FFFF"/>
  
  <rect x="17" y="95" width="1" height="1" fill="#00FFFF"/>
  <rect x="20" y="98" width="1" height="1" fill="#00FFFF"/>
  <rect x="24" y="93" width="1" height="1" fill="#00FFFF"/>
  <rect x="27" y="99" width="1" height="1" fill="#00FFFF"/>
  <rect x="31" y="96" width="1" height="1" fill="#00FFFF"/>
  <rect x="34" y="94" width="1" height="1" fill="#00FFFF"/>
  <rect x="38" y="100" width="1" height="1" fill="#00FFFF"/>
  <rect x="41" y="97" width="1" height="1" fill="#00FFFF"/>
  <rect x="45" y="95" width="1" height="1" fill="#00FFFF"/>
  <rect x="48" y="101" width="1" height="1" fill="#00FFFF"/>
  <rect x="51" y="98" width="1" height="1" fill="#00FFFF"/>
  
  <!-- 书签标签 -->
  <rect x="61" y="60" width="3" height="35" fill="#DC143C"/>
  <rect x="62" y="61" width="1" height="33" fill="#FF6347"/>
  
  <!-- 书脊 -->
  <rect x="1" y="50" width="4" height="70" fill="#654321"/>
  <rect x="1" y="55" width="4" height="6" fill="#8B4513"/>
  <rect x="1" y="65" width="4" height="6" fill="#8B4513"/>
  <rect x="1" y="75" width="4" height="6" fill="#8B4513"/>
  <rect x="1" y="85" width="4" height="6" fill="#8B4513"/>
  <rect x="1" y="95" width="4" height="6" fill="#8B4513"/>
  <rect x="1" y="105" width="4" height="6" fill="#8B4513"/>
  
  <!-- 金色扣子 -->
  <rect x="31" y="82" width="4" height="6" fill="#DAA520"/>
  <rect x="32" y="83" width="2" height="4" fill="#FFD700"/>
  
  <!-- 边框 -->
  <rect x="2" y="49" width="62" height="1" fill="#654321"/>
  <rect x="2" y="49" width="1" height="72" fill="#654321"/>
  <rect x="63" y="49" width="1" height="72" fill="#A0522D"/>
  <rect x="3" y="120" width="60" height="1" fill="#654321"/>`,

    "mage_orb_focus_stage1": `<!-- 法师聚焦宝珠 - 第一阶段 -->
  
  <!-- 小蓝宝珠（3x3px） -->
  <rect x="32" y="80" width="8" height="8" fill="#1E90FF"/>
  <rect x="33" y="81" width="6" height="6" fill="#4169E1"/>
  <rect x="34" y="82" width="4" height="4" fill="#0000FF"/>
  <rect x="35" y="83" width="2" height="2" fill="#191970"/>
  
  <!-- 黑色轮廓 -->
  <rect x="31" y="79" width="10" height="1" fill="#000000"/>
  <rect x="31" y="79" width="1" height="10" fill="#000000"/>
  <rect x="40" y="79" width="1" height="10" fill="#000000"/>
  <rect x="32" y="88" width="8" height="1" fill="#000000"/>
  
  <!-- 手持暗示（简单手臂） -->
  <rect x="24" y="85" width="8" height="6" fill="#d2a679"/>
  <rect x="23" y="86" width="2" height="4" fill="#c49565"/>
  <rect x="29" y="86" width="2" height="4" fill="#b38451"/>
  
  <!-- 手指像素 -->
  <rect x="30" y="82" width="2" height="6" fill="#d2a679"/>
  <rect x="40" y="82" width="2" height="6" fill="#d2a679"/>`,

    "mage_orb_focus_stage2": `<!-- 法师聚焦宝珠 - 第二阶段 -->
  
  <!-- 宝珠与金属环框架 -->
  <rect x="28" y="80" width="10" height="10" fill="#1E90FF"/>
  <rect x="29" y="81" width="8" height="8" fill="#4169E1"/>
  <rect x="30" y="82" width="6" height="6" fill="#0000FF"/>
  <rect x="31" y="83" width="4" height="4" fill="#191970"/>
  
  <!-- 金属环框架 -->
  <rect x="25" y="77" width="16" height="2" fill="#808080"/>
  <rect x="25" y="91" width="16" height="2" fill="#808080"/>
  <rect x="25" y="77" width="2" height="16" fill="#808080"/>
  <rect x="39" y="77" width="2" height="16" fill="#A9A9A9"/>
  
  <!-- 1px高光 -->
  <rect x="33" y="79" width="1" height="1" fill="#87CEEB"/>
  <rect x="35" y="81" width="1" height="1" fill="#87CEEB"/>
  <rect x="32" y="84" width="1" height="1" fill="#87CEEB"/>
  <rect x="34" y="86" width="1" height="1" fill="#87CEEB"/>
  
  <!-- 两个环绕碎片 -->
  <rect x="18" y="75" width="3" height="3" fill="#4169E1"/>
  <rect x="19" y="76" width="1" height="1" fill="#87CEEB"/>
  
  <rect x="45" y="90" width="3" height="3" fill="#4169E1"/>
  <rect x="46" y="91" width="1" height="1" fill="#87CEEB"/>
  
  <!-- 手持 -->
  <rect x="21" y="87" width="8" height="8" fill="#d2a679"/>
  <rect x="20" y="88" width="2" height="6" fill="#c49565"/>
  <rect x="26" y="88" width="2" height="6" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="27" y="83" width="2" height="8" fill="#d2a679"/>
  <rect x="37" y="83" width="2" height="8" fill="#d2a679"/>`,

    "mage_orb_focus_stage3": `<!-- 法师聚焦宝珠 - 第三阶段 -->
  
  <!-- 辐射核心宝珠（4x4px） -->
  <rect x="27" y="80" width="12" height="12" fill="#1E90FF"/>
  <rect x="28" y="81" width="10" height="10" fill="#4169E1"/>
  <rect x="29" y="82" width="8" height="8" fill="#0000FF"/>
  <rect x="30" y="83" width="6" height="6" fill="#191970"/>
  <rect x="31" y="84" width="4" height="4" fill="#000080"/>
  
  <!-- 方形光晕阶梯 -->
  <rect x="24" y="77" width="18" height="2" fill="#87CEEB" opacity="0.7"/>
  <rect x="24" y="93" width="18" height="2" fill="#87CEEB" opacity="0.7"/>
  <rect x="24" y="77" width="2" height="18" fill="#87CEEB" opacity="0.7"/>
  <rect x="40" y="77" width="2" height="18" fill="#87CEEB" opacity="0.7"/>
  
  <rect x="21" y="74" width="24" height="2" fill="#B0E0E6" opacity="0.5"/>
  <rect x="21" y="96" width="24" height="2" fill="#B0E0E6" opacity="0.5"/>
  <rect x="21" y="74" width="2" height="24" fill="#B0E0E6" opacity="0.5"/>
  <rect x="43" y="74" width="2" height="24" fill="#B0E0E6" opacity="0.5"/>
  
  <!-- 四个环绕碎片带轨迹像素 -->
  <rect x="13" y="71" width="4" height="4" fill="#4169E1"/>
  <rect x="14" y="72" width="2" height="2" fill="#87CEEB"/>
  <!-- 轨迹像素 -->
  <rect x="15" y="75" width="1" height="1" fill="#87CEEB" opacity="0.5"/>
  <rect x="17" y="77" width="1" height="1" fill="#87CEEB" opacity="0.3"/>
  
  <rect x="49" y="71" width="4" height="4" fill="#4169E1"/>
  <rect x="50" y="72" width="2" height="2" fill="#87CEEB"/>
  <!-- 轨迹像素 -->
  <rect x="49" y="75" width="1" height="1" fill="#87CEEB" opacity="0.5"/>
  <rect x="47" y="77" width="1" height="1" fill="#87CEEB" opacity="0.3"/>
  
  <rect x="13" y="96" width="4" height="4" fill="#4169E1"/>
  <rect x="14" y="97" width="2" height="2" fill="#87CEEB"/>
  <!-- 轨迹像素 -->
  <rect x="15" y="94" width="1" height="1" fill="#87CEEB" opacity="0.5"/>
  <rect x="17" y="92" width="1" height="1" fill="#87CEEB" opacity="0.3"/>
  
  <rect x="49" y="96" width="4" height="4" fill="#4169E1"/>
  <rect x="50" y="97" width="2" height="2" fill="#87CEEB"/>
  <!-- 轨迹像素 -->
  <rect x="49" y="94" width="1" height="1" fill="#87CEEB" opacity="0.5"/>
  <rect x="47" y="92" width="1" height="1" fill="#87CEEB" opacity="0.3"/>
  
  <!-- 手持 -->
  <rect x="21" y="88" width="8" height="8" fill="#d2a679"/>
  <rect x="20" y="89" width="2" height="6" fill="#c49565"/>
  <rect x="26" y="89" width="2" height="6" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="27" y="84" width="2" height="8" fill="#d2a679"/>
  <rect x="37" y="84" width="2" height="8" fill="#d2a679"/>`,

    "archer_longbow_stage1": `<!-- 弓箭手长弓 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 木质弓身主体 -->
  <rect x="7" y="9" width="7" height="161" fill="#8B4513"/>
  <rect x="7" y="9" width="3" height="161" fill="#654321"/>
  <rect x="11" y="9" width="3" height="161" fill="#A0522D"/>
  
  <!-- 方块状弯曲通过阶梯像素实现 -->
  <!-- 上弓臂 -->
  <rect x="9" y="9" width="5" height="18" fill="#8B4513"/>
  <rect x="11" y="4" width="4" height="22" fill="#8B4513"/>
  <rect x="12" y="0" width="4" height="27" fill="#8B4513"/>
  <rect x="16" y="2" width="4" height="25" fill="#8B4513"/>
  <rect x="20" y="4" width="4" height="22" fill="#8B4513"/>
  
  <!-- 下弓臂 -->
  <rect x="9" y="152" width="5" height="18" fill="#8B4513"/>
  <rect x="11" y="148" width="4" height="22" fill="#8B4513"/>
  <rect x="12" y="143" width="4" height="27" fill="#8B4513"/>
  <rect x="16" y="145" width="4" height="25" fill="#8B4513"/>
  <rect x="20" y="148" width="4" height="22" fill="#8B4513"/>
  
  <!-- 弓弦线 -->
  <rect x="22" y="4" width="1" height="166" fill="#F5F5DC"/>
  
  <!-- 握把区域 -->
  <rect x="5" y="85" width="11" height="27" fill="#654321"/>
  <rect x="7" y="87" width="7" height="23" fill="#8B4513"/>
  
  <!-- 握把纹理 -->
  <rect x="9" y="89" width="4" height="4" fill="#654321"/>
  <rect x="9" y="95" width="4" height="4" fill="#654321"/>
  <rect x="9" y="100" width="4" height="4" fill="#654321"/>
  <rect x="9" y="106" width="4" height="4" fill="#654321"/>
  
  <!-- 基础箭束 -->
  <rect x="29" y="85" width="18" height="5" fill="#654321"/>
  <rect x="31" y="87" width="14" height="2" fill="#8B4513"/>
  
  <!-- 箭头顶部可见 -->
  <rect x="45" y="85" width="4" height="5" fill="#C0C0C0"/>
  <rect x="49" y="85" width="4" height="5" fill="#A9A9A9"/>
  <rect x="53" y="85" width="4" height="5" fill="#C0C0C0"/>
  <rect x="56" y="85" width="4" height="5" fill="#A9A9A9"/>
  
  <!-- 木质纹理细节 -->
  <rect x="8" y="13" width="2" height="7" fill="#654321"/>
  <rect x="8" y="31" width="2" height="7" fill="#654321"/>
  <rect x="8" y="49" width="2" height="7" fill="#654321"/>
  <rect x="8" y="67" width="2" height="7" fill="#654321"/>
  <rect x="8" y="121" width="2" height="7" fill="#654321"/>
  <rect x="8" y="139" width="2" height="7" fill="#654321"/>
  <rect x="8" y="157" width="2" height="7" fill="#654321"/>`,

    "archer_longbow_stage2": `<!-- 弓箭手长弓 - 第二阶段 -->
  
  <!-- 强化弓身 -->
  <rect x="30" y="5" width="7" height="164" fill="#8B4513"/>
  <rect x="30" y="5" width="3" height="164" fill="#654321"/>
  <rect x="34" y="5" width="3" height="164" fill="#A0522D"/>
  
  <!-- 铁制弓梢帽 -->
  <rect x="28" y="3" width="11" height="5" fill="#808080"/>
  <rect x="28" y="165" width="11" height="5" fill="#808080"/>
  <rect x="29" y="4" width="9" height="4" fill="#A9A9A9"/>
  <rect x="29" y="165" width="9" height="4" fill="#A9A9A9"/>
  
  <!-- 弓弦 -->
  <rect x="45" y="0" width="1" height="168" fill="#F5F5DC"/>
  
  <!-- 握把处绿宝石（2px） -->
  <rect x="32" y="80" width="4" height="4" fill="#00FF00"/>
  <rect x="33" y="81" width="2" height="2" fill="#32CD32"/>
  
  <!-- 握把包裹 -->
  <rect x="27" y="77" width="13" height="18" fill="#654321"/>
  <rect x="28" y="78" width="11" height="16" fill="#8B4513"/>
  
  <!-- 箭束 -->
  <rect x="21" y="86" width="3" height="36" fill="#8B4513"/>
  <rect x="19" y="85" width="2" height="3" fill="#C0C0C0"/>
  <rect x="22" y="85" width="2" height="3" fill="#C0C0C0"/>
  <rect x="24" y="85" width="2" height="3" fill="#C0C0C0"/>
  
  <!-- 2色羽毛 -->
  <rect x="19" y="118" width="2" height="5" fill="#FF0000"/>
  <rect x="22" y="118" width="2" height="5" fill="#FFFFFF"/>
  <rect x="24" y="118" width="2" height="5" fill="#FF0000"/>`,

    "archer_longbow_stage3": `<!-- 弓箭手长弓 - 第三阶段 -->
  
  <!-- 金色弓身 -->
  <rect x="25" y="5" width="7" height="164" fill="#DAA520"/>
  <rect x="25" y="5" width="3" height="164" fill="#B8860B"/>
  <rect x="29" y="5" width="3" height="164" fill="#FFD700"/>
  
  <!-- 金色弓梢帽 -->
  <rect x="23" y="3" width="11" height="5" fill="#FFD700"/>
  <rect x="23" y="165" width="11" height="5" fill="#FFD700"/>
  <rect x="24" y="4" width="9" height="4" fill="#FFFFFF"/>
  <rect x="24" y="165" width="9" height="4" fill="#FFFFFF"/>
  
  <!-- 弓弦 -->
  <rect x="40" y="0" width="1" height="168" fill="#F5F5DC"/>
  
  <!-- 发光箭口 -->
  <rect x="27" y="80" width="5" height="5" fill="#00FFFF"/>
  <rect x="28" y="81" width="4" height="4" fill="#87CEEB"/>
  
  <!-- 握把包裹 -->
  <rect x="22" y="77" width="13" height="18" fill="#654321"/>
  <rect x="23" y="78" width="11" height="16" fill="#8B4513"/>
  
  <!-- 搭箭时的能量箭头（青色2px尖端） -->
  <rect x="34" y="80" width="11" height="4" fill="#8B4513"/>
  <rect x="45" y="81" width="4" height="2" fill="#C0C0C0"/>
  <rect x="48" y="82" width="2" height="1" fill="#00FFFF"/>
  <rect x="50" y="82" width="1" height="1" fill="#87CEEB"/>
  
  <!-- 箭束 -->
  <rect x="16" y="86" width="3" height="36" fill="#8B4513"/>
  <rect x="14" y="85" width="2" height="3" fill="#E5E5E5"/>
  <rect x="17" y="85" width="2" height="3" fill="#E5E5E5"/>
  <rect x="19" y="85" width="2" height="3" fill="#E5E5E5"/>
  
  <!-- 精致羽毛 -->
  <rect x="14" y="118" width="2" height="5" fill="#DC143C"/>
  <rect x="17" y="118" width="2" height="5" fill="#FFFFFF"/>
  <rect x="19" y="118" width="2" height="5" fill="#DC143C"/>
  <rect x="16" y="123" width="2" height="2" fill="#FFD700"/>`,

    "archer_quiver_set_stage1": `<!-- 弓箭手箭袋套装 - 第一阶段 -->
  
  <!-- 皮革箭袋 -->
  <rect x="22" y="59" width="20" height="60" fill="#8B4513"/>
  <rect x="23" y="60" width="18" height="58" fill="#A0522D"/>
  
  <!-- 棕色带子 -->
  <rect x="20" y="64" width="24" height="3" fill="#654321"/>
  <rect x="20" y="74" width="24" height="3" fill="#654321"/>
  <rect x="20" y="84" width="24" height="3" fill="#654321"/>
  <rect x="20" y="94" width="24" height="3" fill="#654321"/>
  
  <!-- 少数箭头顶部可见 -->
  <rect x="27" y="54" width="2" height="8" fill="#C0C0C0"/>
  <rect x="30" y="56" width="2" height="6" fill="#C0C0C0"/>
  <rect x="33" y="55" width="2" height="7" fill="#C0C0C0"/>
  
  <!-- 箭尖 -->
  <rect x="27" y="52" width="2" height="2" fill="#808080"/>
  <rect x="30" y="54" width="2" height="2" fill="#808080"/>
  <rect x="33" y="53" width="2" height="2" fill="#808080"/>
  
  <!-- 羽毛 -->
  <rect x="27" y="59" width="2" height="3" fill="#FFFFFF"/>
  <rect x="30" y="61" width="2" height="3" fill="#FFFFFF"/>
  <rect x="33" y="60" width="2" height="3" fill="#FFFFFF"/>
  
  <!-- 简单肩带 -->
  <rect x="42" y="49" width="3" height="25" fill="#654321"/>
  <rect x="43" y="50" width="1" height="23" fill="#8B4513"/>
  
  <!-- 箭袋底部 -->
  <rect x="21" y="117" width="22" height="4" fill="#654321"/>
  <rect x="22" y="118" width="20" height="2" fill="#A0522D"/>`,

    "archer_quiver_set_stage2": `<!-- 弓箭手箭袋套装 - 第二阶段 -->
  
  <!-- 皮革箭袋 -->
  <rect x="22" y="60" width="20" height="60" fill="#8B4513"/>
  <rect x="23" y="61" width="18" height="58" fill="#A0522D"/>
  
  <!-- 银色边缘 -->
  <rect x="21" y="59" width="22" height="2" fill="#C0C0C0"/>
  <rect x="21" y="59" width="2" height="62" fill="#C0C0C0"/>
  <rect x="41" y="59" width="2" height="62" fill="#E5E5E5"/>
  <rect x="23" y="119" width="18" height="2" fill="#C0C0C0"/>
  
  <!-- 棕色带子 -->
  <rect x="19" y="65" width="26" height="3" fill="#654321"/>
  <rect x="19" y="75" width="26" height="3" fill="#654321"/>
  <rect x="19" y="85" width="26" height="3" fill="#654321"/>
  <rect x="19" y="95" width="26" height="3" fill="#654321"/>
  
  <!-- 更多箭头像素 -->
  <rect x="26" y="55" width="2" height="8" fill="#E5E5E5"/>
  <rect x="29" y="57" width="2" height="6" fill="#E5E5E5"/>
  <rect x="32" y="56" width="2" height="7" fill="#E5E5E5"/>
  <rect x="35" y="58" width="2" height="5" fill="#E5E5E5"/>
  <rect x="38" y="57" width="2" height="6" fill="#E5E5E5"/>
  
  <!-- 箭尖 -->
  <rect x="26" y="53" width="2" height="2" fill="#A9A9A9"/>
  <rect x="29" y="55" width="2" height="2" fill="#A9A9A9"/>
  <rect x="32" y="54" width="2" height="2" fill="#A9A9A9"/>
  <rect x="35" y="56" width="2" height="2" fill="#A9A9A9"/>
  <rect x="38" y="55" width="2" height="2" fill="#A9A9A9"/>
  
  <!-- 羽毛 -->
  <rect x="26" y="60" width="2" height="3" fill="#FF0000"/>
  <rect x="29" y="62" width="2" height="3" fill="#FFFFFF"/>
  <rect x="32" y="61" width="2" height="3" fill="#FF0000"/>
  <rect x="35" y="63" width="2" height="3" fill="#FFFFFF"/>
  <rect x="38" y="62" width="2" height="3" fill="#FF0000"/>
  
  <!-- 整齐肩带 -->
  <rect x="43" y="48" width="4" height="28" fill="#654321"/>
  <rect x="44" y="49" width="2" height="26" fill="#8B4513"/>
  
  <!-- 带扣 -->
  <rect x="45" y="58" width="2" height="3" fill="#C0C0C0"/>
  <rect x="45" y="59" width="2" height="1" fill="#808080"/>
  
  <!-- 箭袋底部 -->
  <rect x="21" y="118" width="22" height="4" fill="#654321"/>
  <rect x="22" y="119" width="20" height="2" fill="#A0522D"/>`,

    "archer_quiver_set_stage3": `<!-- 弓箭手箭袋套装 - 第三阶段 -->
  
  <!-- 皮革箭袋 -->
  <rect x="22" y="61" width="20" height="60" fill="#8B4513"/>
  <rect x="23" y="62" width="18" height="58" fill="#A0522D"/>
  
  <!-- 符文边缘 -->
  <rect x="21" y="60" width="22" height="2" fill="#C0C0C0"/>
  <rect x="21" y="60" width="2" height="62" fill="#C0C0C0"/>
  <rect x="41" y="60" width="2" height="62" fill="#E5E5E5"/>
  <rect x="23" y="120" width="18" height="2" fill="#C0C0C0"/>
  
  <!-- 青色符文点 -->
  <rect x="25" y="69" width="1" height="1" fill="#00FFFF"/>
  <rect x="28" y="73" width="1" height="1" fill="#00FFFF"/>
  <rect x="31" y="69" width="1" height="1" fill="#00FFFF"/>
  <rect x="34" y="74" width="1" height="1" fill="#00FFFF"/>
  <rect x="37" y="70" width="1" height="1" fill="#00FFFF"/>
  <rect x="25" y="81" width="1" height="1" fill="#00FFFF"/>
  <rect x="29" y="84" width="1" height="1" fill="#00FFFF"/>
  <rect x="32" y="80" width="1" height="1" fill="#00FFFF"/>
  <rect x="35" y="85" width="1" height="1" fill="#00FFFF"/>
  <rect x="38" y="82" width="1" height="1" fill="#00FFFF"/>
  
  <!-- 棕色带子 -->
  <rect x="19" y="66" width="26" height="3" fill="#654321"/>
  <rect x="19" y="76" width="26" height="3" fill="#654321"/>
  <rect x="19" y="86" width="26" height="3" fill="#654321"/>
  <rect x="19" y="96" width="26" height="3" fill="#654321"/>
  
  <!-- 更多箭头像素 -->
  <rect x="25" y="55" width="2" height="9" fill="#F8F8F8"/>
  <rect x="28" y="57" width="2" height="7" fill="#F8F8F8"/>
  <rect x="31" y="56" width="2" height="8" fill="#F8F8F8"/>
  <rect x="34" y="58" width="2" height="6" fill="#F8F8F8"/>
  <rect x="37" y="57" width="2" height="7" fill="#F8F8F8"/>
  
  <!-- 箭尖周围微弱方形发光 -->
  <rect x="24" y="52" width="4" height="4" fill="#87CEEB" opacity="0.3"/>
  <rect x="27" y="54" width="4" height="4" fill="#87CEEB" opacity="0.3"/>
  <rect x="30" y="53" width="4" height="4" fill="#87CEEB" opacity="0.3"/>
  <rect x="33" y="55" width="4" height="4" fill="#87CEEB" opacity="0.3"/>
  <rect x="36" y="54" width="4" height="4" fill="#87CEEB" opacity="0.3"/>
  
  <!-- 箭尖 -->
  <rect x="25" y="53" width="2" height="2" fill="#E5E5E5"/>
  <rect x="28" y="55" width="2" height="2" fill="#E5E5E5"/>
  <rect x="31" y="54" width="2" height="2" fill="#E5E5E5"/>
  <rect x="34" y="56" width="2" height="2" fill="#E5E5E5"/>
  <rect x="37" y="55" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 羽毛 -->
  <rect x="25" y="61" width="2" height="3" fill="#DC143C"/>
  <rect x="28" y="63" width="2" height="3" fill="#FFFFFF"/>
  <rect x="31" y="62" width="2" height="3" fill="#DC143C"/>
  <rect x="34" y="64" width="2" height="3" fill="#FFFFFF"/>
  <rect x="37" y="63" width="2" height="3" fill="#DC143C"/>
  
  <!-- 符文肩带 -->
  <rect x="43" y="47" width="4" height="30" fill="#654321"/>
  <rect x="44" y="48" width="2" height="28" fill="#8B4513"/>
  
  <!-- 肩带符文 -->
  <rect x="45" y="56" width="1" height="1" fill="#00FFFF"/>
  <rect x="45" y="66" width="1" height="1" fill="#00FFFF"/>
  
  <!-- 带扣 -->
  <rect x="45" y="59" width="2" height="3" fill="#C0C0C0"/>
  <rect x="45" y="60" width="2" height="1" fill="#808080"/>
  
  <!-- 箭袋底部 -->
  <rect x="21" y="119" width="22" height="4" fill="#654321"/>
  <rect x="22" y="120" width="20" height="2" fill="#A0522D"/>`,

    "archer_crossbow_stage1": `<!-- 弓箭手弩 - 第一阶段 -->
  
  <!-- 木制弩身 -->
  <rect x="18" y="72" width="30" height="8" fill="#8B4513"/>
  <rect x="18" y="72" width="10" height="8" fill="#654321"/>
  <rect x="38" y="72" width="10" height="8" fill="#A0522D"/>
  
  <!-- 方块肢体 -->
  <rect x="3" y="67" width="30" height="6" fill="#8B4513"/>
  <rect x="33" y="67" width="30" height="6" fill="#8B4513"/>
  <rect x="3" y="67" width="10" height="6" fill="#654321"/>
  <rect x="53" y="67" width="10" height="6" fill="#654321"/>
  
  <!-- 弓弦 -->
  <rect x="1" y="69" width="64" height="1" fill="#F5F5DC"/>
  
  <!-- 铁制马镫方块 -->
  <rect x="46" y="80" width="4" height="8" fill="#808080"/>
  <rect x="46" y="80" width="1" height="8" fill="#696969"/>
  <rect x="49" y="80" width="1" height="8" fill="#A9A9A9"/>
  
  <!-- 扳机机构 -->
  <rect x="28" y="80" width="8" height="4" fill="#8B4513"/>
  <rect x="30" y="82" width="4" height="2" fill="#654321"/>
  
  <!-- 握把 -->
  <rect x="23" y="84" width="8" height="20" fill="#8B4513"/>
  <rect x="24" y="85" width="6" height="18" fill="#A0522D"/>
  
  <!-- 简单箭矢 -->
  <rect x="8" y="69" width="20" height="1" fill="#8B4513"/>
  <rect x="6" y="69" width="2" height="1" fill="#C0C0C0"/>`,

    "archer_crossbow_stage2": `<!-- 弓箭手弩 - 第二阶段 -->
  
  <!-- 钢制加厚弩身 -->
  <rect x="15" y="69" width="35" height="11" fill="#808080"/>
  <rect x="15" y="69" width="11" height="11" fill="#696969"/>
  <rect x="40" y="69" width="11" height="11" fill="#A9A9A9"/>
  
  <!-- 钢制弩臂 -->
  <rect x="2" y="63" width="31" height="7" fill="#A9A9A9"/>
  <rect x="33" y="63" width="31" height="7" fill="#A9A9A9"/>
  <rect x="2" y="63" width="11" height="7" fill="#808080"/>
  <rect x="53" y="63" width="11" height="7" fill="#C0C0C0"/>
  
  <!-- 弓弦 -->
  <rect x="0" y="66" width="65" height="1" fill="#F5F5DC"/>
  
  <!-- 铁制马镫 -->
  <rect x="48" y="79" width="5" height="9" fill="#A9A9A9"/>
  <rect x="48" y="79" width="2" height="9" fill="#808080"/>
  <rect x="52" y="79" width="2" height="9" fill="#C0C0C0"/>
  
  <!-- 扳机机构 -->
  <rect x="25" y="79" width="11" height="5" fill="#8B4513"/>
  <rect x="27" y="81" width="7" height="2" fill="#654321"/>
  <rect x="29" y="82" width="2" height="1" fill="#A0522D"/>
  
  <!-- 握把 -->
  <rect x="22" y="85" width="11" height="22" fill="#8B4513"/>
  <rect x="23" y="85" width="9" height="20" fill="#A0522D"/>
  
  <!-- 1px高光的箭矢 -->
  <rect x="6" y="66" width="22" height="2" fill="#8B4513"/>
  <rect x="4" y="67" width="3" height="1" fill="#E5E5E5"/>
  <rect x="7" y="66" width="21" height="1" fill="#A0522D"/>`,

    "archer_crossbow_stage3": `<!-- 弓箭手弩 - 第三阶段（奥术弩） -->
  
  <!-- 奥术弩身 -->
  <rect x="16" y="67" width="36" height="12" fill="#8B4513"/>
  <rect x="16" y="67" width="12" height="12" fill="#654321"/>
  <rect x="40" y="67" width="12" height="12" fill="#A0522D"/>
  
  <!-- 弩臂上的紫色发光字符 -->
  <rect x="2" y="62" width="31" height="8" fill="#A9A9A9"/>
  <rect x="34" y="62" width="31" height="8" fill="#A9A9A9"/>
  <rect x="2" y="62" width="10" height="8" fill="#808080"/>
  <rect x="55" y="62" width="10" height="8" fill="#C0C0C0"/>
  
  <!-- 紫色字符 -->
  <rect x="9" y="64" width="1" height="1" fill="#9370DB"/>
  <rect x="12" y="66" width="1" height="1" fill="#9370DB"/>
  <rect x="16" y="64" width="1" height="1" fill="#9370DB"/>
  <rect x="19" y="65" width="1" height="1" fill="#9370DB"/>
  <rect x="42" y="64" width="1" height="1" fill="#9370DB"/>
  <rect x="45" y="66" width="1" height="1" fill="#9370DB"/>
  <rect x="49" y="64" width="1" height="1" fill="#9370DB"/>
  <rect x="52" y="65" width="1" height="1" fill="#9370DB"/>
  <rect x="55" y="64" width="1" height="1" fill="#9370DB"/>
  <rect x="58" y="66" width="1" height="1" fill="#9370DB"/>
  
  <!-- 弓弦 -->
  <rect x="1" y="65" width="64" height="1" fill="#F5F5DC"/>
  
  <!-- 铁制马镫 -->
  <rect x="50" y="78" width="7" height="10" fill="#A9A9A9"/>
  <rect x="50" y="78" width="2" height="10" fill="#808080"/>
  <rect x="55" y="78" width="2" height="10" fill="#C0C0C0"/>
  
  <!-- 扳机机构 -->
  <rect x="26" y="78" width="13" height="7" fill="#8B4513"/>
  <rect x="27" y="80" width="10" height="3" fill=\"654321\"/>
  <rect x="95\" y=\"134\" width=\"6\" height=\"2\" fill=\"#A0522D\"/>
  
  <!-- 握把 -->
  <rect x="22" y="85" width="13" height="23" fill="#8B4513"/>
  <rect x="23" y="86" width="12" height="21" fill="#A0522D"/>
  
  <!-- 预装箭矢带发光尖端 -->
  <rect x="5" y="64" width="25" height="2" fill="#8B4513"/>
  <rect x="3" y="65" width="3" height="1" fill="#E5E5E5"/>
  <rect x="7" y="64" width="23" height="1" fill="#A0522D"/>
  <rect x="2" y="65" width="2" height="1" fill="#9370DB"/>
  <rect x="0" y="65" width="2" height="1" fill="#DA70D6"/>`,

    "rogue_twin_daggers_stage1": `<!-- 盗贼匕首 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 左匕首 -->
  <!-- 左刀刃 -->
  <rect x="5" y="44" width="7" height="56" fill="#C0C0C0"/>
  <rect x="5" y="44" width="3" height="56" fill="#A9A9A9"/>
  <rect x="9" y="44" width="3" height="56" fill="#E5E5E5"/>
  
  <!-- 左刀尖 -->
  <rect x="7" y="40" width="4" height="5" fill="#C0C0C0"/>
  <rect x="7" y="37" width="2" height="3" fill="#C0C0C0"/>
  
  <!-- 左护手 -->
  <rect x="0" y="100" width="17" height="6" fill="#808080"/>
  <rect x="0" y="100" width="4" height="6" fill="#696969"/>
  <rect x="13" y="100" width="4" height="6" fill="#D3D3D3"/>
  
  <!-- 左刀柄 -->
  <rect x="7" y="105" width="4" height="28" fill="#8B4513"/>
  <rect x="7" y="105" width="1" height="28" fill="#654321"/>
  <rect x="9" y="105" width="1" height="28" fill="#A0522D"/>
  
  <!-- 左刀柄纹理 -->
  <rect x="7" y="109" width="2" height="2" fill="#654321"/>
  <rect x="7" y="115" width="2" height="2" fill="#654321"/>
  <rect x="7" y="120" width="2" height="2" fill="#654321"/>
  <rect x="7" y="126" width="2" height="2" fill="#654321"/>
  
  <!-- 右匕首 -->
  <!-- 右刀刃 -->
  <rect x="53" y="44" width="7" height="56" fill="#C0C0C0"/>
  <rect x="53" y="44" width="3" height="56" fill="#A9A9A9"/>
  <rect x="58" y="44" width="3" height="56" fill="#E5E5E5"/>
  
  <!-- 右刀尖 -->
  <rect x="55" y="40" width="4" height="5" fill="#C0C0C0"/>
  <rect x="56" y="37" width="2" height="3" fill="#C0C0C0"/>
  
  <!-- 右护手 -->
  <rect x="48" y="100" width="17" height="6" fill="#808080"/>
  <rect x="48" y="100" width="4" height="6" fill="#696969"/>
  <rect x="61" y="100" width="4" height="6" fill="#D3D3D3"/>
  
  <!-- 右刀柄 -->
  <rect x="55" y="105" width="4" height="28" fill="#8B4513"/>
  <rect x="55" y="105" width="1" height="28" fill="#654321"/>
  <rect x="58" y="105" width="1" height="28" fill="#A0522D"/>
  
  <!-- 右刀柄纹理 -->
  <rect x="56" y="109" width="2" height="2" fill="#654321"/>
  <rect x="56" y="115" width="2" height="2" fill="#654321"/>
  <rect x="56" y="120" width="2" height="2" fill="#654321"/>
  <rect x="56" y="126" width="2" height="2" fill="#654321"/>
  
  <!-- 交叉装饰效果 -->
  <rect x="28" y="72" width="9" height="2" fill="#A9A9A9" opacity="0.3"/>
  <rect x="31" y="67" width="4" height="11" fill="#A9A9A9" opacity="0.2"/>`,

    "rogue_twin_daggers_stage2": `<!-- 盗贼双匕首 - 第二阶段 -->
  
  <!-- 钢制匕首（左） -->
  <rect x="5" y="41" width="9" height="63" fill="#E5E5E5"/>
  <rect x="5" y="41" width="3" height="63" fill="#C0C0C0"/>
  <rect x="11" y="41" width="3" height="63" fill="#F8F8F8"/>
  
  <!-- 凹槽线 -->
  <rect x="8" y="45" width="2" height="54" fill="#A9A9A9"/>
  
  <!-- 匕首（右，轻微偏移姿势） -->
  <rect x="51" y="45" width="9" height="59" fill="#E5E5E5"/>
  <rect x="51" y="45" width="3" height="59" fill="#C0C0C0"/>
  <rect x="58" y="45" width="3" height="59" fill="#F8F8F8"/>
  
  <!-- 凹槽线 -->
  <rect x="55" y="50" width="2" height="50" fill="#A9A9A9"/>
  
  <!-- 护手（左） -->
  <rect x="0" y="104" width="18" height="5" fill="#808080"/>
  <rect x="0" y="104" width="5" height="5" fill="#696969"/>
  <rect x="14" y="104" width="5" height="5" fill="#A9A9A9"/>
  
  <!-- 护手（右） -->
  <rect x="47" y="104" width="18" height="5" fill="#808080"/>
  <rect x="47" y="104" width="5" height="5" fill="#696969"/>
  <rect x="60" y="104" width="5" height="5" fill="#A9A9A9"/>
  
  <!-- 包裹握把（左） -->
  <rect x="6" y="109" width="5" height="27" fill="#654321"/>
  <rect x="6" y="111" width="5" height="2" fill="#8B4513"/>
  <rect x="6" y="115" width="5" height="2" fill="#8B4513"/>
  <rect x="6" y="118" width="5" height="2" fill="#8B4513"/>
  
  <!-- 包裹握把（右） -->
  <rect x="53" y="109" width="5" height="27" fill="#654321"/>
  <rect x="53" y="111" width="5" height="2" fill="#8B4513"/>
  <rect x="53" y="115" width="5" height="2" fill="#8B4513"/>
  <rect x="53" y="118" width="5" height="2" fill="#8B4513"/>
  
  <!-- 匕首尖（左） -->
  <rect x="6" y="36" width="5" height="5" fill="#E5E5E5"/>
  <rect x="8" y="34" width="2" height="3" fill="#E5E5E5"/>
  
  <!-- 匕首尖（右） -->
  <rect x="53" y="41" width="5" height="5" fill="#E5E5E5"/>
  <rect x="55" y="38" width="2" height="3" fill="#E5E5E5"/>`,

    "rogue_twin_daggers_stage3": `<!-- 盗贼双匕首 - 第三阶段（暗影匕首） -->
  
  <!-- 黑色匕首（左） -->
  <rect x="5" y="41" width="9" height="63" fill="#2F2F2F"/>
  <rect x="5" y="41" width="3" height="63" fill="#1C1C1C"/>
  <rect x="11" y="41" width="3" height="63" fill="#4A4A4A"/>
  
  <!-- 紫色符文点 -->
  <rect x="8" y="54" width="1" height="1" fill="#9370DB"/>
  <rect x="7" y="68" width="1" height="1" fill="#9370DB"/>
  <rect x="9" y="81" width="1" height="1" fill="#9370DB"/>
  <rect x="6" y="95" width="1" height="1" fill="#9370DB"/>
  
  <!-- 匕首（右） -->
  <rect x="51" y="45" width="9" height="59" fill="#2F2F2F"/>
  <rect x="51" y="45" width="3" height="59" fill="#1C1C1C"/>
  <rect x="58" y="45" width="3" height="59" fill="#4A4A4A"/>
  
  <!-- 紫色符文点 -->
  <rect x="55" y="59" width="1" height="1" fill="#9370DB"/>
  <rect x="54" y="72" width="1" height="1" fill="#9370DB"/>
  <rect x="56" y="86" width="1" height="1" fill="#9370DB"/>
  <rect x="53" y="99" width="1" height="1" fill="#9370DB"/>
  
  <!-- 微弱阶梯光环（左） -->
  <rect x="2" y="38" width="14" height="2" fill="#4B0082" opacity="0.3"/>
  <rect x="2" y="106" width="14" height="2" fill="#4B0082" opacity="0.3"/>
  <rect x="2" y="38" width="2" height="70" fill="#4B0082" opacity="0.3"/>
  <rect x="14" y="38" width="2" height="70" fill="#4B0082" opacity="0.3"/>
  
  <!-- 微弱阶梯光环（右） -->
  <rect x="49" y="43" width="14" height="2" fill="#4B0082" opacity="0.3"/>
  <rect x="49" y="106" width="14" height="2" fill="#4B0082" opacity="0.3"/>
  <rect x="49" y="43" width="2" height="65" fill="#4B0082" opacity="0.3"/>
  <rect x="61" y="43" width="2" height="65" fill="#4B0082" opacity="0.3"/>
  
  <!-- 护手（左） -->
  <rect x="0" y="104" width="18" height="5" fill="#2F2F2F"/>
  <rect x="0" y="104" width="5" height="5" fill="#1C1C1C"/>
  <rect x="14" y="104" width="5" height="5" fill="#4A4A4A"/>
  
  <!-- 护手（右） -->
  <rect x="47" y="104" width="18" height="5" fill="#2F2F2F"/>
  <rect x="47" y="104" width="5" height="5" fill="#1C1C1C"/>
  <rect x="60" y="104" width="5" height="5" fill="#4A4A4A"/>
  
  <!-- 包裹握把（左） -->
  <rect x="6" y="109" width="5" height="27" fill="#654321"/>
  <rect x="6" y="111" width="5" height="2" fill="#8B4513"/>
  <rect x="6" y="115" width="5" height="2" fill="#8B4513"/>
  <rect x="6" y="118" width="5" height="2" fill="#8B4513"/>
  
  <!-- 包裹握把（右） -->
  <rect x="53" y="109" width="5" height="27" fill="#654321"/>
  <rect x="53" y="111" width="5" height="2" fill="#8B4513"/>
  <rect x="53" y="115" width="5" height="2" fill="#8B4513"/>
  <rect x="53" y="118" width="5" height="2" fill="#8B4513"/>
  
  <!-- 匕首尖（左） -->
  <rect x="6" y="36" width="5" height="5" fill="#2F2F2F"/>
  <rect x="8" y="34" width="2" height="3" fill="#2F2F2F"/>
  
  <!-- 匕首尖（右） -->
  <rect x="53" y="41" width="5" height="5" fill="#2F2F2F"/>
  <rect x="55" y="38" width="2" height="3" fill="#2F2F2F"/>
  
  <!-- 烟雾尘粒 -->
  <rect x="20" y="50" width="1" height="1" fill="#4B0082" opacity="0.5"/>
  <rect x="42" y="63" width="1" height="1" fill="#4B0082" opacity="0.5"/>
  <rect x="24" y="77" width="1" height="1" fill="#4B0082" opacity="0.5"/>
  <rect x="38" y="90" width="1" height="1" fill="#4B0082" opacity="0.5"/>`,

    "rogue_throwing_stars_stage1": `<!-- 盗贼飞镖 - 第一阶段 -->
  
  <!-- 简单4点手里剑 -->
  <rect x="31" y="82" width="4" height="4" fill="#808080"/>
  <rect x="32" y="83" width="2" height="2" fill="#A9A9A9"/>
  
  <!-- 中心洞像素 -->
  <rect x="32" y="83" width="2" height="2" fill="#1a1a1a"/>
  <rect x="33" y="84" width="1" height="1" fill="#000000"/>
  
  <!-- 四个尖端 -->
  <rect x="33" y="77" width="2" height="5" fill="#808080"/>
  <rect x="33" y="90" width="2" height="5" fill="#808080"/>
  <rect x="26" y="83" width="5" height="2" fill="#808080"/>
  <rect x="37" y="83" width="5" height="2" fill="#808080"/>
  
  <!-- 尖端细节 -->
  <rect x="33" y="75" width="2" height="2" fill="#696969"/>
  <rect x="33" y="93" width="2" height="2" fill="#696969"/>
  <rect x="24" y="83" width="2" height="2" fill="#696969"/>
  <rect x="40" y="83" width="2" height="2" fill="#696969"/>`,

    "rogue_throwing_stars_stage2": `<!-- 盗贼飞镖 - 第二阶段 -->
  
  <!-- 钢制星套装 -->
  <rect x="34" y="75" width="6" height="6" fill="#C0C0C0"/>
  <rect x="35" y="76" width="4" height="4" fill="#E5E5E5"/>
  
  <!-- 中心洞 -->
  <rect x="36" y="77" width="2" height="2" fill="#1a1a1a"/>
  <rect x="37" y="78" width="1" height="1" fill="#000000"/>
  
  <!-- 斜面1px边缘的四个尖端 -->
  <rect x="37" y="68" width="2" height="7" fill="#E5E5E5"/>
  <rect x="37" y="83" width="2" height="7" fill="#E5E5E5"/>
  <rect x="27" y="77" width="7" height="2" fill="#E5E5E5"/>
  <rect x="44" y="77" width="7" height="2" fill="#E5E5E5"/>
  
  <!-- 1px边缘高光 -->
  <rect x="36" y="68" width="1" height="7" fill="#FFFFFF"/>
  <rect x="39" y="68" width="1" height="7" fill="#C0C0C0"/>
  <rect x="36" y="83" width="1" height="7" fill="#FFFFFF"/>
  <rect x="39" y="83" width="1" height="7" fill="#C0C0C0"/>
  <rect x="27" y="76" width="7" height="1" fill="#FFFFFF"/>
  <rect x="27" y="79" width="7" height="1" fill="#C0C0C0"/>
  <rect x="44" y="76" width="7" height="1" fill="#FFFFFF"/>
  <rect x="44" y="79" width="7" height="1" fill="#C0C0C0"/>
  
  <!-- 腰带小袋 -->
  <rect x="14" y="90" width="20" height="12" fill="#8B4513"/>
  <rect x="15" y="91" width="18" height="10" fill="#A0522D"/>
  
  <!-- 袋子扣子 -->
  <rect x="22" y="95" width="4" height="2" fill="#654321"/>
  <rect x="23" y="96" width="2" height="1" fill="#8B4513"/>
  
  <!-- 第二个飞镖（部分可见在袋中） -->
  <rect x="19" y="93" width="3" height="3" fill="#C0C0C0"/>
  <rect x="26" y="94" width="3" height="3" fill="#C0C0C0"/>`,

    "rogue_throwing_stars_stage3": `<!-- 盗贼飞镖 - 第三阶段 -->
  
  <!-- 符文星 -->
  <rect x="34" y="75" width="6" height="6" fill="#2F2F2F"/>
  <rect x="35" y="76" width="4" height="4" fill="#4A4A4A"/>
  
  <!-- 紫色符文 -->
  <rect x="36" y="77" width="1" height="1" fill="#9370DB"/>
  <rect x="38" y="77" width="1" height="1" fill="#9370DB"/>
  <rect x="37" y="78" width="1" height="1" fill="#DA70D6"/>
  
  <!-- 尖端 -->
  <rect x="37" y="68" width="2" height="7" fill="#2F2F2F"/>
  <rect x="37" y="83" width="2" height="7" fill="#2F2F2F"/>
  <rect x="27" y="77" width="7" height="2" fill="#2F2F2F"/>
  <rect x="44" y="77" width="7" height="2" fill="#2F2F2F"/>
  
  <!-- 紫色边缘符文 -->
  <rect x="36" y="70" width="1" height="1" fill="#9370DB"/>
  <rect x="39" y="72" width="1" height="1" fill="#9370DB"/>
  <rect x="36" y="85" width="1" height="1" fill="#9370DB"/>
  <rect x="39" y="87" width="1" height="1" fill="#9370DB"/>
  <rect x="29" y="76" width="1" height="1" fill="#9370DB"/>
  <rect x="31" y="79" width="1" height="1" fill="#9370DB"/>
  <rect x="46" y="76" width="1" height="1" fill="#9370DB"/>
  <rect x="48" y="79" width="1" height="1" fill="#9370DB"/>
  
  <!-- 运动轨迹2-3错开鬼影像素 -->
  <rect x="32" y="75" width="2" height="2" fill="#9370DB" opacity="0.3"/>
  <rect x="30" y="75" width="2" height="2" fill="#4B0082" opacity="0.2"/>
  <rect x="44" y="77" width="2" height="2" fill="#9370DB" opacity="0.3"/>
  <rect x="46" y="77" width="2" height="2" fill="#4B0082" opacity="0.2"/>
  <rect x="37" y="71" width="2" height="2" fill="#9370DB" opacity="0.3"/>
  <rect x="37" y="69" width="2" height="2" fill="#4B0082" opacity="0.2"/>
  <rect x="37" y="85" width="2" height="2" fill="#9370DB" opacity="0.3"/>
  <rect x="37" y="87" width="2" height="2" fill="#4B0082" opacity="0.2"/>
  
  <!-- 腰带小袋 -->
  <rect x="14" y="90" width="20" height="12" fill="#2F2F2F"/>
  <rect x="15" y="91" width="18" height="10" fill="#4A4A4A"/>
  
  <!-- 符文袋子扣子 -->
  <rect x="22" y="95" width="4" height="2" fill="#9370DB"/>
  <rect x="23" y="96" width="2" height="1" fill="#DA70D6"/>
  
  <!-- 袋中符文星（部分可见） -->
  <rect x="19" y="93" width="3" height="3" fill="#2F2F2F"/>
  <rect x="26" y="94" width="3" height="3" fill="#2F2F2F"/>
  <rect x="20" y="94" width="1" height="1" fill="#9370DB"/>
  <rect x="27" y="95" width="1" height="1" fill="#9370DB"/>`,

    "rogue_shortsword_stage1": `<!-- 盗贼短剑 - 第一阶段 -->
  
  <!-- 紧凑铁短剑 -->
  <rect x="27" y="43" width="12" height="60" fill="#C0C0C0"/>
  <rect x="27" y="43" width="4" height="60" fill="#A9A9A9"/>
  <rect x="35" y="43" width="4" height="60" fill="#E5E5E5"/>
  
  <!-- 矩形轮廓 -->
  <rect x="26" y="42" width="14" height="1" fill="#808080"/>
  <rect x="26" y="42" width="1" height="62" fill="#808080"/>
  <rect x="39" y="42" width="1" height="62" fill="#F8F8F8"/>
  <rect x="27" y="103" width="12" height="1" fill="#808080"/>
  
  <!-- 剑尖 -->
  <rect x="29" y="38" width="8" height="5" fill="#C0C0C0"/>
  <rect x="31" y="35" width="4" height="3" fill="#C0C0C0"/>
  <rect x="32" y="33" width="2" height="2" fill="#C0C0C0"/>
  
  <!-- 简单护手 -->
  <rect x="21" y="103" width="24" height="6" fill="#808080"/>
  <rect x="21" y="103" width="6" height="6" fill="#696969"/>
  <rect x="39" y="103" width="6" height="6" fill="#A9A9A9"/>
  
  <!-- 剑柄 -->
  <rect x="29" y="109" width="8" height="25" fill="#8B4513"/>
  <rect x="29" y="109" width="3" height="25" fill="#654321"/>
  <rect x="34" y="109" width="3" height="25" fill="#A0522D"/>
  
  <!-- 剑首 -->
  <rect x="31" y="131" width="4" height="6" fill="#654321"/>
  <rect x="29" y="134" width="8" height="3" fill="#8B4513"/>`,

    "rogue_shortsword_stage2": `<!-- 盗贼短剑 - 第二阶段（双短剑） -->
  
  <!-- 短剑（左，镜像） -->
  <rect x="8" y="42" width="12" height="60" fill="#E5E5E5"/>
  <rect x="8" y="42" width="4" height="60" fill="#C0C0C0"/>
  <rect x="16" y="42" width="4" height="60" fill="#F8F8F8"/>
  
  <!-- Fuller线 -->
  <rect x="13" y="47" width="2" height="50" fill="#A9A9A9"/>
  
  <!-- 短剑（右，镜像） -->
  <rect x="46" y="42" width="12" height="60" fill="#E5E5E5"/>
  <rect x="46" y="42" width="4" height="60" fill="#C0C0C0"/>
  <rect x="54" y="42" width="4" height="60" fill="#F8F8F8"/>
  
  <!-- Fuller线 -->
  <rect x="51" y="47" width="2" height="50" fill="#A9A9A9"/>
  
  <!-- 剑尖（左） -->
  <rect x="10" y="37" width="8" height="5" fill="#E5E5E5"/>
  <rect x="12" y="34" width="4" height="3" fill="#E5E5E5"/>
  <rect x="13" y="32" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 剑尖（右） -->
  <rect x="48" y="37" width="8" height="5" fill="#E5E5E5"/>
  <rect x="50" y="34" width="4" height="3" fill="#E5E5E5"/>
  <rect x="51" y="32" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 增强护手（左） -->
  <rect x="2" y="102" width="24" height="8" fill="#808080"/>
  <rect x="2" y="102" width="6" height="8" fill="#696969"/>
  <rect x="20" y="102" width="6" height="8" fill="#A9A9A9"/>
  
  <!-- 增强护手（右） -->
  <rect x="40" y="102" width="24" height="8" fill="#808080"/>
  <rect x="40" y="102" width="6" height="8" fill="#696969"/>
  <rect x="58" y="102" width="6" height="8" fill="#A9A9A9"/>
  
  <!-- 剑柄（左） -->
  <rect x="10" y="110" width="8" height="25" fill="#8B4513"/>
  <rect x="10" y="110" width="3" height="25" fill="#654321"/>
  <rect x="15" y="110" width="3" height="25" fill="#A0522D"/>
  
  <!-- 剑柄（右） -->
  <rect x="48" y="110" width="8" height="25" fill="#8B4513"/>
  <rect x="48" y="110" width="3" height="25" fill="#654321"/>
  <rect x="53" y="110" width="3" height="25" fill="#A0522D"/>
  
  <!-- 剑首（左） -->
  <rect x="12" y="132" width="4" height="6" fill="#654321"/>
  <rect x="10" y="135" width="8" height="3" fill="#8B4513"/>
  
  <!-- 剑首（右） -->
  <rect x="50" y="132" width="4" height="6" fill="#654321"/>
  <rect x="48" y="135" width="8" height="3" fill="#8B4513"/>`,

    "rogue_shortsword_stage3": `<!-- 盗贼短剑 - 第三阶段（暗影尖端短剑） -->
  
  <!-- 暗钢短剑（左） -->
  <rect x="8" y="42" width="12" height="60" fill="#2F2F2F"/>
  <rect x="8" y="42" width="4" height="60" fill="#1C1C1C"/>
  <rect x="16" y="42" width="4" height="60" fill="#4A4A4A"/>
  
  <!-- 紫罗兰边缘像素 -->
  <rect x="7" y="47" width="1" height="50" fill="#8B008B"/>
  <rect x="20" y="47" width="1" height="50" fill="#8B008B"/>
  
  <!-- 暗钢短剑（右） -->
  <rect x="46" y="42" width="12" height="60" fill="#2F2F2F"/>
  <rect x="46" y="42" width="4" height="60" fill="#1C1C1C"/>
  <rect x="54" y="42" width="4" height="60" fill="#4A4A4A"/>
  
  <!-- 紫罗兰边缘像素 -->
  <rect x="45" y="47" width="1" height="50" fill="#8B008B"/>
  <rect x="58" y="47" width="1" height="50" fill="#8B008B"/>
  
  <!-- 剑尖（左） -->
  <rect x="10" y="37" width="8" height="5" fill="#2F2F2F"/>
  <rect x="12" y="34" width="4" height="3" fill="#2F2F2F"/>
  <rect x="13" y="32" width="2" height="2" fill="#2F2F2F"/>
  
  <!-- 剑尖（右） -->
  <rect x="48" y="37" width="8" height="5" fill="#2F2F2F"/>
  <rect x="50" y="34" width="4" height="3" fill="#2F2F2F"/>
  <rect x="51" y="32" width="2" height="2" fill="#2F2F2F"/>
  
  <!-- 护手（左） -->
  <rect x="2" y="102" width="24" height="8" fill="#2F2F2F"/>
  <rect x="2" y="102" width="6" height="8" fill="#1C1C1C"/>
  <rect x="20" y="102" width="6" height="8" fill="#4A4A4A"/>
  
  <!-- 护手（右） -->
  <rect x="40" y="102" width="24" height="8" fill="#2F2F2F"/>
  <rect x="40" y="102" width="6" height="8" fill="#1C1C1C"/>
  <rect x="58" y="102" width="6" height="8" fill="#4A4A4A"/>
  
  <!-- 剑柄（左） -->
  <rect x="10" y="110" width="8" height="25" fill="#8B4513"/>
  <rect x="10" y="110" width="3" height="25" fill="#654321"/>
  <rect x="15" y="110" width="3" height="25" fill="#A0522D"/>
  
  <!-- 剑柄（右） -->
  <rect x="48" y="110" width="8" height="25" fill="#8B4513"/>
  <rect x="48" y="110" width="3" height="25" fill="#654321"/>
  <rect x="53" y="110" width="3" height="25" fill="#A0522D"/>
  
  <!-- 剑首（左） -->
  <rect x="12" y="132" width="4" height="6" fill="#654321"/>
  <rect x="10" y="135" width="8" height="3" fill="#8B4513"/>
  
  <!-- 剑首（右） -->
  <rect x="50" y="132" width="4" height="6" fill="#654321"/>
  <rect x="48" y="135" width="8" height="3" fill="#8B4513"/>
  
  <!-- 烟雾尘粒 -->
  <rect x="23" y="52" width="1" height="1" fill="#8B008B" opacity="0.5"/>
  <rect x="38" y="67" width="1" height="1" fill="#8B008B" opacity="0.5"/>
  <rect x="28" y="82" width="1" height="1" fill="#8B008B" opacity="0.5"/>
  <rect x="33" y="97" width="1" height="1" fill="#8B008B" opacity="0.5"/>`,

    "paladin_sacred_hammer_stage1": `<!-- 圣骑士圣锤 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 锤柄 -->
  <rect x="28" y="44" width="10" height="120" fill="#8B4513"/>
  <rect x="28" y="44" width="3" height="120" fill="#654321"/>
  <rect x="35" y="44" width="3" height="120" fill="#A0522D"/>
  
  <!-- 皮革握把 -->
  <rect x="25" y="104" width="16" height="40" fill="#654321"/>
  <rect x="27" y="106" width="12" height="36" fill="#8B4513"/>
  
  <!-- 握把纹理 -->
  <rect x="29" y="109" width="4" height="4" fill="#654321"/>
  <rect x="33" y="109" width="4" height="4" fill="#654321"/>
  <rect x="29" y="119" width="4" height="4" fill="#654321"/>
  <rect x="33" y="119" width="4" height="4" fill="#654321"/>
  <rect x="29" y="129" width="4" height="4" fill="#654321"/>
  <rect x="33" y="129" width="4" height="4" fill="#654321"/>
  <rect x="29" y="139" width="4" height="4" fill="#654321"/>
  <rect x="33" y="139" width="4" height="4" fill="#654321"/>
  
  <!-- 银质锤头 -->
  <rect x="8" y="4" width="50" height="40" fill="#C0C0C0"/>
  <rect x="8" y="4" width="8" height="40" fill="#A9A9A9"/>
  <rect x="50" y="4" width="8" height="40" fill="#E5E5E5"/>
  <rect x="8" y="36" width="50" height="8" fill="#A9A9A9"/>
  
  <!-- 十字蚀刻 -->
  <rect x="28" y="9" width="10" height="30" fill="#A9A9A9"/>
  <rect x="18" y="19" width="30" height="10" fill="#A9A9A9"/>
  
  <!-- 十字深度效果 -->
  <rect x="30" y="11" width="6" height="26" fill="#808080"/>
  <rect x="20" y="21" width="26" height="6" fill="#808080"/>
  
  <!-- 锤头边缘细节 -->
  <rect x="6" y="2" width="54" height="2" fill="#FFFFFF"/>
  <rect x="6" y="2" width="2" height="44" fill="#808080"/>
  <rect x="58" y="2" width="2" height="44" fill="#FFFFFF"/>
  <rect x="8" y="44" width="50" height="2" fill="#808080"/>
  
  <!-- 连接部分 -->
  <rect x="26" y="39" width="14" height="10" fill="#C0C0C0"/>
  <rect x="28" y="41" width="10" height="6" fill="#A9A9A9"/>
  
  <!-- 锤柄底部 -->
  <rect x="30" y="159" width="6" height="8" fill="#654321"/>
  <rect x="28" y="164" width="10" height="4" fill="#8B4513"/>`,

    "paladin_sacred_hammer_stage2": `<!-- 圣骑士神圣锤 - 第二阶段 -->
  
  <!-- 手柄 -->
  <rect x="28" y="47" width="10" height="119" fill="#8B4513"/>
  <rect x="28" y="47" width="3" height="119" fill="#654321"/>
  <rect x="34" y="47" width="3" height="119" fill="#A0522D"/>
  
  <!-- 银制锤头 -->
  <rect x="3" y="2" width="60" height="45" fill="#C0C0C0"/>
  <rect x="3" y="2" width="12" height="45" fill="#A9A9A9"/>
  <rect x="50" y="2" width="12" height="45" fill="#E5E5E5"/>
  
  <!-- 金色镶嵌板 -->
  <rect x="18" y="12" width="30" height="25" fill="#DAA520"/>
  <rect x="18" y="12" width="8" height="25" fill="#B8860B"/>
  <rect x="39" y="12" width="8" height="25" fill="#FFD700"/>
  
  <!-- 白色1px高光 -->
  <rect x="28" y="17" width="10" height="1" fill="#FFFFFF"/>
  <rect x="28" y="32" width="10" height="1" fill="#FFFFFF"/>
  <rect x="23" y="22" width="1" height="10" fill="#FFFFFF"/>
  <rect x="41" y="22" width="1" height="10" fill="#FFFFFF"/>
  
  <!-- 侧面光晕币 -->
  <rect x="7" y="19" width="6" height="6" fill="#DAA520"/>
  <rect x="8" y="20" width="4" height="4" fill="#FFD700"/>
  <rect x="9" y="21" width="2" height="2" fill="#FFFFFF"/>
  
  <rect x="52" y="19" width="6" height="6" fill="#DAA520"/>
  <rect x="53" y="20" width="4" height="4" fill="#FFD700"/>
  <rect x="54" y="21" width="2" height="2" fill="#FFFFFF"/>
  
  <!-- 连接部分 -->
  <rect x="21" y="42" width="24" height="10" fill="#C0C0C0"/>
  <rect x="23" y="44" width="20" height="6" fill="#A9A9A9"/>
  
  <!-- 手柄包裹 -->
  <rect x="26" y="67" width="14" height="4" fill="#654321"/>
  <rect x="26" y="86" width="14" height="4" fill="#654321"/>
  <rect x="26" y="106" width="14" height="4" fill="#654321"/>
  <rect x="26" y="126" width="14" height="4" fill="#654321"/>
  <rect x="26" y="146" width="14" height="4" fill="#654321"/>
  
  <!-- 锤头边缘 -->
  <rect x="1" y="0" width="64" height="2" fill="#E5E5E5"/>
  <rect x="1" y="0" width="2" height="49" fill="#A9A9A9"/>
  <rect x="62" y="0" width="2" height="49" fill="#FFFFFF"/>
  <rect x="3" y="47" width="60" height="2" fill="#A9A9A9"/>
  
  <!-- 手柄底端 -->
  <rect x="29" y="161" width="8" height="8" fill="#654321"/>
  <rect x="27" y="166" width="12" height="4" fill="#8B4513"/>`,

    "paladin_sacred_hammer_stage3": `<!-- 圣骑士神圣锤 - 第三阶段 -->
  
  <!-- 手柄 -->
  <rect x="29" y="66" width="6" height="77" fill="#8B4513"/>
  <rect x="29" y="66" width="2" height="77" fill="#654321"/>
  <rect x="33" y="66" width="2" height="77" fill="#A0522D"/>
  
  <!-- 金色神圣锤头 -->
  <rect x="10" y="34" width="45" height="32" fill="#DAA520"/>
  <rect x="10" y="34" width="9" height="32" fill="#B8860B"/>
  <rect x="46" y="34" width="9" height="32" fill="#FFD700"/>
  
  <!-- 白色发光十字符文在锤面 -->
  <rect x="29" y="40" width="6" height="19" fill="#FFFFFF"/>
  <rect x="18" y="48" width="28" height="4" fill="#FFFFFF"/>
  
  <!-- 十字符文发光边缘 -->
  <rect x="28" y="40" width="8" height="1" fill="#F0F8FF"/>
  <rect x="28" y="60" width="8" height="1" fill="#F0F8FF"/>
  <rect x="17" y="47" width="1" height="5" fill="#F0F8FF"/>
  <rect x="47" y="47" width="1" height="5" fill="#F0F8FF"/>
  
  <!-- 锤面 -->
  <rect x="13" y="37" width="39" height="26" fill="#FFD700"/>
  <rect x="14" y="38" width="36" height="23" fill="#FFFFFF"/>
  
  <!-- 连接部分 -->
  <rect x="24" y="63" width="15" height="6" fill="#DAA520"/>
  <rect x="26" y="64" width="13" height="4" fill="#FFD700"/>
  
  <!-- 辐射像素火花 -->
  <rect x="3" y="43" width="1" height="1" fill="#FFFFFF"/>
  <rect x="0" y="50" width="1" height="1" fill="#F0F8FF"/>
  <rect x="61" y="45" width="1" height="1" fill="#FFFFFF"/>
  <rect x="64" y="52" width="1" height="1" fill="#F0F8FF"/>
  <rect x="23" y="27" width="1" height="1" fill="#FFFFFF"/>
  <rect x="29" y="24" width="1" height="1" fill="#F0F8FF"/>
  <rect x="35" y="27" width="1" height="1" fill="#FFFFFF"/>
  <rect x="42" y="24" width="1" height="1" fill="#F0F8FF"/>
  <rect x="23" y="72" width="1" height="1" fill="#FFFFFF"/>
  <rect x="29" y="76" width="1" height="1" fill="#F0F8FF"/>
  <rect x="35" y="72" width="1" height="1" fill="#FFFFFF"/>
  <rect x="42" y="76" width="1" height="1" fill="#F0F8FF"/>
  
  <!-- 手柄包裹 -->
  <rect x="28" y="79" width="9" height="3" fill="#654321"/>
  <rect x="28" y="92" width="9" height="3" fill="#654321"/>
  <rect x="28" y="105" width="9" height="3" fill="#654321"/>
  <rect x="28" y="118" width="9" height="3" fill="#654321"/>
  <rect x="28" y="130" width="9" height="3" fill="#654321"/>
  
  <!-- 锤头边缘 -->
  <rect x="8" y="33" width="48" height="1" fill="#FFFFFF"/>
  <rect x="8" y="33" width="1" height="35" fill="#B8860B"/>
  <rect x="55" y="33" width="1" height="35" fill="#FFFFFF"/>
  <rect x="10" y="66" width="45" height="1" fill="#B8860B"/>
  
  <!-- 手柄底端 -->
  <rect x="30" y="140" width="5" height="5" fill="#654321"/>
  <rect x="28" y="143" width="8" height="3" fill="#8B4513"/>`,

    "paladin_sword_shield_holy_stage1": `<!-- 圣骑士剑盾圣器 - 第一阶段 -->
  
  <!-- 铁制盾牌 -->
  <rect x="1" y="44" width="41" height="41" fill="#808080"/>
  <rect x="1" y="45" width="39" height="39" fill="#A9A9A9"/>
  
  <!-- 简单十字 -->
  <rect x="19" y="55" width="4" height="20" fill="#2F2F2F"/>
  <rect x="9" y="63" width="23" height="4" fill="#2F2F2F"/>
  
  <!-- 铁剑 -->
  <rect x="55" y="71" width="7" height="34" fill="#C0C0C0"/>
  <rect x="55" y="71" width="2" height="34" fill="#A9A9A9"/>
  <rect x="60" y="71" width="2" height="34" fill="#E5E5E5"/>
  
  <!-- 剑尖 -->
  <rect x="56" y="68" width="4" height="3" fill="#C0C0C0"/>
  <rect x="58" y="66" width="1" height="2" fill="#C0C0C0"/>
  
  <!-- 护手 -->
  <rect x="51" y="105" width="14" height="4" fill="#808080"/>
  <rect x="51" y="105" width="3" height="4" fill="#696969"/>
  <rect x="62" y="105" width="3" height="4" fill="#A9A9A9"/>
  
  <!-- 剑柄 -->
  <rect x="56" y="109" width="4" height="17" fill="#8B4513"/>
  <rect x="56" y="109" width="1" height="17" fill="#654321"/>
  <rect x="59" y="109" width="1" height="17" fill="#A0522D"/>
  
  <!-- 盾牌边缘 -->
  <rect x="0" y="44" width="42" height="1" fill="#696969"/>
  <rect x="0" y="44" width="1" height="42" fill="#696969"/>
  <rect x="41" y="44" width="1" height="42" fill="#D3D3D3"/>
  <rect x="1" y="84" width="39" height="1" fill="#696969"/>
  
  <!-- 盾牌握把（背面暗示） -->
  <rect x="19" y="63" width="4" height="4" fill="#654321"/>
  <rect x="18" y="65" width="1" height="1" fill="#8B4513"/>
  <rect x="23" y="65" width="1" height="1" fill="#8B4513"/>`,

    "paladin_sword_shield_holy_stage2": `<!-- 圣骑士剑盾圣器 - 第二阶段 -->
  
  <!-- 风筝盾牌 -->
  <rect x="1" y="46" width="40" height="43" fill="#C0C0C0"/>
  <rect x="2" y="47" width="39" height="42" fill="#E5E5E5"/>
  
  <!-- 金色边框 -->
  <rect x="0" y="45" width="42" height="2" fill="#DAA520"/>
  <rect x="0" y="45" width="2" height="45" fill="#DAA520"/>
  <rect x="40" y="45" width="2" height="45" fill="#FFD700"/>
  <rect x="2" y="89" width="39" height="2" fill="#B8860B"/>
  
  <!-- 浮雕十字 -->
  <rect x="19" y="56" width="5" height="25" fill="#FFD700"/>
  <rect x="10" y="65" width="22" height="5" fill="#FFD700"/>
  
  <!-- 银剑带1px fuller -->
  <rect x="53" y="71" width="7" height="34" fill="#E5E5E5"/>
  <rect x="53" y="71" width="2" height="34" fill="#C0C0C0"/>
  <rect x="58" y="71" width="2" height="34" fill="#F8F8F8"/>
  
  <!-- fuller线 -->
  <rect x="56" y="74" width="1" height="28" fill="#A9A9A9"/>
  
  <!-- 剑尖 -->
  <rect x="55" y="68" width="5" height="3" fill="#E5E5E5"/>
  <rect x="56" y="66" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 增强护手 -->
  <rect x="49" y="105" width="16" height="5" fill="#C0C0C0"/>
  <rect x="49" y="105" width="4" height="5" fill="#A9A9A9"/>
  <rect x="61" y="105" width="4" height="5" fill="#F8F8F8"/>
  
  <!-- 剑柄 -->
  <rect x="55" y="110" width="5" height="15" fill="#8B4513"/>
  <rect x="55" y="110" width="2" height="15" fill="#654321"/>
  <rect x="58" y="110" width="2" height="15" fill="#A0522D"/>
  
  <!-- 盾牌握把 -->
  <rect x="19" y="65" width="5" height="5" fill="#654321"/>
  <rect x="18" y="67" width="1" height="2" fill="#8B4513"/>
  <rect x="25" y="67" width="1" height="2" fill="#8B4513"/>`,

    "paladin_sword_shield_holy_stage3": `<!-- 圣骑士剑盾圣器 - 第三阶段 -->
  
  <!-- 辐射盾牌 -->
  <rect x="5" y="53" width="38" height="41" fill="#E5E5E5"/>
  <rect x="6" y="53" width="37" height="40" fill="#F8F8F8"/>
  
  <!-- 金色边框 -->
  <rect x="4" y="51" width="40" height="2" fill="#FFD700"/>
  <rect x="4" y="51" width="2" height="43" fill="#FFD700"/>
  <rect x="43" y="51" width="2" height="43" fill="#FFFFFF"/>
  <rect x="6" y="93" width="37" height="2" fill="#DAA520"/>
  
  <!-- 神圣十字 -->
  <rect x="22" y="61" width="5" height="24" fill="#FFFFFF"/>
  <rect x="12" y="70" width="25" height="5" fill="#FFFFFF"/>
  
  <!-- 中央宝石（青色发光） -->
  <rect x="23" y="71" width="3" height="3" fill="#00FFFF"/>
  <rect x="24" y="72" width="2" height="2" fill="#87CEEB"/>
  <rect x="24" y="73" width="1" height="1" fill="#FFFFFF"/>
  
  <!-- 神圣剑带白色发光边缘 -->
  <rect x="54" y="74" width="8" height="33" fill="#F8F8F8"/>
  <rect x="54" y="74" width="2" height="33" fill="#E5E5E5"/>
  <rect x="60" y="74" width="2" height="33" fill="#FFFFFF"/>
  
  <!-- 白色发光沿边缘 -->
  <rect x="54" y="77" width="1" height="27" fill="#FFFFFF"/>
  <rect x="62" y="77" width="1" height="27" fill="#FFFFFF"/>
  
  <!-- 剑尖 -->
  <rect x="55" y="71" width="5" height="3" fill="#F8F8F8"/>
  <rect x="56" y="70" width="3" height="2" fill="#F8F8F8"/>
  <rect x="57" y="69" width="1" height="1" fill="#FFFFFF"/>
  
  <!-- 神圣护手 -->
  <rect x="49" y="107" width="16" height="5" fill="#FFD700"/>
  <rect x="49" y="107" width="4" height="5" fill="#DAA520"/>
  <rect x="61" y="107" width="4" height="5" fill="#FFFFFF"/>
  
  <!-- 剑柄 -->
  <rect x="55" y="112" width="5" height="14" fill="#8B4513"/>
  <rect x="55" y="112" width="2" height="14" fill="#654321"/>
  <rect x="59" y="112" width="2" height="14" fill="#A0522D"/>
  
  <!-- 盾牌辐射发光效果 -->
  <rect x="3" y="71" width="1" height="1" fill="#87CEEB"/>
  <rect x="0" y="74" width="1" height="1" fill="#87CEEB"/>
  <rect x="46" y="71" width="1" height="1" fill="#87CEEB"/>
  <rect x="49" y="74" width="1" height="1" fill="#87CEEB"/>
  <rect x="22" y="47" width="1" height="1" fill="#87CEEB"/>
  <rect x="24" y="44" width="1" height="1" fill="#87CEEB"/>
  <rect x="27" y="47" width="1" height="1" fill="#87CEEB"/>
  <rect x="22" y="99" width="1" height="1" fill="#87CEEB"/>
  <rect x="24" y="101" width="1" height="1" fill="#87CEEB"/>
  <rect x="27" y="99" width="1" height="1" fill="#87CEEB"/>
  
  <!-- 盾牌握把 -->
  <rect x="22" y="70" width="5" height="5" fill="#654321"/>
  <rect x="21" y="71" width="1" height="3" fill="#8B4513"/>
  <rect x="29" y="71" width="1" height="3" fill="#8B4513"/>`,

    "paladin_relic_sigil_stage1": `<!-- 圣骑士圣遗物印章 - 第一阶段 -->
  
  <!-- 小金属圣物匣十字 -->
  <rect x="25" y="77" width="16" height="4" fill="#808080"/>
  <rect x="31" y="67" width="4" height="24" fill="#808080"/>
  <rect x="26" y="78" width="14" height="2" fill="#A9A9A9"/>
  <rect x="32" y="68" width="2" height="22" fill="#A9A9A9"/>
  
  <!-- 十字中心 -->
  <rect x="29" y="75" width="8" height="8" fill="#C0C0C0"/>
  <rect x="30" y="76" width="6" height="6" fill="#E5E5E5"/>
  <rect x="31" y="77" width="4" height="4" fill="#F8F8F8"/>
  
  <!-- 链条像素 -->
  <rect x="32" y="57" width="2" height="4" fill="#808080"/>
  <rect x="34" y="61" width="2" height="4" fill="#808080"/>
  <rect x="30" y="65" width="2" height="4" fill="#808080"/>
  <rect x="32" y="69" width="2" height="4" fill="#808080"/>
  <rect x="34" y="73" width="2" height="4" fill="#808080"/>
  
  <rect x="32" y="93" width="2" height="4" fill="#808080"/>
  <rect x="30" y="97" width="2" height="4" fill="#808080"/>
  <rect x="34" y="101" width="2" height="4" fill="#808080"/>
  <rect x="32" y="105" width="2" height="4" fill="#808080"/>
  <rect x="30" y="109" width="2" height="4" fill="#808080"/>
  
  <!-- 链条连接点 -->
  <rect x="33" y="59" width="1" height="1" fill="#A9A9A9"/>
  <rect x="31" y="63" width="1" height="1" fill="#A9A9A9"/>
  <rect x="33" y="67" width="1" height="1" fill="#A9A9A9"/>
  <rect x="31" y="71" width="1" height="1" fill="#A9A9A9"/>
  
  <!-- 十字轮廓 -->
  <rect x="24" y="76" width="18" height="1" fill="#696969"/>
  <rect x="24" y="82" width="18" height="1" fill="#696969"/>
  <rect x="30" y="66" width="1" height="18" fill="#696969"/>
  <rect x="36" y="66" width="1" height="18" fill="#D3D3D3"/>`,

    "paladin_relic_sigil_stage2": `<!-- 圣骑士圣遗物印章 - 第二阶段 -->
  
  <!-- 华丽圣物匣 -->
  <rect x="21" y="69" width="24" height="6" fill="#DAA520"/>
  <rect x="29" y="59" width="8" height="26" fill="#DAA520"/>
  <rect x="22" y="70" width="22" height="4" fill="#FFD700"/>
  <rect x="30" y="60" width="6" height="24" fill="#FFD700"/>
  
  <!-- 金色丝线（方形卷曲） -->
  <rect x="18" y="74" width="4" height="2" fill="#B8860B"/>
  <rect x="18" y="76" width="2" height="4" fill="#B8860B"/>
  <rect x="44" y="74" width="4" height="2" fill="#B8860B"/>
  <rect x="46" y="76" width="2" height="4" fill="#B8860B"/>
  
  <rect x="26" y="56" width="2" height="4" fill="#B8860B"/>
  <rect x="28" y="56" width="4" height="2" fill="#B8860B"/>
  <rect x="38" y="56" width="2" height="4" fill="#B8860B"/>
  <rect x="34" y="56" width="4" height="2" fill="#B8860B"/>
  
  <!-- 微小宝石点 -->
  <rect x="25" y="72" width="2" height="2" fill="#DC143C"/>
  <rect x="39" y="72" width="2" height="2" fill="#DC143C"/>
  <rect x="32" y="63" width="2" height="2" fill="#DC143C"/>
  <rect x="32" y="81" width="2" height="2" fill="#DC143C"/>
  
  <!-- 十字中心 -->
  <rect x="27" y="67" width="12" height="12" fill="#E5E5E5"/>
  <rect x="28" y="68" width="10" height="10" fill="#F8F8F8"/>
  <rect x="29" y="69" width="8" height="8" fill="#FFFFFF"/>
  
  <!-- 紫色符文轴上的点 -->
  <rect x="32" y="49" width="2" height="2" fill="#9370DB"/>
  <rect x="32" y="89" width="2" height="2" fill="#9370DB"/>
  <rect x="32" y="99" width="2" height="2" fill="#9370DB"/>
  <rect x="32" y="109" width="2" height="2" fill="#9370DB"/>
  <rect x="32" y="119" width="2" height="2" fill="#9370DB"/>
  
  <!-- 链条 -->
  <rect x="32" y="52" width="2" height="4" fill="#DAA520"/>
  <rect x="34" y="56" width="2" height="4" fill="#DAA520"/>
  <rect x="30" y="60" width="2" height="4" fill="#DAA520"/>
  <rect x="32" y="64" width="2" height="4" fill="#DAA520"/>
  
  <rect x="32" y="92" width="2" height="4" fill="#DAA520"/>
  <rect x="30" y="96" width="2" height="4" fill="#DAA520"/>
  <rect x="34" y="100" width="2" height="4" fill="#DAA520"/>
  <rect x="32" y="104" width="2" height="4" fill="#DAA520"/>
  <rect x="30" y="108" width="2" height="4" fill="#DAA520"/>
  
  <!-- 金色边框 -->
  <rect x="20" y="68" width="26" height="1" fill="#DAA520"/>
  <rect x="20" y="75" width="26" height="1" fill="#DAA520"/>
  <rect x="28" y="58" width="1" height="24" fill="#DAA520"/>
  <rect x="37" y="58" width="1" height="24" fill="#FFD700"/>`,

    "paladin_relic_sigil_stage3": `<!-- 圣骑士圣遗物印章 - 第三阶段 -->
  
  <!-- 悬浮圣物 -->
  <rect x="17" y="77" width="32" height="8" fill="#FFD700"/>
  <rect x="25" y="67" width="16" height="28" fill="#FFD700"/>
  <rect x="18" y="78" width="30" height="6" fill="#FFFFFF"/>
  <rect x="26" y="68" width="14" height="26" fill="#FFFFFF"/>
  
  <!-- 强白色像素光晕环 -->
  <rect x="13" y="73" width="40" height="2" fill="#FFFFFF" opacity="0.8"/>
  <rect x="13" y="97" width="40" height="2" fill="#FFFFFF" opacity="0.8"/>
  <rect x="21" y="63" width="2" height="32" fill="#FFFFFF" opacity="0.8"/>
  <rect x="43" y="63" width="2" height="32" fill="#FFFFFF" opacity="0.8"/>
  
  <rect x="9" y="69" width="48" height="2" fill="#F0F8FF" opacity="0.6"/>
  <rect x="9" y="101" width="48" height="2" fill="#F0F8FF" opacity="0.6"/>
  <rect x="17" y="59" width="2" height="40" fill="#F0F8FF" opacity="0.6"/>
  <rect x="47" y="59" width="2" height="40" fill="#F0F8FF" opacity="0.6"/>
  
  <rect x="5" y="65" width="56" height="2" fill="#E6F3FF" opacity="0.4"/>
  <rect x="5" y="105" width="56" height="2" fill="#E6F3FF" opacity="0.4"/>
  <rect x="13" y="55" width="2" height="48" fill="#E6F3FF" opacity="0.4"/>
  <rect x="51" y="55" width="2" height="48" fill="#E6F3FF" opacity="0.4"/>
  
  <!-- 微小环绕十字 -->
  <rect x="3" y="80" width="6" height="2" fill="#FFFFFF"/>
  <rect x="5" y="76" width="2" height="10" fill="#FFFFFF"/>
  
  <rect x="57" y="80" width="6" height="2" fill="#FFFFFF"/>
  <rect x="59" y="76" width="2" height="10" fill="#FFFFFF"/>
  
  <rect x="31" y="52" width="6" height="2" fill="#FFFFFF"/>
  <rect x="33" y="48" width="2" height="10" fill="#FFFFFF"/>
  
  <rect x="31" y="110" width="6" height="2" fill="#FFFFFF"/>
  <rect x="33" y="106" width="2" height="10" fill="#FFFFFF"/>
  
  <!-- 十字中心 -->
  <rect x="23" y="75" width="20" height="20" fill="#FFFFFF"/>
  <rect x="24" y="76" width="18" height="18" fill="#F0F8FF"/>
  <rect x="25" y="77" width="16" height="16" fill="#E6F3FF"/>
  
  <!-- 中央十字核心 -->
  <rect x="29" y="69" width="8" height="32" fill="#FFFFFF"/>
  <rect x="17" y="81" width="32" height="8" fill="#FFFFFF"/>
  
  <!-- 链条消失，仅剩辐射点 -->
  <rect x="32" y="42" width="2" height="2" fill="#FFFFFF"/>
  <rect x="32" y="128" width="2" height="2" fill="#FFFFFF"/>
  <rect x="32" y="137" width="2" height="2" fill="#F0F8FF"/>
  <rect x="32" y="32" width="2" height="2" fill="#F0F8FF"/>
  
  <!-- 悬浮暗示（无阴影） -->
  <rect x="15" y="74" width="36" height="1" fill="none" stroke="#E6E6FA" stroke-width="1" opacity="0.3"/>
  <rect x="15" y="98" width="36" height="1" fill="none" stroke="#E6E6FA" stroke-width="1" opacity="0.3"/>`,

    "summoner_summon_staff_stage1": `<!-- 召唤师召唤法杖 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 暗木法杖主体 -->
  <rect x="28" y="15" width="9" height="145" fill="#654321"/>
  <rect x="28" y="15" width="3" height="145" fill="#4A4A4A"/>
  <rect x="34" y="15" width="3" height="145" fill="#8B4513"/>
  
  <!-- 暗木纹理 -->
  <rect x="30" y="23" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="40" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="57" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="74" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="91" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="108" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="126" width="2" height="7" fill="#4A4A4A"/>
  <rect x="30" y="143" width="2" height="7" fill="#4A4A4A"/>
  
  <!-- 骨质顶端 2×3px -->
  <rect x="26" y="2" width="14" height="17" fill="#F5F5DC"/>
  <rect x="26" y="2" width="3" height="17" fill="#E6E6E6"/>
  <rect x="36" y="2" width="3" height="17" fill="#FFFFFF"/>
  
  <!-- 骨质细节 -->
  <rect x="29" y="6" width="7" height="9" fill="#E6E6E6"/>
  <rect x="31" y="8" width="3" height="5" fill="#D3D3D3"/>
  
  <!-- 微弱黑色像素环绕 -->
  <rect x="24" y="0" width="2" height="2" fill="#2F2F2F" opacity="0.6"/>
  <rect x="39" y="0" width="2" height="2" fill="#2F2F2F" opacity="0.6"/>
  <rect x="24" y="19" width="2" height="2" fill="#2F2F2F" opacity="0.6"/>
  <rect x="39" y="19" width="2" height="2" fill="#2F2F2F" opacity="0.6"/>
  
  <rect x="22" y="2" width="2" height="2" fill="#404040" opacity="0.4"/>
  <rect x="41" y="2" width="2" height="2" fill="#404040" opacity="0.4"/>
  <rect x="22" y="17" width="2" height="2" fill="#404040" opacity="0.4"/>
  <rect x="41" y="17" width="2" height="2" fill="#404040" opacity="0.4"/>
  
  <!-- 握持区域 -->
  <rect x="27" y="126" width="12" height="26" fill="#4A4A4A"/>
  <rect x="28" y="127" width="9" height="22" fill="#654321"/>
  
  <!-- 握把纹理 -->
  <rect x="30" y="130" width="5" height="3" fill="#4A4A4A"/>
  <rect x="30" y="138" width="5" height="3" fill="#4A4A4A"/>
  <rect x="30" y="147" width="5" height="3" fill="#4A4A4A"/>
  
  <!-- 底端 -->
  <rect x="30" y="160" width="5" height="7" fill="#4A4A4A"/>
  <rect x="32" y="167" width="2" height="3" fill="#654321"/>`,

    "summoner_summon_staff_stage2": `<!-- 召唤师召唤法杖 - 第二阶段 -->
  
  <!-- 雕刻法杖 -->
  <rect x="28" y="21" width="9" height="145" fill="#654321"/>
  <rect x="28" y="21" width="3" height="145" fill="#4A2C2A"/>
  <rect x="34" y="21" width="3" height="145" fill="#8B6914"/>
  
  <!-- 银色帽 -->
  <rect x="24" y="4" width="17" height="21" fill="#C0C0C0"/>
  <rect x="25" y="5" width="15" height="20" fill="#E5E5E5"/>
  
  <!-- 骨刺 -->
  <rect x="22" y="9" width="5" height="7" fill="#F5F5DC"/>
  <rect x="38" y="9" width="5" height="7" fill="#F5F5DC"/>
  <rect x="28" y="0" width="9" height="9" fill="#F5F5DC"/>
  
  <!-- 骨刺细节 -->
  <rect x="23" y="9" width="3" height="5" fill="#E6E6E6"/>
  <rect x="38" y="9" width="3" height="5" fill="#E6E6E6"/>
  <rect x="29" y="1" width="7" height="7" fill="#E6E6E6"/>
  
  <!-- 紫色符文点沿轴 -->
  <rect x="31" y="30" width="1" height="1" fill="#9370DB"/>
  <rect x="34" y="38" width="1" height="1" fill="#9370DB"/>
  <rect x="29" y="47" width="1" height="1" fill="#9370DB"/>
  <rect x="33" y="56" width="1" height="1" fill="#9370DB"/>
  <rect x="30" y="64" width="1" height="1" fill="#9370DB"/>
  <rect x="35" y="73" width="1" height="1" fill="#9370DB"/>
  <rect x="31" y="81" width="1" height="1" fill="#9370DB"/>
  <rect x="33" y="90" width="1" height="1" fill="#9370DB"/>
  <rect x="29" y="98" width="1" height="1" fill="#9370DB"/>
  <rect x="34" y="107" width="1" height="1" fill="#9370DB"/>
  <rect x="32" y="115" width="1" height="1" fill="#9370DB"/>
  <rect x="30" y="124" width="1" height="1" fill="#9370DB"/>
  <rect x="33" y="132" width="1" height="1" fill="#9370DB"/>
  <rect x="31" y="141" width="1" height="1" fill="#9370DB"/>
  <rect x="33" y="149" width="1" height="1" fill="#9370DB"/>
  <rect x="32" y="158" width="1" height="1" fill="#9370DB"/>
  
  <!-- 法杖包裹 -->
  <rect x="27" y="43" width="12" height="3" fill="#4A2C2A"/>
  <rect x="27" y="64" width="12" height="3" fill="#4A2C2A"/>
  <rect x="27" y="85" width="12" height="3" fill="#4A2C2A"/>
  <rect x="27" y="107" width="12" height="3" fill="#4A2C2A"/>
  <rect x="27" y="128" width="12" height="3" fill="#4A2C2A"/>
  <rect x="27" y="149" width="12" height="3" fill="#4A2C2A"/>
  
  <!-- 法杖底端 -->
  <rect x="30" y="162" width="5" height="7" fill="#4A2C2A"/>
  <rect x="28" y="167" width="9" height="3" fill="#654321"/>`,

    "summoner_summon_staff_stage3": `<!-- 召唤师召唤法杖 - 第三阶段 -->
  
  <!-- 高大秘法法杖 -->
  <rect x="28" y="30" width="9" height="137" fill="#654321"/>
  <rect x="28" y="30" width="3" height="137" fill="#4A2C2A"/>
  <rect x="34" y="30" width="3" height="137" fill="#8B6914"/>
  
  <!-- 新月骨冠 -->
  <rect x="21" y="15" width="23" height="19" fill="#F5F5DC"/>
  <rect x="21" y="16" width="21" height="17" fill="#E6E6E6"/>
  
  <!-- 新月形状 -->
  <rect x="17" y="19" width="8" height="11" fill="#F5F5DC"/>
  <rect x="40" y="19" width="8" height="11" fill="#F5F5DC"/>
  <rect x="25" y="11" width="15" height="8" fill="#F5F5DC"/>
  
  <!-- 新月细节 -->
  <rect x="18" y="20" width="6" height="10" fill="#E6E6E6"/>
  <rect x="40" y="20" width="6" height="10" fill="#E6E6E6"/>
  <rect x="25" y="12" width="14" height="6" fill="#E6E6E6"/>
  
  <!-- 密集紫色粒子环（方形尘粒） -->
  <rect x="13" y="23" width="1" height="1" fill="#9370DB"/>
  <rect x="51" y="23" width="1" height="1" fill="#9370DB"/>
  <rect x="17" y="27" width="1" height="1" fill="#9370DB"/>
  <rect x="47" y="27" width="1" height="1" fill="#9370DB"/>
  <rect x="21" y="30" width="1" height="1" fill="#9370DB"/>
  <rect x="44" y="30" width="1" height="1" fill="#9370DB"/>
  <rect x="25" y="34" width="1" height="1" fill="#9370DB"/>
  <rect x="40" y="34" width="1" height="1" fill="#9370DB"/>
  <rect x="28" y="38" width="1" height="1" fill="#9370DB"/>
  <rect x="36" y="38" width="1" height="1" fill="#9370DB"/>
  
  <!-- 第二圈 -->
  <rect x="9" y="19" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="55" y="19" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="13" y="15" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="51" y="15" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="21" y="8" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="44" y="8" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="28" y="4" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  <rect x="36" y="4" width="1" height="1" fill="#4B0082" opacity="0.7"/>
  
  <!-- 第三圈 -->
  <rect x="6" y="23" width="1" height="1" fill="#483D8B" opacity="0.5"/>
  <rect x="59" y="23" width="1" height="1" fill="#483D8B" opacity="0.5"/>
  <rect x="32" y="0" width="1" height="1" fill="#483D8B" opacity="0.5"/>
  
  <!-- 奥术符文沿轴 -->
  <rect x="30" y="38" width="2" height="2" fill="#9370DB"/>
  <rect x="33" y="46" width="2" height="2" fill="#9370DB"/>
  <rect x="28" y="53" width="2" height="2" fill="#9370DB"/>
  <rect x="34" y="61" width="2" height="2" fill="#9370DB"/>
  <rect x="29" y="68" width="2" height="2" fill="#9370DB"/>
  <rect x="34" y="76" width="2" height="2" fill="#9370DB"/>
  <rect x="31" y="83" width="2" height="2" fill="#9370DB"/>
  <rect x="32" y="91" width="2" height="2" fill="#9370DB"/>
  <rect x="30" y="99" width="2" height="2" fill="#9370DB"/>
  <rect x="34" y="106" width="2" height="2" fill="#9370DB"/>
  <rect x="31" y="114" width="2" height="2" fill="#9370DB"/>
  <rect x="29" y="121" width="2" height="2" fill="#9370DB"/>
  <rect x="34" y="129" width="2" height="2" fill="#9370DB"/>
  <rect x="31" y="137" width="2" height="2" fill="#9370DB"/>
  <rect x="33" y="144" width="2" height="2" fill="#9370DB"/>
  <rect x="31" y="152" width="2" height="2" fill="#9370DB"/>
  <rect x="32" y="159" width="2" height="2" fill="#9370DB"/>
  
  <!-- 法杖包裹 -->
  <rect x="26" y="49" width="12" height="3" fill="#4A2C2A"/>
  <rect x="26" y="68" width="12" height="3" fill="#4A2C2A"/>
  <rect x="26" y="87" width="12" height="3" fill="#4A2C2A"/>
  <rect x="26" y="106" width="12" height="3" fill="#4A2C2A"/>
  <rect x="26" y="125" width="12" height="3" fill="#4A2C2A"/>
  <rect x="26" y="144" width="12" height="3" fill="#4A2C2A"/>
  
  <!-- 法杖底端 -->
  <rect x="29" y="163" width="6" height="6" fill="#4A2C2A"/>
  <rect x="28" y="167" width="9" height="3" fill="#654321"/>`,

    "summoner_pact_tome_stage1": `<!-- 召唤师契约之书 - 第一阶段 -->
  
  <!-- 磨损的书 -->
  <rect x="13" y="60" width="40" height="50" fill="#2F1B14"/>
  <rect x="14" y="61" width="38" height="48" fill="#4A2F23"/>
  
  <!-- 爪痕像素 -->
  <rect x="18" y="65" width="1" height="8" fill="#1C1C1C"/>
  <rect x="20" y="63" width="1" height="10" fill="#1C1C1C"/>
  <rect x="22" y="64" width="1" height="9" fill="#1C1C1C"/>
  <rect x="24" y="62" width="1" height="11" fill="#1C1C1C"/>
  
  <rect x="33" y="80" width="1" height="6" fill="#1C1C1C"/>
  <rect x="35" y="78" width="1" height="8" fill="#1C1C1C"/>
  <rect x="37" y="79" width="1" height="7" fill="#1C1C1C"/>
  
  <rect x="43" y="95" width="1" height="5" fill="#1C1C1C"/>
  <rect x="45" y="93" width="1" height="7" fill="#1C1C1C"/>
  <rect x="47" y="94" width="1" height="6" fill="#1C1C1C"/>
  
  <!-- 书脊 -->
  <rect x="11" y="60" width="4" height="50" fill="#1C1C1C"/>
  <rect x="11" y="65" width="4" height="5" fill="#2F1B14"/>
  <rect x="11" y="75" width="4" height="5" fill="#2F1B14"/>
  <rect x="11" y="85" width="4" height="5" fill="#2F1B14"/>
  <rect x="11" y="95" width="4" height="5" fill="#2F1B14"/>
  
  <!-- 简单边框 -->
  <rect x="12" y="59" width="42" height="1" fill="#1C1C1C"/>
  <rect x="12" y="59" width="1" height="52" fill="#1C1C1C"/>
  <rect x="53" y="59" width="1" height="52" fill="#4A2F23"/>
  <rect x="13" y="110" width="40" height="1" fill="#1C1C1C"/>
  
  <!-- 破损纹理 -->
  <rect x="16" y="70" width="2" height="1" fill="#1C1C1C"/>
  <rect x="28" y="90" width="3" height="1" fill="#1C1C1C"/>
  <rect x="38" y="75" width="2" height="1" fill="#1C1C1C"/>
  <rect x="48" y="85" width="1" height="2" fill="#1C1C1C"/>`,

    "summoner_pact_tome_stage2": `<!-- 召唤师契约之书 - 第二阶段 -->
  
  <!-- 磨损的书 -->
  <rect x="8" y="55" width="50" height="60" fill="#2F1B14"/>
  <rect x="9" y="56" width="48" height="58" fill="#4A2F23"/>
  
  <!-- 书脊钉子 -->
  <rect x="6" y="65" width="4" height="2" fill="#C0C0C0"/>
  <rect x="6" y="75" width="4" height="2" fill="#C0C0C0"/>
  <rect x="6" y="85" width="4" height="2" fill="#C0C0C0"/>
  <rect x="6" y="95" width="4" height="2" fill="#C0C0C0"/>
  <rect x="6" y="105" width="4" height="2" fill="#C0C0C0"/>
  
  <!-- 红色符文印章在封面 -->
  <rect x="28" y="75" width="10" height="10" fill="#8B0000"/>
  <rect x="29" y="76" width="8" height="8" fill="#DC143C"/>
  
  <!-- 符文印章内部图案 -->
  <rect x="31" y="78" width="1" height="1" fill="#FF6347"/>
  <rect x="34" y="78" width="1" height="1" fill="#FF6347"/>
  <rect x="32" y="80" width="2" height="2" fill="#FF6347"/>
  <rect x="31" y="82" width="1" height="1" fill="#FF6347"/>
  <rect x="34" y="82" width="1" height="1" fill="#FF6347"/>
  
  <!-- 金属角护 -->
  <rect x="8" y="55" width="8" height="8" fill="#808080"/>
  <rect x="50" y="55" width="8" height="8" fill="#A9A9A9"/>
  <rect x="8" y="107" width="8" height="8" fill="#808080"/>
  <rect x="50" y="107" width="8" height="8" fill="#A9A9A9"/>
  
  <!-- 角护细节 -->
  <rect x="9" y="56" width="6" height="6" fill="#A9A9A9"/>
  <rect x="51" y="56" width="6" height="6" fill="#C0C0C0"/>
  <rect x="9" y="108" width="6" height="6" fill="#A9A9A9"/>
  <rect x="51" y="108" width="6" height="6" fill="#C0C0C0"/>
  
  <!-- 爪痕 -->
  <rect x="18" y="65" width="1" height="10" fill="#1C1C1C"/>
  <rect x="20" y="63" width="1" height="12" fill="#1C1C1C"/>
  <rect x="22" y="64" width="1" height="11" fill="#1C1C1C"/>
  <rect x="24" y="62" width="1" height="13" fill="#1C1C1C"/>
  
  <rect x="38" y="90" width="1" height="8" fill="#1C1C1C"/>
  <rect x="40" y="88" width="1" height="10" fill="#1C1C1C"/>
  <rect x="42" y="89" width="1" height="9" fill="#1C1C1C"/>
  
  <!-- 书脊 -->
  <rect x="6" y="55" width="4" height="60" fill="#1C1C1C"/>
  <rect x="6" y="60" width="4" height="6" fill="#2F1B14"/>
  <rect x="6" y="70" width="4" height="6" fill="#2F1B14"/>
  <rect x="6" y="80" width="4" height="6" fill="#2F1B14"/>
  <rect x="6" y="90" width="4" height="6" fill="#2F1B14"/>
  <rect x="6" y="100" width="4" height="6" fill="#2F1B14"/>
  <rect x="6" y="110" width="4" height="5" fill="#2F1B14"/>
  
  <!-- 边框 -->
  <rect x="7" y="54" width="52" height="1" fill="#1C1C1C"/>
  <rect x="7" y="54" width="1" height="62" fill="#1C1C1C"/>
  <rect x="58" y="54" width="1" height="62" fill="#4A2F23"/>
  <rect x="8" y="115" width="50" height="1" fill="#1C1C1C"/>`,

    "summoner_pact_tome_stage3": `<!-- 召唤师契约之书 - 第三阶段 -->
  
  <!-- 束缚之书 -->
  <rect x="3" y="72" width="60" height="70" fill="#2F1B14"/>
  <rect x="4" y="73" width="58" height="68" fill="#4A2F23"/>
  
  <!-- 红色发光印章 -->
  <rect x="25" y="92" width="16" height="16" fill="#8B0000"/>
  <rect x="26" y="93" width="14" height="14" fill="#DC143C"/>
  <rect x="27" y="94" width="12" height="12" fill="#FF4500"/>
  
  <!-- 发光印章符号 -->
  <rect x="30" y="97" width="2" height="2" fill="#FFFF00"/>
  <rect x="34" y="97" width="2" height="2" fill="#FFFF00"/>
  <rect x="32" y="100" width="2" height="6" fill="#FFFF00"/>
  <rect x="29" y="103" width="8" height="2" fill="#FFFF00"/>
  <rect x="30" y="99" width="1" height="1" fill="#FFFFFF"/>
  <rect x="35" y="99" width="1" height="1" fill="#FFFFFF"/>
  <rect x="32" y="106" width="2" height="1" fill="#FFFFFF"/>
  
  <!-- 黑烟方块向上飘移 -->
  <rect x="28" y="62" width="2" height="2" fill="#1C1C1C" opacity="0.8"/>
  <rect x="36" y="57" width="2" height="2" fill="#1C1C1C" opacity="0.7"/>
  <rect x="31" y="52" width="2" height="2" fill="#1C1C1C" opacity="0.6"/>
  <rect x="34" y="47" width="2" height="2" fill="#1C1C1C" opacity="0.5"/>
  <rect x="29" y="42" width="2" height="2" fill="#1C1C1C" opacity="0.4"/>
  <rect x="37" y="37" width="2" height="2" fill="#1C1C1C" opacity="0.3"/>
  <rect x="32" y="32" width="2" height="2" fill="#1C1C1C" opacity="0.2"/>
  <rect x="35" y="27" width="2" height="2" fill="#1C1C1C" opacity="0.1"/>
  
  <!-- 金属角护 -->
  <rect x="3" y="72" width="10" height="10" fill="#2F2F2F"/>
  <rect x="53" y="72" width="10" height="10" fill="#4A4A4A"/>
  <rect x="3" y="132" width="10" height="10" fill="#2F2F2F"/>
  <rect x="53" y="132" width="10" height="10" fill="#4A4A4A"/>
  
  <!-- 角护钉子 -->
  <rect x="5" y="74" width="2" height="2" fill="#DC143C"/>
  <rect x="9" y="78" width="2" height="2" fill="#DC143C"/>
  <rect x="55" y="74" width="2" height="2" fill="#DC143C"/>
  <rect x="59" y="78" width="2" height="2" fill="#DC143C"/>
  <rect x="5" y="134" width="2" height="2" fill="#DC143C"/>
  <rect x="9" y="138" width="2" height="2" fill="#DC143C"/>
  <rect x="55" y="134" width="2" height="2" fill="#DC143C"/>
  <rect x="59" y="138" width="2" height="2" fill="#DC143C"/>
  
  <!-- 深爪痕 -->
  <rect x="15" y="82" width="1" height="15" fill="#000000"/>
  <rect x="17" y="80" width="1" height="17" fill="#000000"/>
  <rect x="19" y="81" width="1" height="16" fill="#000000"/>
  <rect x="21" y="79" width="1" height="18" fill="#000000"/>
  
  <rect x="43" y="117" width="1" height="12" fill="#000000"/>
  <rect x="45" y="115" width="1" height="14" fill="#000000"/>
  <rect x="47" y="116" width="1" height="13" fill="#000000"/>
  <rect x="49" y="114" width="1" height="15" fill="#000000"/>
  
  <!-- 书脊 -->
  <rect x="1" y="72" width="4" height="70" fill="#1C1C1C"/>
  <rect x="1" y="77" width="4" height="7" fill="#2F1B14"/>
  <rect x="1" y="87" width="4" height="7" fill="#2F1B14"/>
  <rect x="1" y="97" width="4" height="7" fill="#2F1B14"/>
  <rect x="1" y="107" width="4" height="7" fill="#2F1B14"/>
  <rect x="1" y="117" width="4" height="7" fill="#2F1B14"/>
  <rect x="1" y="127" width="4" height="7" fill="#2F1B14"/>
  <rect x="1" y="137" width="4" height="5" fill="#2F1B14"/>
  
  <!-- 边框 -->
  <rect x="2" y="71" width="62" height="1" fill="#1C1C1C"/>
  <rect x="2" y="71" width="1" height="72" fill="#1C1C1C"/>
  <rect x="63" y="71" width="1" height="72" fill="#4A2F23"/>
  <rect x="3" y="142" width="60" height="1" fill="#1C1C1C"/>`,

    "summoner_bone_bell_stage1": `<!-- 召唤师骨铃 - 第一阶段 -->
  
  <!-- 小骨铃 -->
  <rect x="31" y="84" width="10" height="12" fill="#F5F5DC"/>
  <rect x="32" y="85" width="8" height="10" fill="#E6E6E6"/>
  
  <!-- 1px铃舌点 -->
  <rect x="35" y="94" width="2" height="2" fill="#2F2F2F"/>
  
  <!-- 绳子 -->
  <rect x="35" y="74" width="2" height="10" fill="#8B4513"/>
  <rect x="35" y="74" width="1" height="10" fill="#654321"/>
  
  <!-- 铃顶部 -->
  <rect x="33" y="82" width="6" height="4" fill="#E6E6E6"/>
  <rect x="34" y="83" width="4" height="2" fill="#F5F5DC"/>
  
  <!-- 铃边缘 -->
  <rect x="30" y="83" width="12" height="1" fill="#D3D3D3"/>
  <rect x="30" y="83" width="1" height="14" fill="#D3D3D3"/>
  <rect x="41" y="83" width="1" height="14" fill="#FFFFFF"/>
  <rect x="32" y="96" width="8" height="1" fill="#D3D3D3"/>
  
  <!-- 手持暗示 -->
  <rect x="24" y="89" width="8" height="8" fill="#d2a679"/>
  <rect x="23" y="90" width="2" height="6" fill="#c49565"/>
  <rect x="29" y="90" width="2" height="6" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="30" y="87" width="2" height="6" fill="#d2a679"/>
  <rect x="40" y="87" width="2" height="6" fill="#d2a679"/>`,

    "summoner_bone_bell_stage2": `<!-- 召唤师骨铃 - 第二阶段 -->
  
  <!-- 骨铃带牙齿挂饰 -->
  <rect x="25" y="80" width="16" height="18" fill="#F5F5DC"/>
  <rect x="26" y="81" width="14" height="16" fill="#E6E6E6"/>
  
  <!-- 铃舌 -->
  <rect x="31" y="96" width="4" height="4" fill="#2F2F2F"/>
  <rect x="32" y="97" width="2" height="2" fill="#1C1C1C"/>
  
  <!-- 绳子 -->
  <rect x="32" y="70" width="2" height="10" fill="#8B4513"/>
  <rect x="32" y="70" width="1" height="10" fill="#654321"/>
  
  <!-- 牙齿挂饰（微小三角形） -->
  <rect x="21" y="90" width="3" height="2" fill="#F5F5DC"/>
  <rect x="22" y="92" width="1" height="2" fill="#F5F5DC"/>
  
  <rect x="42" y="92" width="3" height="2" fill="#F5F5DC"/>
  <rect x="43" y="94" width="1" height="2" fill="#F5F5DC"/>
  
  <rect x="18" y="95" width="3" height="2" fill="#F5F5DC"/>
  <rect x="19" y="97" width="1" height="2" fill="#F5F5DC"/>
  
  <rect x="45" y="97" width="3" height="2" fill="#F5F5DC"/>
  <rect x="46" y="99" width="1" height="2" fill="#F5F5DC"/>
  
  <!-- 牙齿连接线 -->
  <rect x="24" y="91" width="2" height="1" fill="#654321"/>
  <rect x="40" y="93" width="2" height="1" fill="#654321"/>
  <rect x="21" y="96" width="2" height="1" fill="#654321"/>
  <rect x="43" y="98" width="2" height="1" fill="#654321"/>
  
  <!-- 更暗的轮廓 -->
  <rect x="24" y="79" width="18" height="1" fill="#C0C0C0"/>
  <rect x="24" y="79" width="1" height="20" fill="#C0C0C0"/>
  <rect x="41" y="79" width="1" height="20" fill="#FFFFFF"/>
  <rect x="26" y="98" width="14" height="1" fill="#C0C0C0"/>
  
  <!-- 铃顶部 -->
  <rect x="28" y="78" width="10" height="4" fill="#E6E6E6"/>
  <rect x="29" y="79" width="8" height="2" fill="#F5F5DC"/>
  
  <!-- 手持 -->
  <rect x="21" y="90" width="8" height="8" fill="#d2a679"/>
  <rect x="20" y="91" width="2" height="6" fill="#c49565"/>
  <rect x="26" y="91" width="2" height="6" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="27" y="88" width="2" height="6" fill="#d2a679"/>
  <rect x="37" y="88" width="2" height="6" fill="#d2a679"/>`,

    "summoner_bone_bell_stage3": `<!-- 召唤师骨铃 - 第三阶段 -->
  
  <!-- 仪式铃 -->
  <rect x="21" y="75" width="24" height="25" fill="#F5F5DC"/>
  <rect x="22" y="76" width="22" height="23" fill="#E6E6E6"/>
  
  <!-- 红色发光字符 -->
  <rect x="26" y="82" width="2" height="2" fill="#DC143C"/>
  <rect x="30" y="80" width="2" height="2" fill="#DC143C"/>
  <rect x="34" y="82" width="2" height="2" fill="#DC143C"/>
  <rect x="38" y="80" width="2" height="2" fill="#DC143C"/>
  <rect x="28" y="88" width="2" height="2" fill="#DC143C"/>
  <rect x="32" y="86" width="2" height="2" fill="#DC143C"/>
  <rect x="36" y="88" width="2" height="2" fill="#DC143C"/>
  <rect x="30" y="94" width="2" height="2" fill="#DC143C"/>
  <rect x="34" y="92" width="2" height="2" fill="#DC143C"/>
  
  <!-- 铃舌 -->
  <rect x="29" y="98" width="8" height="6" fill="#2F2F2F"/>
  <rect x="30" y="99" width="6" height="4" fill="#1C1C1C"/>
  
  <!-- 绳子 -->
  <rect x="32" y="65" width="2" height="10" fill="#8B4513"/>
  <rect x="32" y="65" width="1" height="10" fill="#654321"/>
  
  <!-- 响铃效果通过同心方块带 -->
  <rect x="13" y="85" width="40" height="2" fill="#DC143C" opacity="0.3"/>
  <rect x="13" y="87" width="40" height="2" fill="#DC143C" opacity="0.3"/>
  <rect x="18" y="70" width="30" height="2" fill="#FF6347" opacity="0.2"/>
  <rect x="18" y="100" width="30" height="2" fill="#FF6347" opacity="0.2"/>
  <rect x="8" y="80" width="50" height="2" fill="#FF4500" opacity="0.2"/>
  <rect x="8" y="95" width="50" height="2" fill="#FF4500" opacity="0.2"/>
  <rect x="3" y="75" width="60" height="2" fill="#FFFF00" opacity="0.1"/>
  <rect x="3" y="105" width="60" height="2" fill="#FFFF00" opacity="0.1"/>
  
  <!-- 垂直同心方块带 -->
  <rect x="18" y="65" width="2" height="40" fill="#DC143C" opacity="0.3"/>
  <rect x="46" y="65" width="2" height="40" fill="#DC143C" opacity="0.3"/>
  <rect x="13" y="60" width="2" height="50" fill="#FF6347" opacity="0.2"/>
  <rect x="51" y="60" width="2" height="50" fill="#FF6347" opacity="0.2"/>
  <rect x="8" y="55" width="2" height="60" fill="#FF4500" opacity="0.2"/>
  <rect x="56" y="55" width="2" height="60" fill="#FF4500" opacity="0.2"/>
  <rect x="3" y="50" width="2" height="70" fill="#FFFF00" opacity="0.1"/>
  <rect x="61" y="50" width="2" height="70" fill="#FFFF00" opacity="0.1"/>
  
  <!-- 牙齿挂饰 -->
  <rect x="13" y="90" width="4" height="3" fill="#F5F5DC"/>
  <rect x="14" y="93" width="2" height="3" fill="#F5F5DC"/>
  
  <rect x="49" y="92" width="4" height="3" fill="#F5F5DC"/>
  <rect x="50" y="95" width="2" height="3" fill="#F5F5DC"/>
  
  <rect x="8" y="98" width="4" height="3" fill="#F5F5DC"/>
  <rect x="9" y="101" width="2" height="3" fill="#F5F5DC"/>
  
  <rect x="54" y="100" width="4" height="3" fill="#F5F5DC"/>
  <rect x="55" y="103" width="2" height="3" fill="#F5F5DC"/>
  
  <!-- 铃顶部 -->
  <rect x="24" y="73" width="18" height="4" fill="#E6E6E6"/>
  <rect x="25" y="74" width="16" height="2" fill="#F5F5DC"/>
  
  <!-- 轮廓 -->
  <rect x="20" y="74" width="26" height="1" fill="#C0C0C0"/>
  <rect x="20" y="74" width="1" height="27" fill="#C0C0C0"/>
  <rect x="45" y="74" width="1" height="27" fill="#FFFFFF"/>
  <rect x="22" y="100" width="22" height="1" fill="#C0C0C0"/>
  
  <!-- 手持 -->
  <rect x="21" y="90" width="8" height="8" fill="#d2a679"/>
  <rect x="20" y="91" width="2" height="6" fill="#c49565"/>
  <rect x="26" y="91" width="2" height="6" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="27" y="88" width="2" height="6" fill="#d2a679"/>
  <rect x="37" y="88" width="2" height="6" fill="#d2a679"/>`,

    "berserker_great_axe_stage1": `<!-- 狂战士巨斧 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 木质长柄 -->
  <rect x="26" y="43" width="8" height="124" fill="#8B4513"/>
  <rect x="26" y="43" width="2" height="124" fill="#654321"/>
  <rect x="32" y="43" width="2" height="124" fill="#A0522D"/>
  
  <!-- 木柄纹理 -->
  <rect x="28" y="51" width="2" height="7" fill="#654321"/>
  <rect x="28" y="68" width="2" height="7" fill="#654321"/>
  <rect x="28" y="85" width="2" height="7" fill="#654321"/>
  <rect x="28" y="101" width="2" height="7" fill="#654321"/>
  <rect x="28" y="118" width="2" height="7" fill="#654321"/>
  <rect x="28" y="134" width="2" height="7" fill="#654321"/>
  <rect x="28" y="151" width="2" height="7" fill="#654321"/>
  
  <!-- 铁质斧头 - 矩形头部 -->
  <rect x="6" y="2" width="50" height="41" fill="#808080"/>
  <rect x="6" y="2" width="8" height="41" fill="#696969"/>
  <rect x="47" y="2" width="8" height="41" fill="#D3D3D3"/>
  <rect x="6" y="36" width="50" height="7" fill="#696969"/>
  
  <!-- 缺口破片 -->
  <rect x="51" y="6" width="7" height="7" fill="#transparent"/>
  <rect x="58" y="10" width="3" height="5" fill="#transparent"/>
  <rect x="10" y="18" width="5" height="5" fill="#transparent"/>
  <rect x="4" y="14" width="3" height="7" fill="#transparent"/>
  
  <!-- 斧刃锋利边缘 -->
  <rect x="5" y="0" width="51" height="2" fill="#A9A9A9"/>
  <rect x="4" y="2" width="1" height="41" fill="#A9A9A9"/>
  <rect x="56" y="2" width="1" height="41" fill="#FFFFFF"/>
  
  <!-- 斧头连接部 -->
  <rect x="22" y="39" width="17" height="8" fill="#808080"/>
  <rect x="24" y="41" width="13" height="5" fill="#696969"/>
  
  <!-- 握把区域 -->
  <rect x="24" y="118" width="13" height="33" fill="#654321"/>
  <rect x="25" y="119" width="10" height="30" fill="#8B4513"/>
  
  <!-- 握把细节 -->
  <rect x="27" y="122" width="7" height="3" fill="#654321"/>
  <rect x="27" y="130" width="7" height="3" fill="#654321"/>
  <rect x="27" y="138" width="7" height="3" fill="#654321"/>
  <rect x="27" y="147" width="7" height="3" fill="#654321"/>
  
  <!-- 柄底 -->
  <rect x="28" y="163" width="5" height="7" fill="#654321"/>`,

    "berserker_great_axe_stage2": `<!-- 狂战士巨斧 - 第二阶段 -->
  
  <!-- 木柄 -->
  <rect x="29" y="53" width="8" height="114" fill="#8B4513"/>
  <rect x="29" y="53" width="2" height="114" fill="#654321"/>
  <rect x="34" y="53" width="2" height="114" fill="#A0522D"/>
  
  <!-- 双刃钢斧头 -->
  <rect x="6" y="11" width="53" height="42" fill="#C0C0C0"/>
  <rect x="6" y="11" width="11" height="42" fill="#A9A9A9"/>
  <rect x="48" y="11" width="11" height="42" fill="#E5E5E5"/>
  
  <!-- 尖刺顶部 -->
  <rect x="29" y="4" width="8" height="11" fill="#C0C0C0"/>
  <rect x="29" y="5" width="6" height="10" fill="#E5E5E5"/>
  <rect x="32" y="0" width="2" height="4" fill="#C0C0C0"/>
  
  <!-- 血迹像素（深红色几个） -->
  <rect x="17" y="19" width="2" height="2" fill="#8B0000"/>
  <rect x="29" y="27" width="2" height="2" fill="#8B0000"/>
  <rect x="40" y="15" width="2" height="2" fill="#8B0000"/>
  <rect x="14" y="34" width="1" height="1" fill="#8B0000"/>
  <rect x="48" y="23" width="1" height="1" fill="#8B0000"/>
  <rect x="36" y="38" width="1" height="1" fill="#8B0000"/>
  
  <!-- 斧头细节 -->
  <rect x="10" y="15" width="46" height="34" fill="#E5E5E5"/>
  <rect x="11" y="17" width="43" height="31" fill="#F8F8F8"/>
  
  <!-- 连接部分 -->
  <rect x="23" y="49" width="18" height="8" fill="#C0C0C0"/>
  <rect x="25" y="51" width="15" height="5" fill="#A9A9A9"/>
  
  <!-- 斧头边缘 -->
  <rect x="4" y="10" width="56" height="2" fill="#A9A9A9"/>
  <rect x="4" y="10" width="2" height="45" fill="#808080"/>
  <rect x="59" y="10" width="2" height="45" fill="#FFFFFF"/>
  <rect x="6" y="53" width="53" height="2" fill="#808080"/>
  
  <!-- 手柄底端 -->
  <rect x="30" y="163" width="5" height="6" fill="#654321"/>
  <rect x="29" y="167" width="8" height="3" fill="#8B4513"/>`,

    "berserker_great_axe_stage3": `<!-- 狂战士巨斧 - 第三阶段（熔岩斧） -->
  
  <!-- 木柄 -->
  <rect x="29" y="60" width="6" height="97" fill="#8B4513"/>
  <rect x="29" y="60" width="2" height="97" fill="#654321"/>
  <rect x="33" y="60" width="2" height="97" fill="#A0522D"/>
  
  <!-- 熔岩斧头 -->
  <rect x="6" y="21" width="51" height="39" fill="#2F2F2F"/>
  <rect x="6" y="21" width="10" height="39" fill="#1C1C1C"/>
  <rect x="48" y="21" width="10" height="39" fill="#4A4A4A"/>
  
  <!-- 橙色发光裂缝在头部 -->
  <rect x="16" y="27" width="1" height="13" fill="#FF4500"/>
  <rect x="26" y="24" width="1" height="16" fill="#FF6600"/>
  <rect x="35" y="29" width="1" height="12" fill="#FF4500"/>
  <rect x="45" y="26" width="1" height="14" fill="#FF6600"/>
  
  <!-- 横向裂缝 -->
  <rect x="13" y="34" width="13" height="1" fill="#FF4500"/>
  <rect x="39" y="31" width="12" height="1" fill="#FF6600"/>
  <rect x="19" y="43" width="10" height="1" fill="#FF4500"/>
  
  <!-- 边缘余烬尘粒 -->
  <rect x="3" y="31" width="1" height="1" fill="#FFD700"/>
  <rect x="0" y="37" width="1" height="1" fill="#FF8C00"/>
  <rect x="61" y="27" width="1" height="1" fill="#FFD700"/>
  <rect x="64" y="34" width="1" height="1" fill="#FF8C00"/>
  <rect x="23" y="18" width="1" height="1" fill="#FFD700"/>
  <rect x="29" y="15" width="1" height="1" fill="#FF8C00"/>
  <rect x="35" y="18" width="1" height="1" fill="#FFD700"/>
  <rect x="42" y="15" width="1" height="1" fill="#FF8C00"/>
  
  <!-- 尖刺顶部 -->
  <rect x="28" y="15" width="8" height="10" fill="#2F2F2F"/>
  <rect x="29" y="15" width="6" height="8" fill="#4A4A4A"/>
  <rect x="31" y="11" width="3" height="3" fill="#2F2F2F"/>
  
  <!-- 尖刺裂缝 -->
  <rect x="32" y="16" width="1" height="5" fill="#FF6600"/>
  
  <!-- 斧头细节 -->
  <rect x="10" y="24" width="45" height="32" fill="#4A4A4A"/>
  <rect x="11" y="25" width="42" height="30" fill="#2F2F2F"/>
  
  <!-- 连接部分 -->
  <rect x="23" y="56" width="18" height="8" fill="#2F2F2F"/>
  <rect x="24" y="58" width="15" height="5" fill="#4A4A4A"/>
  
  <!-- 连接部分裂缝 -->
  <rect x="32" y="59" width="1" height="4" fill="#FF4500"/>
  
  <!-- 斧头边缘 -->
  <rect x="5" y="20" width="54" height="1" fill="#4A4A4A"/>
  <rect x="5" y="20" width="1" height="41" fill="#1C1C1C"/>
  <rect x="58" y="20" width="1" height="41" fill="#696969"/>
  <rect x="6" y="60" width="51" height="1" fill="#1C1C1C"/>
  
  <!-- 手柄底端 -->
  <rect x="30" y="153" width="4" height="5" fill="#654321"/>
  <rect x="29" y="156" width="6" height="3" fill="#8B4513"/>`,

    "berserker_spiked_club_stage1": `<!-- 狂战士狼牙棒 - 第一阶段 -->
  
  <!-- 木棍 -->
  <rect x="28" y="40" width="9" height="126" fill="#8B4513"/>
  <rect x="28" y="40" width="3" height="126" fill="#654321"/>
  <rect x="34" y="40" width="3" height="126" fill="#A0522D"/>
  
  <!-- 木制棒头 -->
  <rect x="19" y="4" width="27" height="45" fill="#A0522D"/>
  <rect x="20" y="5" width="25" height="43" fill="#D2B48C"/>
  
  <!-- 方形尖刺（灰色） -->
  <rect x="15" y="13" width="5" height="5" fill="#808080"/>
  <rect x="13" y="15" width="2" height="2" fill="#696969"/>
  
  <rect x="45" y="18" width="5" height="5" fill="#808080"/>
  <rect x="50" y="20" width="2" height="2" fill="#696969"/>
  
  <rect x="22" y="0" width="5" height="5" fill="#808080"/>
  <rect x="20" y="2" width="2" height="2" fill="#696969"/>
  
  <rect x="38" y="3" width="5" height="5" fill="#808080"/>
  <rect x="43" y="4" width="2" height="2" fill="#696969"/>
  
  <rect x="25" y="36" width="5" height="5" fill="#808080"/>
  <rect x="24" y="38" width="2" height="2" fill="#696969"/>
  
  <rect x="34" y="33" width="5" height="5" fill="#808080"/>
  <rect x="40" y="35" width="2" height="2" fill="#696969"/>
  
  <!-- 缠带握把 -->
  <rect x="26" y="67" width="13" height="3" fill="#654321"/>
  <rect x="26" y="76" width="13" height="3" fill="#654321"/>
  <rect x="26" y="85" width="13" height="3" fill="#654321"/>
  <rect x="26" y="94" width="13" height="3" fill="#654321"/>
  <rect x="26" y="103" width="13" height="3" fill="#654321"/>
  <rect x="26" y="112" width="13" height="3" fill="#654321"/>
  <rect x="26" y="121" width="13" height="3" fill="#654321"/>
  <rect x="26" y="130" width="13" height="3" fill="#654321"/>
  
  <!-- 连接部分 -->
  <rect x="24" y="45" width="18" height="9" fill="#A0522D"/>
  <rect x="25" y="47" width="14" height="5" fill="#D2B48C"/>
  
  <!-- 棍端 -->
  <rect x="30" y="162" width="5" height="7" fill="#654321"/>
  <rect x="28" y="166" width="9" height="4" fill="#8B4513"/>`,

    "berserker_spiked_club_stage2": `<!-- 狂战士狼牙棒 - 第二阶段 -->
  
  <!-- 木棍 -->
  <rect x="29" y="45" width="9" height="121" fill="#8B4513"/>
  <rect x="29" y="45" width="3" height="121" fill="#654321"/>
  <rect x="35" y="45" width="3" height="121" fill="#A0522D"/>
  
  <!-- 铁包木制棒头 -->
  <rect x="16" y="6" width="35" height="48" fill="#A0522D"/>
  <rect x="16" y="7" width="33" height="46" fill="#D2B48C"/>
  
  <!-- 铁包边缘 -->
  <rect x="14" y="4" width="38" height="3" fill="#808080"/>
  <rect x="14" y="4" width="3" height="51" fill="#808080"/>
  <rect x="49" y="4" width="3" height="51" fill="#A9A9A9"/>
  <rect x="16" y="53" width="33" height="3" fill="#808080"/>
  
  <!-- 更多尖刺 -->
  <rect x="11" y="15" width="7" height="7" fill="#C0C0C0"/>
  <rect x="10" y="16" width="3" height="3" fill="#A9A9A9"/>
  
  <rect x="48" y="19" width="7" height="7" fill="#C0C0C0"/>
  <rect x="53" y="21" width="3" height="3" fill="#A9A9A9"/>
  
  <rect x="20" y="0" width="7" height="7" fill="#C0C0C0"/>
  <rect x="18" y="2" width="3" height="3" fill="#A9A9A9"/>
  
  <rect x="39" y="2" width="7" height="7" fill="#C0C0C0"/>
  <rect x="44" y="3" width="3" height="3" fill="#A9A9A9"/>
  
  <rect x="24" y="43" width="7" height="7" fill="#C0C0C0"/>
  <rect x="23" y="45" width="3" height="3" fill="#A9A9A9"/>
  
  <rect x="35" y="41" width="7" height="7" fill="#C0C0C0"/>
  <rect x="40" y="43" width="3" height="3" fill="#A9A9A9"/>
  
  <!-- 侧面尖刺 -->
  <rect x="9" y="26" width="7" height="7" fill="#C0C0C0"/>
  <rect x="7" y="28" width="3" height="3" fill="#A9A9A9"/>
  
  <rect x="50" y="32" width="7" height="7" fill="#C0C0C0"/>
  <rect x="55" y="34" width="3" height="3" fill="#A9A9A9"/>
  
  <!-- 缠带握把 -->
  <rect x="27" y="67" width="12" height="3" fill="#654321"/>
  <rect x="27" y="75" width="12" height="3" fill="#654321"/>
  <rect x="27" y="84" width="12" height="3" fill="#654321"/>
  <rect x="27" y="93" width="12" height="3" fill="#654321"/>
  <rect x="27" y="101" width="12" height="3" fill="#654321"/>
  <rect x="27" y="110" width="12" height="3" fill="#654321"/>
  <rect x="27" y="119" width="12" height="3" fill="#654321"/>
  <rect x="27" y="128" width="12" height="3" fill="#654321"/>
  
  <!-- 连接部分 -->
  <rect x="23" y="49" width="21" height="10" fill="#808080"/>
  <rect x="24" y="51" width="17" height="7" fill="#A9A9A9"/>
  
  <!-- 棍端 -->
  <rect x="30" y="162" width="5" height="7" fill="#654321"/>
  <rect x="29" y="167" width="9" height="3" fill="#8B4513"/>`,

    "berserker_spiked_club_stage3": `<!-- 狂战士狼牙棒 - 第三阶段（火焰棒） -->
  
  <!-- 木棍 -->
  <rect x="29" y="65" width="7" height="102" fill="#8B4513"/>
  <rect x="29" y="65" width="2" height="102" fill="#654321"/>
  <rect x="34" y="65" width="2" height="102" fill="#A0522D"/>
  
  <!-- 火焰带状头部 -->
  <rect x="14" y="29" width="36" height="44" fill="#8B4513"/>
  <rect x="15" y="30" width="35" height="42" fill="#A0522D"/>
  
  <!-- 阶梯式橙色/黄色火焰带 -->
  <rect x="17" y="33" width="32" height="6" fill="#FF6600"/>
  <rect x="18" y="36" width="29" height="4" fill="#FF4500"/>
  <rect x="19" y="40" width="26" height="4" fill="#FFD700"/>
  <rect x="17" y="44" width="32" height="4" fill="#FF6600"/>
  <rect x="18" y="47" width="29" height="4" fill="#FF4500"/>
  <rect x="19" y="51" width="26" height="4" fill="#FFD700"/>
  <rect x="17" y="54" width="32" height="4" fill="#FF6600"/>
  <rect x="18" y="58" width="29" height="4" fill="#FF4500"/>
  <rect x="19" y="62" width="26" height="4" fill="#FFD700"/>
  <rect x="17" y="65" width="32" height="4" fill="#FF6600"/>
  
  <!-- 火焰尖刺 -->
  <rect x="11" y="40" width="7" height="7" fill="#FF4500"/>
  <rect x="9" y="41" width="3" height="3" fill="#FFD700"/>
  
  <rect x="47" y="44" width="7" height="7" fill="#FF4500"/>
  <rect x="53" y="45" width="3" height="3" fill="#FFD700"/>
  
  <rect x="22" y="25" width="7" height="7" fill="#FF4500"/>
  <rect x="20" y="27" width="3" height="3" fill="#FFD700"/>
  
  <rect x="36" y="28" width="7" height="7" fill="#FF4500"/>
  <rect x="42" y="29" width="3" height="3" fill="#FFD700"/>
  
  <!-- 上升方形火花 -->
  <rect x="25" y="22" width="1" height="1" fill="#FFD700"/>
  <rect x="38" y="18" width="1" height="1" fill="#FF6600"/>
  <rect x="22" y="15" width="1" height="1" fill="#FFD700"/>
  <rect x="43" y="11" width="1" height="1" fill="#FF6600"/>
  <rect x="29" y="7" width="1" height="1" fill="#FFD700"/>
  <rect x="36" y="4" width="1" height="1" fill="#FF6600"/>
  <rect x="33" y="0" width="1" height="1" fill="#FFD700"/>
  
  <!-- 侧边火花 -->
  <rect x="7" y="47" width="1" height="1" fill="#FFD700"/>
  <rect x="56" y="51" width="1" height="1" fill="#FF6600"/>
  <rect x="11" y="58" width="1" height="1" fill="#FFD700"/>
  <rect x="53" y="62" width="1" height="1" fill="#FF6600"/>
  
  <!-- 缠带握把 -->
  <rect x="27" y="84" width="10" height="3" fill="#654321"/>
  <rect x="27" y="91" width="10" height="3" fill="#654321"/>
  <rect x="27" y="98" width="10" height="3" fill="#654321"/>
  <rect x="27" y="105" width="10" height="3" fill="#654321"/>
  <rect x="27" y="113" width="10" height="3" fill="#654321"/>
  <rect x="27" y="120" width="10" height="3" fill="#654321"/>
  <rect x="27" y="127" width="10" height="3" fill="#654321"/>
  <rect x="27" y="134" width="10" height="3" fill="#654321"/>
  
  <!-- 连接部分 -->
  <rect x="22" y="69" width="20" height="9" fill="#A0522D"/>
  <rect x="24" y="70" width="17" height="6" fill="#D2B48C"/>
  
  <!-- 连接部分火焰 -->
  <rect x="32" y="72" width="1" height="4" fill="#FF6600"/>
  
  <!-- 棍端 -->
  <rect x="30" y="163" width="4" height="6" fill="#654321"/>
  <rect x="29" y="167" width="7" height="3" fill="#8B4513"/>`,

    "berserker_berserker_sword_stage1": `<!-- 狂战士巨剑 - 第一阶段 -->
  
  <!-- 超大铁剑 -->
  <rect x="22" y="13" width="21" height="120" fill="#C0C0C0"/>
  <rect x="22" y="13" width="7" height="120" fill="#A9A9A9"/>
  <rect x="36" y="13" width="7" height="120" fill="#E5E5E5"/>
  
  <!-- 矩形剑身 -->
  <rect x="21" y="12" width="22" height="1" fill="#808080"/>
  <rect x="21" y="12" width="1" height="121" fill="#808080"/>
  <rect x="43" y="12" width="1" height="121" fill="#F8F8F8"/>
  <rect x="22" y="132" width="21" height="1" fill="#808080"/>
  
  <!-- 缺口边缘像素 -->
  <rect x="20" y="30" width="2" height="3" fill="#C0C0C0"/>
  <rect x="44" y="43" width="2" height="3" fill="#C0C0C0"/>
  <rect x="20" y="60" width="2" height="2" fill="#C0C0C0"/>
  <rect x="44" y="73" width="2" height="3" fill="#C0C0C0"/>
  <rect x="20" y="94" width="2" height="3" fill="#C0C0C0"/>
  <rect x="44" y="111" width="2" height="2" fill="#C0C0C0"/>
  
  <!-- 剑尖 -->
  <rect x="26" y="9" width="14" height="4" fill="#C0C0C0"/>
  <rect x="29" y="4" width="7" height="4" fill="#C0C0C0"/>
  <rect x="31" y="2" width="3" height="3" fill="#C0C0C0"/>
  <rect x="32" y="0" width="2" height="2" fill="#C0C0C0"/>
  
  <!-- 护手 -->
  <rect x="11" y="132" width="43" height="9" fill="#808080"/>
  <rect x="11" y="132" width="10" height="9" fill="#696969"/>
  <rect x="44" y="132" width="10" height="9" fill="#A9A9A9"/>
  
  <!-- 剑柄 -->
  <rect x="24" y="141" width="17" height="26" fill="#8B4513"/>
  <rect x="24" y="141" width="5" height="26" fill="#654321"/>
  <rect x="36" y="141" width="5" height="26" fill="#A0522D"/>
  
  <!-- 剑首 -->
  <rect x="26" y="162" width="14" height="7" fill="#654321"/>
  <rect x="22" y="167" width="21" height="3" fill="#8B4513"/>`,

    "berserker_berserker_sword_stage2": `<!-- 狂战士巨剑 - 第二阶段 -->
  
  <!-- 染血钢剑身 -->
  <rect x="21" y="12" width="22" height="116" fill="#E5E5E5"/>
  <rect x="21" y="12" width="7" height="116" fill="#C0C0C0"/>
  <rect x="37" y="12" width="7" height="116" fill="#F8F8F8"/>
  
  <!-- 血迹 -->
  <rect x="24" y="28" width="2" height="2" fill="#8B0000"/>
  <rect x="37" y="44" width="2" height="2" fill="#8B0000"/>
  <rect x="23" y="60" width="2" height="2" fill="#8B0000"/>
  <rect x="39" y="72" width="2" height="2" fill="#8B0000"/>
  <rect x="26" y="92" width="2" height="2" fill="#8B0000"/>
  <rect x="37" y="108" width="2" height="2" fill="#8B0000"/>
  
  <!-- 更重的护手 -->
  <rect x="8" y="128" width="48" height="10" fill="#C0C0C0"/>
  <rect x="8" y="128" width="12" height="10" fill="#A9A9A9"/>
  <rect x="45" y="128" width="12" height="10" fill="#E5E5E5"/>
  
  <!-- 包裹握把 -->
  <rect x="23" y="138" width="19" height="28" fill="#8B4513"/>
  <rect x="23" y="138" width="6" height="28" fill="#654321"/>
  <rect x="39" y="138" width="6" height="28" fill="#A0522D"/>
  
  <!-- 包裹带 -->
  <rect x="21" y="144" width="22" height="2" fill="#654321"/>
  <rect x="21" y="152" width="22" height="2" fill="#654321"/>
  <rect x="21" y="160" width="22" height="2" fill="#654321"/>
  
  <!-- 缺口边缘 -->
  <rect x="19" y="32" width="2" height="3" fill="#E5E5E5"/>
  <rect x="44" y="44" width="2" height="4" fill="#E5E5E5"/>
  <rect x="19" y="60" width="2" height="2" fill="#E5E5E5"/>
  <rect x="45" y="72" width="2" height="3" fill="#E5E5E5"/>
  <rect x="19" y="92" width="2" height="4" fill="#E5E5E5"/>
  <rect x="44" y="108" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 剑尖 -->
  <rect x="24" y="8" width="16" height="4" fill="#E5E5E5"/>
  <rect x="28" y="4" width="10" height="4" fill="#E5E5E5"/>
  <rect x="30" y="2" width="5" height="2" fill="#E5E5E5"/>
  <rect x="32" y="0" width="2" height="2" fill="#E5E5E5"/>
  
  <!-- 轮廓 -->
  <rect x="20" y="11" width="24" height="2" fill="#A9A9A9"/>
  <rect x="20" y="11" width="2" height="119" fill="#A9A9A9"/>
  <rect x="43" y="11" width="2" height="119" fill="#FFFFFF"/>
  <rect x="22" y="128" width="21" height="2" fill="#A9A9A9"/>
  
  <!-- 剑首 -->
  <rect x="24" y="162" width="16" height="8" fill="#654321"/>
  <rect x="21" y="166" width="22" height="4" fill="#8B4513"/>`,

    "berserker_berserker_sword_stage3": `<!-- 狂战士巨剑 - 第三阶段（熔融巨剑） -->
  
  <!-- 熔融剑身 -->
  <rect x="19" y="13" width="27" height="111" fill="#2F2F2F"/>
  <rect x="19" y="13" width="9" height="111" fill="#1C1C1C"/>
  <rect x="37" y="13" width="9" height="111" fill="#4A4A4A"/>
  
  <!-- 发光岩浆裂缝 -->
  <rect x="25" y="24" width="2" height="19" fill="#FF6600"/>
  <rect x="38" y="31" width="2" height="15" fill="#FF4500"/>
  <rect x="21" y="53" width="2" height="22" fill="#FF6600"/>
  <rect x="41" y="61" width="2" height="19" fill="#FF4500"/>
  <rect x="29" y="87" width="2" height="15" fill="#FF6600"/>
  <rect x="34" y="98" width="2" height="11" fill="#FF4500"/>
  
  <!-- 横向裂缝 -->
  <rect x="23" y="46" width="15" height="2" fill="#FF4500"/>
  <rect x="27" y="76" width="13" height="2" fill="#FF6600"/>
  <rect x="24" y="102" width="12" height="2" fill="#FF4500"/>
  
  <!-- 热带（无软晕） -->
  <rect x="16" y="20" width="1" height="104" fill="#FF8C00" opacity="0.6"/>
  <rect x="47" y="20" width="1" height="104" fill="#FF8C00" opacity="0.6"/>
  <rect x="13" y="27" width="1" height="89" fill="#FFD700" opacity="0.4"/>
  <rect x="50" y="27" width="1" height="89" fill="#FFD700" opacity="0.4"/>
  <rect x="10" y="35" width="1" height="74" fill="#FFFF00" opacity="0.3"/>
  <rect x="53" y="35" width="1" height="74" fill="#FFFF00" opacity="0.3"/>
  
  <!-- 缺口边缘 -->
  <rect x="17" y="35" width="3" height="4" fill="#2F2F2F"/>
  <rect x="45" y="46" width="3" height="4" fill="#2F2F2F"/>
  <rect x="17" y="61" width="3" height="3" fill="#2F2F2F"/>
  <rect x="46" y="72" width="3" height="4" fill="#2F2F2F"/>
  <rect x="17" y="91" width="3" height="4" fill="#2F2F2F"/>
  <rect x="45" y="105" width="3" height="3" fill="#2F2F2F"/>
  
  <!-- 剑尖 -->
  <rect x="24" y="9" width="18" height="4" fill="#2F2F2F"/>
  <rect x="27" y="5" width="12" height="4" fill="#2F2F2F"/>
  <rect x="30" y="3" width="6" height="2" fill="#2F2F2F"/>
  <rect x="31" y="1" width="3" height="1" fill="#2F2F2F"/>
  <rect x="32" y="0" width="1" height="1" fill="#2F2F2F"/>
  
  <!-- 剑尖裂缝 -->
  <rect x="32" y="7" width="1" height="4" fill="#FF6600"/>
  
  <!-- 护手 -->
  <rect x="7" y="124" width="52" height="11" fill="#2F2F2F"/>
  <rect x="7" y="124" width="13" height="11" fill="#1C1C1C"/>
  <rect x="46" y="124" width="13" height="11" fill="#4A4A4A"/>
  
  <!-- 握把 -->
  <rect x="22" y="135" width="21" height="30" fill="#8B4513"/>
  <rect x="22" y="135" width="7" height="30" fill="#654321"/>
  <rect x="36" y="135" width="7" height="30" fill="#A0522D"/>
  
  <!-- 轮廓 -->
  <rect x="18" y="11" width="30" height="1" fill="#1C1C1C"/>
  <rect x="18" y="11" width="1" height="114" fill="#1C1C1C"/>
  <rect x="46" y="11" width="1" height="114" fill="#696969"/>
  <rect x="19" y="124" width="27" height="1" fill="#1C1C1C"/>
  
  <!-- 剑首 -->
  <rect x="24" y="161" width="18" height="9" fill="#654321"/>
  <rect x="21" y="165" width="24" height="4" fill="#8B4513"/>`,

    "priest_holy_staff_stage1": `<!-- 牧师圣杖 - 第一阶段 - Minecraft像素风格 -->
  
  <!-- 木质法杖主体 -->
  <rect x="28" y="14" width="8" height="146" fill="#8B4513"/>
  <rect x="28" y="14" width="3" height="146" fill="#654321"/>
  <rect x="34" y="14" width="3" height="146" fill="#A0522D"/>
  
  <!-- 木质纹理 -->
  <rect x="30" y="23" width="2" height="7" fill="#654321"/>
  <rect x="30" y="39" width="2" height="7" fill="#654321"/>
  <rect x="30" y="56" width="2" height="7" fill="#654321"/>
  <rect x="30" y="73" width="2" height="7" fill="#654321"/>
  <rect x="30" y="89" width="2" height="7" fill="#654321"/>
  <rect x="30" y="106" width="2" height="7" fill="#654321"/>
  <rect x="30" y="123" width="2" height="7" fill="#654321"/>
  <rect x="30" y="139" width="2" height="7" fill="#654321"/>
  
  <!-- 小型白色宝石顶端 -->
  <rect x="26" y="2" width="13" height="17" fill="#FFFFFF"/>
  <rect x="28" y="3" width="10" height="13" fill="#F0F8FF"/>
  <rect x="29" y="5" width="7" height="10" fill="#E6E6FA"/>
  
  <!-- 微妙的十字缺口 -->
  <rect x="32" y="0" width="2" height="7" fill="#E6E6FA"/>
  <rect x="28" y="3" width="8" height="2" fill="#E6E6FA"/>
  
  <!-- 圣光微弱效果 -->
  <rect x="24" y="0" width="2" height="2" fill="#FFFFFF" opacity="0.6"/>
  <rect x="39" y="0" width="2" height="2" fill="#FFFFFF" opacity="0.6"/>
  <rect x="24" y="18" width="2" height="2" fill="#FFFFFF" opacity="0.6"/>
  <rect x="39" y="18" width="2" height="2" fill="#FFFFFF" opacity="0.6"/>
  
  <rect x="23" y="2" width="2" height="2" fill="#F0F8FF" opacity="0.4"/>
  <rect x="41" y="2" width="2" height="2" fill="#F0F8FF" opacity="0.4"/>
  <rect x="23" y="17" width="2" height="2" fill="#F0F8FF" opacity="0.4"/>
  <rect x="41" y="17" width="2" height="2" fill="#F0F8FF" opacity="0.4"/>
  
  <!-- 法杖连接部 -->
  <rect x="24" y="14" width="17" height="7" fill="#8B4513"/>
  <rect x="26" y="16" width="13" height="3" fill="#654321"/>
  
  <!-- 握持区域 -->
  <rect x="27" y="127" width="12" height="25" fill="#654321"/>
  <rect x="28" y="128" width="8" height="22" fill="#8B4513"/>
  
  <!-- 握把纹理 -->
  <rect x="30" y="131" width="5" height="3" fill="#654321"/>
  <rect x="30" y="139" width="5" height="3" fill="#654321"/>
  <rect x="30" y="148" width="5" height="3" fill="#654321"/>
  
  <!-- 底端 -->
  <rect x="30" y="160" width="5" height="7" fill="#654321"/>
  <rect x="32" y="167" width="2" height="3" fill="#8B4513"/>`,

    "priest_holy_staff_stage2": `<!-- 牧师神圣法杖 - 第二阶段 -->
  
  <!-- 银色法杖 -->
  <rect x="28" y="17" width="9" height="149" fill="#C0C0C0"/>
  <rect x="28" y="17" width="3" height="149" fill="#A9A9A9"/>
  <rect x="34" y="17" width="3" height="149" fill="#E5E5E5"/>
  
  <!-- 银色顶端与金环 -->
  <rect x="24" y="0" width="17" height="21" fill="#C0C0C0"/>
  <rect x="25" y="1" width="15" height="20" fill="#E5E5E5"/>
  
  <!-- 金环 -->
  <rect x="22" y="4" width="21" height="3" fill="#DAA520"/>
  <rect x="22" y="15" width="21" height="3" fill="#DAA520"/>
  <rect x="22" y="4" width="3" height="14" fill="#DAA520"/>
  <rect x="39" y="4" width="3" height="14" fill="#FFD700"/>
  
  <!-- 白色高光像素 -->
  <rect x="28" y="6" width="2" height="2" fill="#FFFFFF"/>
  <rect x="35" y="6" width="2" height="2" fill="#FFFFFF"/>
  <rect x="28" y="15" width="2" height="2" fill="#FFFFFF"/>
  <rect x="35" y="15" width="2" height="2" fill="#FFFFFF"/>
  <rect x="24" y="9" width="2" height="2" fill="#FFFFFF"/>
  <rect x="39" y="9" width="2" height="2" fill="#FFFFFF"/>
  
  <!-- 法杖装饰环 -->
  <rect x="27" y="38" width="12" height="3" fill="#A9A9A9"/>
  <rect x="27" y="64" width="12" height="3" fill="#A9A9A9"/>
  <rect x="27" y="90" width="12" height="3" fill="#A9A9A9"/>
  <rect x="27" y="115" width="12" height="3" fill="#A9A9A9"/>
  <rect x="27" y="141" width="12" height="3" fill="#A9A9A9"/>
  
  <!-- 小十字装饰 -->
  <rect x="32" y="43" width="2" height="5" fill="#FFFFFF"/>
  <rect x="29" y="44" width="7" height="2" fill="#FFFFFF"/>
  
  <rect x="32" y="68" width="2" height="5" fill="#FFFFFF"/>
  <rect x="29" y="70" width="7" height="2" fill="#FFFFFF"/>
  
  <!-- 法杖底端 -->
  <rect x="30" y="162" width="5" height="7" fill="#A9A9A9"/>
  <rect x="28" y="167" width="9" height="3" fill="#C0C0C0"/>`,

    "priest_holy_staff_stage3": `<!-- 牧师神圣法杖 - 第三阶段 -->
  
  <!-- 辐射法杖 -->
  <rect x="29" y="33" width="8" height="134" fill="#FFFFFF"/>
  <rect x="29" y="33" width="2" height="134" fill="#F0F8FF"/>
  <rect x="34" y="33" width="2" height="134" fill="#E6F3FF"/>
  
  <!-- 大白色发光宝石 -->
  <rect x="22" y="14" width="21" height="23" fill="#FFFFFF"/>
  <rect x="23" y="15" width="20" height="21" fill="#F0F8FF"/>
  <rect x="23" y="15" width="18" height="20" fill="#E6F3FF"/>
  <rect x="25" y="17" width="15" height="17" fill="#FFFFFF"/>
  
  <!-- 同心方形光晕 -->
  <rect x="17" y="9" width="31" height="2" fill="#FFFFFF" opacity="0.8"/>
  <rect x="17" y="40" width="31" height="2" fill="#FFFFFF" opacity="0.8"/>
  <rect x="19" y="8" width="2" height="34" fill="#FFFFFF" opacity="0.8"/>
  <rect x="45" y="8" width="2" height="34" fill="#FFFFFF" opacity="0.8"/>
  
  <rect x="13" y="5" width="38" height="2" fill="#F0F8FF" opacity="0.6"/>
  <rect x="13" y="44" width="38" height="2" fill="#F0F8FF" opacity="0.6"/>
  <rect x="15" y="4" width="2" height="41" fill="#F0F8FF" opacity="0.6"/>
  <rect x="49" y="4" width="2" height="41" fill="#F0F8FF" opacity="0.6"/>
  
  <rect x="10" y="2" width="46" height="2" fill="#E6F3FF" opacity="0.4"/>
  <rect x="10" y="47" width="46" height="2" fill="#E6F3FF" opacity="0.4"/>
  <rect x="11" y="0" width="2" height="49" fill="#E6F3FF" opacity="0.4"/>
  <rect x="52" y="0" width="2" height="49" fill="#E6F3FF" opacity="0.4"/>
  
  <!-- 法杖装饰 -->
  <rect x="26" y="52" width="12" height="3" fill="#F0F8FF"/>
  <rect x="26" y="67" width="12" height="3" fill="#F0F8FF"/>
  <rect x="26" y="83" width="12" height="3" fill="#F0F8FF"/>
  <rect x="26" y="98" width="12" height="3" fill="#F0F8FF"/>
  <rect x="26" y="113" width="12" height="3" fill="#F0F8FF"/>
  <rect x="26" y="129" width="12" height="3" fill="#F0F8FF"/>
  <rect x="26" y="144" width="12" height="3" fill="#F0F8FF"/>
  
  <!-- 十字装饰 -->
  <rect x="31" y="56" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="58" width="9" height="3" fill="#FFFFFF"/>
  
  <rect x="31" y="71" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="74" width="9" height="3" fill="#FFFFFF"/>
  
  <rect x="31" y="87" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="89" width="9" height="3" fill="#FFFFFF"/>
  
  <rect x="31" y="102" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="104" width="9" height="3" fill="#FFFFFF"/>
  
  <rect x="31" y="117" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="119" width="9" height="3" fill="#FFFFFF"/>
  
  <rect x="31" y="132" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="135" width="9" height="3" fill="#FFFFFF"/>
  
  <rect x="31" y="148" width="3" height="8" fill="#FFFFFF"/>
  <rect x="28" y="150" width="9" height="3" fill="#FFFFFF"/>
  
  <!-- 法杖底端 -->
  <rect x="30" y="163" width="5" height="6" fill="#F0F8FF"/>
  <rect x="29" y="167" width="8" height="3" fill="#FFFFFF"/>`,

    "priest_chalice_stage1": `<!-- 牧师圣杯 - 第一阶段 -->
  
  <!-- 小杯 -->
  <rect x="26" y="70" width="20" height="25" fill="#DAA520"/>
  <rect x="27" y="71" width="18" height="23" fill="#FFD700"/>
  
  <!-- 杯口 -->
  <rect x="24" y="68" width="24" height="3" fill="#FFD700"/>
  <rect x="25" y="69" width="22" height="2" fill="#FFFFFF"/>
  
  <!-- 暗内像素 -->
  <rect x="29" y="73" width="14" height="15" fill="#1C1C1C"/>
  <rect x="30" y="74" width="12" height="13" fill="#2F2F2F"/>
  
  <!-- 杯底 -->
  <rect x="31" y="90" width="10" height="3" fill="#B8860B"/>
  <rect x="32" y="91" width="8" height="2" fill="#DAA520"/>
  
  <!-- 杯柄 -->
  <rect x="31" y="93" width="10" height="4" fill="#B8860B"/>
  <rect x="32" y="94" width="8" height="3" fill="#DAA520"/>
  
  <!-- 底座 -->
  <rect x="24" y="97" width="24" height="6" fill="#B8860B"/>
  <rect x="25" y="98" width="22" height="4" fill="#DAA520"/>
  <rect x="26" y="99" width="20" height="2" fill="#FFD700"/>
  
  <!-- 手持暗示 -->
  <rect x="18" y="85" width="8" height="8" fill="#d2a679"/>
  <rect x="17" y="86" width="2" height="6" fill="#c49565"/>
  <rect x="23" y="86" width="2" height="6" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="24" y="83" width="2" height="6" fill="#d2a679"/>
  <rect x="46" y="83" width="2" height="6" fill="#d2a679"/>
  
  <!-- 轮廓 -->
  <rect x="23" y="67" width="26" height="1" fill="#B8860B"/>
  <rect x="23" y="67" width="1" height="36" fill="#B8860B"/>
  <rect x="48" y="67" width="1" height="36" fill="#FFFFFF"/>
  <rect x="24" y="102" width="24" height="1" fill="#B8860B"/>`,

    "priest_chalice_stage2": `<!-- 牧师圣杯 - 第二阶段 -->
  
  <!-- 雕刻圣杯 -->
  <rect x="24" y="65" width="24" height="30" fill="#DAA520"/>
  <rect x="25" y="66" width="22" height="28" fill="#FFD700"/>
  
  <!-- 杯口 -->
  <rect x="22" y="63" width="28" height="3" fill="#FFD700"/>
  <rect x="23" y="64" width="26" height="2" fill="#FFFFFF"/>
  
  <!-- 十字图标 -->
  <rect x="34" y="73" width="4" height="12" fill="#FFFFFF"/>
  <rect x="29" y="77" width="14" height="4" fill="#FFFFFF"/>
  
  <!-- 暗内像素 -->
  <rect x="27" y="68" width="18" height="18" fill="#1C1C1C"/>
  <rect x="28" y="69" width="16" height="16" fill="#2F2F2F"/>
  
  <!-- 杯底 -->
  <rect x="29" y="90" width="14" height="4" fill="#B8860B"/>
  <rect x="30" y="91" width="12" height="3" fill="#DAA520"/>
  
  <!-- 杯柄 -->
  <rect x="29" y="94" width="14" height="5" fill="#B8860B"/>
  <rect x="30" y="95" width="12" height="4" fill="#DAA520"/>
  
  <!-- 底座宝石点 -->
  <rect x="21" y="99" width="30" height="8" fill="#B8860B"/>
  <rect x="22" y="100" width="28" height="6" fill="#DAA520"/>
  <rect x="23" y="101" width="26" height="4" fill="#FFD700"/>
  
  <!-- 底座宝石点 -->
  <rect x="35" y="103" width="2" height="2" fill="#DC143C"/>
  
  <!-- 手持 -->
  <rect x="16" y="83" width="8" height="10" fill="#d2a679"/>
  <rect x="15" y="84" width="2" height="8" fill="#c49565"/>
  <rect x="21" y="84" width="2" height="8" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="22" y="80" width="2" height="8" fill="#d2a679"/>
  <rect x="48" y="80" width="2" height="8" fill="#d2a679"/>
  
  <!-- 轮廓 -->
  <rect x="21" y="62" width="30" height="1" fill="#B8860B"/>
  <rect x="21" y="62" width="1" height="46" fill="#B8860B"/>
  <rect x="50" y="62" width="1" height="46" fill="#FFFFFF"/>
  <rect x="22" y="107" width="28" height="1" fill="#B8860B"/>`,

    "priest_chalice_stage3": `<!-- 牧师圣杯 - 第三阶段 -->
  
  <!-- 悬浮圣杯 -->
  <rect x="20" y="60" width="30" height="35" fill="#FFD700"/>
  <rect x="21" y="61" width="28" height="33" fill="#FFFFFF"/>
  
  <!-- 悬浮暗示 -->
  <rect x="18" y="57" width="34" height="1" fill="none" stroke="#E6E6FA" stroke-width="1" opacity="0.3"/>
  <rect x="18" y="97" width="34" height="1" fill="none" stroke="#E6E6FA" stroke-width="1" opacity="0.3"/>
  
  <!-- 杯口 -->
  <rect x="17" y="58" width="36" height="3" fill="#FFFFFF"/>
  <rect x="18" y="59" width="34" height="2" fill="#F0F8FF"/>
  
  <!-- 明亮白色液面（平面） -->
  <rect x="23" y="63" width="24" height="4" fill="#FFFFFF"/>
  <rect x="24" y="64" width="22" height="3" fill="#F0F8FF"/>
  
  <!-- 微小闪光像素 -->
  <rect x="27" y="65" width="1" height="1" fill="#FFFF00"/>
  <rect x="42" y="65" width="1" height="1" fill="#FFFF00"/>
  <rect x="33" y="66" width="1" height="1" fill="#FFFFFF"/>
  <rect x="37" y="66" width="1" height="1" fill="#FFFFFF"/>
  
  <!-- 十字装饰 -->
  <rect x="33" y="75" width="4" height="15" fill="#F0F8FF"/>
  <rect x="27" y="80" width="16" height="4" fill="#F0F8FF"/>
  
  <!-- 杯底 -->
  <rect x="27" y="90" width="16" height="5" fill="#DAA520"/>
  <rect x="28" y="91" width="14" height="4" fill="#FFD700"/>
  
  <!-- 杯柄 -->
  <rect x="27" y="95" width="16" height="6" fill="#DAA520"/>
  <rect x="28" y="96" width="14" height="5" fill="#FFD700"/>
  
  <!-- 底座 -->
  <rect x="17" y="101" width="36" height="10" fill="#DAA520"/>
  <rect x="18" y="102" width="34" height="8" fill="#FFD700"/>
  <rect x="19" y="103" width="32" height="6" fill="#FFFFFF"/>
  
  <!-- 底座宝石 -->
  <rect x="33" y="106" width="4" height="4" fill="#00FFFF"/>
  <rect x="34" y="107" width="2" height="2" fill="#87CEEB"/>
  
  <!-- 手持（略微远离） -->
  <rect x="10" y="80" width="8" height="12" fill="#d2a679"/>
  <rect x="9" y="81" width="2" height="10" fill="#c49565"/>
  <rect x="15" y="81" width="2" height="10" fill="#b38451"/>
  
  <!-- 手指 -->
  <rect x="16" y="77" width="2" height="10" fill="#d2a679"/>
  <rect x="52" y="77" width="2" height="10" fill="#d2a679"/>
  
  <!-- 光晕效果 -->
  <rect x="13" y="55" width="44" height="2" fill="#F0F8FF" opacity="0.5"/>
  <rect x="13" y="113" width="44" height="2" fill="#F0F8FF" opacity="0.5"/>
  <rect x="13" y="55" width="2" height="60" fill="#F0F8FF" opacity="0.5"/>
  <rect x="55" y="55" width="2" height="60" fill="#F0F8FF" opacity="0.5"/>
  
  <!-- 轮廓 -->
  <rect x="16" y="57" width="38" height="1" fill="#DAA520"/>
  <rect x="16" y="57" width="1" height="56" fill="#DAA520"/>
  <rect x="53" y="57" width="1" height="56" fill="#FFFFFF"/>
  <rect x="17" y="111" width="36" height="1" fill="#DAA520"/>`,

    "priest_holy_tome_stage1": `<!-- 牧师圣典 - 第一阶段 -->
  
  <!-- 白色封皮书 -->
  <rect x="18" y="66" width="30" height="40" fill="#F5F5F5"/>
  <rect x="19" y="67" width="28" height="38" fill="#FFFFFF"/>
  
  <!-- 书脊 -->
  <rect x="15" y="66" width="4" height="40" fill="#E5E5E5"/>
  <rect x="16" y="67" width="2" height="38" fill="#DCDCDC"/>
  
  <!-- 小十字 -->
  <rect x="31" y="78" width="4" height="12" fill="#C0C0C0"/>
  <rect x="25" y="83" width="16" height="4" fill="#C0C0C0"/>
  
  <!-- 蓝色书签带 -->
  <rect x="43" y="64" width="3" height="25" fill="#4169E1"/>
  <rect x="44" y="65" width="1" height="23" fill="#6495ED"/>
  
  <!-- 书页边缘 -->
  <rect x="48" y="71" width="2" height="30" fill="#F8F8FF"/>
  <rect x="49" y="72" width="1" height="28" fill="#F0F8FF"/>
  
  <!-- 手持书本 -->
  <rect x="3" y="81" width="12" height="8" fill="#d2a679"/>
  <rect x="2" y="82" width="2" height="6" fill="#c49565"/>
  <rect x="12" y="82" width="2" height="6" fill="#b38451"/>
  
  <!-- 另一只手 -->
  <rect x="51" y="81" width="12" height="8" fill="#d2a679"/>
  <rect x="50" y="82" width="2" height="6" fill="#c49565"/>
  <rect x="60" y="82" width="2" height="6" fill="#b38451"/>
  
  <!-- 轮廓 -->
  <rect x="14" y="65" width="36" height="1" fill="#DCDCDC"/>
  <rect x="14" y="65" width="1" height="42" fill="#DCDCDC"/>
  <rect x="49" y="65" width="1" height="42" fill="#E5E5E5"/>
  <rect x="15" y="106" width="34" height="1" fill="#DCDCDC"/>`,

    "priest_holy_tome_stage2": `<!-- 牧师圣典 - 第二阶段 -->
  
  <!-- 金边典籍 -->
  <rect x="16" y="65" width="30" height="41" fill="#F5F5F5"/>
  <rect x="17" y="66" width="28" height="39" fill="#FFFFFF"/>
  
  <!-- 金边装饰 -->
  <rect x="15" y="64" width="32" height="2" fill="#DAA520"/>
  <rect x="15" y="105" width="32" height="2" fill="#DAA520"/>
  <rect x="15" y="64" width="2" height="43" fill="#DAA520"/>
  <rect x="45" y="64" width="2" height="43" fill="#FFD700"/>
  
  <!-- 浮雕十字（1px更高） -->
  <rect x="29" y="76" width="4" height="13" fill="#FFD700"/>
  <rect x="23" y="81" width="16" height="4" fill="#FFD700"/>
  <rect x="30" y="77" width="2" height="11" fill="#FFFFFF"/>
  <rect x="24" y="82" width="14" height="2" fill="#FFFFFF"/>
  
  <!-- 角保护 -->
  <rect x="15" y="64" width="6" height="6" fill="#DAA520"/>
  <rect x="41" y="64" width="6" height="6" fill="#DAA520"/>
  <rect x="15" y="101" width="6" height="6" fill="#DAA520"/>
  <rect x="41" y="101" width="6" height="6" fill="#DAA520"/>
  
  <!-- 角保护装饰 -->
  <rect x="16" y="65" width="4" height="4" fill="#FFD700"/>
  <rect x="42" y="65" width="4" height="4" fill="#FFD700"/>
  <rect x="16" y="102" width="4" height="4" fill="#FFD700"/>
  <rect x="42" y="102" width="4" height="4" fill="#FFD700"/>
  
  <!-- 蓝色书签带 -->
  <rect x="47" y="63" width="3" height="26" fill="#4169E1"/>
  <rect x="48" y="64" width="1" height="24" fill="#6495ED"/>
  
  <!-- 书页边缘 -->
  <rect x="50" y="70" width="2" height="30" fill="#F8F8FF"/>
  <rect x="51" y="71" width="1" height="28" fill="#F0F8FF"/>
  
  <!-- 手持书本 -->
  <rect x="1" y="80" width="12" height="8" fill="#d2a679"/>
  <rect x="0" y="81" width="2" height="6" fill="#c49565"/>
  <rect x="10" y="81" width="2" height="6" fill="#b38451"/>
  
  <!-- 另一只手 -->
  <rect x="53" y="80" width="12" height="8" fill="#d2a679"/>
  <rect x="52" y="81" width="2" height="6" fill="#c49565"/>
  <rect x="62" y="81" width="2" height="6" fill="#b38451"/>
  
  <!-- 金色装饰线 -->
  <rect x="19" y="70" width="24" height="1" fill="#FFD700"/>
  <rect x="19" y="95" width="24" height="1" fill="#FFD700"/>
  
  <!-- 轮廓 -->
  <rect x="14" y="63" width="34" height="1" fill="#B8860B"/>
  <rect x="14" y="63" width="1" height="45" fill="#B8860B"/>
  <rect x="47" y="63" width="1" height="45" fill="#FFD700"/>
  <rect x="15" y="107" width="32" height="1" fill="#B8860B"/>`,

    "priest_holy_tome_stage3": `<!-- 牧师圣典 - 第三阶段 -->
  
  <!-- 悬浮发光典籍 -->
  <rect x="17" y="65" width="28" height="39" fill="#F5F5F5"/>
  <rect x="18" y="66" width="26" height="37" fill="#FFFFFF"/>
  
  <!-- 悬浮暗示 -->
  <rect x="15" y="62" width="32" height="1" fill="none" stroke="#00FFFF" stroke-width="1" opacity="0.3"/>
  <rect x="15" y="105" width="32" height="1" fill="none" stroke="#00FFFF" stroke-width="1" opacity="0.3"/>
  
  <!-- 白色/青色辐射符文网格 -->
  <rect x="20" y="70" width="2" height="2" fill="#FFFFFF"/>
  <rect x="24" y="70" width="2" height="2" fill="#00FFFF"/>
  <rect x="27" y="70" width="2" height="2" fill="#FFFFFF"/>
  <rect x="31" y="70" width="2" height="2" fill="#00FFFF"/>
  <rect x="35" y="70" width="2" height="2" fill="#FFFFFF"/>
  <rect x="39" y="70" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="22" y="74" width="2" height="2" fill="#00FFFF"/>
  <rect x="25" y="74" width="2" height="2" fill="#FFFFFF"/>
  <rect x="29" y="74" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="74" width="2" height="2" fill="#FFFFFF"/>
  <rect x="37" y="74" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="20" y="77" width="2" height="2" fill="#FFFFFF"/>
  <rect x="24" y="77" width="2" height="2" fill="#00FFFF"/>
  <rect x="27" y="77" width="2" height="2" fill="#FFFFFF"/>
  <rect x="31" y="77" width="2" height="2" fill="#00FFFF"/>
  <rect x="35" y="77" width="2" height="2" fill="#FFFFFF"/>
  <rect x="39" y="77" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="22" y="81" width="2" height="2" fill="#00FFFF"/>
  <rect x="25" y="81" width="2" height="2" fill="#FFFFFF"/>
  <rect x="29" y="81" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="81" width="2" height="2" fill="#FFFFFF"/>
  <rect x="37" y="81" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="20" y="85" width="2" height="2" fill="#FFFFFF"/>
  <rect x="24" y="85" width="2" height="2" fill="#00FFFF"/>
  <rect x="27" y="85" width="2" height="2" fill="#FFFFFF"/>
  <rect x="31" y="85" width="2" height="2" fill="#00FFFF"/>
  <rect x="35" y="85" width="2" height="2" fill="#FFFFFF"/>
  <rect x="39" y="85" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="22" y="89" width="2" height="2" fill="#00FFFF"/>
  <rect x="25" y="89" width="2" height="2" fill="#FFFFFF"/>
  <rect x="29" y="89" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="89" width="2" height="2" fill="#FFFFFF"/>
  <rect x="37" y="89" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="20" y="93" width="2" height="2" fill="#FFFFFF"/>
  <rect x="24" y="93" width="2" height="2" fill="#00FFFF"/>
  <rect x="27" y="93" width="2" height="2" fill="#FFFFFF"/>
  <rect x="31" y="93" width="2" height="2" fill="#00FFFF"/>
  <rect x="35" y="93" width="2" height="2" fill="#FFFFFF"/>
  <rect x="39" y="93" width="2" height="2" fill="#00FFFF"/>
  
  <rect x="22" y="96" width="2" height="2" fill="#00FFFF"/>
  <rect x="25" y="96" width="2" height="2" fill="#FFFFFF"/>
  <rect x="29" y="96" width="2" height="2" fill="#00FFFF"/>
  <rect x="33" y="96" width="2" height="2" fill="#FFFFFF"/>
  <rect x="37" y="96" width="2" height="2" fill="#00FFFF"/>
  
  <!-- 青色书签带（发光） -->
  <rect x="46" y="63" width="3" height="24" fill="#00FFFF"/>
  <rect x="47" y="64" width="1" height="23" fill="#87CEEB"/>
  
  <!-- 发光书页边缘 -->
  <rect x="49" y="70" width="2" height="28" fill="#F0F8FF"/>
  <rect x="50" y="71" width="1" height="26" fill="#E0F6FF"/>
  
  <!-- 远距离手持暗示 -->
  <rect x="1" y="79" width="11" height="8" fill="#d2a679"/>
  <rect x="0" y="80" width="2" height="6" fill="#c49565"/>
  <rect x="9" y="80" width="2" height="6" fill="#b38451"/>
  
  <!-- 另一只手 -->
  <rect x="54" y="79" width="11" height="8" fill="#d2a679"/>
  <rect x="53" y="80" width="2" height="6" fill="#c49565"/>
  <rect x="62" y="80" width="2" height="6" fill="#b38451"/>
  
  <!-- 光晕效果 -->
  <rect x="10" y="61" width="41" height="2" fill="#00FFFF" opacity="0.5"/>
  <rect x="10" y="108" width="41" height="2" fill="#00FFFF" opacity="0.5"/>
  <rect x="10" y="61" width="2" height="49" fill="#00FFFF" opacity="0.5"/>
  <rect x="50" y="61" width="2" height="49" fill="#00FFFF" opacity="0.5"/>
  
  <!-- 轮廓 -->
  <rect x="16" y="64" width="30" height="1" fill="#87CEEB"/>
  <rect x="16" y="64" width="1" height="41" fill="#87CEEB"/>
  <rect x="45" y="64" width="1" height="41" fill="#FFFFFF"/>
  <rect x="17" y="104" width="28" height="1" fill="#87CEEB"/>`
  }
};

// Weapon index mapping (matching dropdown order 0-71)
window.WEAPON_INDEX_MAPPING = [
  // WARRIOR (0-8)
  'warrior_longsword_stage1', 'warrior_longsword_stage2', 'warrior_longsword_stage3',
  'warrior_shield_sword_set_stage1', 'warrior_shield_sword_set_stage2', 'warrior_shield_sword_set_stage3',
  'warrior_warhammer_stage1', 'warrior_warhammer_stage2', 'warrior_warhammer_stage3',
  // MAGE (9-17)
  'mage_crystal_staff_stage1', 'mage_crystal_staff_stage2', 'mage_crystal_staff_stage3',
  'mage_spellbook_stage1', 'mage_spellbook_stage2', 'mage_spellbook_stage3',
  'mage_orb_focus_stage1', 'mage_orb_focus_stage2', 'mage_orb_focus_stage3',
  // ARCHER (18-26)
  'archer_longbow_stage1', 'archer_longbow_stage2', 'archer_longbow_stage3',
  'archer_quiver_set_stage1', 'archer_quiver_set_stage2', 'archer_quiver_set_stage3',
  'archer_crossbow_stage1', 'archer_crossbow_stage2', 'archer_crossbow_stage3',
  // ROGUE (27-35)
  'rogue_twin_daggers_stage1', 'rogue_twin_daggers_stage2', 'rogue_twin_daggers_stage3',
  'rogue_throwing_stars_stage1', 'rogue_throwing_stars_stage2', 'rogue_throwing_stars_stage3',
  'rogue_shortsword_stage1', 'rogue_shortsword_stage2', 'rogue_shortsword_stage3',
  // PALADIN (36-44)
  'paladin_sacred_hammer_stage1', 'paladin_sacred_hammer_stage2', 'paladin_sacred_hammer_stage3',
  'paladin_sword_shield_holy_stage1', 'paladin_sword_shield_holy_stage2', 'paladin_sword_shield_holy_stage3',
  'paladin_relic_sigil_stage1', 'paladin_relic_sigil_stage2', 'paladin_relic_sigil_stage3',
  // SUMMONER (45-53)
  'summoner_summon_staff_stage1', 'summoner_summon_staff_stage2', 'summoner_summon_staff_stage3',
  'summoner_pact_tome_stage1', 'summoner_pact_tome_stage2', 'summoner_pact_tome_stage3',
  'summoner_bone_bell_stage1', 'summoner_bone_bell_stage2', 'summoner_bone_bell_stage3',
  // BERSERKER (54-62)
  'berserker_great_axe_stage1', 'berserker_great_axe_stage2', 'berserker_great_axe_stage3',
  'berserker_spiked_club_stage1', 'berserker_spiked_club_stage2', 'berserker_spiked_club_stage3',
  'berserker_berserker_sword_stage1', 'berserker_berserker_sword_stage2', 'berserker_berserker_sword_stage3',
  // PRIEST (63-71)
  'priest_holy_staff_stage1', 'priest_holy_staff_stage2', 'priest_holy_staff_stage3',
  'priest_chalice_stage1', 'priest_chalice_stage2', 'priest_chalice_stage3',
  'priest_holy_tome_stage1', 'priest_holy_tome_stage2', 'priest_holy_tome_stage3'
];

// Index mappings for all layer categories
window.LAYER_INDEX_MAPPINGS = {
  BACKGROUND: ['forest_dawn', 'basalt_lavafield', 'cavern_torchlight', 'mountain_sunset', 'underwater_ruins'],
  BASE: ['human', 'elf', 'undead', 'orc', 'frost_clan'],
  EYES: ['blue_spark', 'red_glow', 'void_black', 'purple_mystic', 'yellow_cat'],
  MOUTH: ['grit_teeth', 'smile_simple', 'surprised_open', 'neutral_line', 'fangs_vampire'],
  FACE_FEATURE: ['blue_tattoo', 'scar_cheek', 'warpaint_red', 'freckles', 'tribal_white'],
  GLASSES: ['monocle', 'round_glasses', 'square_goggles', 'visor_tech', 'eye_patch'],
  HAIR_HAT: ['green_hood', 'short_brown_hair', 'silver_long_hair', 'royal_crown_hat', 'mohawk_red'],
  BODY: ['cloth_tunic', 'gold_robe_runes', 'iron_cuirass', 'leather_vest', 'diamond_plate'],
  LEGS: ['cloth_pants', 'iron_greaves', 'robe_tails_blue', 'chain_leggings', 'shorts_simple'],
  FOOT: ['gold_rune_shoes', 'iron_sabatons', 'leather_boots', 'sandals_strapped', 'armored_greaves']
};

// 集成函数
window.integrateNewTraits = function() {
  // Map all categories by index
  for (const category in window.NEW_TRAIT_SVG_DATA) {
    if (category === 'WEAPON') {
      // Special handling for weapons using existing mapping
      const weaponData = window.NEW_TRAIT_SVG_DATA.WEAPON;
      for (let i = 0; i < window.WEAPON_INDEX_MAPPING.length; i++) {
        const weaponKey = window.WEAPON_INDEX_MAPPING[i];
        if (weaponData[weaponKey]) {
          window.TRAIT_SVG_DATA.WEAPON[i] = weaponData[weaponKey];
        }
      }
    } else {
      // Map other categories by index using their mappings
      const categoryData = window.NEW_TRAIT_SVG_DATA[category];
      const indexMapping = window.LAYER_INDEX_MAPPINGS[category];
      
      if (indexMapping) {
        for (let i = 0; i < indexMapping.length; i++) {
          const traitKey = indexMapping[i];
          if (categoryData[traitKey]) {
            window.TRAIT_SVG_DATA[category][i] = categoryData[traitKey];
          }
        }
      }
    }
  }
  
  console.log('All traits integrated successfully!', {
    totalWeapons: Object.keys(window.TRAIT_SVG_DATA.WEAPON).length,
    totalBackgrounds: Object.keys(window.TRAIT_SVG_DATA.BACKGROUND).length,
    totalBases: Object.keys(window.TRAIT_SVG_DATA.BASE).length
  });
};

// 自动集成
window.integrateNewTraits();