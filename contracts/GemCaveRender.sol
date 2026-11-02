//SPDX-License-Identifier: UNLICENSED
// Developed by Tom G

/*   _____                _____                   ______ _       
    |  __ \              /  __ \                  |  _  (_)      
    | |  \/ ___ _ __ ___ | /  \/ __ ___   _____   | | | |_  __ _ 
    | | __ / _ \ '_ ` _ \| |    / _` \ \ / / _ \  | | | | |/ _` |
    | |_\ \  __/ | | | | | \__/\ (_| |\ V /  __/  | |/ /| | (_| |
     \____/\___|_| |_| |_|\____/\__,_| \_/ \___|  |___/ |_|\__, |
                                                            __/ |
    SVG Generator Contract                                 |___/ 
    Takes a Render Code and returns an SVG for an NFT
               
    Developed by Tom G
    Website: https://example.invalid
*/

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.4;

contract IGemCaveDigRenderShape {
    function getShapeSVG(uint256 gemShapeID, uint256 gemCond, string memory gemCode) public pure returns (string memory) {}
}

contract GemCaveDigRender {    
    struct gemOptions {
        string colourSet;
        string shapeSet;
        string conditionSet;
    }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toScale(uint256 value) internal pure returns (string memory) {
        if (value > 99) {
            value = value - 100;
            return string(abi.encodePacked('1.', toString(value)));
        }

        return string(abi.encodePacked('0.', toString(value)));
    }


   /*
    RENDER CODE FORMAT:

    0 = Stone Seed
    1 = Distort Seed
    2 = Distort Strength
    3 = Colour
    4 = Weight
    5 = Condition
    6 = Shape

    */
    function renderGem(uint256[7] memory renderCode, string memory gemTitle, string memory gemCode) public pure returns (string memory) {
        string[10] memory colourCode = ['#F62217', '#4ED012', '#2554C7', '#13BBAF', '#D1F8FA', '#9966CC', '#fff', '#ffbd66', '#ff8426', '#f6ff00'];

        IGemCaveDigRenderShape shapeGetter;
        if (renderCode[6] == 0 || renderCode[6] == 1 || renderCode[6] == 2) {
            shapeGetter = IGemCaveDigRenderShape(address(0));
        }
        if (renderCode[6] == 3 || renderCode[6] == 4) {
            shapeGetter = IGemCaveDigRenderShape(address(0));
        }
        if (renderCode[6] == 5 || renderCode[6] == 6) {
            shapeGetter = IGemCaveDigRenderShape(address(0));
        }

        string memory shapeSVG = shapeGetter.getShapeSVG(renderCode[6], renderCode[5], gemCode);
 
        string memory theColourM = string(abi.encodePacked('<filter id="colourise',gemCode,'" style="color-interpolation-filters:sRGB"> <feComposite in2="SourceGraphic" k1="0.748503" k2="0.958084" operator="arithmetic" result="composite1"/> <feColorMatrix in="composite1" result="colormatrix1" type="saturate" values="0.2"/> <feFlood flood-color="', colourCode[renderCode[3]],'" result="flood1"/> <feBlend in="flood1" in2="colormatrix1" mode="multiply" result="blend1"/> <feBlend in2="blend1" mode="darken" result="blend2"/> <feColorMatrix in="blend2" result="colormatrix2" type="saturate" values="1"/> <feComposite in="colormatrix2" in2="SourceGraphic" k2="1" operator="in" result="composite2"/> </filter>'));
        if (renderCode[3] == 6) {
            theColourM = string(abi.encodePacked('<filter id="colourise',gemCode,'" style="color-interpolation-filters:sRGB"> <feComposite in2="SourceGraphic" k1="1.07784" k2="0.658683" operator="arithmetic" result="composite1"/> <feColorMatrix in="composite1" result="colormatrix1" type="saturate" values="0"/> <feFlood id="changecolor" flood-color="#F62217" result="flood1"/> <feBlend in="flood1" in2="colormatrix1" mode="multiply" result="blend1"/> <feBlend in2="blend1" mode="lighten" result="blend2"/> <feColorMatrix in="blend2" result="colormatrix2" type="saturate" values="1"/> <feComposite in="colormatrix2" in2="SourceGraphic" k2="1" operator="in" result="composite2"/> <feColorMatrix id="colourisehue" result="color1" type="hueRotate" values="10"/> </filter> <animate xlink:href="#colourisehue" attributeName="values" begin="0" values="0;800;0" dur="40s" repeatCount="indefinite" fill="freeze" />'));
        }

        string memory svgOne = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="', gemCode, '" width="550" height="550" version="1.1" viewBox="0 0 95.24 95.24"> <defs><style>#sparkles path {transform-origin: center;transform-box: fill-box;animation-name: spin;animation-duration: 2000ms;animation-iteration-count: infinite;animation-timing-function: linear;overflow:visible;}@keyframes spin {0% {transform: rotate(0deg) scale(1);}50% {transform: rotate(180deg) scale(1.7);}100% {transform: rotate(360deg) scale(1);}}</style> <linearGradient id="gold-grad-1" x1="10" x2="50" y1="50" y2="1" gradientUnits="userSpaceOnUse" gradientTransform="matrix(1 0 0 1 1 -.8)"> <stop offset="0" style="stop-color:#a07937"/> <stop offset=".5" style="stop-color:#f4e5a1"/> <stop offset="1" style="stop-color:#f4e5a1"/> </linearGradient> <linearGradient id="gold-grad-2" x1="10" x2="50" y1="50" y2="1" gradientUnits="userSpaceOnUse" gradientTransform="matrix(1 0 0 1 1 -.8)"> <stop offset="0" style="stop-color:#f4e5a1"/> <stop offset=".5" style="stop-color:#f4e5a1"/> <stop offset="1" style="stop-color:#a07937"/> </linearGradient> <linearGradient id="silver-grad-1" x1="10" x2="50" y1="50" y2="1" gradientUnits="userSpaceOnUse" gradientTransform="matrix(1 0 0 1 1 -.8)"> <stop offset="0" style="stop-color:#dfdfdf"/> <stop offset=".5" style="stop-color:#6c6c6c"/> <stop offset="1" style="stop-color:#dfdfdf"/> </linearGradient> <filter id="stone',gemCode,'" width="1.2" height="1.2" x="-.1" y="-.1" style="color-interpolation-filters:sRGB"> <feTurbulence baseFrequency="0.056 0.123" numOctaves="2" result="result92" seed="', toString(renderCode[0]), '" type="fractalNoise"/> <feColorMatrix result="result5" values="1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0.7 0"/> <feComposite in="SourceGraphic" in2="result5" operator="out" result="result94"/> <feMorphology operator="dilate" radius="2.018" result="result3"/> <feTurbulence baseFrequency="0.10603588907014681 0.12561174551386622" numOctaves="50" result="result91" seed="25"/> <feDisplacementMap in="result3" in2="result91" result="result4" scale="3" xChannelSelector="R" yChannelSelector="G"/> <feSpecularLighting in="result4" lighting-color="#fff" result="result1" specularConstant="1" specularExponent="50" surfaceScale="-8"> <feDistantLight azimuth="83" elevation="69"/> </feSpecularLighting> <feComposite in2="result4" operator="atop" result="result2"/> <feComposite in="result4" in2="result2" operator="lighter" result="result4"/> </filter> <filter id="blur" style="overflow:visible;"> <feGaussianBlur stdDeviation=".098"/> </filter> <filter id="big-blur" width="2" height="2" x="-0.3" y="-0.3" style="color-interpolation-filters:sRGB"> <feGaussianBlur stdDeviation="7"></feGaussianBlur> </filter> <filter id="glasslight" width="1.5" height="1.5" x="-.3" y="-.3" color-interpolation-filters="sRGB"> <feGaussianBlur result="result1" stdDeviation="0"/> <feGaussianBlur in="result1" result="result6" stdDeviation="2"/> <feComposite in="result6" in2="result1" operator="in" result="result8"/> <feComposite in="result6" in2="result8" operator="xor" result="fbSourceGraphic"/> <feColorMatrix in="fbSourceGraphic" result="fbSourceGraphicAlpha" values="0 0 0 -1 0 0 0 0 -1 2 0 0 0 -1 0 0 0 0 1 0"/> <feGaussianBlur in="fbSourceGraphicAlpha" result="result0" stdDeviation="1"/> <feSpecularLighting id="movelights2" in="result0" lighting-color="#FFF" result="result1" specularConstant="2.5" specularExponent="80" surfaceScale="-7"> <feDistantLight id="movelights" azimuth="230" elevation="0"/> </feSpecularLighting> <feComposite in="result1" in2="fbSourceGraphicAlpha" operator="in" result="result2"/> <feComposite in="fbSourceGraphic" in2="result2" k2="0" k3="1" operator="arithmetic" result="result4"/> <feComposite in="result9" in2="result4" operator="atop" result="result91"/> </filter> <animate xlink:href="#movelights" attributeName="elevation" begin="0" values="0;800;0;" dur="15s" repeatCount="indefinite" fill="freeze" /> <filter id="glasslight2" width="1.5" height="1.5" x="-.3" y="-.3" color-interpolation-filters="sRGB"> <feGaussianBlur result="result1" stdDeviation="1"/> <feComposite in="result6" in2="result1" operator="atop" result="result8"/> <feComposite in="result6" in2="result8" operator="xor" result="fbSourceGraphic"/> <feColorMatrix in="fbSourceGraphic" result="fbSourceGraphicAlpha" values="0 0 0 -1 0 0 0 0 -1 2 0 0 0 -1 0 0 0 0 3 0"/> <feGaussianBlur in="fbSourceGraphicAlpha" result="result0" stdDeviation="1"/> <feSpecularLighting id="movelights21" in="result0" lighting-color="#FFF" result="result1" specularConstant="2.5" specularExponent="35" surfaceScale="-2"> <feDistantLight id="movelights22" azimuth="230" elevation="300"/> </feSpecularLighting> <feComposite in="result1" in2="fbSourceGraphicAlpha" operator="in" result="result2"/> <feComposite in="fbSourceGraphic" in2="result2" k2="1" k3="1" operator="arithmetic" result="result4"/> <feComposite in="result9" in2="result4" operator="atop" result="result91"/> <feBlend in2="result91" mode="multiply"/> </filter> <animate xlink:href="#movelights22" attributeName="elevation" begin="0" values="0;300;0;0" dur="5100ms" repeatCount="indefinite" fill="freeze" /> <filter id="glass" width="1.224" height="1.255" x="-.112" y="-.128" style="color-interpolation-filters:sRGB"> <feOffset dx="2.791" dy="4.909" in="SourceAlpha" result="result3"/> <feGaussianBlur in="result3" result="result1" stdDeviation="5.917"/> <feComposite in="SourceGraphic" in2="result1" operator="in" result="result2"/> <feComposite in="result2" in2="result2" operator="out" result="fbSourceGraphic"/> <feColorMatrix in="fbSourceGraphic" result="fbSourceGraphicAlpha" values="0 0 0 -1 0 0 0 0 -1 0 0 0 0 1 0 0 0 0 6 0"/> <feGaussianBlur in="fbSourceGraphicAlpha" result="result0" stdDeviation="2.135"/> <feSpecularLighting in="result0" kernelUnitLength=".01" lighting-color="#fff" result="result1" specularConstant="1.141" specularExponent="31.701" surfaceScale="1.323"> <feDistantLight azimuth="222" elevation="52"/> </feSpecularLighting> <feComposite in="result1" in2="fbSourceGraphicAlpha" operator="in" result="result2"/> <feComposite in="fbSourceGraphic" in2="result2" k1=".699" k2="3.952" k3="6.766" k4="-.143" operator="arithmetic" result="result91"/> </filter> <filter id="distort',gemCode,'"> <feTurbulence type="fractalNoise" numOctaves="2" seed="',  toString(renderCode[1]),'" baseFrequency="0.06 0.02" result="turbulence" /> <feDisplacementMap in="SourceGraphic" in2="turbulence" scale="',  toString(renderCode[2]),'" result="fbSourceGraphic" /> </filter>', theColourM));
        string memory svgTwo = string(abi.encodePacked('</defs><g transform="translate(7.937 7.937)"><path id="bg" d="M-4.398-4.051h86.59v86.39h-86.59z" fill="#000" style="opacity:0.75;filter:url(#stone',gemCode,')"/><g id="title"><path d="M-1.081-1.679H80.38c3.45 0 3.45 10.35 0 10.35H-1.081c-3.451 0-3.45-10.35 0-10.35z" fill="#000" style="display:inline;opacity:.7;"/><text x="39.56" y="5.551"><tspan x="39.56" y="5.15" fill="',  colourCode[renderCode[3]], '" stroke="#000" stroke-width="0.7px" style="text-anchor:middle;paint-order: stroke;font-weight:700;font-size:4px;font-family: Verdana, Geneva, sans-serif;">', gemTitle, '</tspan></text><text x="44.61" y="-6.437"><tspan x="44.61" y="-6.437" style="font-size:1px;text-align:end;text-anchor:end;font-family: Verdana, Geneva, sans-serif;">', gemCode, '</tspan></text></g><g id="condition-rating"><path d="M-.807 71.99H30.39c3.45 0 3.45 10.35 0 10.35H-.807c-3.45 0-3.45-10.35 0-10.35z" fill="#000" style="opacity:.7;"/><g transform="translate(.072 11.03) scale(.8455)" stroke="#42331b" stroke-width="0.4px">'));

        string memory gemStarCords = string('M17.03 82.71c-.17.27-2.92-.28-3.22-.16-.3.13-1.84 2.48-2.16 2.4-.31-.1-.63-2.87-.84-3.11-.21-.25-2.924-.99-2.95-1.31-.03-.32 2.53-1.49 2.7-1.77.17-.27 0-3.08.33-3.2.3-.13 2.2 1.94 2.52 2.02.31.1 2.94-.92 3.15-.68.21.25-1.17 2.7-1.14 3.02 0 .32 1.78 2.51 1.61 2.79z');
        string memory gemAllStars = '';
        if (renderCode[5] == 0) {
            gemAllStars = string(abi.encodePacked('<path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -73.016 49.93) scale(.6127)"/>'));
        }
        if (renderCode[5] == 1) {
            gemAllStars = string(abi.encodePacked('<path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -73.016 49.93) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -69.071 69.404) scale(.6127)"/>'));
        }
        if (renderCode[5] == 2) {
            gemAllStars = string(abi.encodePacked('<path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -73.016 49.93) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -69.071 69.404) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -65.126 88.879) scale(.6127)"/>'));
        }
        if (renderCode[5] == 3) {
            gemAllStars = string(abi.encodePacked('<path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -73.016 49.93) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -69.071 69.404) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -65.126 88.879) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -61.181 108.353) scale(.6127)"/>'));
        }
        if (renderCode[5] == 4) {
            gemAllStars = string(abi.encodePacked('<path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -73.016 49.93) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -69.071 69.404) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -65.126 88.879) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -61.181 108.353) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="matrix(.5675 .2309 -.2309 .5675 43.95 31)"/><path class="rating-star" fill="url(#gold-grad-2)" filter="url(#glasslight2)" style="mix-blend-mode: hard-light;" d="', gemStarCords, '" transform="rotate(22.146 -73.016 49.93) scale(.6127)"/><path class="rating-star" filter="url(#glasslight2)" style="mix-blend-mode: hard-light;" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -69.071 69.404) scale(.6127)"/><path class="rating-star" fill="url(#gold-grad-2)" filter="url(#glasslight2)" style="mix-blend-mode: hard-light;" d="', gemStarCords, '" transform="rotate(22.146 -65.126 88.879) scale(.6127)"/><path class="rating-star" filter="url(#glasslight2)" style="mix-blend-mode: hard-light;" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="rotate(22.146 -61.181 108.353) scale(.6127)"/><path class="rating-star" filter="url(#glasslight2)" style="mix-blend-mode: hard-light;" fill="url(#gold-grad-2)" d="', gemStarCords, '" transform="matrix(.5675 .2309 -.2309 .5675 43.95 31)"/>'));
        }
        
        string memory svgThree = string(abi.encodePacked(gemAllStars, '</g><text x="-1.219" y="74.96"><tspan x="-1.219" y="74.96" fill="#fff6d5" style="font-size:2px;line-height:1.25;font-style:italic;font-weight:700;font-family: Verdana, Geneva, sans-serif;">CONDITION</tspan></text></g><g id="weight-rating"><path d="M60.14 71.84h17.97c3.45 0 3.45 10.35 0 10.35H60.14c-3.45 0-3.45-10.35 0-10.35z" fill="#000" style="opacity:.7;"/><text x="68.69" y="74.96"><tspan x="68.69" y="74.96" fill="#fff6d5" style="font-style:italic;font-weight:700;font-size:2px;text-align:end;text-anchor:end;font-family: Verdana, Geneva, sans-serif;">WEIGHT</tspan></text><text x="60" y="79.73"><tspan x="60" y="79.73" fill="url(#gold-grad-2)" stroke="#42331b" stroke-width="0.5px" style="paint-order: stroke;font-weight:700;font-size:4px;font-family: Verdana, Geneva, sans-serif;">', toString(renderCode[4]), '0ct</tspan></text></g>', '<g id="gem" style="transform-origin:center;transform-box: fill-box;" transform-origin="center" transform="scale(', toScale(renderCode[4]), ')">', shapeSVG));

        string memory svgGemSparkle = '';
        if (renderCode[5] == 4) {
            svgGemSparkle = string(abi.encodePacked('<g id="sparkles" style="overflow:visible;filter:url(#blur);transform: scale(1);transform-origin: center;"><path fill="#fff" style="animation-duration:2s;" d="m20.93 28.58-4.44-6.05-2.29 7.15 1.97-7.25-7.025 2.66 6.895-2.97-6.462-3.83 6.622 3.53-1.03-7.44 1.37 7.38 5.17-5.44-4.92 5.67 7.49.65-7.51-.31z" /> <path fill="#fff" style="animation-duration:5s;" d="m60.32 58.73-4.47-6.05-3.36 6.73 3.01-6.89-7.51.45 7.47-.85-4.14-6.27 4.47 6.05 3.36-6.73-3.01 6.9 7.51-.46-7.47.85z"/> <path fill="#fff" style="animation-duration:2s;" d="m65.32 50.73-4.57-6.05-6.37 4.11 6.05-4.57-4.11-6.37 4.57 6.05 6.37-4.11-6.05 4.57z" /> <path fill="#fff" style="animation-duration:1.8s;" d="m70.32 20.73-4.57-6.05-6.37 4.11 6.05-4.57-4.11-6.37 4.57 6.05 6.37-4.11-6.05 4.57z" /> <path fill="#fff" style="animation-duration:10s;" d="m19.05 63.62-4.44-6.05-2.29 7.15 1.97-7.25-7.025 2.66 6.895-2.97-6.462-3.83 6.622 3.53-1.03-7.44 1.37 7.38 5.17-5.44-4.92 5.67 7.49.65-7.51-.31z" /></g>'));
        }
       
        string memory svgFour = string(abi.encodePacked('</g>', svgGemSparkle, '</g></svg>'));

        return string(abi.encodePacked(svgOne, svgTwo, svgThree, svgFour));

    }
}