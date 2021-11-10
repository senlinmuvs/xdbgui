let platform_win = 0;
let platform_linux = 1;
let platform_mac = 2;

//let file_pre = $app.getPlatform() === platform_win ? "file:///" : "file://";
let isDebug = $l.isDebug();

let Push_Add_Conn = 1;
let Push_ConnErr = 2;
let Push_Edit_Conn = 3;

let K_Query1 = "K_QUERY1";

////key type
let KEY_TYPE_KV = 1;
let KEY_TYPE_HASH = 2;
let KEY_TYPE_ZSET = 3;
let KEY_TYPE_QUEUE = 4;

//每个连接默认添加如下命令
let DEF_CMDS = [
        "/keys - - 10",
        "/scan - - 10",
        "/hlist - - 10",
        "/zlist - - 10",
        "/qlist - - 10",
    ];

let PageingNoParamCMD = ["keys","scan","hlist","zlist"];
let PageingNoParamCMDCol = ["-","key","-","-"];
function indexPageingNoParamCMD(k) {
    for(let i = 0; i < PageingNoParamCMD.length; i++) {
        if(PageingNoParamCMD[i] === k) {
            return i;
        }
    }
    return -1;
}

function conv2Str(arr) {
    let s = '';
    for(let i in arr) {
        s += arr[i] + " ";
    }
    return s;
}
function trace(...arr) {
    $l.trace(conv2Str(arr));
}
function debug(...arr) {
    $l.debug(conv2Str(arr));
}
function info(...arr) {
    $l.info(conv2Str(arr));
}
function warn(...arr) {
    $l.warn(conv2Str(arr));
}
function error(...arr) {
    $l.error(conv2Str(arr));
}
///
function eq(...args) {
    if(args.length<2){
      return true;
    }
    let first = args[0];
    for(let i = 1; i < args.length; i++) {
      if(args[i] === first){
          return true;
      }
    }
    return false;
}
function min(a,b) {
	if(a>b){
		return b;
	}
	return a;
}
function max(a,b) {
	if(a>b){
		return a;
	}
	return b;
}
function isAnimation(s) {
    return s.endsWith(".gif") || s.endsWith(".webp");
}
function fillArr(arr, index, def) {
    if(arr.length < index) {
        for(let i = arr.length; i <= index; i++) {
            arr[i] = def;
        }
    }
}
function parseKeyType(key) {
    if(key.startsWith("h:")) {
        return KEY_TYPE_HASH;
    } else if(key.startsWith("z:")) {
        return KEY_TYPE_ZSET;
    } else if(key.startsWith("q:")) {
        return KEY_TYPE_QUEUE;
    } else {
        return KEY_TYPE_KV;
    }
}
function getFirstKV(kv) {
    let paramKey = "";
    let paramVal = "";
    for (let k in kv) {
        if(!paramKey) {
            paramKey = k;
            paramVal = kv[k];
        }
    }
    return [paramKey,paramVal];
}
