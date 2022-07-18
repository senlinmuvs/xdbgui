.import "com/com.js" as Com

let platform = $app.getPlatform();

/////////////////MAC/////////////////
let font_size_title1 = 15;
let font_size_title2 = 13;
let font_size_title3 = 12;

/////////////////WIN/////////////////
if(platform === Com.platform_win) {
    font_size_title3 = 10;
}
