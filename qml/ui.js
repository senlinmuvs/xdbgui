.import "com/com.js" as Com

let platform = $app.getPlatform();

/////////////////MAC/////////////////
let font_size_title0 = 23;
let font_size_title1 = 20;
let font_size_title2 = 16;
let font_size_title3 = 15;
let font_size_title4 = 13;
let font_size_title5 = 12;

let height1 = 16;
let height2 = 25;
let height3 = 30;

let color_gray1 = "#989898";

/////////////////WIN/////////////////
if(platform === Com.platform_win) {
    font_size_title0 = 18;
    font_size_title1 = 16;
    font_size_title2 = 14;
    font_size_title3 = 13;
    font_size_title4 = 12;
    font_size_title5 = 10;

    height1 = 30;
    height2 = 35;
    height3 = 40;

    color_gray1 = "#eaeaea";
}
